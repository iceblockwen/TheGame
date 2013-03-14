package gameWorld
{
	import flash.geom.Point;
	
	import Evocati.GraphicsEngine;
	
	import Interface.ITick;
	
	import gameUnit.BaseSceneObj;
	
	import tick.TickManager;

	public class CameraManager implements ITick
	{
		private static var instance:CameraManager;
		private var _target:BaseSceneObj;
		private var _desPoint:Point;
		private var _curPoint:Point;
		
		private var _interval:int;
		private var _speed:Number = 5;
		
		private var TRACE_INTERVAL:int = 100;
		public function CameraManager()
		{
			_curPoint= new Point();
		}
		public static function getInstance():CameraManager
		{
			if(!instance)
				instance = new CameraManager();
			return instance;
		}
		public function cameraTrace(target:BaseSceneObj):void
		{
			_interval = 0;
			_target = target;
			_curPoint = new Point(_target.x,_target.y);
			_desPoint = new Point(_target.x,_target.y);
			TickManager.getInstance().addTick(this);
		}
		public function moveCameraDirectTo(target:BaseSceneObj):void
		{
			GraphicsEngine.getInstance().moveCamera(target.x,target.y,0);
		}
		public function update(duration:int):void
		{
//			_interval += duration;
			var time:Number = duration/1000;
//			if(_interval >TRACE_INTERVAL)
//			{
//				_interval = 0;
//				_desPoint = new Point(_target.x,_target.y)
//			}
			var offX:Number = _target.x - _curPoint.x;
			var offY:Number = _target.y - _curPoint.y;
			
			_curPoint.x += _speed*time*offX;
			_curPoint.y += _speed*time*offY;
			
			GraphicsEngine.getInstance().moveCamera(_curPoint.x,_curPoint.y,0);
//			GraphicsEngine.getInstance().moveCamera(_target.x,_target.y,0);
		}
	}
}