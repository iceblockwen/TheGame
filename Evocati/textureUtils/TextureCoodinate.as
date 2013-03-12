package Evocati.textureUtils
{
	import flash.geom.Rectangle;

	public class TextureCoodinate
	{
		public var xOffset:Number;
		public var yOffset:Number;
		public var scaleX:Number;
		public var scaleY:Number;
		public var bound:Rectangle;
		public var texSize:Number;
		public function TextureCoodinate(x:Number,y:Number,xScale:Number,yScale:Number, b:Rectangle ,pTexSize:Number = 1024)
		{
			xOffset = x;
			yOffset = y;
			scaleX = xScale;
			scaleY = yScale;
			bound = b;
			texSize = pTexSize;
		}
	}
}