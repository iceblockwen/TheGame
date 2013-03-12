package tick
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	import Interface.ITick;
	
	public class TickManager extends Sprite
	{
		private static var _inst:TickManager;
		private var HPriorityList:Array = [];
		private var LPriorityList:Array = [];
		private var _startTimer:int;
		private var _curTimer:int;
		private var _firstTick:Boolean;
		
		public var duration:int;
		public function TickManager()
		{
			addEventListener(Event.ENTER_FRAME,update);
			_curTimer = _startTimer = getTimer();
			_firstTick = true;
		}
		
		public static function getInstance():TickManager
		{
			if(_inst == null)
				_inst = new TickManager();
			return _inst;
		}
		
		protected function update(event:Event):void
		{
			if(_firstTick) 
			{
				_firstTick = false;
				return;
			}
			var tmp:int = getTimer();
			duration = tmp -_curTimer;
			for each(var i:ITick in HPriorityList)
			{
				i.update(duration);
			}
			for each(var j:ITick in LPriorityList)
			{
				i.update(duration);
			}
			_curTimer = tmp;
			
		}
		public function addTick(obj:ITick,priority:int = 1):void
		{
			if(LPriorityList.indexOf(obj) == -1 && HPriorityList.indexOf(obj) ==-1)
			{
				switch(priority)
				{
					case 0:
					{
						LPriorityList.push(obj);
						break;
					}
						
					case 1:
					{
						HPriorityList.push(obj);
						break;
					}
						
					default:
					{
						HPriorityList.push(obj);
						break;
					}
				}
			}
		}
		public function removeTick(obj:ITick):void
		{
			var index:int;
			if((index = HPriorityList.indexOf(obj)) >=0)
			{
				HPriorityList.splice(index,1);
			}
			else if((index = LPriorityList.indexOf(obj)) >=0)
			{
				LPriorityList.splice(index,1);
			}
		}
	}
}