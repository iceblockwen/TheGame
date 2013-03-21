package gameConfig
{
	import flash.utils.Dictionary;

	public class FrameAnimationConfig
	{
		public var frameQueue:Dictionary;
		public static const ANIMATION_STAND:int = 0;
		public static const ANIMATION_RUN:int = 1;
		public static const ANIMATION_ATTACK1:int = 2;
		public static const ANIMATION_ATTACK2:int = 3;
		public static const ANIMATION_BEHIT:int = 4;
		public static const ANIMATION_DEAD:int = 5;
		public static const ANIMATION_RUSH:int = 6;
		public function FrameAnimationConfig(data:Array)
		{
			frameQueue = new Dictionary();
			for each(var arr:Array in data[1])
			{
				frameQueue[arr[0]] = [arr[1],arr[2],arr[3]];
			}
		}
		private static var _data:Array = [
			[100001,
				[
					[0,[0,1,2,3,4,5,6,7],"res\\character\\1",15],
					[1,[8,9,10,11,12,13,14,15],"res\\character\\1",15],
					[2,[0,1,2,3,4,5,6,7],"res\\character\\2",15],
					[3,[8,9,10,11,12,13,14,15],"res\\character\\2",15],
					[4,[16,17,18,19],"res\\character\\2",15],
					[5,[16,17,18,19,20,21,22,23],"res\\character\\1",15],
					[6,[12],"res\\character\\2",15],],],
			[200001,
				[
					[0,[0,1,2,3,4,5,6,7],"res\\weapon\\1",15],
					[1,[8,9,10,11,12,13,14,15],"res\\weapon\\1",15],
					[2,[16,17,18,19,20,21,22,23],"res\\weapon\\1",15],
					[3,[24,25,26,27,28,29,30,31],"res\\weapon\\1",15],
					[4,[32,33,34,35],"res\\weapon\\1",15],
					[5,[0,1,2,3,4,5,6,7],"res\\weapon\\2",15],
					[6,[28],"res\\weapon\\1",15],],],
			[107001,
				[
					[0,[5,6],"res\\character\\107",3],
					[1,[1,2,3,4],"res\\character\\107",7],
					[2,[7,8,9,10,11,12,13,14],"res\\character\\107",15],
					[3,[0],"res\\character\\107",15],
					[4,[0],"res\\character\\107",15],
					[5,[15],"res\\character\\107",15],
					[6,[12],"res\\character\\107",15],],],
			
		];
		private static function InitData(): Dictionary
		{
			var dic:Dictionary = new Dictionary();
			var len:int = _data.length;
			for (var i:int = 0; i < len; i++)
			{
				var arr:Array = (_data[i] as Array);
				dic[arr[0]] = new FrameAnimationConfig(arr);
			}
			return dic;
		}
		public static var configData:Dictionary = InitData();
	}
}