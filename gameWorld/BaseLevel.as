package gameWorld
{
	import Interface.ITick;
	
	import gameUnit.character.Monster;
	import gameUnit.character.Player;
	import gameUnit.dataVO.MonsterVO;
	import gameUnit.dataVO.PlayerVO;
	
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
			CameraManager.getInstance().setMap(map);
//			for(var i:int = 0;i<500;i++)
//			{
//				var vo:PlayerVO = new PlayerVO();
//				vo.id = i+"";
//				addPlayer(vo,Math.random()*1000,Math.random()*1000);
//			}
			for(var i:int = 0;i<100;i++)
			{
				var vo:MonsterVO = new MonsterVO();
				vo.id = i+"";
				addMonster(vo,Math.random()*1000,Math.random()*1000);
			}
			TickManager.getInstance().addTick(this);
		}
		public function initSelf():void
		{
			GlobalData.self = CharacterManager.getInstance().setSelf();
			GlobalData.self.visible = true;
			GlobalData.self.move(0,0,0);
			CameraManager.getInstance().cameraTrace(GlobalData.self);
		}
		public function addMonster(vo:MonsterVO,x:int,y:int):void
		{
			var monster:Monster = CharacterManager.getInstance().addMonster(vo);
			monster.visible = true;
			monster.groundY = y;
			monster.move(x,y,0);
			
		}
		public function addPlayer(vo:PlayerVO,x:int,y:int):void
		{
			var player:Player = CharacterManager.getInstance().addPlayer(vo);
			player.visible = true;
			player.groundY = y;
			player.move(x,y,0);
		}
		public function update(duration:int):void
		{
			CharacterManager.getInstance().updateCharacters(duration);
		}
	}
}