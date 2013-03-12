package gameWorld
{
	import flash.display.Stage;
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	
	import Interface.ITick;
	
	import gameUnit.animation.data.FrameAnimationGraph;
	
	import global.DirectionType;
	import global.GlobalData;
	import global.GlobalEvent;
	import global.KeyType;
	
	import tick.TickManager;

	public class InputManager extends EventDispatcher implements ITick
	{
		private static var instance:InputManager;
		
		private var _stage:Stage;
		public var _keyBuffer:Array;
		public var _instructionBuffer:Array;
		public var _upCallback:Function;
		public var _downCallback:Function;
		private const DELAY:int = 500;
		public function InputManager(stage:Stage)
		{
			_stage = stage;
			_keyBuffer = [];
			_instructionBuffer = [];
			initListener();
		}
		public static function getInstance(stage:Stage = null):InputManager
		{
			if(instance == null)
			{
				instance = new InputManager(stage);
			}
			return instance;
		}
		
		private function initListener():void
		{
			if(!_stage) return;
				
			_stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDownHandler);
			_stage.addEventListener(KeyboardEvent.KEY_UP,onKeyUpHandler);
		}
		
		protected function onKeyUpHandler(event:KeyboardEvent):void
		{
			if(_keyBuffer.indexOf(event.keyCode as int) == -1)
				return;
			//trace("UP KEY:"+event.keyCode);
			_keyBuffer.splice(_keyBuffer.indexOf(event.keyCode as int),1);
			bufferInstructions(event.keyCode);
			dispatchEvent(GlobalEvent.GLOBAL_EVT_KEY_UP);
		}
		
		protected function onKeyDownHandler(event:KeyboardEvent):void
		{
			if(_keyBuffer.indexOf(event.keyCode as int) != -1)
				return;
			//trace("DOWN KEY:"+event.keyCode);
			_keyBuffer.push(event.keyCode as int);
			dispatchEvent(GlobalEvent.GLOBAL_EVT_KEY_UP);
		}
		
		protected function bufferInstructions(keyCode:int):void
		{
			_instructionBuffer.push([keyCode,DELAY]);
			TickManager.getInstance().addTick(this);
		}
		
		public function update(duration:int):void
		{
			for each(var arr:Array in _instructionBuffer)
			{
				arr[1] -= duration;
				if(arr[1] <= 0)
				{
					_instructionBuffer.splice(_instructionBuffer.indexOf(arr),1);
				}
			}
			if(_instructionBuffer.length == 0)
				TickManager.getInstance().removeTick(this);
		}
		
		public function checkMove():void
		{
			var downKeys:Array = _keyBuffer;
			var w:Boolean = downKeys.indexOf(KeyType.W) != -1
			var s:Boolean = downKeys.indexOf(KeyType.S) != -1
			var a:Boolean = downKeys.indexOf(KeyType.A) != -1
			var d:Boolean = downKeys.indexOf(KeyType.D) != -1
			if(w && !a && !s && !d)
			{
				GlobalData.self.direction = DirectionType.TOP;
				GlobalData.self.updateMovementState(FrameAnimationGraph.ACT_RUN);
				return;
			}
			else if(s && !a && !w && !d)
			{
				GlobalData.self.direction = DirectionType.BOTTOM;
				GlobalData.self.updateMovementState(FrameAnimationGraph.ACT_RUN);
				return;
			}
			else if(a && !w && !s && !d)
			{
				GlobalData.self.direction = DirectionType.LEFT;
				GlobalData.self.updateMovementState(FrameAnimationGraph.ACT_RUN);
				return;
			}
			else if(d && !a && !s && !w)
			{
				GlobalData.self.direction = DirectionType.RIGHT;
				GlobalData.self.updateMovementState(FrameAnimationGraph.ACT_RUN);
				return;
			}
			else if(w && a && !s && !d)
			{
				GlobalData.self.direction = DirectionType.TOP_LEFT;
				GlobalData.self.updateMovementState(FrameAnimationGraph.ACT_RUN);
				return;
			}
			else if(s && a && !w && !d)
			{
				GlobalData.self.direction = DirectionType.BOTTOM_LEFT;
				GlobalData.self.updateMovementState(FrameAnimationGraph.ACT_RUN);
				return;
			}
			else if(!a && !w && s && d)
			{
				GlobalData.self.direction = DirectionType.BOTTOM_RIGHT;
				GlobalData.self.updateMovementState(FrameAnimationGraph.ACT_RUN);
				return;
			}
			else if(d && !a && !s && w)
			{
				GlobalData.self.direction = DirectionType.TOP_RIGHT;
				GlobalData.self.updateMovementState(FrameAnimationGraph.ACT_RUN);
				return;
			}
			else
			{
				GlobalData.self.updateMovementState(FrameAnimationGraph.ACT_STAND);
			}
		}
			
	}
}