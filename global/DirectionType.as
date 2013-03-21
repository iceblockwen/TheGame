package global
{
	public class DirectionType
	{
		public static var TOP:int = 1;
		public static var BOTTOM:int = 2;
		public static var LEFT:int = 4;
		public static var RIGHT:int = 8;
		
		
		public function DirectionType()
		{
		}
		
		public static function getDirX(dir:int):int
		{
			if(dir & LEFT)
			{
				return -1
			}
			else if(dir & RIGHT)
			{
				return 1;
			}
			return 0;
		}
		
		public static function getDirY(dir:int):int
		{
			if(dir & TOP)
			{
				return -1;
			}
			else if(dir & BOTTOM)
			{
				return 1;
			}
			return 0;
		}
	}
}