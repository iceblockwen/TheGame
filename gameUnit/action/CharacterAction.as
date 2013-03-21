package gameUnit.action
{
	import gameConfig.FrameAnimationConfig;
	
	import gameUnit.effect.ScreenEffect;
	
	import global.GlobalData;
	

	public class CharacterAction
	{
		public static var pool:Array = [];
		
		public static const TYPE_MOVEMENT:int = 0;
		public static const TYPE_ATTACK:int = 1;
		
		public static const ACTION_RUN:int = 1;
		public static const ACTION_ATTACK1:int = 2;
		public static const ACTION_ATTACK2:int = 3;
		public static const ACTION_JUMP:int =4;
		public static const ACTION_ATTACK1_PART2:int = 5;
		public static const ACTION_ATTACK1_PART3:int = 6;
		public static const ACTION_ATTACK1_PART4:int = 7;
		public static const ACTION_ATTACK2_PART2:int = 8;
		public static const ACTION_ATTACK2_PART3:int = 9;
		public static const ACTION_BEHIT_NORMAL:int = 10;
		
		public var block:Boolean;
		public var blockMove:Boolean;
		public var blockAirMove:Boolean;
		public var mainType:int;
		public var subType:int;
		public var animationQueue:Array;
		public var animationIndex:int = 0;
		public var moveVecters:Array;
		public var timeMutiplier:Number = 1;
		public var finishMove:Boolean;
		public var finishAnimation:Boolean;
		public var actionTime:int = -1;
		public var finish:Boolean = false;
		public var effectKeyTime:int = -1;
		public var attackKeyTime:int = -1;
		public var attackEnable:Boolean;
		public var force:Boolean;
		public var fixDir:Boolean;
		public var dir:int;
		public var inControl:Boolean = true;;
		
		public var timer:int
		private var _isCircle:Boolean;
		
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
			timer+=duration*GlobalData.characterTimerMutiplier;
			if(effectKeyTime != -1 && timer > effectKeyTime)
			{
				effectKeyTime = -1;
				doEffect();
			}
			if(attackKeyTime != -1 && timer > attackKeyTime)
			{
				attackKeyTime = -1;
				attackEnable = true;
			}
			if(actionTime != -1 && timer >= actionTime)
				finish = true;
		}
		private function doEffect():void
		{
			ScreenEffect.getInstance().radioBlur(0.2,550,0.1);
		}
		public function dispose():void
		{
			timer = 0;
			block = false;
			blockMove = false;
			blockAirMove = false;
			animationQueue = [];
			moveVecters = null;
			animationIndex = 0;
			timeMutiplier = 1;
			finishMove = false;
			finishAnimation = false;
			finish = false;
			actionTime = -1;
			effectKeyTime = -1;
			force = false;
			inControl = true;
			mainType = 0;
			subType = 0;
			dir = 0;
			fixDir= false;
			attackEnable = false;
			attackKeyTime = -1;
			pool.push(this);
		}
		public static function getInstanceByType(type:int):CharacterAction
		{
			var inst:CharacterAction;
			if(type == ACTION_JUMP)
			{
				inst = getInstance();
				inst.animationQueue = [[FrameAnimationConfig.ANIMATION_BEHIT,1]];
				inst.block = true;
				inst.mainType = TYPE_MOVEMENT;
			}
			else if(type == ACTION_ATTACK1)
			{
				inst = getInstance();
				inst.animationQueue = [[FrameAnimationConfig.ANIMATION_ATTACK1,1]];
				inst.attackKeyTime = 275;
				inst.block = true;
				inst.blockMove = true;
				inst.mainType = TYPE_ATTACK;
			}
			else if(type == ACTION_ATTACK1_PART2)
			{
				inst = getInstance();
				inst.animationQueue = [[FrameAnimationConfig.ANIMATION_ATTACK1,1]];
				inst.attackKeyTime = 275;
				inst.moveVecters = [[0,100,100,0,0,0]];
				inst.block = true;
				inst.blockMove = true;
				inst.mainType = TYPE_ATTACK;
			}
			else if(type == ACTION_ATTACK1_PART3)
			{
				inst = getInstance();
				inst.animationQueue = [[FrameAnimationConfig.ANIMATION_RUSH,-1]];
				inst.attackKeyTime = 275;
				inst.actionTime = 350;
				inst.moveVecters = [[0,300,250,0,0,0]];
				inst.block = true;
				inst.blockMove = true;
				inst.mainType = TYPE_ATTACK;
			}
			else if(type == ACTION_ATTACK1_PART4)
			{
				inst = getInstance();
				inst.animationQueue = [[FrameAnimationConfig.ANIMATION_ATTACK2,1]];
				inst.attackKeyTime = 275;
				inst.timeMutiplier = 0.5;
				inst.block = true;
				inst.blockMove = true;
				inst.mainType = TYPE_ATTACK;
			}
			else if(type == ACTION_ATTACK2)
			{
				inst = getInstance();
				inst.animationQueue = [[FrameAnimationConfig.ANIMATION_ATTACK2,1]];
				inst.attackKeyTime = 275;
				inst.block = true;
				inst.blockMove = true;
				inst.mainType = TYPE_ATTACK;
			}
			else if(type == ACTION_ATTACK2_PART2)
			{
				inst = getInstance();
				inst.animationQueue = [[FrameAnimationConfig.ANIMATION_ATTACK1,1]];
				inst.attackKeyTime = 275;
				inst.timeMutiplier = 0.65;
				inst.block = true;
				inst.blockMove = true;
				inst.mainType = TYPE_ATTACK;
			}
			else if(type == ACTION_ATTACK2_PART3)
			{
				inst = getInstance();
				inst.animationQueue = [[FrameAnimationConfig.ANIMATION_ATTACK2,1]];
				inst.moveVecters = [[0,100,200,0,230,-10],[101,201,200,0,-200,-10]];         //时间 s e    距离x 距离x 距离x 加速度
				inst.timeMutiplier = 0.5;
				inst.attackKeyTime = 175;
				inst.effectKeyTime = 175;
				inst.block = true;
				inst.blockMove = true;
				inst.mainType = TYPE_ATTACK;
//				inst.blockAirMove = true;
			}
			else if(type == ACTION_BEHIT_NORMAL)
			{
				inst = getInstance();
				inst.animationQueue = [[FrameAnimationConfig.ANIMATION_BEHIT,-1]];
				inst.actionTime = 670;
				inst.moveVecters = [[0,100,50,0,0,0]]; 
				inst.block = true;
				inst.blockMove = true;
				inst.force = true;
				inst.inControl = false;
				inst.fixDir = true;
			}
			inst.subType = type;
			return inst;
		}
	}
}