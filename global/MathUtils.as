package global
{
	import flash.geom.Rectangle;

	public class MathUtils
	{
		public function MathUtils()
		{
		}
		
		
		/**
		 * 分别比较两个矩形的重心在x轴方向上和y轴方向上的距离与两个矩形的长或者宽的一半的和的大小。
		 * 如果重心的在x轴和y轴上的距离都比他们边长和的一半要小就符合相交的条件
		 */
		public static function rectHitTest(rectA:Rectangle,rectB:Rectangle):Boolean
		{
			var wpX_A:int = 2*rectA.x + rectA.width;  //重心2倍
			var wpY_A:int = 2*rectA.y + rectA.height;
			
			var wpX_B:int = 2*rectB.x + rectB.width;  //重心2倍
			var wpY_B:int = 2*rectB.y + rectB.height;
			
			var sum_x:int = rectA.width + rectB.width;
			var sum_y:int = rectA.height + rectB.height;
			
			if(abs(wpX_A - wpX_B) <= sum_x && abs(wpY_A - wpY_B) <= sum_y)
				return true;
			return false;
		}
		
		public static function abs(value:Number):Object
		{
			if(value>0)
				return value;
			return -value;
		}
	}
}