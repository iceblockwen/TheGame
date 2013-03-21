package gameUnit.character
{
	import gameUnit.RenderUnit;
	import gameUnit.animation.FrameAnimationCtrl;

	public class Player extends Role
	{
		public static var pool:Array = [];
		public const PART_BODY:int = 0;
		public const PART_WEAPON:int = 1;
		
		public function Player()
		{
			super();
		}
		public static function getInstanece():Player
		{
			var instance:Player = pool.length ? pool.pop() : new Player();
			return instance;
		}
		override protected function initFigure():void
		{
			_renderObjs[PART_BODY] = RenderUnit.getInstance();
			_renderObjs[PART_WEAPON] = RenderUnit.getInstance();
			
			_renderObjs[PART_BODY].id = id+"@0";
			_renderObjs[PART_BODY].isAnimated = true;
			_renderObjs[PART_BODY].animationId = 100001;
			_renderObjs[PART_BODY].setFrame(0);
			_renderObjs[PART_BODY].level = 1000.1;
			_renderObjs[PART_WEAPON].id = id+"@1";
			_renderObjs[PART_WEAPON].isAnimated = true;
			_renderObjs[PART_WEAPON].animationId = 200001;
			_renderObjs[PART_WEAPON].setFrame(0);
			_renderObjs[PART_WEAPON].level = 1000.2;
			frameAnimationCtrls[PART_BODY] = new FrameAnimationCtrl();
			frameAnimationCtrls[PART_WEAPON] = new FrameAnimationCtrl();
			frameAnimationCtrls[PART_BODY].fps = 15;
			frameAnimationCtrls[PART_WEAPON].fps = 15;
			frameAnimationCtrls[PART_BODY].target = _renderObjs[PART_BODY];
			frameAnimationCtrls[PART_WEAPON].target = _renderObjs[PART_WEAPON];
			frameAnimationCtrls[PART_BODY].addEventListener("ANIMATION_EVT_FINISH",onFinishAnimation);
			setAnimation();
		}
		
		public function dispose():void
		{
			pool.push(this);
		}
	}
}