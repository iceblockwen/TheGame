package Evocati.scene
{
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;

	public class QuadTreeNode
	{
		public var rect:Rectangle;
		public var section:int;
		public var UL:QuadTreeNode;
		public var UR:QuadTreeNode;
		public var LL:QuadTreeNode;
		public var LR:QuadTreeNode;
		public var data:Dictionary;
		
		public var isLeaf:Boolean;
		public function QuadTreeNode(isleaf:Boolean = false)
		{
			isLeaf = isleaf;
			if(isLeaf)
				data = new Dictionary();
		}
	}
}