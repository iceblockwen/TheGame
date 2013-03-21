package gameWorld
{
	import flash.geom.Point;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import Evocati.GraphicsEngine;
	import Evocati.object.Base2DRectObjInfo;
	
	import gameConfig.MapConfig;
	
	import gameWorld.mapTile.MapTile;
	
	import global.GlobalData;
	
	import resource.PathConfig;
	import resource.ResourceManager;

	public class BaseMap
	{
		public static const TILE_WIDTH:int = 256;
		public static const TILE_HEIGHT:int = 256;
		
		public static var RIGHT_BORDER:int;
		public static var BOTTOM_BORDER:int;
		public static var RIGHT_X:int;
		public static var RIGHT_Y:int;
//		public static var EXTRA_TILE_ROW:int = 1;
//		public static var EXTRA_TILE_COL:int = 1;
		
		private var _ThumbMap:Base2DRectObjInfo;
		private var _tilesFront:Dictionary;
		private var _tilesBack:Dictionary;
		
		public var mapId:int;
		
		private var _rowNum:int;
		private var _colNum:int;
		private var _rowStart:int;
		private var _colStart:int;
		
		private var _lastCameraX:int = 0;
		private var _lastCameraY:int = 0;
		
		private var _config:MapConfig;
		public function BaseMap()
		{
			_tilesFront = new Dictionary();
			_tilesBack = new Dictionary();
		}
		public function loadMap(id:int):void
		{
			mapId = id;
			_config = MapConfig.configData[mapId];
			var focus:Point = CameraManager.getInstance().getCurFocus();
			_lastCameraX = focus.x;
			_lastCameraY = focus.y;
			initThumbMap();
		}
		public function initThumbMap():void
		{
			ResourceManager.getInstance().loadBinFile(PathConfig.getMapThumbResPath(mapId),finishLoadThumb);
		}
		
		public function resize():void
		{
			_rowNum = Math.ceil(GlobalData.stage.stageHeight / TILE_HEIGHT) + 1;
			_colNum = Math.ceil(GlobalData.stage.stageWidth / TILE_WIDTH) + 1;
			updateMap();
		}
		
		public function updateMap():void
		{
			_rowStart = (_lastCameraY-GlobalData.stage.stageHeight/2) / TILE_HEIGHT;
			_colStart = (_lastCameraX-GlobalData.stage.stageWidth/2) / TILE_WIDTH;
			for(var i:int = _rowStart;i < _rowStart + _rowNum;i++)
			{	
				for(var j:int = _colStart;j < _colStart + _colNum;j++)
				{
					var id:String = i + "_" + j;
					if(_tilesFront[id] != undefined && _tilesFront[id] != null)
					{
						continue;
					}
					else if(i >= 0 && j >= 0 && i < _config.row && j < _config.col)
					{
							_tilesFront[id] = MapTile.getInstance(mapId,i,j);
					}
				}
			}
		}
		
		public function refreshMapTile(camFocusX:int,camFocusY:int):void
		{
			var addX:int = camFocusX -_lastCameraX;
			var addY:int = camFocusY -_lastCameraY;
			if((addX<TILE_WIDTH && addX > -TILE_WIDTH) && (addY<TILE_HEIGHT && addY>-TILE_HEIGHT))
				return;
			
			_lastCameraX = camFocusX;
			_lastCameraY = camFocusY;
			
			updateMap();
		}
		
		private function finishLoadThumb(data:ByteArray,url:String):void
		{
			GraphicsEngine.getInstance().getCompressedMapTextureFromByteArray(data,"thumb"+mapId,256,128,false);
			_ThumbMap = Base2DRectObjInfo.getInstance("thumb","thumb"+mapId,_config.width,_config.height,0,0,0);
			GraphicsEngine.getInstance().setMapthumb(_ThumbMap);
		}
	}
}