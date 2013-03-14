package gameUnit.action
{
	import data.FrameAnimationConfig;
	

	public class CharacterAction
	{
		public static var pool:Array = [];
		
		public static const ACTION_STAND:int = 0;
		public static const ACTION_RUN:int = 1;
		public static const ACTION_ATTACK1:int = 2;
		public static const ACTION_ATTACK2:int = 3;
		public static const ACTION_JUMP:int =4;
		
		public var block:Boolean;
		public var type:int;
		public var animationQueue:Array;
		public var animationIndex:int = 0;
		public var defaultAnimation:Array;
		
		private var _timer:int
		private var _isCircle:Boolean;
		
		public static var STATIC_ACTION_STAND:CharacterAction = getInstanceByType(ACTION_STAND);
		public static var STATIC_ACTION_RUN:CharacterAction = getInstanceByType(ACTION_RUN);
		
		public function CharacterAction()
		{
			
		}
		public static function getInstance():CharacterAction
		{
			var instance:CharacterAction = pool.length ? pool.pop() : new CharacterAction();
			return instance;
		}
		public function update(duration:int):void
		{
			if(_isCircle)
				return;
			_timer+=duration;
		}
		public function dispose():void
		{
			_timer = 0;
			block = false;
			animationQueue = [];
			defaultAnimation = null;
			animationIndex = 0;
			pool.push(this);
		}
		
		public static function getInstanceByType(type:int):CharacterAction
		{
			var inst:CharacterAction;
			if(type == ACTION_STAND)
			{
				inst = getInstance();
				inst._isCircle = true;
				inst.animationQueue = [[FrameAnimationConfig.ANIMATION_STAND,-1]];
			}
			else if(type == ACTION_RUN)
			{
				inst = getInstance();
				inst._isCircle = true;
				inst.animationQueue = [[FrameAnimationConfig.ANIMATION_RUN,-1]];
			}
			else if(type == ACTION_JUMP)
			{
				inst = getInstance();
				inst.animationQueue = [[FrameAnimationConfig.ANIMATION_DEAD,1]];
				inst.defaultAnimation = [FrameAnimationConfig.ANIMATION_STAND,-1];
				inst.block = true;
			}
			else if(type == ACTION_ATTACK1)
			{
				inst = getInstance();
				inst.animationQueue = [[FrameAnimationConfig.ANIMATION_ATTACK1,1]];
				inst.block = true;
			}
			else if(type == ACTION_ATTACK2)
			{
				inst = getInstance();
				inst.animationQueue = [[FrameAnimationConfig.ANIMATION_ATTACK2,1]];
				inst.block = true;
			}
			inst.type = type;
			return inst;
		}
	}
}