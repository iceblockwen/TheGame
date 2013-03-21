package gameWorld
{
	import flash.display.Stage;
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	
	import Interface.ITick;
	
	import gameUnit.action.CharacterAction;
	import gameUnit.character.Self;
	
	import global.GlobalData;
	import global.GlobalEvent;
	import global.KeyType;
	
	import tick.TickManager;

	public class InputManager extends EventDispatcher implements ITick
	{
		private static var instance:InputManager;
		
		private var _stage:Stage;
		public var _keyBuffer:Array;
		public var _currentKeyClick:int;
		public var _instructionBuffer:Array;
		public var _attackBuffer:Array;
		public var _upCallback:Function;
		public var _downCallback:Function;
		private const DELAY:int = 300;
		public function InputManager(stage:Stage)
		{
			_stage = stage;
			_keyBuffer = [];
			_instructionBuffer = [];
			_attackBuffer= [];
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
			dispatchEvent(GlobalEvent.GLOBAL_EVT_KEY);
			dispatchEvent(GlobalEvent.GLOBAL_EVT_KEY_UP);
		}
		
		protected function onKeyDownHandler(event:KeyboardEvent):void
		{
			if(_keyBuffer.indexOf(event.keyCode as int) != -1)
				return;
//			trace("DOWN KEY:"+event.keyCode);
			_keyBuffer.push(event.keyCode as int);
			_currentKeyClick = event.keyCode;
			bufferInstructions(event.keyCode);
			dispatchEvent(GlobalEvent.GLOBAL_EVT_KEY);
			dispatchEvent(GlobalEvent.GLOBAL_EVT_KEY_DOWN);
		}
		
		protected function bufferInstructions(keyCode:int):void
		{
			_instructionBuffer.push([keyCode,DELAY]);
//			trace("buffer "+keyCode);
			TickManager.getInstance().addTick(this);
		}
		
		private function findInstruction(keyCode:int,from:int):int
		{
			var len:int = _instructionBuffer.length;
			for(var i:int = from;i< len;i++)
			{
				if(_instructionBuffer[i][0] == keyCode)
				{
					return i;
				}
			}
			return -1;
		}
		
		public function checkInstruction():void
		{
			if(_currentKeyClick == KeyType.A)
			{
				if(checkDoubleClick(KeyType.A))
					GlobalData.self.rush();
			}
			else if(_currentKeyClick == KeyType.D)
			{
				if(checkDoubleClick(KeyType.D))
					GlobalData.self.rush();
			}
			else if(_currentKeyClick == KeyType.J)
			{
				if(!GlobalData.self.attack(Self.ATTACK_TYPE_1))
				{
					_attackBuffer.push(KeyType.J);
				}
			}
			else if(_currentKeyClick == KeyType.U)
			{
				if(!GlobalData.self.attack(Self.ATTACK_TYPE_2))
				{
					_attackBuffer.push(KeyType.U);
				}
			}
			else if(_currentKeyClick == KeyType.SPACE)
			{
				GlobalData.self.setAction(CharacterAction.getInstanceByType(CharacterAction.ACTION_JUMP));
			}
		}
		
		private function checkDoubleClick(keyCode:int):Boolean
		{
			var index:int = findInstruction(keyCode,0);
			if(index != -1)
			{
				var nextIndex:int = findInstruction(keyCode,index+1);
				if(nextIndex != -1)
				{
					_instructionBuffer.splice(index,1);
					_instructionBuffer.splice(nextIndex-1,1);
					return true;
				}
			}
			return false;
		}
		
		private function checkAttackBuffer():void
		{
			var len:int = _attackBuffer.length;
			for(var i:int = 0;i<len;i++)
			{
				var key:int = _attackBuffer[i];
				var index:int = findInstruction(key,0);
				if(index != -1)
				{
					if(key == KeyType.J)
					{
						if(GlobalData.self.attack(Self.ATTACK_TYPE_1))
							_instructionBuffer.splice(index,1);
					}
					else if(key == KeyType.U)
					{
						if(GlobalData.self.attack(Self.ATTACK_TYPE_2))
							_instructionBuffer.splice(index,1);
					}
				}
			}
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
			checkAttackBuffer();
			if(_instructionBuffer.length == 0)
				TickManager.getInstance().removeTick(this);
		}
		public function checkMove():void
		{
			if(GlobalData.self.inControl == false)
				return;
			var downKeys:Array = _keyBuffer;
			var w:int = int(downKeys.indexOf(KeyType.W) != -1)
			var s:int = int(downKeys.indexOf(KeyType.S) != -1)
			var a:int = int(downKeys.indexOf(KeyType.A) != -1)
			var d:int = int(downKeys.indexOf(KeyType.D) != -1)
			var j:Boolean = downKeys.indexOf(KeyType.J) != -1;
			var u:Boolean = downKeys.indexOf(KeyType.U) != -1;
			var value:int = w+(s<<1)+(a<<2)+(d<<3);
//			if(j)
//			{
//				GlobalData.self.setAction(CharacterAction.getInstanceByType(CharacterAction.ACTION_ATTACK1));
//				return;
//			}
//			if(u)
//			{
//				GlobalData.self.setAction(CharacterAction.getInstanceByType(CharacterAction.ACTION_ATTACK2));
//				return;
//			}
			if(value)
			{
				GlobalData.self.keyBoardMove(value);
				return;
			}
			else
			{
				GlobalData.self.keyBoardStop();
			}
		}
			
	}
}