package Evocati.textureUtils
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	public class TexturePacker
	{
		
		public static var WIDTH:int = 1024;
		public static var HEIGHT:int = 1024;
		public function TexturePacker()
		{			
			
		}
		
		public static function packSingleBitmapData(source:Bitmap):Bitmap
		{
			var res:BitmapData = new BitmapData(WIDTH,HEIGHT,true,0xff000000);
			res.draw(source);
			return new Bitmap(res);
		}
		
		public static function getCompatibleSize(size:int):Number
		{
			return nextPowerOfTwo(size);
		}
		
		public static function nextPowerOfTwo(v:uint): uint
		{
			v--;
			v |= v >> 1;
			v |= v >> 2;
			v |= v >> 4;
			v |= v >> 8;
			v |= v >> 16;
			v++;
			return v;
			
		}
		
		public static function packMapTile(source:Bitmap,target:Array = null):Array
		{
			//暂时不用
			return null;
		}
		
		public static function packBitmapSqueueFromMC(mc:MovieClip,start:int = 1,end:int = 0):Array
		{
			if(end == 0) end = mc.totalFrames;
			var totleFrameNum:int = mc.totalFrames;
			var curYoffset:int =0;
			var curXoffset:int =0;
			var offsetArr:Array = [];
			var maxHeight:int;
			var lastW:int = 0;
			
			var bmd:BitmapData = new BitmapData(WIDTH, HEIGHT, true,00);
			
			for (var i:int = start; i <= end ; i++ ) 
			{
				
				mc.gotoAndStop(i);
				
				var bound:Rectangle= mc.getBounds(mc);
				
				var matrix:Matrix = new Matrix();
				
				if(maxHeight< bound.height)
					maxHeight = bound.height;
				
				if(curXoffset+lastW+bound.width < WIDTH)
				{
					curXoffset += lastW;
				}
				else
				{
					curXoffset = 0;
					curYoffset += maxHeight;
				}
				
				matrix.tx = -(bound.x) + curXoffset;
				matrix.ty = -(bound.y) + curYoffset;
				
				bmd.draw (mc,matrix);
				
				offsetArr.push(new TextureCoodinate(Number(curXoffset),Number(curYoffset),1,1,bound));
				lastW = bound.width;
				
			}
			return [bmd,offsetArr];
		}
	}
}