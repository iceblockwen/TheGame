package global
{
	import flash.events.Event;

	public class GlobalEvent
	{
		public static var GLOBAL_EVT_KEY:Event = new Event("GLOBAL_EVT_KEY");
		public static var GLOBAL_EVT_KEY_UP:Event = new Event("GLOBAL_EVT_KEY_UP");
		public static var GLOBAL_EVT_KEY_DOWN:Event = new Event("GLOBAL_EVT_KEY_DOWN");
		public function GlobalEvent()
		{
		}
	}
}