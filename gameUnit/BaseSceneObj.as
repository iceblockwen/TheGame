package gameUnit
{
	public class BaseSceneObj
	{
		protected var _renderObjs:Array;
		
		public var id:String;
		public var x:Number;
		public var y:Number;
		public var groundY:Number = 0;
		private var _visible:Boolean;
		public function BaseSceneObj()
		{
			_renderObjs = [];
		}
		public function move(mx:Number,my:Number,mz:Number):void
		{
			x = mx;
			y = my;
			groundY = mz;
			if(groundY<0)
				groundY = 0;
			for each(var part:RenderUnit in _renderObjs)
			{
				part.move(x,y - groundY);
			}
		}
		
		public function set visible(value:Boolean):void
		{
			_visible = value;
			if(value)
			{
				for each(var part:RenderUnit in _renderObjs)
				{
					part.show();
				}
			}
			else
			{
				for each(part in _renderObjs)
				{
					part.hide();
				}
			}
		}
	}
}