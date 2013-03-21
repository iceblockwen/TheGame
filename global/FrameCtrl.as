package global
{
	import Interface.ITick;
	
	import tick.TickManager;

	public class FrameCtrl implements ITick
	{
		private static var _instance:FrameCtrl;
		
		private var _timer:int;
		private var _totleTime:int;
		private var _lastRate:Number;
		private var _lock:Boolean;
		public function FrameCtrl()
		{
		}
		public static function getInstance():FrameCtrl
		{
			if(!_instance)
				_instance = new FrameCtrl();
			return _instance;
		}
		public function slowDownAnimation(time:int,rate:Number):void
		{
			if(_lock) return;
			_lock = true;
			_timer = 0;
			_totleTime = time;
			_lastRate = GlobalData.characterTimerMutiplier;
			GlobalData.lockCharacterTimer = true;
			GlobalData.characterTimerMutiplier = rate;
			TickManager.getInstance().addTick(this);
		}
		public function update(duration:int):void
		{
			_timer += duration;
			if(_timer >= _totleTime)
			{
				GlobalData.characterTimerMutiplier = _lastRate;
				GlobalData.lockCharacterTimer = false;
				TickManager.getInstance().removeTick(this);
				_lock = false;
			}
		}
	}
}