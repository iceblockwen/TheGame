package gameUnit.character
{
	import flash.events.Event;
	
	import gameConfig.FrameAnimationConfig;
	
	import gameUnit.BaseSceneObj;
	import gameUnit.RenderUnit;
	import gameUnit.action.CharacterAction;
	import gameUnit.animation.FrameAnimationCtrl;
	import gameUnit.dataVO.RoleVO;
	import gameUnit.physics.InteractionRect;
	
	import gameWorld.CharacterManager;
	
	import global.DirectionType;
	import global.GlobalData;

	public class Role extends BaseSceneObj
	{
		protected var _data:RoleVO;
		protected var _curSpeedX:Number = 0;
		protected var _curSpeedY:Number = 0;
		
		public static var WALK_SPEED:Number = 0.3;
		public static var RUSH_SPEED:Number = 0.8;
		public static var JUMP_SPEED:Number = 0.8;
		
		protected var _currentAct:CharacterAction;
		protected var _speed:Number = WALK_SPEED;

		public var direction:int = 0;
		public var airSpeed:Number = 0;
		public var gravity:Number = -1.2;
		
		public var inControl:Boolean = true;
		
		public var onHitRect:InteractionRect;
		public var attackRect:InteractionRect;
		
		public var frameAnimationCtrls:Array;
		
		protected var DEFAULT_ANIMATION:Array = [FrameAnimationConfig.ANIMATION_STAND,FrameAnimationConfig.ANIMATION_RUN,FrameAnimationConfig.ANIMATION_RUSH];
		protected var DEFAULT_AIR_ANIMATION:Array = [FrameAnimationConfig.ANIMATION_STAND,FrameAnimationConfig.ANIMATION_DEAD];
		
		public function Role()
		{
			frameAnimationCtrls = [];
			onHitRect = new InteractionRect(100,140);
			_hFlip = 1;
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
		public function setAction(act:CharacterAction):Boolean
		{
			if(!act.force && (_currentAct && _currentAct.block) || _currentAct == act)
				return false;
			if(act.force && _currentAct)
			{
				forceClearCurAction();
			}
			//设置要执行的动作
			_currentAct = act;
			if(_currentAct)
			{
				if(_currentAct.blockMove && groundY == 0)
				{
					stop();
				}
				if(_currentAct.subType == CharacterAction.ACTION_JUMP)
				{
					airSpeed = JUMP_SPEED;
				}
				if(!_currentAct.moveVecters)
				{
					_currentAct.finishMove = true;
				}
				inControl = _currentAct.inControl;
			}
			setAnimation();
			return true;
		}
		
		public function doBeHit(dir:int):void
		{
			var act:CharacterAction = CharacterAction.getInstanceByType(CharacterAction.ACTION_BEHIT_NORMAL);
			act.dir = dir;
			setAction(act);
		}
		
		protected function doAttack():void
		{
			attackRect = new InteractionRect(100,50);
			var h:int = _hFlip>0?50:-150;
			attackRect.move(x + h,y-100,groundY);
			attackRect.drawRect();
			CharacterManager.getInstance().hitTest(attackRect,this);
		}
		
		override public function move(mx:Number,my:Number,mz:Number):void
		{
			super.move(mx,my,mz);
			onHitRect.move(mx,my,mz);
			adjustAttackRect();
			if(onHitRect)
				onHitRect.drawRect();
			if(attackRect)
			{
				attackRect.move(mx,my,mz);
				var h:int = _hFlip>0?50:-150;
				attackRect.rect.x += h;
				attackRect.rect.y -= 100;
				attackRect.drawRect();
			}
		}
		
		protected function adjustAttackRect():void
		{
		}
		
		public function stop():void
		{
			_curSpeedX = 0;
			_curSpeedY = 0;
		}
		
		public function rush():void
		{
			if(groundY == 0)
				setSpeed(RUSH_SPEED,true);
		}
		
		protected function setSpeed(value:Number,realtime:Boolean = false):void
		{
			_speed = value;
			if(realtime)
			{
				var dirX:Number = DirectionType.getDirX(direction);
				var dirY:Number = DirectionType.getDirY(direction);
				
				if(dirX != 0 && dirY != 0)
				{
					dirX = 0.71*dirX;
					dirY = 0.71*dirY;
				}
				_curSpeedX = _speed*dirX;
				_curSpeedY = _speed*dirY;
				setAnimation();
			}
		}
		//设置位移
		protected function setActMovement(duration:int):void
		{
			var len:int = _currentAct.moveVecters.length;
			if(_currentAct.timer > _currentAct.moveVecters[len-1][1])
			{
				_currentAct.finishMove = true;
				if(_currentAct.finishAnimation)
					setAnimation();
				return;
			}
			for(var i:int = 0;i<len;i++)
			{
				var timer:Number = duration * GlobalData.characterTimerMutiplier;
				var startTime:int = _currentAct.moveVecters[i][0];
				var endTime:int = _currentAct.moveVecters[i][1];
				if(_currentAct.timer > endTime || _currentAct.timer < startTime)
					continue;
				var disX:int = _currentAct.moveVecters[i][2];
				var disY:int = _currentAct.moveVecters[i][3];
				var disZ:int = _currentAct.moveVecters[i][4];
				
				var acc:Number = _currentAct.moveVecters[i][5];
				var timeScale:Number = timer/(endTime - startTime);
				if(_currentAct.fixDir)
				{
					var dirX:int = DirectionType.getDirX(_currentAct.dir);
					var dirY:int = DirectionType.getDirX(_currentAct.dir);
					move(x+disX*timeScale*dirX,y+disY*timeScale*dirY,groundY + disZ*timeScale);
				}
				else
					move(x+disX*timeScale*_hFlip,y+disY*timeScale,groundY + disZ*timeScale);
			}
		}
		//设置动画
		protected function setAnimation():void
		{
			if(_currentAct == null)
			{
				setDefaultAnimation();
			}
			else
			{
				var animation:Array = _currentAct.animationQueue[_currentAct.animationIndex];
				if(animation)
				{
					for each(var ctrl:FrameAnimationCtrl in frameAnimationCtrls)
					{
						ctrl.setAnimation(animation[0],animation[1]);
					}
				}
				else
				{
					_currentAct.finishAnimation = true;
					clearCurAction();
				}
			}
		}
		protected function clearCurAction():void
		{
			if((_currentAct.finishMove && 
				_currentAct.finishAnimation && 
				_currentAct.actionTime == -1 )|| _currentAct.finish)
			{
				_currentAct.dispose();
				_currentAct = null;
				actionFinish();
			}
		}
		protected function forceClearCurAction():void
		{
			_currentAct.dispose();
			_currentAct = null;
			actionFinish();
		}
		protected function actionFinish():void
		{
			GlobalData.setCharacterTimerMutiplier(1);
			inControl = true;
			setAnimation();
			if(attackRect)
			{	
				attackRect.dispose();
				attackRect = null;
			}
		}
		
		protected function setDefaultAnimation():void
		{
			if(groundY == 0)
			{
				for each(var ctrl:FrameAnimationCtrl in frameAnimationCtrls)
				{
					if(_curSpeedX ==0 && _curSpeedY ==0)
						ctrl.setAnimation(DEFAULT_ANIMATION[0]);
					else if(_speed < 0.5)
						ctrl.setAnimation(DEFAULT_ANIMATION[1]);
					else
						ctrl.setAnimation(DEFAULT_ANIMATION[2]);
				}
			}
			if(groundY > 0)
			{
				for each(ctrl in frameAnimationCtrls)
				{
					if(_curSpeedX ==0)
						ctrl.setAnimation(DEFAULT_AIR_ANIMATION[0]);
					else
						ctrl.setAnimation(DEFAULT_AIR_ANIMATION[1]);
				}
			}
		}
		
		protected function initFigure():void
		{
			setAnimation();
		}
		
		protected function onFinishAnimation(event:Event):void
		{
			if(_currentAct != null) 
				_currentAct.animationIndex ++;
			setAnimation();
		}
		private var _dirX:int;
		private var _hFlip:int;
		protected function setRenderDirection(dirX:int):void
		{
			_dirX = dirX;
			if(dirX == 1)
			{
				for each(var unit:RenderUnit in _renderObjs)
				{
					unit.hFlip(false);
					_hFlip = 1;
				}
			}
			else if(dirX == -1)
			{
				for each(unit in _renderObjs)
				{
					unit.hFlip(true);
					_hFlip = -1;
				}
			}
		}
		protected function moveOneStep(duration:int):void
		{
			if(groundY > 0)
			{
				airSpeed += gravity*duration/1000;
				move(x + _curSpeedX*duration,y + _curSpeedY*duration,groundY + airSpeed*duration);
				if(groundY == 0)
				{
					airSpeed = 0;
					stop();
				}
			}
			else
			{
				if(airSpeed > 0)
					airSpeed += gravity*duration/1000;
				else if(airSpeed < 0)
					airSpeed = 0;
				move(x + _curSpeedX*duration,y + _curSpeedY*duration,groundY + airSpeed*duration);
			}
		}
		
		public function update(duration:int):void
		{
			var timer:int;
			if(_currentAct)
			{
				GlobalData.setCharacterTimerMutiplier(_currentAct.timeMutiplier);
				timer = duration * GlobalData.characterTimerMutiplier;
				_currentAct.update(timer);
				if(_currentAct.attackEnable)
				{
					doAttack();
					_currentAct.attackEnable = false;
				}
				if(_currentAct.finish)
					clearCurAction();
			}
			else
				timer = duration * GlobalData.characterTimerMutiplier;
			var dirX:int = DirectionType.getDirX(direction);
			if(_dirX != dirX)
				setRenderDirection(dirX);
			if(_currentAct && _currentAct.moveVecters)
				setActMovement(timer);
			if(_currentAct == null || (!_currentAct.blockMove && groundY == 0) || (!_currentAct.blockAirMove && groundY > 0))
				moveOneStep(timer);
			for each (var ctrl:FrameAnimationCtrl in frameAnimationCtrls)
			{
				ctrl.update(timer);
			}
		}
	}
}