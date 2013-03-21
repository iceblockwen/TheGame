package gameWorld
{
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	import gameUnit.character.Monster;
	import gameUnit.character.Player;
	import gameUnit.character.Role;
	import gameUnit.character.Self;
	import gameUnit.dataVO.MonsterVO;
	import gameUnit.dataVO.PlayerVO;
	import gameUnit.dataVO.RoleVO;
	import gameUnit.physics.InteractionRect;
	
	import global.FrameCtrl;
	import global.MathUtils;

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
			InputManager.getInstance().addEventListener("GLOBAL_EVT_KEY",onKeyInput);
			InputManager.getInstance().addEventListener("GLOBAL_EVT_KEY_DOWN",onKeyDownInput);
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
		public function addMonster(vo:MonsterVO):Monster
		{
			var monster:Monster = Monster.getInstanece();
			monster.data = vo;
			characters[vo.id] = monster;
			return monster;
		}
		protected function onKeyInput(event:Event):void
		{
			if(selfPlayer)
			{
				InputManager.getInstance().checkMove();
			}
		}
		protected function onKeyDownInput(event:Event):void
		{
//			trace("keydown")
			if(selfPlayer)
			{
				InputManager.getInstance().checkInstruction();
			}
		}
		
		public function hitTest(rect:InteractionRect,source:Role):void
		{
			var hit:int = 0;
			for each(var role:Role in characters)
			{
				if(role == source)
					continue;
				if(MathUtils.rectHitTest(rect.rect,role.onHitRect.rect))
				{
					trace("hit"+role.id+"!");
					hit++;
					role.doBeHit(source.direction);
				}
			}
			if(hit)
			{
				var h:Number = 1+(hit-1)/4;
				FrameCtrl.getInstance().slowDownAnimation(100*h,0.1);
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