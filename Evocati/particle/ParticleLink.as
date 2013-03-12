package Evocati.particle
{
	import flash.geom.Point;
	
	import Evocati.Interface.IObj3D;

	public class ParticleLink implements IObj3D
	{
		public var posX:Number;
		public var posY:Number;
		public var posZ:Number;
		public var texId:String;
		public var maxLife:Number;
		public var thickness:int = 10;
		
		public var nodeNum:int;
		
		public var vertexArray:Array;
		private var _timeAdd:Number = 0;
		private var _lastPoint:Point = new Point();
		public function ParticleLink()
		{
			vertexArray = [];
		}
		public function step(time:Number):void
		{
			_timeAdd += time;
			if(_timeAdd>0.016)
			{
				getTwoVectex();
				var i:int = -1;
				while(++i < nodeNum)
				{
					var index:int = i*2
					vertexArray[index][3] += _timeAdd;
					vertexArray[index+1][3] += _timeAdd;
					vertexArray[index][4] = 1 - vertexArray[index][3]/maxLife;
					vertexArray[index+1][4] = 1 - vertexArray[index+1][3]/maxLife;
					if(vertexArray[index][3] > maxLife && vertexArray[index-2] != null)
					{
						vertexArray.shift();
						vertexArray.shift();
//						trace("删除节点"+index+"长度"+vertexArray.length);
						i--;
						nodeNum--;
					}
				}
				_timeAdd = 0;
			}
		}
		
		private var tmp:Point;
		private function getTwoVectex():Boolean
		{
			if(_lastPoint && posX == _lastPoint.x && posY == _lastPoint.y)
				return false;
			nodeNum++;
			tmp = getPerpendicularLine(_lastPoint,new Point(posX,posY),thickness);
			vertexArray.push([tmp.x+posX,tmp.y+posY,posZ,0,1]);
			vertexArray.push([posX-tmp.x,posY-tmp.y,posZ,0,1]);
			
			_lastPoint.setTo(posX,posY);
			return true;
		}
		private function getPerpendicularLine(p1:Point,p2:Point,d:Number):Point
		{
			var x:Number;
			var y:Number;
			if(Point.distance(p1,p2)<5)
			{
				return tmp;
			}
			var mul:int;
			var a:int = p2.x - p1.x;
			var b:int = p2.y - p1.y;
			if(p1.x >=p2.x)
			{
				mul = -1;
			}
			else
			{
				mul = 1;
			}
			if((p1.y - p2.y)==0)
			{
				x = 0;
				y = mul*d;
			}
			else
			{
				var slope:Number = (p1.x - p2.x)/(p1.y - p2.y);
				x = d/Math.sqrt(1+slope*slope);
				y = d*(-slope)/Math.sqrt(1+slope*slope);
				if(a*y - b*x > 0)
					mul = 1;
				else
					mul = -1;
				x = mul*x;
				y = mul*y;
			}
			x = int(x);
			y = int(y);
//			trace("("+p1.x +","+ p1.y+")"+"("+p2.x  +","+  p2.y+")"+" slope "+slope+"  "+
//			x+","+y+" mul "+mul);
			return new Point(x,y);
		}
		public function move(x:Number,y:Number,z:Number):void
		{
			posX = x;
			posY = -y   //stage3d的Y轴是反的
			posZ = z;
		}
		
		public function moveBy(x:Number,y:Number,z:Number):void
		{
			posX += x;
			posY += -y;
			posZ += z;
		}
		public function rotate(x:Number,y:Number,z:Number):void
		{
			
		}
	}
	
	
}