package Evocati.object
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	import flash.text.TextField;
	
	import Evocati.Interface.IObj3D;
	import Evocati.Interface.ISceneObj;
	import Evocati.scene.QuadTreeNode;

	public class BaseRigidBody implements ISceneObj
	{
		public var pos:Point = new Point();
//		public var posZ:Number;
		public var width:int = 64;
		public var height:int = 64;
		public var rect:Rectangle = new Rectangle(0,0,64,64);
		public var velocity:Vector3D = new Vector3D();
		public var sectionTxt:TextField;
		public var node:QuadTreeNode;
		private var target:IObj3D;
		public var id:String;
		public function BaseRigidBody()
		{
			
		}
		public function setCurrentRect(w:int,h:int):void
		{
			width = w;
			height = h;
			rect.setTo(pos.x,pos.y,w,h);
		}
		public function bindTarget(obj:IObj3D,pid:String):void
		{
			target = obj;
			id = pid;
		}
		public function move(x:int,y:int):void
		{
			target.move(x,y,0);
			pos.setTo(x,y);
			setCurrentRect(width,height);
			if(sectionTxt)
			{
				sectionTxt.x = x;
				sectionTxt.y = y;
			}
		}
		
		public function setSection(value:int):void
		{
			if(sectionTxt)
				sectionTxt.text = value + "";
		}
		
		public function moveBy(x:int,y:int):void
		{
			move(pos.x+x,pos.y+y);
		}
		public function testPoint(point:Point):Boolean
		{
			return rect.containsPoint(point);
		}
		public function testRect(r:Rectangle):Boolean
		{
			if(rect.contains(r.right,r.top))
				return true;
			if(rect.contains(r.right,r.bottom))
				return true;
			if(rect.contains(r.left,r.top))
				return true;
			if(rect.contains(r.left,r.bottom))
				return true;
			return false;
		}
	}
}