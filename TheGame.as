package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	import Evocati.GraphicsEngine;
	
	import gameWorld.InputManager;
	import gameWorld.LevelManager;
	
	import global.GameConstant;
	
	import resource.ResourceManager;
	
	import tick.TickManager;
	
	public class TheGame extends Sprite
	{
		public function TheGame()
		{
			addEventListener(Event.ADDED_TO_STAGE,initGame);
		}
		private function initGame(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE,initGame);
			
			stage.frameRate = 60;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			TickManager.getInstance();
			ResourceManager.getInstance();
			LevelManager.getInstance();
			InputManager.getInstance(stage);
			stage.addEventListener(Event.RESIZE,onStageResize);
			GraphicsEngine.getInstance(stage).initContext3D();
			GraphicsEngine.getInstance().addEventListener("CompleteInit",onGraphicsReady);
			GraphicsEngine.getInstance().setGameSize(GameConstant.gameWidth,GameConstant.gameHight);
		}
		
		protected function onGraphicsReady(event:Event):void
		{
			GraphicsEngine.getInstance().removeEventListener("CompleteInit",onGraphicsReady);
			LevelManager.getInstance().loadLevel();
			
		}
		protected function onStageResize(event:Event):void
		{
			GameConstant.gameWidth = stage.stageWidth;
			GameConstant.gameHight = stage.stageHeight;
			GraphicsEngine.getInstance().setGameSize(GameConstant.gameWidth,GameConstant.gameHight);
		}
	}
}