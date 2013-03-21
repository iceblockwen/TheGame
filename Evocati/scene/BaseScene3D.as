package Evocati.scene
{
	import flash.utils.Dictionary;
	
	import Evocati.object.Base2DRectObjInfo;
	import Evocati.object.Group2DRectObjInfo;

	public class BaseScene3D
	{
		public var _singleObjList:Array;
		public var _batchObjList:Dictionary;
		public var _totalList:Dictionary;
		public var _mapTileList:Dictionary;
		public var _groupObjList:Dictionary;
		public var _mapThumb:Base2DRectObjInfo;
		public function BaseScene3D()
		{
			_singleObjList = [];
			_groupObjList = new Dictionary();
			_batchObjList = new Dictionary();
			_totalList = new Dictionary();
			_mapTileList = new Dictionary();
		}
		public function findObjById(id:String):Array
		{
			if(_totalList[id]!=undefined)
				return _totalList[id];
			else 
				return null;
		}
		public function addSingleObj(info:Base2DRectObjInfo):void
		{
			_singleObjList.push(info);
			if(_totalList[info.id] != undefined)
				trace("已经有此id");
			else
				_totalList[info.id] = [info,""];
		}
		
		public function removeOneObj(id:String,isDispose:Boolean = true):void
		{
			if(_totalList[id] != undefined)
			{
				var arr:Array = _totalList[id];
				var info:Base2DRectObjInfo = arr[0];
				if(arr[1] == "")
				{
					_singleObjList.splice(_singleObjList.indexOf(info),1);
				}
				else
				{
					var list:Array = _batchObjList[arr[1]];
					list.splice(list.indexOf(info),1);
					if(list.length == 0)
						delete  _batchObjList[arr[1]];
				}
				delete _totalList[id];
				if(isDispose)
					info.dispose();
			}
			else
			{
				trace("无法删除id:"+id+"找不到此id");
			}
			
		}
		
		public function removeGroupObj(id:String):void
		{
			if(_groupObjList[id] != undefined)
			{
				for each(var child:Array in _groupObjList[id].childObjsInfo)
				{
					removeOneObj(child[0].id);
				}
				delete _groupObjList[id];
			}
		}
		
		public function addMapTile(info:Base2DRectObjInfo):void
		{
			if(_mapTileList[info.id] != undefined)
				trace("已经有此id地图块"+info.id);
			else
				_mapTileList[info.id] = info;
		}
		public function setMapthumb(info:Base2DRectObjInfo):void
		{
			if(_mapThumb) 
				_mapThumb.dispose();
			_mapThumb = info;
		}
		
		public function findTile(id:String):Base2DRectObjInfo
		{
			if(_mapTileList[id] != undefined)
				return _mapTileList[id];
			else
				return null;
		}		
		public function removeMapTile(id:String):void
		{
			if(_mapTileList[id] != undefined)
			{
			   	delete _mapTileList[id];
			}
			else
				trace("无法删除地图切片id:"+id+"找不到此id");
		}
		
		public function addGroupObj(info:Group2DRectObjInfo):Boolean
		{
			for each(var child:Array in info.childObjsInfo)
			{
				addBatchObj(child[0]);
			}
			_groupObjList[info.id] = info;
			return false;
		}
		
		public function addBatchObj(info:Base2DRectObjInfo):Boolean
		{
			if(info.textureId == "")
			{
				trace("不能为空啊batchId");
				return false;
			}
			if(_batchObjList[info.textureId] == undefined)
				_batchObjList[info.textureId] = new Array();
			_batchObjList[info.textureId].push(info);
			
			if(_totalList[info.id] != undefined)
			{
				trace("已经有此id:"+info.id);
				return false;
			}
			else
				_totalList[info.id] = [info,info.textureId];
			
			return true;
		}
		
		public function moveObjById(id:String,x:Number,y:Number):void
		{
			if(_totalList[id] != undefined)
			{
				var arr:Array = _totalList[id] as Array;
				(arr[0] as Base2DRectObjInfo).move(x,y,0);
			}
			else
				trace("找不到id:"+id);
		}
		
		public function rotateObjById(id:String,x:Number,y:Number,z:Number):void
		{
			if(_totalList[id] != undefined)
			{
				var arr:Array = _totalList[id] as Array;
				(arr[0] as Base2DRectObjInfo).rotate(x,y,z);
			}
			else
				trace("找不到id:"+id);
		}
		
		public function isObjInBatch(id:String ,batchId:String):Boolean
		{
			if(_totalList[id] != undefined && _totalList[id][1] == batchId)
				return true;
			else
				return false;
		}
	}
}