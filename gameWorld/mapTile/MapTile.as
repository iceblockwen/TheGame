package gameWorld.mapTile
{
	import flash.utils.ByteArray;
	
	import Evocati.GraphicsEngine;
	import Evocati.object.Base2DRectObjInfo;
	
	import gameWorld.BaseMap;
	
	import resource.PathConfig;
	import resource.ResourceManager;

	public class MapTile
	{
		public static var pool:Array = [];
		public var mapId:int;
		public var row:int;
		public var col:int;
		
		public var x:int;
		public var y:int;
		
		public var graphicInfo:Base2DRectObjInfo;
		public var url:String;
		public function MapTile(pmapId:int,prow:int,pcol:int)
		{
			mapId = pmapId;
			row = prow;
			col = pcol;
			x = col * BaseMap.TILE_WIDTH;
			y = row * BaseMap.TILE_HEIGHT;
			getRes();
		}
		private function getRes():void
		{
			url = PathConfig.getMapResPath(mapId,row,col);
			ResourceManager.getInstance().loadBinFile(url,onFinishLoadTile);
		}
		
		private function onFinishLoadTile(data:ByteArray,url:String):void
		{
			GraphicsEngine.getInstance().getCompressedMapTextureFromByteArray(data,url,BaseMap.TILE_WIDTH,BaseMap.TILE_HEIGHT,false);
			graphicInfo = Base2DRectObjInfo.getInstance(row+"_"+col,url,BaseMap.TILE_WIDTH,BaseMap.TILE_HEIGHT,x,y,0);
			GraphicsEngine.getInstance().addMapTile(graphicInfo);
		}
		
		public static function getInstance(mapId:int,row:int,col:int):MapTile
		{
			var instance:MapTile = pool.length ? pool.pop() : new MapTile(mapId,row,col);
			return instance;
		}
		public function dispose():void
		{
			mapId = 0;
			row = 0;
			col = 0;
			pool.push(this);
			GraphicsEngine.getInstance().removeMapTile(graphicInfo.id);
			graphicInfo.dispose();
			graphicInfo = null;
		}
		public function move(px:Number,py:Number):void
		{
			x = px;
			y = py;
			if(graphicInfo)
				graphicInfo.move(x,y,0);
		}
		
	}
}