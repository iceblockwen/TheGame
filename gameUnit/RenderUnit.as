package gameUnit
{
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	import Evocati.GraphicsEngine;
	import Evocati.object.Base2DRectObjInfo;
	import Evocati.object.BaseRigidBody;
	import Evocati.textureUtils.TextureCoodinate;
	
	import Interface.IFrameAnimation;
	
	import gameUnit.data.RenderProperty;
	
	import resource.ResourceManager;

	public class RenderUnit implements IFrameAnimation
	{
		public static var pool:Array = [];
		public var property:RenderProperty;
		public var graphicInfo:Base2DRectObjInfo;
		
		private var _url:String;
		
		private var _resData:ByteArray;
		private var _resReady:int;
		private var _visible:Boolean;
		private var _body:BaseRigidBody;
		private var _frame:int = 0;
		
		private var _x:Number;
		private var _y:Number;
		public function RenderUnit()
		{
			property = new RenderProperty();
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
		public function set url(value:String):void
		{
			_url = value;
			property.texId = _url;
		}
		public function get url():String
		{
			return _url;
		}
		public function setFrame(index:int):void
		{
			_frame = index;
			if(graphicInfo) graphicInfo.setFrame(index);
		}
		public function hFlip(value:Boolean):void
		{
			graphicInfo.hFlip = value;
		}
		public function hide():void
		{
			_visible = false;
			GraphicsEngine.getInstance().removeOneObj(property.id);
		}
		
		public function move(x:Number,y:Number):void
		{
			_x = x;
			_y = y;
			if(graphicInfo)
				graphicInfo.move(x,y,0);
		}
		
		protected function getRes():void
		{
			_resReady = 0;
			if(property.isAnimated)
				ResourceManager.getInstance().loadBinFile(url+".config.gif",configCallback);
			else
				_resReady++;
			ResourceManager.getInstance().loadBinFile(url+".res.atf",resourceCallback);
		}
		private function configCallback(data:ByteArray):void
		{
			var len:int = data.length;
			property.texSize = data.readInt();
			len -= 4;
			while(len)
			{
				var xoff:int = data.readInt();
				var yoff:int = data.readInt();
				var bx:int = data.readInt();
				var by:int = data.readInt();
				var width:int = data.readInt();
				var height:int = data.readInt();
				property.texCoodinates.push(new TextureCoodinate(Number(xoff),Number(yoff),1,1,new Rectangle(bx,by,width,height),512));
				len -= 24;
			}
			_resReady++;
			checkRes();
		}
		private function resourceCallback(data:ByteArray):void
		{
			_resReady++;
			_resData = data;
			checkRes();
		}
		private function checkRes():void
		{
			if(_resReady >= 2)
			{
				GraphicsEngine.getInstance().getCompressedTextureFromByteArray(_resData,property.texId,property.texSize,property.texSize,true);
				if(_visible)
					GraphicsEngine.getInstance().addBatchSquare(getGraphicInfo());
				if(graphicInfo) 
				{
					graphicInfo.setFrame(_frame);
					graphicInfo.move(_x,_y,0);
				}
			}
		}
	    public function getGraphicInfo():Base2DRectObjInfo
		{
			if(graphicInfo == null)
				graphicInfo = Base2DRectObjInfo.getInstance(property.id,property.texId,0,0,0,0,0,property.texCoodinates,0,0,0,property.scaleX,property.scaleY);
			if(_body) _body.bindTarget(graphicInfo,property.id);
			return graphicInfo;
		}
		public function dispose():void
		{
			property.reset();
			graphicInfo = null;
			url = "";
			_resData = null;
			_resReady = 0;
			_visible = false;
			_body = null;
			pool.push(this);
		}
	}
}