package gameUnit.animation
{
	import Interface.IFrameAnimation;
	
	import gameUnit.animation.data.FrameAnimationGraph;

	public class FrameAnimationCtrl
	{
		public var pool:Array = [];
		
		/**动画目标*/
		private var _target:IFrameAnimation
		/**播放索引长度 */
		private var _length:int
		/**回放帧索引 */
		private var _playbackGraph:FrameAnimationGraph;
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
		public var playbackTimes:int = -1;
		
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
		public function setGraph(graph:FrameAnimationGraph):void
		{
			_playbackGraph = graph;
		}
		public function setAct(type:int):void
		{
			_curPlaybackArray = _playbackGraph.frameQueue[type];
			_length = _curPlaybackArray.length;
		}
		public function set target(value:IFrameAnimation):void
		{
			_target = value;
		}
		protected function getNextFrame(n:int):int
		{
			_currentFrame+=n;
			if(_currentFrame >= _length)
			{
				if(playbackTimes > 0)
					playbackTimes --;
				if(playbackTimes == 0)
				{
					state = FIXED;
				}
				else if(playbackTimes == -1)
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