package gameUnit.effect
{
	import flash.geom.Point;
	
	import Evocati.GraphicsEngine;
	
	import Interface.ITick;
	
	import gameWorld.CameraManager;
	
	import global.GlobalData;
	
	import tick.TickManager;

	public class ScreenEffect implements ITick
	{
		private static var instance:ScreenEffect;
		private var _timer:int;
		private var _totleTime:int;
		private var _value:Number;
		private var _p:Number;
		private var _b:Number;
		private var _x:Number;
		private var _y:Number;
		public function ScreenEffect()
		{
		}
		public static function getInstance():ScreenEffect
		{
			if(!instance)
				instance = new ScreenEffect();
			return instance;
		}
		public function radioBlur(amount:Number,time:int,p:Number):void
		{
			_totleTime = time;
			_p = p;
			_value = amount/_totleTime;
			_b = p/(p-1)*_value;
			_timer = 0;
			TickManager.getInstance().addTick(this);
			
		}
		public function update(duration:int):void
		{
			_timer += duration;
			if(_timer >= _totleTime)
			{
				TickManager.getInstance().removeTick(this);
				GraphicsEngine.getInstance().enableRadialBlur(0,0,0);
				return;
			}
			_x = GlobalData.self.x;
			_y = GlobalData.self.y;
			var point:Point = CameraManager.getInstance().getCurFocus();
			_x = _x - point.x;
			_y = _y - point.y;
			_x = _x/GlobalData.stage.stageWidth + 1;
			_y = _y/GlobalData.stage.stageHeight + 1;
			if(_timer > _totleTime*_p)
				GraphicsEngine.getInstance().enableRadialBlur(_b*(_timer-_totleTime),_x,_y);
			else
				GraphicsEngine.getInstance().enableRadialBlur(_timer*_value,_x,_y);
		}
	}
}