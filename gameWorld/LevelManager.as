package gameWorld
{
	public class LevelManager
	{
		private var _Levels:Array;
		private var _currentLevel:BaseLevel;
		private static var instance:LevelManager;
		public function LevelManager()
		{
		}
		public static function getInstance():LevelManager
		{
			if(!instance)
				instance  = new LevelManager();
			return instance;
		}
		public function loadLevel():void
		{
			_currentLevel = new BaseLevel();
		}
	}
}