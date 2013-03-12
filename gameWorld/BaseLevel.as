package gameWorld
{
	import Interface.ITick;
	
	import global.GlobalData;
	
	import tick.TickManager;

	public class BaseLevel implements ITick
	{
		public var map:BaseMap;
		public function BaseLevel()
		{
			map = new BaseMap();
			initLevel();
		}
		public function initLevel():void
		{
			initSelf();
			map.loadMap(101);
			TickManager.getInstance().addTick(this);
		}
		public function initSelf():void
		{
			GlobalData.self = CharacterManager.getInstance().setSelf();
			GlobalData.self.visible = true;
			GlobalData.self.move(0,0);
			CameraManager.getInstance().cameraTrace(GlobalData.self);
		}
		public function update(duration:int):void
		{
			CharacterManager.getInstance().updateCharacters(duration);
		}
	}
}