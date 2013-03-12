package global
{
	public class DirectionType
	{
		public static var TOP:int = 0;
		public static var TOP_LEFT:int = 1;
		public static var TOP_RIGHT:int = 2;
		public static var LEFT:int = 3;
		public static var RIGHT:int = 4;
		public static var BOTTOM:int = 5;
		public static var BOTTOM_LEFT:int = 6;
		public static var BOTTOM_RIGHT:int = 7;
		
		
		public function DirectionType()
		{
		}
		
		public static function getDirX(dir:int):int
		{
			if(dir == LEFT ||
				dir == TOP_LEFT ||
				dir == BOTTOM_LEFT)
			{
				return -1
			}
			else if(dir == RIGHT ||
				dir == TOP_RIGHT ||
				dir == BOTTOM_RIGHT)
			{
				return 1;
			}
			return 0;
		}
		
		public static function getDirY(dir:int):int
		{
			if( dir == TOP_LEFT ||
				dir == TOP_RIGHT ||
				dir == TOP)
			{
				return -1;
			}
			else if(dir == BOTTOM ||
				dir == BOTTOM_LEFT ||
				dir == BOTTOM_RIGHT)
			{
				return 1;
			}
			return 0;
		}
	}
}