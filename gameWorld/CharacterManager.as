package gameWorld
{
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	import gameUnit.character.Player;
	import gameUnit.character.Role;
	import gameUnit.character.Self;
	import gameUnit.data.PlayerVO;
	import gameUnit.data.RoleVO;

	public class CharacterManager
	{
		public var selfPlayer:Self;
		public var characters:Dictionary;
		private static var instance:CharacterManager;
		public static function getInstance():CharacterManager
		{
			if(!instance)
				instance = new CharacterManager();
			return instance;
		}
		public function CharacterManager()
		{
			characters = new Dictionary();
			InputManager.getInstance().addEventListener("GLOBAL_EVT_KEY_UP",onKeyInput);
		}
		
		public function setSelf():Self
		{
			if(!selfPlayer)
			{
				selfPlayer = new Self();
				selfPlayer.data = new RoleVO();
			}
			characters[selfPlayer.data.id] = selfPlayer;
			return selfPlayer;
		}
		public function addPlayer(vo:PlayerVO):Player
		{
			var player:Player = Player.getInstanece();
			player.data = vo;
			characters[vo.id] = player;
			return player;
		}
		protected function onKeyInput(event:Event):void
		{
			if(selfPlayer)
			{
				InputManager.getInstance().checkMove();
			}
		}
		public function updateCharacters(duration:int):void
		{
			for each(var role:Role in characters)
			{
				role.update(duration);
			}
		}
	}
}