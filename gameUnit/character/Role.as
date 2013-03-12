package gameUnit.character
{
	import gameUnit.BaseSceneObj;
	import gameUnit.RenderUnit;
	import gameUnit.animation.FrameAnimationCtrl;
	import gameUnit.animation.data.FrameAnimationGraph;
	import gameUnit.data.RoleVO;
	
	import global.DirectionType;
	
	import resource.PathConfig;

	public class Role extends BaseSceneObj
	{
		public static const MOV_STAND:int = 0;
		public static const MOV_RUN:int = 1;
		
		protected var _data:RoleVO;
		protected var _movementState:int;
		public var direction:int = 0;
		public var speed:Number = 0.2;
		
		public var frameAnimationCtrl:FrameAnimationCtrl = new FrameAnimationCtrl();
		public function Role()
		{
			
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
			move(x + speed*duration*dirX,y + speed*duration*dirY);
		}
		public function set data(value:RoleVO):void
		{
			_data = value;
			initFigure();
		}
		public function get data():RoleVO
		{
			return _data;
		}
		protected function initFigure():void
		{
			if(_renderObj == null) 
				_renderObj = RenderUnit.getInstance();
			_renderObj.property.isAnimated = true;
			_renderObj.url = PathConfig.getCharacterResPath();
			_renderObj.setFrame(0);
			frameAnimationCtrl.setGraph(new FrameAnimationGraph());
			frameAnimationCtrl.fps = 15;
			frameAnimationCtrl.target = _renderObj;
			frameAnimationCtrl.setAct(FrameAnimationGraph.ACT_STAND);
		}
		protected function setDirection():void
		{
			var dirX:int = DirectionType.getDirX(direction);
			if(dirX == 1)
				_renderObj.hFlip(false);
			else if(dirX == -1)
				_renderObj.hFlip(true);
		}
		public function update(duration:int):void
		{
			if(_movementState == MOV_RUN)
				moveOneStep(duration);
			setDirection();
			frameAnimationCtrl.update(duration);
		}
		
		public function updateMovementState(type:int):void
		{
			_movementState = type;
			if(_movementState == MOV_STAND)
				frameAnimationCtrl.setAct(FrameAnimationGraph.ACT_STAND);
			else if(_movementState == MOV_RUN)
				frameAnimationCtrl.setAct(FrameAnimationGraph.ACT_RUN);
		}
	}
}