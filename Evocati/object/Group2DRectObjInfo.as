package Evocati.object
{
	import Evocati.Interface.IObj3D;

	public class Group2DRectObjInfo implements IObj3D
	{
		public var id:String;

		public var x:Number;
		public var y:Number;
		public var z:Number;
		
		public var rx:Number;
		public var ry:Number;
		public var rz:Number;
		
		public var childObjsInfo:Array;
		
		public function Group2DRectObjInfo(pId:String,pX:Number,pY:Number,pZ:Number)
		{
			id = pId;
			x = pX;
			y = pY;
			z = pZ;
			childObjsInfo = [];
		}
		
		public function addChildObj(info:Base2DRectObjInfo):void
		{
			var ox:Number = info.originX;
			var oy:Number = info.originY;
			childObjsInfo.push([info,ox,oy]);
			info.setPosition(x,y,z);
			info.id = id + "@" + (childObjsInfo.length-1);
		}
		public function addChildObjAt(info:Base2DRectObjInfo,i:int):void
		{
			var ox:Number = info.originX;
			var oy:Number = info.originY;
			childObjsInfo[i] = ([info,ox,oy]);
			info.setPosition(x,y,z);
			info.id = id + "@" + i;
		}
		
		public function move(mx:Number, my:Number ,mz:Number):void
		{
			x = mx;
			y = my;
			for each(var i:Array in childObjsInfo)
			{
				i[0].move( mx + i[1],my + i[2],mz);
			}
		}
		
		public function setChildPos(ox:Number,oy:Number,index:int):void
		{
			if(childObjsInfo[index] != null)
			{
				childObjsInfo[index][1] = ox;
				childObjsInfo[index][2] = oy;
				
				childObjsInfo[index][0].x = x +ox;
				childObjsInfo[index][0].y = y +oy;
			}
		}
		
		public function getChild(index:int):Base2DRectObjInfo
		{
			return childObjsInfo[index][0];
		}
		
		public function rotate(xx:Number, xy:Number,xz:Number):void
		{
			rx = xx;
			ry = xy;
			rz = xz;
		}
		
	}
}