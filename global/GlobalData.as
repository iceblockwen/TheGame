package global
{
	import flash.display.Stage;
	
	import gameUnit.character.Self;

	public class GlobalData
	{
		public static var self:Self;
		public static var stage:Stage;
		public static var characterTimerMutiplier:Number = 1;
		public static var lockCharacterTimer:Boolean
		public function GlobalData()
		{
		}
		public static function setCharacterTimerMutiplier(value:Number):void
		{
			if(lockCharacterTimer)
				return;
			characterTimerMutiplier = value;
		}
	}
}