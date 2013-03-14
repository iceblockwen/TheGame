package gameUnit.animation
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import data.FrameAnimationConfig;
	
	import gameUnit.RenderUnit;

	public class FrameAnimationCtrl extends EventDispatcher
	{
		public var pool:Array = [];
		public static var ANIMATION_EVT_FINISH:Event = new Event("ANIMATION_EVT_FINISH");
		
		/**动画目标*/
		private var _target:RenderUnit
		/**播放索引长度 */
		private var _length:int
		/**当前回放帧 */
		private var _curPlaybackArray:Array;
		
		/**基本回放状态
		 * CIRCLE: 循环播放
		 * REVERSE:倒序循环播放
		 * FIXED:固定播放*/
		public var state:int; 
		/**基础刷新率/s */
		public var fps:int = 60;      
		/**刷新间隔帧数 */
		public var frameSkip:int;  
		/**播放索引次数 */
		private var _playbackTimes:int = -1;
		
		public static const CIRCLE:int = 0;
		public static const REVERSE:int = 1;
		public static const FIXED:int = 2;
		
		public static var _fpsMultiplier:Number = 1;
		
		public var _autoAdapt:Boolean;
		
		public function FrameAnimationCtrl()
		{
		}
		public function getInstance():void
		{
			return;
		}
		public function setAnimation(type:int,times:int = -1):void
		{
			_playbackTimes = times;
			state = CIRCLE;
			var info:Array = FrameAnimationConfig.configData[_target.animationId].frameQueue[type] as Array;
			_curPlaybackArray = info[0];
			_length = _curPlaybackArray.length;
			if(_target)
			{
				_target.setPreUrl(info[1],info[0][0]);
				_currentFrame = 0;
			}
		}
		public function set target(value:RenderUnit):void
		{
			_target = value;
		}
		protected function getNextFrame(n:int):int
		{
			_currentFrame+=n;
			if(_currentFrame >= _length)
			{
				if(_playbackTimes > 0)
					_playbackTimes --;
				if(_playbackTimes == 0)
				{
					state = FIXED;
					dispatchEvent(ANIMATION_EVT_FINISH);
				}
				else if(_playbackTimes == -1)
				{
					_currentFrame = (_currentFrame-_length)%_length;
				}
			}
			return _curPlaybackArray[_currentFrame];
		}
		protected function getPreFrame(n:int):int
		{
			_currentFrame-=n;
			if(_currentFrame < 0)
				_currentFrame =(_length + _currentFrame)%_length;
			return _curPlaybackArray[_currentFrame];
		}
		
		
		private var time:int;
		private var _acTime:int;
		private var _acFrame:int;
		private var _currentFrame:int;
		public function update(duration:int):void
		{
			_acFrame++;
			_acTime+=duration;
			
			if(_autoAdapt)
				frameSkip = duration;
			
			if(_acFrame % (frameSkip+1) != 0) return;
			
			var state:int = state;
			switch(state)
			{
				case CIRCLE:
				{
					_target.setFrame(getNextFrame(_acTime*fps*_fpsMultiplier / 1000 ));
					break;
				}
					
				case REVERSE:
				{
					_target.setFrame(getPreFrame(_acTime*fps*_fpsMultiplier / 1000 ));
					break;
				}
					
				case FIXED:
				{
					_target.setFrame(_currentFrame);
					break;
				}
					
				default:
				{
					_target.setFrame(_currentFrame);
					break;
				}
			}
			
			if( _acTime >= 1000/(fps*_fpsMultiplier)) _acTime = 0;
		}
	}
}