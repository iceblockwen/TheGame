package resource
{
	public class PathConfig
	{
		public function PathConfig()
		{
		}
		public static function getCharacterResPath():String
		{
			return "res\\character\\";
		}
		
		public static function getMapThumbResPath(id:int):String
		{
			return "res\\map\\" + id +"\\thumb.atf";
		}
		public static function getMapResPath(id:int,row:int,col:int):String
		{
			return "res\\map\\" + id +"\\" + row + "_" + col + ".atf";
		}
	}
}