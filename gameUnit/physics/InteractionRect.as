package gameUnit.physics
{
	import flash.display.Shape;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import gameWorld.CameraManager;
	
	import global.GlobalData;

	public class InteractionRect
	{
		public var rect:Rectangle;
		public var groundY:int;
		private var _shape:Shape;
		public function InteractionRect(width:int,height:int)
		{
			rect = new Rectangle(0,0,width,height);
		}
		public function move(x:Number,y:Number,z:Number):void
		{
			rect.x = x;
			rect.y = y;
			groundY = z;
		}
		public function drawRect():void
		{
			if(!_shape)
				_shape = new Shape();
			var point:Point = CameraManager.getInstance().getCurFocus();
			var x:int = rect.x - point.x + GlobalData.stage.stageWidth/2;
			var y:int = rect.y - groundY - point.y + GlobalData.stage.stageHeight/2;
			GlobalData.stage.addChild(_shape);
			_shape.graphics.clear();
			_shape.graphics.lineStyle(1,0xff0000);
			_shape.graphics.drawRect(x,y,rect.width,rect.height);
		}
		public function dispose():void
		{
			if(_shape)
			{
				_shape.graphics.clear();
				if(_shape.parent)
					_shape.parent.removeChild(_shape);
				_shape = null;
			}
			rect = null;
			groundY = 0;
		}
	}
}