package gameUnit.character
{
	import gameUnit.RenderUnit;
	import gameUnit.animation.FrameAnimationCtrl;

	public class Monster extends Role
	{
		public const PART_BODY:int = 0;
		public function Monster()
		{
		}
		override protected function initFigure():void
		{
			_renderObjs[PART_BODY] = RenderUnit.getInstance();
			
			_renderObjs[PART_BODY].id = id+"@0";
			_renderObjs[PART_BODY].isAnimated = true;
			_renderObjs[PART_BODY].animationId = 100001;
			_renderObjs[PART_BODY].setFrame(0);
			_renderObjs[PART_BODY].level = 1000.1;
			frameAnimationCtrls[PART_BODY] = new FrameAnimationCtrl();
			frameAnimationCtrls[PART_BODY].fps = 15;
			frameAnimationCtrls[PART_BODY].target = _renderObjs[PART_BODY];
			frameAnimationCtrls[PART_BODY].addEventListener("ANIMATION_EVT_FINISH",onFinishAnimation);
			setAction(DEFAULT_ACTION);
		}
	}
}