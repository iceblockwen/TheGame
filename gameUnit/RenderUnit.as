package gameUnit
{
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	import Evocati.GraphicsEngine;
	import Evocati.object.Base2DRectObjInfo;
	import Evocati.object.BaseRigidBody;
	import Evocati.textureUtils.TextureCoodinate;
	
	import gameUnit.data.RenderProperty;
	
	import resource.ResourceManager;

	public class RenderUnit
	{
		public static var pool:Array = [];
		public var graphicInfo:Base2DRectObjInfo;
		public var animationId:int;
		
		private var _preUrl:String;
		private var _resUrl:String;
		
		private var _resData:ByteArray;
		private var _resReady:int;
		private var _visible:Boolean;
		private var _body:BaseRigidBody;
		private var _frame:int = 0;
		private var _lock:Boolean = false;
		
		private var _x:Number;
		private var _y:Number;
		public var level:Number;
		
		public var id:String;
		public var isAnimated:Boolean;
		public var scaleX:Number = 1;
		public var scaleY:Number = 1;
		public function RenderUnit()
		{
		}
		public static function getInstance():RenderUnit
		{
			var instance:RenderUnit = pool.length ? pool.pop() : new RenderUnit();
			return instance;
		}
		public function show():void
		{
			_visible = true;
			if(_resReady < 2)
			{
				getRes();
			}
			else
			{
				GraphicsEngine.getInstance().addBatchSquare(getGraphicInfo());
			}
		}
		public function setPreUrl(value:String,headFrame:int):void
		{
			if(_preUrl != value)
			{
				_frame = headFrame;
				_preUrl = value;
				_resUrl = _preUrl + ".res.atf";
				if(_visible)
					getRes();
			}
		}
		public function setFrame(index:int):void
		{
			if(_lock) return;
			_frame = index;
			if(graphicInfo) 
				graphicInfo.setFrame(index);
		}
		public function hFlip(value:Boolean):void
		{
			graphicInfo.hFlip = value;
		}
		public function hide():void
		{
			_visible = false;
			GraphicsEngine.getInstance().removeOneObj(id);
		}
		public function move(x:Number,y:Number):void
		{
			_x = x;
			_y = y;
			if(graphicInfo)
				graphicInfo.move(x,y,level);
		}
		protected function getRes():void
		{
			_resReady = 0;
			_lock = true;
			if(isAnimated)
			{
				if(RenderProperty.data[_resUrl] != undefined)
				{
					_resReady++;
				}
				else
					ResourceManager.getInstance().loadBinFile(_preUrl + ".config.gif",configCallback);
			}
			else
				_resReady++;
			ResourceManager.getInstance().loadBinFile(_preUrl + ".res.atf",resourceCallback);
		}
		private function configCallback(data:ByteArray,url:String):void
		{
			if(RenderProperty.data[_resUrl] != undefined)
			{
				_resReady++;
				checkRes();
				return;
			}
			RenderProperty.data[_resUrl] = new RenderProperty();
			RenderProperty.data[_resUrl].texCoodinates = [];
			var len:int = data.length;
			RenderProperty.data[_resUrl].texId = _resUrl;
			RenderProperty.data[_resUrl].texSizeX = data.readInt();
			RenderProperty.data[_resUrl].texSizeY = data.readInt();
			len -= 8;
			while(len)
			{
				var xoff:int = data.readInt();
				var yoff:int = data.readInt();
				var bx:int = data.readInt();
				var by:int = data.readInt();
				var width:int = data.readInt();
				var height:int = data.readInt();
				RenderProperty.data[_resUrl].texCoodinates.push(new TextureCoodinate(Number(xoff),Number(yoff),1,1,new Rectangle(bx,by,width,height),512));
				len -= 24;
			}
			_resReady++;
			checkRes();
		}
		private function resourceCallback(data:ByteArray,url:String):void
		{
			_resReady++;
			_resData = data;
			checkRes();
		}
		private function checkRes():void
		{
			if(_resReady >= 2)
			{
				var property:RenderProperty = RenderProperty.data[_resUrl];
				GraphicsEngine.getInstance().getCompressedTextureFromByteArray(_resData,property.texId,property.texSizeX,property.texSizeY,true);
				if(_visible)
				{	
					if(!graphicInfo)
						GraphicsEngine.getInstance().addBatchSquare(getGraphicInfo());
					else
					{
						GraphicsEngine.getInstance().updateBatchSquareTex(graphicInfo,property.texId);
						graphicInfo.textureCoordinates = property.texCoodinates;
					}
					_lock = false;
					graphicInfo.setFrame(_frame);
					graphicInfo.move(_x,_y,0);
				}
			}
		}
	    public function getGraphicInfo():Base2DRectObjInfo
		{
			var property:RenderProperty = RenderProperty.data[_resUrl];
			if(graphicInfo == null)
				graphicInfo = Base2DRectObjInfo.getInstance(id,property.texId,0,0,0,0,0,property.texCoodinates,0,0,0,scaleX,scaleY);
			if(_body) _body.bindTarget(graphicInfo,id);
			return graphicInfo;
		}
		public function dispose():void
		{
			graphicInfo = null;
			_resUrl = "";
			_preUrl = "";
			_resData = null;
			_resReady = 0;
			_visible = false;
			_body = null;
			pool.push(this);
		}
	}
}