package Evocati
{
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	import Evocati.object.BaseRigidBody;
	import Evocati.scene.QuadTree;
	import Evocati.scene.QuadTreeNode;

	public class PhysicsEngine
	{
		public var gravity:Number;
		public var bodyTree:QuadTree;
		public var ready:Boolean;
		private var _sp:Sprite;
		public static var instance:PhysicsEngine;
		public function PhysicsEngine()
		{
		}
		public function initScene(x:int,y:int,width:int,height:int,depth:int = 4,sp:Sprite = null):void
		{
			_sp = sp;
			bodyTree = new QuadTree();
			bodyTree.build(depth,new Rectangle(x,y,width,height),_sp);
			ready = true;
		}
		public static function getInstance():PhysicsEngine
		{
			if(!instance) instance = new PhysicsEngine();
			return instance;
		}
		public function addRigidBody(body:BaseRigidBody):void
		{
			body.sectionTxt = new TextField();
			body.sectionTxt.textColor = 0xffffff;
			body.sectionTxt.text =  "无";
			_sp.addChild(body.sectionTxt);
			
			if(bodyTree)
				bodyTree.insertObject(body,body.pos);
		}
		public function update(time:int):void
		{
			var dtime:int = getTimer();
			var leaf:Array = bodyTree.leafArray;
			var len:int = leaf.length;
			var i:int = -1;
			for each(var arr:Array in bodyTree.objMap)
			{
				var body:BaseRigidBody = arr[1] as BaseRigidBody;
				if(body.pos.x > 200 || body.pos.x < 0)
					body.velocity.x = -body.velocity.x;
				if(body.pos.y > 200 || body.pos.y < 0)
					body.velocity.y = -body.velocity.y;
				body.moveBy(time*body.velocity.x,time*body.velocity.y);
				reInsert(body);
			}	
			while(++i<len)
			{
				checkAround(leaf[i]);
			}
			i = -1;
//			trace(getTimer() - dtime);
		}
		public function checkAround(node:QuadTreeNode):void
		{
			var arr:Array = [];
			var data:Dictionary = node.data;
			for each(var tmp:BaseRigidBody in data)
			{
				if(tmp)
					arr.push(tmp);
			}
			var len:int = arr.length;
			for(var i:int = 0; i < len; i++)
			{
				for(var j:int = i+1;j <len;j++)
				{
					var a:BaseRigidBody = arr[i] as BaseRigidBody;
					var b:BaseRigidBody = arr[j] as BaseRigidBody;
					if(a.testRect(b.rect))
					{
						calculateImpact(a,b);
					}
				}
			}
		}
		
		private function calculateImpact(a:BaseRigidBody,b:BaseRigidBody):void
		{
			var tmpx:Number = a.velocity.x;
			var tmpy:Number = a.velocity.y;
			a.velocity.x = b.velocity.x;
			a.velocity.y = b.velocity.y;
			b.velocity.x = tmpx;
			b.velocity.y = tmpy;
		}
		
		public function reInsert(body:BaseRigidBody):void
		{
			if(body.node.rect.containsPoint(body.pos) == false)
			{
				delete body.node.data[body.id];
				bodyTree.insertObject(body,body.pos);
			}
		}
	}
}