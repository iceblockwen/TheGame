package gameUnit
{
	import Evocati.object.BaseRigidBody;

	public class BaseSceneObj
	{
		protected var _rigidBody:BaseRigidBody;
		protected var _renderObjs:Array;
		
		public var id:String;
		public var x:Number;
		public var y:Number;
		private var _visible:Boolean;
		public function BaseSceneObj()
		{
			_renderObjs = [];
		}
		public function move(mx:Number,my:Number):void
		{
			x = mx;
			y = my;
			if(_rigidBody)
				_rigidBody.move(x,y);
			else
			{
				for each(var part:RenderUnit in _renderObjs)
				{
					part.move(x,y);
				}
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