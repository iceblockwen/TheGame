package gameUnit
{
	import Evocati.object.BaseRigidBody;

	public class BaseSceneObj
	{
		protected var _rigidBody:BaseRigidBody;
		protected var _renderObj:RenderUnit;
		
		public var x:Number;
		public var y:Number;
		private var _visible:Boolean;
		public function BaseSceneObj()
		{
			
		}
		public function move(mx:Number,my:Number):void
		{
			x = mx;
			y = my;
			if(_rigidBody)
				_rigidBody.move(x,y);
			else
				_renderObj.move(x,y);
		}
		
		public function set visible(value:Boolean):void
		{
			_visible = value;
			if(value)
			{
				_renderObj.show();
			}
			else
			{
				_renderObj.hide();
			}
		}
	}
}