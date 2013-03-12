package Evocati.particle
{
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	import flash.utils.Dictionary;
	
	import Evocati.scene.BaseScene3D;
	import Evocati.textureUtils.TextureCoodinate;

	public class ParticleSystem
	{
		private var _poolMaxSize:int;
		private var _particlePool:Array;
		private var _particleEmitterList:Array;
		public var _particleLinkList:Array;
		public var _particleBatchList:Dictionary;
		
		private var _scene:BaseScene3D
		public function ParticleSystem()
		{
			_particlePool = [];
			_particleEmitterList = [];
			_particleLinkList= [];
			_particleBatchList = new Dictionary();
		}
		public function setScene(scene3d:BaseScene3D):void
		{
			_scene = scene3d;
		}
		public function generatePoolObjs():void
		{
			var n:int = 500;
			while(n--)
			{
				_particlePool.push(new BaseParticle("0","0",256,256,0,0,0));
			}
		}
		public function addParticle(batchId:String,position:Vector3D,velocity:Vector3D,maxLife:Number,sizeX:int,sizeY:int,texSize:int,textureAlter:Boolean = false):void
		{
			var particle:BaseParticle;
			particle = _particlePool.shift();
			if(!particle)
				particle = new BaseParticle("0","0",sizeX,sizeY,0,0,0);
			particle.respawn(batchId,position,velocity,maxLife,0,100,sizeX,sizeY,textureAlter);
			particle.textureCoordinates = [new TextureCoodinate(0,0,1,1,new Rectangle(0,0,texSize,texSize),texSize)];
			if(batchId == "")
			{
				trace("不能为空啊batchId");
				return;
			}
			if(_particleBatchList[batchId] == undefined)
				_particleBatchList[batchId] = new Array();
			
			_particleBatchList[batchId].push(particle);
		}
		
		public function addParticleEmitter(batchId:String,position:Vector3D,velocity:Vector3D,maxLife:Number,sizeX:int,sizeY:int,texSize:int):ParticleEmitter
		{
			var particleEmitter:ParticleEmitter;
			particleEmitter = new ParticleEmitter(this);
			particleEmitter.batchId = batchId;
			particleEmitter.posX = position.x;
			particleEmitter.posY = position.y;
			particleEmitter.posZ = position.z;
			particleEmitter.velocity = velocity;
			particleEmitter.maxLife = maxLife;
			particleEmitter.sizeX = sizeX;
			particleEmitter.sizeY = sizeY;
			particleEmitter.texSize = texSize;
			_particleEmitterList.push(particleEmitter);
			return particleEmitter;
		}
		public function addParticleLink(texId:String,position:Vector3D,velocity:Vector3D,maxLife:Number,sizeX:int,sizeY:int,texSize:int):ParticleLink
		{
			var particlelink:ParticleLink;
			particlelink = new ParticleLink();
			particlelink.texId = texId;
			particlelink.posX = position.x;
			particlelink.posY = position.y;
			particlelink.posZ = position.z;
			particlelink.maxLife = maxLife;
//			particlelink.velocity = velocity;
//			particlelink.maxLife = maxLife;
//			particlelink.sizeX = sizeX;
//			particlelink.sizeY = sizeY;
//			particlelink.texSize = texSize;
			_particleLinkList.push(particlelink);
			return particlelink;
		}
		
		public function update(time:Number):void
		{
			for each(var arr:Array in _particleBatchList)
			{
				for each(var i:BaseParticle in arr)
				{
					i.step(time/1000);
					if(i.active == false)
					{	
						arr.splice(arr.indexOf(i),1);
						_particlePool.push(i);
					}
				}
			}
			for each(var j:ParticleEmitter in _particleEmitterList)
			{
				j.step(time/1000);
			}
			for each(var k:ParticleLink in _particleLinkList)
			{
				k.step(time/1000);
			}
		}
	}
}