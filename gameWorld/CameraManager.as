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
		private var _map:BaseMap;
		private var _desPoint:Point;
		private var _curPoint:Point;
		
		private var _interval:int;
		private var _speed:Number = 5;
		
		public function CameraManager()
		{
			_curPoint= new Point();
		}
		public function getCurFocus():Point
		{
			return _curPoint;
		}
		public static function getInstance():CameraManager
		{
			if(!instance)
				instance = new CameraManager();
			return instance;
		}
		public function setMap(map:BaseMap):void
		{
			_map = map;
		}
		public function cameraTrace(target:BaseSceneObj):void
		{
			_interval = 0;
			_target = target;
			_curPoint = new Point(_target.x,_target.y-_target.groundY);
			_desPoint = new Point(_target.x,_target.y-_target.groundY);
			TickManager.getInstance().addTick(this);
		}
		public function moveCameraDirectTo(target:BaseSceneObj):void
		{
			GraphicsEngine.getInstance().moveCamera(target.x,target.y-target.groundY,0);
		}
		public function resize():void
		{
			if(_map)
			{
				_map.resize();
			}
		
		}
		public function update(duration:int):void
		{
			var time:Number = duration/1000;

			var offX:Number = _target.x - _curPoint.x;
			var offY:Number = _target.y - _target.groundY - _curPoint.y;
			
			_curPoint.x += _speed*time*offX;
			_curPoint.y += _speed*time*offY;
			
			GraphicsEngine.getInstance().moveCamera(_curPoint.x,_curPoint.y,0);
			if(_map)
				_map.refreshMapTile(_curPoint.x,_curPoint.y);
			
//			_curPoint.x = _target.x;
//			_curPoint.y = _target.y;
//			GraphicsEngine.getInstance().moveCamera( _target.x, _target.y,0);
		}
	}
}