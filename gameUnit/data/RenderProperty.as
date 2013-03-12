package gameUnit.data
{
	public class RenderProperty
	{
		public var id:String;
		public var texId:String;
		public var texSize:int;
		public var texCoodinates:Array = [];
		public var scaleX:Number = 1;
		public var scaleY:Number = 1;
		public var isAnimated:Boolean;
		public function RenderProperty()
		{
		}
		public function reset():void
		{
			id = "";
			texId = "";
			texCoodinates = [];
			scaleX = 1;
			scaleY = 1;
			isAnimated = false;
		}
	}
}