package gameUnit.character
{
	import flash.events.Event;
	
	import gameUnit.BaseSceneObj;
	import gameUnit.RenderUnit;
	import gameUnit.action.CharacterAction;
	import gameUnit.animation.FrameAnimationCtrl;
	import gameUnit.data.RoleVO;
	
	import global.DirectionType;

	public class Role extends BaseSceneObj
	{
		protected var _data:RoleVO;
		protected var _curSpeedX:Number = 0;
		protected var _curSpeedY:Number = 0;
		protected var _currentAct:CharacterAction;

		public var direction:int = 0;
		public var speed:Number = 0.3;
		public var airSpeed:Number;
		public var gravity:Number = 1.2;
		public var jumpHeight:Number = 0;
		public var groundY:Number = 0;
		
		public var frameAnimationCtrls:Array;
		
		protected var DEFAULT_ACTION:CharacterAction;
		
		public function Role()
		{
			frameAnimationCtrls = [];
			DEFAULT_ACTION = CharacterAction.STATIC_ACTION_STAND;
		}
		public function set data(value:RoleVO):void
		{
			_data = value;
			id = _data.id;
			initFigure();
		}
		public function get data():RoleVO
		{
			return _data;
		}
		public function setAction(act:CharacterAction):void
		{
			if((_currentAct && _currentAct.block) || (act != null && _currentAct == act))
				return;
			_currentAct = act?act:DEFAULT_ACTION;
			if(_currentAct.type == CharacterAction.ACTION_JUMP)
			{
				jumpHeight = 0;
				groundY = y;
				airSpeed = -speed *2;
			}
			else if(_currentAct.type == CharacterAction.ACTION_STAND)
			{
				_curSpeedX = 0;
				_curSpeedY = 0;
			}
			
			var animation:Array = _currentAct.animationQueue[_currentAct.animationIndex];
			for each(var ctrl:FrameAnimationCtrl in frameAnimationCtrls)
			{
				ctrl.setAnimation(animation[0],animation[1]);
			}
		}
		protected function initFigure():void
		{
			setAction(DEFAULT_ACTION);
		}
		protected function moveOneStep(duration:int):void
		{
			var dirX:Number = DirectionType.getDirX(direction);
			var dirY:Number = DirectionType.getDirY(direction);
			if(dirX != 0 && dirY != 0)
			{
				dirX = 0.71*dirX;
				dirY = 0.71*dirY;
			}
			_curSpeedX = speed*dirX;
			_curSpeedY = speed*dirY;
			move(x + _curSpeedX*duration,y + _curSpeedY*duration);
		}
		protected function jumpOneStep(duration:int):void
		{
			airSpeed += gravity*duration/1000;
			jumpHeight += airSpeed*duration;
			if(jumpHeight >= 0)
			{
				_currentAct.dispose();
				_currentAct = null;
				jumpHeight = 0;
			}
			move(x + _curSpeedX*duration,groundY + jumpHeight);
		}
		protected function onFinishAnimation(event:Event):void
		{
			if(_currentAct == null) 
				return;
			_currentAct.animationIndex ++;
			var animation:Array = _currentAct.animationQueue[_currentAct.animationIndex];
			if(animation)
			{
				for each(var ctrl:FrameAnimationCtrl in frameAnimationCtrls)
				{
					ctrl.setAnimation(animation[0],animation[1]);
				}
			}
			else if(_currentAct.defaultAnimation)
			{
				for each (ctrl in frameAnimationCtrls)
				{
					ctrl.setAnimation(_currentAct.defaultAnimation[0],_currentAct.defaultAnimation[1]);
				}
			}
			else
			{
				_currentAct.dispose();
				_currentAct = null;
			}
		}
		protected function setDirection():void
		{
			var dirX:int = DirectionType.getDirX(direction);
			if(dirX == 1)
			{
				for each(var unit:RenderUnit in _renderObjs)
				{
					unit.hFlip(false);
				}
			}
			else if(dirX == -1)
			{
				for each(unit in _renderObjs)
				{
					unit.hFlip(true);
				}
			}
		}
		public function update(duration:int):void
		{
			if(_currentAct == null)
				return;
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
			for each (var ctrl:FrameAnimationCtrl in frameAnimationCtrls)
			{
				ctrl.update(duration);
			}
		}
	}
}