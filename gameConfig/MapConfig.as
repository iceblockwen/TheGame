package gameConfig
{
	import flash.utils.Dictionary;
	
	public class MapConfig
	{
		public var width:int;
		public var height:int;
		public var row:int;
		public var col:int;
		public function MapConfig(data:Array)
		{
			width = data[1];
			height = data[2];
			row = data[3];
			col = data[4];
		}
		private static var _data:Array = [
			[101,2048,1024,4,8]
		];
		private static function InitData(): Dictionary
		{
			var dic:Dictionary = new Dictionary();
			var len:int = _data.length;
			for (var i:int = 0; i < len; i++)
			{
				var arr:Array = (_data[i] as Array);
				dic[arr[0]] = new MapConfig(arr);
			}
			return dic;
		}
		public static var configData:Dictionary = InitData();
	}
}