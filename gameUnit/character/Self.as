package gameUnit.character
{
	import gameUnit.action.CharacterAction;
	
	import gameWorld.InputManager;
	
	import global.DirectionType;

	public class Self extends Player
	{
		public static const ATTACK_TYPE_1:int = 1;
		public static const ATTACK_TYPE_2:int = 2;
		
		public const COMBO_TIME:int = 500;
		
		private var _comboLevel:int;
		private var _startCombo:Boolean;
		private var _comboDelay:int;
		public function Self()
		{
			super();
		}
		public function keyBoardMove(dir:int):void
		{
			if(_currentAct && _currentAct.blockMove) 
				return;
			direction = dir;
			var dirX:Number = DirectionType.getDirX(direction);
			var dirY:Number = DirectionType.getDirY(direction);
			
			if(dirX != 0 && dirY != 0)
			{
				dirX = 0.71*dirX;
				dirY = 0.71*dirY;
			}
			_curSpeedX = _speed*dirX;
			if(groundY == 0)
				_curSpeedY = _speed*dirY;
			else
				_curSpeedY = 0
			if(groundY == 0 && _currentAct == null)
				setAnimation();
		}
		public function keyBoardStop():void
		{
			if(groundY == 0 && _currentAct == null)
			{
				_curSpeedX = 0;
				_curSpeedY = 0;
				setSpeed(WALK_SPEED);
				setAnimation();
			}
		}
		public function attack(attackType:int):Boolean
		{
			var res:Boolean;
			_comboDelay = 0;
			if(attackType == ATTACK_TYPE_1)
			{
				if(_comboLevel == 0)
				{
					res = setAction(CharacterAction.getInstanceByType(CharacterAction.ACTION_ATTACK1));
					if(res)
						_startCombo = true;
				}
				else if(_comboLevel == 1)
					res = setAction(CharacterAction.getInstanceByType(CharacterAction.ACTION_ATTACK1_PART2));
				else if(_comboLevel == 2)
					res = setAction(CharacterAction.getInstanceByType(CharacterAction.ACTION_ATTACK1_PART3));
				else if(_comboLevel == 3)
					res = setAction(CharacterAction.getInstanceByType(CharacterAction.ACTION_ATTACK1_PART4));
				if(res)
				{
					_comboLevel++;
				}
				if(_comboLevel > 3)
				{
					_comboLevel = 0;
					_startCombo = false;
				}
			}
			else if(attackType == ATTACK_TYPE_2)
			{
				if(_comboLevel == 0)
				{
					res = setAction(CharacterAction.getInstanceByType(CharacterAction.ACTION_ATTACK2));
					if(res)
						_startCombo = true;
				}
				else if(_comboLevel == 1)
					res = setAction(CharacterAction.getInstanceByType(CharacterAction.ACTION_ATTACK2_PART2));
				else if(_comboLevel == 2)
					res = setAction(CharacterAction.getInstanceByType(CharacterAction.ACTION_ATTACK2_PART3));
				if(res)
				{
					_comboLevel++;
				}
				if(_comboLevel > 2)
				{
					_comboLevel = 0;
					_startCombo = false;
				}
			}
			return res;
		}
		
		override protected function adjustAttackRect():void
		{
			onHitRect.rect.x -= 50;
			onHitRect.rect.y -= 120;
		}
		
		override public function update(duration:int):void
		{
			super.update(duration);
			if(_startCombo)
			{
				_comboDelay += duration;
				if(_comboDelay > COMBO_TIME)
				{
					_comboLevel = 0;
					_startCombo = false;
				}
			}
		}
		override protected function actionFinish():void
		{
			super.actionFinish();
			InputManager.getInstance().checkMove();
		}
		override public function stop():void
		{
			super.stop();
			InputManager.getInstance().checkMove();
		}
	}
}