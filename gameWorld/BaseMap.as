package gameWorld
{
	import flash.utils.ByteArray;
	
	import Evocati.GraphicsEngine;
	import Evocati.object.Base2DRectObjInfo;
	
	import resource.PathConfig;
	import resource.ResourceManager;

	public class BaseMap
	{
		public static const TILE_WIDTH:int = 256;
		public static const TILE_HEIGHT:int = 256;
		
		private var _ThumbMap:Base2DRectObjInfo;
		public var mapId:int;
		public var mapWidth:int = 2048;
		public var mapHeight:int = 1024;
		public function BaseMap()
		{
		}
		public function loadMap(id:int):void
		{
			mapId = id;
			initThumbMap();
		}
		public function initThumbMap():void
		{
			ResourceManager.getInstance().loadBinFile(PathConfig.getMapThumbResPath(mapId),finishLoadThumb);
		}
		
		private function finishLoadThumb(data:ByteArray,url:String):void
		{
			GraphicsEngine.getInstance().getCompressedMapTextureFromByteArray(data,"thumb"+mapId,256,128,false);
			_ThumbMap = Base2DRectObjInfo.getInstance("thumb"+mapId,"thumb"+mapId,mapWidth,mapHeight,0,0,0);
			GraphicsEngine.getInstance().addMapTile(_ThumbMap);
		}
	}
}