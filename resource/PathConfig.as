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
	}
}