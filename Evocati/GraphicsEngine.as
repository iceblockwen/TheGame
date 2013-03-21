package Evocati
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Stage;
	import flash.display.Stage3D;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DCompareMode;
	import flash.display3D.Context3DTriangleFace;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Vector3D;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	
	import Evocati.configration.Configration;
	import Evocati.gameData.CommonData;
	import Evocati.manager.RegisterManager;
	import Evocati.manager.RenderManager;
	import Evocati.manager.ShaderManager;
	import Evocati.manager.TextureManager;
	import Evocati.manager.TransformManager;
	import Evocati.object.Base2DRectObjInfo;
	import Evocati.object.Group2DRectObjInfo;
	import Evocati.particle.ParticleEmitter;
	import Evocati.particle.ParticleLink;
	import Evocati.particle.ParticleSystem;
	import Evocati.scene.BaseScene3D;
	import Evocati.textureUtils.TexturePacker;
	import Evocati.tool.StatisticsTool;
	
	public class GraphicsEngine extends EventDispatcher
	{
		private static var _instance:GraphicsEngine;
		
		public var ready:Boolean;
		public var mainConfig:Configration;
		
		/**
		 * ctx
		 */
		private var context3D:Context3D;
		/**
		 * Manager
		 */
		private var shaderManager:ShaderManager;
		private var registerManager:RegisterManager;
		private var renderManager:RenderManager;
		private var textureManager:TextureManager;
		private var transformManager:TransformManager;
		private var particleSystem:ParticleSystem;
		/**
		 * 统计工具
		 */
		public var statistics:StatisticsTool;
		private var batchUploadTime:int;
		private var singleUploadTime:int;
		/**
		 * 设置数据
		 */
		private var commonData:CommonData = new CommonData();
		/**
		 * 舞台
		 */
		private var _stage:Stage;
		/**
		 * 场景
		 */
		private var _scene:BaseScene3D;
		/**
		 * 帧计数
		 */
		private var _frame:int;
		private var _lastTime:int;
		
		public function GraphicsEngine(stage:Stage)
		{
			if(stage == null) return;
			_stage = stage;
		}
		
		public static function getInstance(stage:Stage = null):GraphicsEngine
		{
			if(_instance == null) _instance = new GraphicsEngine(stage);
			return _instance;
		}
		
		/**
		 * 启动
		 */
		public function initContext3D():void
		{		
			_stage.scaleMode = StageScaleMode.NO_SCALE;
			_stage.align = StageAlign.TOP_LEFT;
			_stage.stage3Ds[0].addEventListener(Event.CONTEXT3D_CREATE,onCreate);
			_stage.stage3Ds[0].requestContext3D();
		}
		
		/**
		 * 设置缓冲区大小
		 */
		public function setGameSize(x:int,y:int):void
		{		
			commonData.gameWidth = x;
			commonData.gameHeight = y;
			configEngine();
		}
		
		
		/**
		 * 从位图数据得到纹理
		 */
		public function getTextureFromBitmapData(bitmapData:BitmapData,id:String,sizeX:int,sizeY:int):void
		{
			textureManager.getTextureFromBitmapData(bitmapData,id,sizeX,sizeY);
		}
		/**
		 * 从字节流数据得到压缩的纹理
		 */
		public function getCompressedTextureFromByteArray(data:ByteArray,id:String,sizeX:int,sizeY:int,alpha:Boolean = false):void
		{
			textureManager.getCompressedTextureFromByteArray(data,id,sizeX,sizeY,alpha);
		}
		
		/**
		 * 从位图数据得到地图纹理
		 */
		public function getCompressedMapTextureFromByteArray(data:ByteArray,id:String,sizeX:int,sizeY:int,isAlpha:Boolean):void
		{
			textureManager.getCompressedMapTextureFromByteArray(data,id,sizeX,sizeY,isAlpha);
		}
		
		/**
		 * 从位图数据得到地图纹理
		 */
		public function getMapTextureFromBitmap(bitmap:Bitmap,id:String,sizeX:int,sizeY:int):void
		{
			textureManager.getMapTextureFromBitmap(bitmap,id,sizeX,sizeY);
		}
		
		/**
		 * 向场景增加单个矩形(着色器操作参数)
		 */
		public function addSingleSquare(info:Base2DRectObjInfo):void
		{
			_scene.addSingleObj(info);
		}
		
		/**
		 * 向场景增加物件组
		 */
		public function addGroupObj(info:Group2DRectObjInfo):void
		{
			_scene.addGroupObj(info);
		}
		
		/**
		 * 从场景中移除物件组
		 */
		public function removeGroupObj(id:String):void
		{
			_scene.removeGroupObj(id);
		}
		
		/**
		 * 单一物体是否在场景中
		 */
		public function isInScene(info:Base2DRectObjInfo):Boolean
		{
			if(info && _scene.findObjById(info.id))
			{
				return true;	
			}
			return false;
		}
		/**
		 * 地图块是否在场景中
		 */
		public function isMapTileInScene(info:Base2DRectObjInfo):Boolean
		{
			if(info && (_scene._mapTileList[info.id] != undefined))
			{
				return true;	
			}
			return false;
		}
		
		/**
		 * 删除场景中单个矩形
		 */
		public function removeOneObj(id:String,isDispose:Boolean = true):void
		{
			_scene.removeOneObj(id,isDispose);
			
		}
		
		/**
		 * 向场景增加地图块
		 */
		public function addMapTile(info:Base2DRectObjInfo):void
		{
			_scene.addMapTile(info);
		}
		/**
		 * 向场景增加地图块
		 */
		public function setMapthumb(info:Base2DRectObjInfo):void
		{
			_scene.setMapthumb(info);
		}
		
		/**
		 * 删除场景地图块
		 */
		public function removeMapTile(id:String):void
		{
			_scene.removeMapTile(id);
		}
		
		/**
		 * 向场景增加一个批量处理矩形(预存参数)
		 */
		public function addBatchSquare(info:Base2DRectObjInfo):void
		{
			_scene.addBatchObj(info)
		}
		/**
		 * 场景修改批量处理矩形的纹理(预存参数)
		 */
		public function updateBatchSquareTex(info:Base2DRectObjInfo,batchId:String):void
		{
			info.textureId = batchId;
			if(_scene.isObjInBatch(info.id,batchId))
				return;
			removeOneObj(info.id,false);
			addBatchSquare(info);
		}		
		/**
		 * 增加粒子发生器
		 */
		public function addBatchParticleEmitter(batchId:String,life:Number,sizeX:int,sizeY:int,texSize:int,position:Vector3D,velocity:Vector3D):ParticleEmitter
		{
			return particleSystem.addParticleEmitter(batchId,position,velocity,life,sizeX,sizeY,texSize);
		}
		
		/**
		 * 增加粒子链
		 */
		public function addParticleLink(texId:String,life:Number,sizeX:int,sizeY:int,texSize:int,position:Vector3D,velocity:Vector3D):ParticleLink
		{
			return particleSystem.addParticleLink(texId,position,velocity,life,sizeX,sizeY,texSize);
		}
		
		/**
		 * 移动场景中的单个矩形(着色器操作,实际像素数据)
		 */
		public function moveSquare(id:String,x:Number,y:Number):void
		{
			_scene.moveObjById(id,x,y);
		}
		/**
		 * 旋转场景中的单个矩形(着色器操作,实际像素数据)
		 */
		public function rotateSquare(id:String,rx:Number,ry:Number,rz:Number):void
		{
			_scene.rotateObjById(id,rx,ry,rz);
		}
		
		/**
		 * 设置场景中物件的纹理序号
		 */
		public function setFrameByObjectId(id:String,index:int):void
		{
			_scene.findObjById(id)[0].setFrame(index);
		}
		
		/**
		 * 移动摄影机(实际像素数据)
		 */
		public function moveCamera(x:Number,y:Number,z:Number):void
		{
			transformManager.moveCamera(x,y,z)
		}
		/**
		 * 增量摄影机(实际像素数据)
		 */
		public function moveCameraBy(x:Number,y:Number,z:Number):void
		{
			transformManager.moveCameraBy(x,y,z);
		}
		
		/**
		 * 旋转摄影机(实际像素数据)
		 */
		public function rotateCamera(rx:Number,ry:Number,rz:Number):void
		{
			transformManager.rotateCamera(rx,ry,rz);
		}
		
		/**
		 * 旋转摄影机(实际像素数据)
		 */
		public function getCameraPos():Vector3D
		{
			return transformManager.getCameraPos();
		}
		
		/**
		 * 创建并初始化Stage3D
		 */
		protected function onCreate(event:Event):void
		{
			removeEventListener(Event.ENTER_FRAME,render);
			
			var t:Stage3D = event.target as Stage3D;
			context3D = t.context3D;
			
			if(context3D == null)
			{
				trace("stage3d 初始化失败");
				return;
			}
			trace("stage3d 初始化成功");
			
			context3D.enableErrorChecking = false;

			shaderManager = new ShaderManager(context3D);
			registerManager = new RegisterManager(context3D);
			renderManager = new RenderManager(context3D);
			textureManager = new TextureManager(context3D,commonData);
			transformManager = new TransformManager(commonData);
			particleSystem = new ParticleSystem();
			
			particleSystem.generatePoolObjs();
			
			configEngine();
			
			shaderManager.setShaders("MAP","COMMON");
			shaderManager.setShaders("MAP","COMMON_DXT1");
			shaderManager.setShaders("COMMON","COMMON");
			shaderManager.setShaders("COMMON","COMMON_DXT1");
			shaderManager.setShaders("BATCH","COMMON");
			shaderManager.setShaders("POST_COMMON","POST_RADIAL_BLUR_P1+POST_RADIAL_BLUR_P2@20+POST_RADIAL_BLUR_P3");
			shaderManager.setShaders("POST_COMMON","POST_RADIAL_BLUR_P1+POST_DIR_BLUR_P2@20+POST_RADIAL_BLUR_P3");
			shaderManager.setShaders("POST_COMMON","POST_TEST");
			shaderManager.setShaders("POST_COMMON","COMMON");
			shaderManager.setShaders("POST_COMMON","POST_BLUR_VERTICAL+POST_BLUR_P2");
			shaderManager.setShaders("POST_COMMON","POST_BLUR_HORIZONTAL+POST_BLUR_P2");
			shaderManager.setShaders("POST_COMMON","POST_BLOOM");
			shaderManager.setShaders("COMMON","COMMON_DXT5");
			shaderManager.setShaders("BATCH","COMMON_DXT5");
			shaderManager.setShaders("PARTICLE_BATCH","COMMON_PARTICLE_DXT5");
			shaderManager.setShaders("PARTICLE_LINK","COMMON_PARTICLE_LINK_DXT5");
			
			renderManager.initCommonMeshData();
			
			dispatchEvent(new Event("CompleteInit"));
			
			_stage.addEventListener(Event.ENTER_FRAME,render);
		}
		/**
		 * 初始化场景
		 */
		private function configEngine(config:Configration = null):void
		{
			if(context3D == null) return;
			context3D.configureBackBuffer(commonData.gameWidth, commonData.gameHeight, 0, true);
			context3D.setCulling( Context3DTriangleFace.BACK);
			context3D.setDepthTest(false,Context3DCompareMode.LESS);
			
			if(config)
				mainConfig = config;
			else if(mainConfig == null)
				mainConfig = new Configration();
			
			if(!_scene)
				_scene = new BaseScene3D();
			
			renderManager.setScene(_scene);
			renderManager.setParticleSystem(particleSystem);
			textureManager.setScene(_scene);
			textureManager.initTexture();
			
			
			if(mainConfig.detail)
			{
				statistics = new StatisticsTool();
				_stage.addChild(statistics);
				statistics.x = 0;
				statistics.y = 0;
			}
			
			ready = true;
		}					
		
		/**
		 * 径向模糊开启
		 */
		private var _blurAmount:Number;
		private var _blurX:Number;
		private var _blurY:Number;
		private var _RadialblurType:int = -1;
		public function enableRadialBlur(value:Number,x:Number,y:Number,type:int = 0):void
		{
			_blurAmount = value;
			_blurX = x;
			_blurY = y;
			_RadialblurType = type;
			if(value > 0)
				mainConfig.usePostFx = 1;
			else
			{	
				mainConfig.usePostFx = 0;
				_RadialblurType = -1;
			}
		}	
		/**
		 * 高斯模糊开启
		 */
		private var gaussianTimes:int;
		private var gaussian:Boolean;
		public function enableGaussianBlur(times:int):void
		{
			gaussianTimes = times;
			gaussian = true;
			if(times > 0)
				mainConfig.usePostFx = 1;
			else
			{
				mainConfig.usePostFx = 0;
				gaussian = false;
			}
		}	
		
		/**
		 * 画当前缓存中的多边形
		 */
		protected function draw():void
		{		
			registerManager.setTransformMatrixToRegister(transformManager.modelViewProjection);
			renderManager.singleDraw();
		}
		/**
		 * 画当前批量缓存中的多边形
		 */
		protected function batchDraw():void
		{
			registerManager.setTransformMatrixToRegister(transformManager.modelViewProjection);
			renderManager.batchDraw();
		}
		/**
		 * 画当前批量缓存中的多边形(粒子)
		 */
		protected function batchDrawParticle():void
		{
			registerManager.setTransformMatrixToRegister(transformManager.modelViewProjection);
			renderManager.batchDrawParticle();
		}
		/**
		 * 画当前批量缓存中的多边形(粒子链)
		 */
		protected function drawParticleLink():void
		{
			registerManager.setTransformMatrixToRegister(transformManager.modelViewProjection);
			renderManager.drawParticleLink();
		}
		/**
		 * 渲染当前帧
		 */
		protected function render(event:Event):void
		{
			renderManager.polyNum = 0;
			var now:int = getTimer();
			var dTime:int = now - _lastTime;
			if(_frame == 0) dTime = 0;
			_lastTime = now;
			if(mainConfig.usePostFx)
			{
				context3D.setRenderToTexture(textureManager.sceneTexture);
			}
			else
			{
				context3D.setRenderToBackBuffer();
			}
			context3D.clear(0,0,0);
			context3D.setProgram ( shaderManager.getShaders('MAP','COMMON_DXT1'));
			
			var len:int = _scene._mapTileList.length;
			var textureId:String;
			
			renderManager.setBlendmode(0);
			
			//渲染详细地图
			if(_scene._mapThumb)
			{
				var thumb:Base2DRectObjInfo = _scene._mapThumb;
				textureId = thumb.textureId;
				textureManager.setMapTexture(textureId,0);
				transformManager.setTransform(thumb.x, thumb.y, thumb.z, thumb.rx, thumb.ry, thumb.rz,
					thumb.sizeX*2/commonData.gameWidth,
					thumb.sizeY*2/commonData.gameHeight
				);
				draw();
			}
			for each(var k:Base2DRectObjInfo in  _scene._mapTileList)
			{
				textureId =  k.textureId;
				textureManager.setMapTexture(textureId,0);
				transformManager.setTransform(k.x, k.y, k.z, k.rx, k.ry, k.rz,
					k.sizeX*2/commonData.gameWidth,
					k.sizeY*2/commonData.gameHeight
				);
				draw();
			}
			
			renderManager.setBlendmode(1);
			var time:int = getTimer();
			//渲染单个矩形
			context3D.setProgram ( shaderManager.getShaders("COMMON","COMMON_DXT5"));
			registerManager.setFogParam(new Vector3D(),3,new Vector3D(0.5,0.5,0.5));
			len = _scene._singleObjList.length;
			var i:int = -1;
			while(++i < len)
			{
				var index:int = _scene._singleObjList[i].textureIndex;
				textureId =  _scene._singleObjList[i].textureId;
				registerManager.setTextureSizeToRegister(TexturePacker.getCompatibleSize( _scene._singleObjList[i].textureCoordinates[index].texSize));
				var obj:Base2DRectObjInfo = _scene._singleObjList[i];
				textureManager.setTexture(textureId,0);
				registerManager.setUVToRegister(obj.textureCoordinates[index].bound.width,
					obj.textureCoordinates[index].bound.height,
					obj.textureCoordinates[index].xOffset,
					obj.textureCoordinates[index].yOffset);
				transformManager.setTransform(obj.originX, obj.originY, obj.originZ, obj.rx, obj.ry, obj.rz,
					obj.sizeX*2/commonData.gameWidth,
					obj.sizeY*2/commonData.gameHeight
				);
				draw();
			}
			singleUploadTime = getTimer() - time;
			
			context3D.setProgram ( shaderManager.getShaders('BATCH','COMMON_DXT5'));
			//渲染批量对象
			registerManager.setGameSizeToRegister(commonData.gameWidth,commonData.gameHeight);
			time = getTimer();
			for(var batchId:String in _scene._batchObjList)
			{
				
				if(renderManager.setBatchData(batchId))   
				{
					textureManager.setTexture(batchId,0);
					transformManager.setTransform(0,0,0,0,0,0,1,1);
					registerManager.setTextureSizeToRegister(textureManager.getTextureSize(batchId));
					batchDraw();
				}
			}
			
			
			//渲染粒子
			particleSystem.update(dTime);
			renderManager.setBlendmode(3);
			context3D.setProgram ( shaderManager.getShaders("PARTICLE_BATCH","COMMON_PARTICLE_DXT5"));
			for(var id:String in particleSystem._particleBatchList)
			{
				if(renderManager.setBatchParticleData(id))
				{
					registerManager.setTextureSizeToRegister(textureManager.getTextureSize(id));
					registerManager.setParticleParam(100);
					textureManager.setTexture(id,0);
					transformManager.setTransform(0,0,0,0,0,0,1,1);
					batchDrawParticle();
				}
			}
			context3D.setProgram ( shaderManager.getShaders("PARTICLE_LINK","COMMON_PARTICLE_LINK_DXT5"));
			for each(var link:ParticleLink in particleSystem._particleLinkList)
			{
				if(renderManager.setLinkParticleData(link))
				{
					id = link.texId;
					registerManager.setTextureSizeToRegister(textureManager.getTextureSize(id));
					registerManager.setParticleParam(0);
					textureManager.setTexture(id,0);
					transformManager.setTransform(0,0,0,0,0,0,1,1);
					drawParticleLink();
				}
			}
			batchUploadTime = getTimer() - time;
			//后处理效果
			if(mainConfig.usePostFx)		
			{
				registerManager.setRadialBlurMatrix();
				switch(_RadialblurType)
				{
					case 0:
						registerManager.setRadialBlurParam(_blurX,_blurY,_blurAmount);
						context3D.setProgram(shaderManager.getShaders("POST_COMMON","POST_RADIAL_BLUR_P1+POST_RADIAL_BLUR_P2@20+POST_RADIAL_BLUR_P3"));
						break;
					case 1:
						registerManager.setDirBlurParam(_blurX,_blurY,_blurAmount);
						context3D.setProgram(shaderManager.getShaders("POST_COMMON","POST_RADIAL_BLUR_P1+POST_DIR_BLUR_P2@20+POST_RADIAL_BLUR_P3"));
						break;
					default:
						context3D.setProgram(shaderManager.getShaders("POST_COMMON","POST_TEST"));
						break;
					
				}
				if(!gaussian)
					context3D.setRenderToBackBuffer();
				else
					context3D.setRenderToTexture(textureManager.blurTexture);
				renderManager.setBlendmode(0);
				context3D.clear(0,0,0);
				context3D.setTextureAt(0, textureManager.sceneTexture);
				context3D.setTextureAt(1, null);
				renderManager.wholeScreenDraw()
				if(gaussian)
				{
					gaussianBlur(gaussianTimes);
					bloom();
				}
				
			}
			_frame++;
			context3D.present();
			if(mainConfig.detail)
			{
				if(!statistics)
				{
					statistics = new StatisticsTool();
					_stage.addChild(statistics);
					statistics.x = 0;
					statistics.y = 0;
				}
				statistics._3dAPI.text = "Device:  "+context3D.driverInfo;
				statistics._batchUpLoadTimeText.text = "批量数据上传耗时:  " + batchUploadTime +" ms";
				statistics._DrawSingleTime.text = "单一数据上传耗时:  " + singleUploadTime +" ms";
				statistics._totlePolyText.text = "多边形数量:  " + renderManager.polyNum;
				statistics._vramUseText.text = "显存使用:  " + textureManager.vramUse + " kB";
			}
		}
		private function bloom():void
		{
			context3D.setRenderToBackBuffer();
			context3D.clear(0,0,0);
			context3D.setTextureAt(0, textureManager.sceneTexture);
			context3D.setTextureAt(1, textureManager.blurTexture);
			context3D.setProgram(shaderManager.getShaders("POST_COMMON","POST_BLOOM"));
			renderManager.wholeScreenDraw(false);
		}
		private function gaussianBlur(times:int):void
		{
			var t:int = times;
			t--;
			var ratio:Number = commonData.gameWidth/commonData.gameHeight;
			registerManager.setGaussianBlurParam(commonData.blurTextureSize,ratio);
			context3D.setTextureAt(0, textureManager.blurTexture);
			context3D.setTextureAt(1, null);
			context3D.setRenderToTexture(textureManager.blurTextureSec);
			context3D.setProgram(shaderManager.getShaders("POST_COMMON","POST_BLUR_VERTICAL+POST_BLUR_P2"));
			context3D.clear(0,0,0);
			renderManager.wholeScreenDraw(false);
			while(t--)
			{
				registerManager.setGaussianBlurParam(commonData.blurTextureSize,1);
				context3D.setTextureAt(0, textureManager.blurTextureSec);
				context3D.setTextureAt(1, null);
				context3D.setRenderToTexture(textureManager.blurTexture);
				context3D.setProgram(shaderManager.getShaders("POST_COMMON","POST_BLUR_HORIZONTAL+POST_BLUR_P2"));
				context3D.clear(0,0,0);
				renderManager.wholeScreenDraw(false);
				
				registerManager.setGaussianBlurParam(commonData.blurTextureSize,ratio);
				context3D.setTextureAt(0, textureManager.blurTexture);
				context3D.setTextureAt(1, null);
				context3D.setRenderToTexture(textureManager.blurTextureSec);
				context3D.setProgram(shaderManager.getShaders("POST_COMMON","POST_BLUR_VERTICAL+POST_BLUR_P2"));
				context3D.clear(0,0,0);
				renderManager.wholeScreenDraw(false);
			}
			registerManager.setGaussianBlurParam(commonData.blurTextureSize,1);
			context3D.setTextureAt(0, textureManager.blurTextureSec);
			context3D.setTextureAt(1, null);
			context3D.setRenderToTexture(textureManager.blurTexture);
			context3D.setProgram(shaderManager.getShaders("POST_COMMON","POST_BLUR_HORIZONTAL+POST_BLUR_P2"));
			context3D.clear(0,0,0);
			renderManager.wholeScreenDraw(false);
		}
	}
}