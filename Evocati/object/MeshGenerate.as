package Evocati.object
{
	import Evocati.particle.BaseParticle;

	public class MeshGenerate
	{

		public function MeshGenerate()
		{
			
		}
		
		/** 
		 * 取得一个矩形的索引数组
		 * */
		public static function getSquareIndex():Vector.<uint>
		{
			var indexdata:Vector.<uint> = Vector.<uint> 
				([
					0, 2, 3,  0, 1, 2
				]);
			return indexdata;
		}
		
		/** 
		 * 取得一个矩形的顶点数组(归一化数据)
		 * */
		public static function getNormalizedSquareVertex(nSizeX:Number,nSizeY:Number):Vector.<Number>
		{
			var vertexData:Vector.<Number> = Vector.<Number> 
				( [
					//X,  Y,  Z,          U, V,       r,  g,  b,  a
					0, 0,  0,             0, 0,     1.0,  1.0,  1.0,  1.0,
					nSizeX, 0,  0,         1, 0,     1.0,  1.0,  1.0,  1.0,
					nSizeX, -nSizeY, 0,     1, 1,     1.0,  1.0,  1.0,  1.0,
					0,   -nSizeY,  0,      0, 1,     1.0,  1.0,  1.0,  1.0
				]);
			return vertexData;
		}
		/** 
		 * 取得一个全屏矩形的顶点数组(归一化数据)
		 * */
		public static function getFullScreenSquareVertex():Vector.<Number>
		{
			var vertexData:Vector.<Number> = Vector.<Number> 
				( [
					//X,  Y,  Z,     U, V,       r,  g,  b,  a
					-1, 1,  0,      0, 0,     1.0,  1.0,  1.0,  1.0,
					1, 1,  0,      1, 0,     1.0,  1.0,  1.0,  1.0,
					1, -1, 0,     1, 1,     1.0,  1.0,  1.0,  1.0,
				-1, -1,  0,      0, 1,     1.0,  1.0,  1.0,  1.0
				]);
			return vertexData;
		}
		
		public static function addLinkIndexByNumber(vector:Vector.<uint>, n:int):void
		{
			var index:int = n*6;
			vector[index++] = 0+4*n;
			vector[index++] = 2+4*n;
			vector[index++] = 3+4*n;
			vector[index++] = 0+4*n;
			vector[index++] = 1+4*n;
			vector[index++] = 2+4*n;
		}
		
		public static function addSquareIndexByNumber(vector:Vector.<uint>, n:int):void
		{
			var index:int = n*6;
			vector[index++] = 0+4*n;
			vector[index++] = 2+4*n;
			vector[index++] = 3+4*n;
			vector[index++] = 0+4*n;
			vector[index++] = 1+4*n;
			vector[index++] = 2+4*n;
		}
		
		public static function generateVertexLink(arr:Array,nodeNum:int):Array 
		{
			var n:int = arr.length;
			var numIndex:int = n*3-6;
			var indexs:Vector.<uint>  = new Vector.<uint>(numIndex);
			var link:Vector.<Number>  = new Vector.<Number>(n*7);
			var index:int = 0;
//			var interval:Number = 1/(1-nodeNum)/2;
			var i:int = -1;
			while(++i < n)
			{
				link[index++] = arr[i][0];  //x
				link[index++] = arr[i][1];  //y
				link[index++] = arr[i][2];  //z
				if(i<2)
					link[index++] = 0;   //u
				else
					link[index++] = 0.5;   //u
//				link[index++] = i/2*interval;   //u
				if(i%2)
					link[index++] = 0;     //v
				else
					link[index++] = 1;     //v
				link[index++] = arr[i][3];  //life
				link[index++] = arr[i][4];  //lifeScale
			}
			i = -1;
			index = 0;
			while(++i < nodeNum-1)
			{
				indexs[index++] = 0 + i*2;
				indexs[index++] = 2 + i*2;
				indexs[index++] = 1 + i*2;
				indexs[index++] = 1 + i*2;
				indexs[index++] = 2 + i*2;
				indexs[index++] = 3 + i*2;
			}
			return [indexs,link];
		}
		
		
		/** 
		 * 批处理一个矩形的顶点数组(像素数据,Shader做归一化运算,略微提高性能)
		 * */
		public static function addSquareVertexPixel(vector:Vector.<Number>,obj:Base2DRectObjInfo,n:int):void
		{
			var index:int = n*36;
			var xoffset:Number;
			var yoffset:Number;
			if(obj.textureCoordinates)
			{
				xoffset = obj.textureCoordinates[obj.textureIndex].xOffset
				yoffset = obj.textureCoordinates[obj.textureIndex].yOffset
			}
			var texWidth:Number = obj.sizeX
			var texHeight:Number = obj.sizeY
			var px:Number = obj.x;
			var py:Number = obj.y;
			var pz:Number = obj.z;
			var dir:Boolean = obj.hFlip;
			/**p1*/
			//pos
			vector[index++] = px;
			vector[index++] = py;
			vector[index++] = pz;
			//uv
			vector[index++] = xoffset + (dir?texWidth:0);
			vector[index++] = yoffset;
			//color
			vector[index++] = 1;
			vector[index++] = 1;
			vector[index++] = 1;
			vector[index++] = 1;
			
			/**p2*/
			//pos
			vector[index++] = texWidth+px;
			vector[index++] = py;
			vector[index++] = pz;
			//uv
			vector[index++] = xoffset + (dir?0:texWidth);
			vector[index++] = yoffset;
			//color
			vector[index++] = 1;
			vector[index++] = 1;
			vector[index++] = 1;
			vector[index++] = 1;
			
			/**p3*/
			//pos
			vector[index++] = texWidth + px;
			vector[index++] = -texHeight + py;
			vector[index++] = pz;
			//uv
			vector[index++] = xoffset + (dir?0:texWidth);
			vector[index++] = yoffset+ texHeight;
			//color
			vector[index++] = 1;
			vector[index++] = 1;
			vector[index++] = 1;
			vector[index++] = 1;
			
			/**p4*/
			//pos
			vector[index++] = px;
			vector[index++] = -texHeight+py;
			vector[index++] = pz;
			//uv
			vector[index++] = xoffset + (dir?texWidth:0);
			vector[index++] = yoffset + texHeight;
			//color
			vector[index++] = 1;
			vector[index++] = 1;
			vector[index++] = 1;
			vector[index++] = 1;
			
		}
		/** 
		 * 批处理一个粒子的顶点数组(像素数据,Shader做归一化运算,略微提高性能)
		 * */
		public static function addParticleVertexPixel(vector:Vector.<Number>,obj:BaseParticle,n:int,textureAlt:Boolean = false):void
		{
			var index:int = n*56;
			var xoffset:Number = 0;
			var yoffset:Number = 0;
			if(obj.textureCoordinates)
			{
				xoffset = obj.textureCoordinates[obj.textureIndex].xOffset
				yoffset = obj.textureCoordinates[obj.textureIndex].yOffset
			}
			var texWidth:Number = 0;
			var texHeight:Number = 0;
			var sizeWidth:Number = 0;
			var sizeHeight:Number = 0;
			sizeWidth  = obj.sizeX * obj.scaleX/2;
			sizeHeight  = obj.sizeY * obj.scaleY/2;
			if(textureAlt)
			{
				texWidth = sizeWidth*2;
				texHeight = sizeHeight*2;
			}
			else
			{
				texWidth = obj.textureCoordinates[obj.textureIndex].texSize;
				texHeight = texWidth;
			}
			var px:Number = obj.x;
			var py:Number = obj.y;
			var pz:Number = obj.z;
			/**p1*/
			//pos
			vector[index++] = px - sizeWidth;
			vector[index++] = py + sizeHeight;
			vector[index++] = pz;
			//uv
			vector[index++] = xoffset;
			vector[index++] = yoffset;
			//color
			vector[index++] = 1;
			vector[index++] = 1;
			vector[index++] = 1;
			vector[index++] = 1;
			//speed
			vector[index++] = obj.velocity.x;
			vector[index++] = obj.velocity.y;
			vector[index++] = obj.velocity.z;
			//life
			vector[index++] = obj.life;
			vector[index++] = obj.lifeScale[0];
			
			/**p2*/
			//pos
			vector[index++] = px + sizeWidth;
			vector[index++] = py + sizeHeight;
			vector[index++] = pz;
			//uv
			vector[index++] = xoffset + texWidth;
			vector[index++] = yoffset;
			//color
			vector[index++] = 1;
			vector[index++] = 1;
			vector[index++] = 1;
			vector[index++] = 1;
			//speed
			vector[index++] = obj.velocity.x;
			vector[index++] = obj.velocity.y;
			vector[index++] = obj.velocity.z;
			//life
			vector[index++] = obj.life;
			vector[index++] = obj.lifeScale[0];
			
			/**p3*/
			//pos
			vector[index++] = px + sizeWidth;
			vector[index++] = py - sizeHeight;
			vector[index++] = pz;
			//uv
			vector[index++] = xoffset+ texWidth;
			vector[index++] = yoffset+ texHeight;
			//color
			vector[index++] = 1;
			vector[index++] = 1;
			vector[index++] = 1;
			vector[index++] = 1;
			//speed
			vector[index++] = obj.velocity.x;
			vector[index++] = obj.velocity.y;
			vector[index++] = obj.velocity.z;
			//life
			vector[index++] = obj.life;
			vector[index++] = obj.lifeScale[0];
			
			/**p4*/
			//pos
			vector[index++] = px - sizeWidth;
			vector[index++] = py - sizeHeight;
			vector[index++] = pz;
			//uv
			vector[index++] = xoffset;
			vector[index++] = yoffset + texHeight;
			//color
			vector[index++] = 1;
			vector[index++] = 1;
			vector[index++] = 1;
			vector[index++] = 1;
			//speed
			vector[index++] = obj.velocity.x;
			vector[index++] = obj.velocity.y;
			vector[index++] = obj.velocity.z;
			//life
			vector[index++] = obj.life;
			vector[index++] = obj.lifeScale[0];
		}
		
	}
}