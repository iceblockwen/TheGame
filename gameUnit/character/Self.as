package gameUnit.character
{
	import gameUnit.action.CharacterAction;
	
	import gameWorld.InputManager;

	public class Self extends Player
	{
		public function Self()
		{
		}
		override public function move(mx:Number, my:Number):void
		{
			super.move(mx,my);
		}
		override public function update(duration:int):void
		{
			if(_currentAct == null)
			{
				InputManager.getInstance().checkMove();
				return;
			}
			_currentAct.update(duration);
			if(_currentAct.type == CharacterAction.ACTION_RUN)
			{
				moveOneStep(duration);
			}
			else if(_currentAct.type == CharacterAction.ACTION_JUMP)
			{
				jumpOneStep(duration);
			}
			setDirection();
			frameAnimationCtrls[PART_BODY].update(duration);
			frameAnimationCtrls[PART_WEAPON].update(duration);
		}
		override protected function jumpOneStep(duration:int):void
		{
			airSpeed += gravity*duration/1000;
			jumpHeight += airSpeed*duration;
			if(jumpHeight >= 0)
			{
				_currentAct.dispose();
				_currentAct = null;
				jumpHeight = 0;
				InputManager.getInstance().checkMove();
			}
			move(x + _curSpeedX*duration,groundY + jumpHeight);
		}
	}
}