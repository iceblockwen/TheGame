package Evocati.manager
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;

	public class RegisterManager
	{
		private var context3D:Context3D
		
		/**
		 * uv偏移(着色器控制)
		 */
		private var uvOffset:Vector.<Number>;
		
		/**
		 * 场景大小(着色器控制)
		 */
		private var gameSize:Vector.<Number>;
		/**
		 * 场景大小(着色器控制)
		 */
		private var textureSize:Vector.<Number>;
		
		//顶点常量寄存器
		//
		//------------------------------------------------------------------
		/**
		 * 动态改变缩放(着色器控制)
		 */
		private var meshScale:Vector.<Number>;
		
		public function RegisterManager(ctx3d:Context3D)
		{
			context3D = ctx3d;
		}
		/**
		 * 设置物体空间矩阵
		 */
		public function setTransformMatrixToRegister(matrix:Matrix3D):void
		{
			context3D.setProgramConstantsFromMatrix(
				Context3DProgramType.VERTEX, 
				0, matrix, true );
		}
		/**
		 * 设置纹理uv范围,偏移量(实际像素数据)到GPU寄存器
		 */
		public function setUVToRegister(US:Number,VS:Number,U:Number,V:Number):void
		{
			uvOffset = Vector.<Number>([US,VS,U,V]);
			context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX,4,uvOffset);		
		}
		/**
		 * 设置场景大小到GPU寄存器
		 */
		public function setGameSizeToRegister(sizex:Number,sizey:Number):void
		{
			gameSize = Vector.<Number>([sizex/2,sizey/2,1,1]);
			context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX,5,gameSize);		
		}
		/**
		 * 设纹理景大小到GPU寄存器
		 */
		public function setTextureSizeToRegister(size:Number):void
		{
			textureSize = Vector.<Number>([size,size,size,size]);
			context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX,6,textureSize);		
		}	
		
		/**
		 * 粒子预设参数
		 */
		public function setParticleParam(gravity:Number):void
		{
			var value:Vector.<Number> = Vector.<Number>([gravity,0,0,0]);   //重力
			context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX,7,value);	
		}
		
		//像素常量寄存器
		//
		//------------------------------------------------------------------
		/**
		 * 径向模糊矩阵
		 */
		public function setRadialBlurMatrix():void
		{
			var blurMatrix:Matrix3D = new Matrix3D();
			blurMatrix.identity();
			context3D.setProgramConstantsFromMatrix(
				Context3DProgramType.FRAGMENT, 1, blurMatrix, true );
		}
		/**
		 * 径向模糊预设参数
		 */
		public function setRadialBlurParam(blurX:Number,blurY:Number,blurAmount:Number):void
		{
			var value:Vector.<Number> = Vector.<Number>([blurX*blurAmount/2,blurY*blurAmount/2,blurAmount,20]);
			context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,0,value);	
		}
		public function setDirBlurParam(blurX:Number,blurY:Number,blurAmount:Number):void
		{
			var value:Vector.<Number> = Vector.<Number>([-blurX,-blurY,blurAmount,20]);
			context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,0,value);	
		}
		/**
		 * 高斯模糊预设参数
		 */
		public function setGaussianBlurParam(texSize:Number,ratio:Number):void
		{
			var value:Vector.<Number> = Vector.<Number>([1/texSize*ratio,0,0,0.16]);   //像素偏移单位. . 高斯参数0
			context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,0,value);	
			
			var value2:Vector.<Number> = Vector.<Number>([0.05,0.09,0.12,0.15]);   //高斯参数4 3 2 1
			context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,1,value2);	
		}
		/**
		 * 雾化预设参数
		 */
		public function setFogParam(centerPoint:Vector3D,clampDis:Number,color:Vector3D):void
		{
			var value:Vector.<Number> = Vector.<Number>([centerPoint.x,centerPoint.y,centerPoint.z,clampDis]);   //中心点,距离门限
			context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,0,value);	
			
			var value2:Vector.<Number> = Vector.<Number>([color.x,color.y,color.z,0]);   //雾化颜色
			context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,1,value2);	
		}
	}
}