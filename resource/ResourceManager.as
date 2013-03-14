package resource
{
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	public class ResourceManager
	{
		private static var instance:ResourceManager;
		
		private var _mainLoader:Loader;
		private var _loading:Boolean;
		private var _mainURLLoader:URLLoader;
		private var _callbackList:Dictionary = new Dictionary();
		public  var resourceCache:Dictionary = new Dictionary();
		private var _currentURL:String;
		private var _urlLoaderQueue:Array = [];
		
		public function ResourceManager()
		{
			_mainLoader = new Loader();
			_mainURLLoader = new URLLoader();
			_mainURLLoader.dataFormat = URLLoaderDataFormat.BINARY;
		}
		
		public static function getInstance():ResourceManager
		{
			if(!instance)
				instance = new ResourceManager();
			return instance;
		}
		
		public function getCharacterRes():Array
		{
			return null;
		}
		
		public function loadBinFile(url:String,callback:Function = null):void
		{
			if(_loading) 
			{
				_urlLoaderQueue.push([url,callback]);
				return;
			}
			_loading = true;
			if(resourceCache[url] != null || resourceCache[url] != undefined)
			{
				_loading = false;
				if(callback)
					callback(resourceCache[url],_currentURL);
				var nextUrl:Array = _urlLoaderQueue.shift();
				if(nextUrl)
					loadBinFile(nextUrl[0],nextUrl[1]);
				return;
			}
			if(callback)
				_callbackList[url] = callback;
			_currentURL = url;
			_mainURLLoader.load(new URLRequest(url));
			_mainURLLoader.addEventListener(Event.COMPLETE,urlLoaderCallback);
		}
		
		public function loadFile(url:String,callback:Function = null):void
		{
			
			if(resourceCache[url] != null || resourceCache[url] != undefined)
			{
				if(callback)
					callback(resourceCache[url],_currentURL);
				return;
			}
			_mainLoader.load(new URLRequest(url));
			_mainLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,loaderCallback);
			if(callback)
				_callbackList[url] = callback;
		}
		
		private function loaderCallback(e:Event):void
		{
			_mainLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,loaderCallback);
			var info:LoaderInfo = e.target as LoaderInfo;
			if(_mainLoader.content)
			{
				resourceCache[info.url] = _mainLoader.content;
				_callbackList[info.url](_mainLoader.content,_currentURL);
			}
		}
		private function urlLoaderCallback(e:Event):void
		{
			_mainURLLoader.removeEventListener(Event.COMPLETE,urlLoaderCallback);
			_loading = false;
			var info:URLLoader = e.target as URLLoader;
			if(info.data)
			{
				resourceCache[_currentURL] = info.data as ByteArray;
				_callbackList[_currentURL](info.data,_currentURL);
			}
			var nextUrl:Array = _urlLoaderQueue.shift();
			if(nextUrl)
				loadBinFile(nextUrl[0],nextUrl[1]);
		}
	}
}