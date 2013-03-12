package gameUnit.animation.data
{
	import flash.utils.Dictionary;

	public class FrameAnimationGraph
	{
		public var frameQueue:Dictionary = new Dictionary();
		public static const ACT_STAND:int = 0;
		public static const ACT_RUN:int = 1;
		public static const ACT_ATTACK:int = 2;
		public function FrameAnimationGraph()
		{
			frameQueue[ACT_STAND] = [0,1,2,3,4,5,6,7];
			frameQueue[ACT_RUN] = [8,9,10,11,12,13,14,15];
			frameQueue[ACT_ATTACK] = [16,17,18,19];
		}
	}
}