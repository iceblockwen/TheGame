package Evocati.manager
{
	import com.adobe.utils.PerspectiveMatrix3D;
	
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import Evocati.gameData.CommonData;

	public class TransformManager
	{
		private var data:CommonData;
		/**
		 * 摄影机中心位置(归一化)
		 */
		private var _nCameraPos:Vector3D = new Vector3D();
		/**
		 * 摄影机中心位置(像素)
		 */
		private var _cameraPos:Vector3D = new Vector3D();
		/**
		 * 摄影机旋转矩阵
		 */
		private var _cameraRotation:Vector3D = new Vector3D();
		/**
		 * 位置旋转矩阵和摄影机矩阵
		 */
		private var projectionMatrix:PerspectiveMatrix3D = new PerspectiveMatrix3D();     //透视矩阵
		private var modelMatrix:Matrix3D = new Matrix3D();                                //物体位置和旋转矩阵
		private var viewMatrix:Matrix3D = new Matrix3D();                                 //摄像机矩阵
		public var modelViewProjection:Matrix3D = new Matrix3D();                        //合并矩阵
		
		public function TransformManager(cdata:CommonData)
		{
			data = cdata;
		}
		
		/**
		 * 移动摄影机(实际像素数据)
		 */
		public function moveCamera(x:Number,y:Number,z:Number):void
		{
			_cameraPos.setTo(x,y,z);
			var nx:Number = x*2/data.gameWidth
			var ny:Number = y*2/data.gameHeight
			var nz:Number = z;
			_nCameraPos.setTo(nx,ny,nz);
		}
		/**
		 * 增量摄影机(实际像素数据)
		 */
		public function moveCameraBy(x:Number,y:Number,z:Number):void
		{
			_cameraPos.x += x;
			_cameraPos.y += y;
			_cameraPos.z += z;
			var nx:Number = x*2/data.gameWidth
			var ny:Number = y*2/data.gameHeight
			var nz:Number = z;
			_nCameraPos.x += nx;
			_nCameraPos.y += ny;
			_nCameraPos.z += nz;
		}
		
		/**
		 * 旋转摄影机(实际像素数据)
		 */
		public function rotateCamera(rx:Number,ry:Number,rz:Number):void
		{
			_cameraRotation.setTo(rx,ry,rz);
		}
		
		public function getCameraPos():Vector3D
		{
			return _cameraPos;
		}
		
		/**
		 * 设置摄像机透视矩阵
		 */
		private function setCameraPerspective():void
		{
			projectionMatrix.identity();
			// ---45 degrees FOV, 640/480 aspect ratio, 0.1=near, 100=far---
			projectionMatrix.perspectiveFieldOfViewRH(
				45.0, data.gameWidth / data.gameHeight, 0.01, 100.0);
		}	
		/**
		 * 设置多边形的位置和旋转,动态改变缩放(实际像素数据)
		 */
		public function setTransform(x:Number,y:Number,z:Number,rx:Number,ry:Number,rz:Number,sx:Number,sy:Number):void
		{
			var nx:Number = x*2/data.gameWidth;
			var ny:Number = y*2/data.gameHeight;
			viewMatrix.identity();
			
			//			viewMatrix.appendTranslation(-(_nCameraPos.x - nx),0,_nCameraPos.z);
			//			viewMatrix.appendRotation(_cameraRotation.x,Vector3D.X_AXIS);
			//			viewMatrix.appendTranslation(_nCameraPos.x - nx,0,-_nCameraPos.z);
			//			
			//			viewMatrix.appendTranslation(0,_nCameraPos.y - ny,_nCameraPos.z);
			//			viewMatrix.appendRotation(_cameraRotation.y,Vector3D.Y_AXIS);
			//			viewMatrix.appendTranslation(0,-(_nCameraPos.y - ny),-_nCameraPos.z);
			//			viewMatrix.appendTranslation(_nCameraPos.x,_nCameraPos.y,_nCameraPos.z);   //归一化
			
			viewMatrix.appendTranslation(-_nCameraPos.x,_nCameraPos.y,_nCameraPos.z);   
			
			modelMatrix.identity();
			
			//			modelMatrix.appendTranslation(-0.1,0.1,0);
			//			modelMatrix.appendRotation(ry,Vector3D.Y_AXIS);
			//			modelMatrix.appendRotation(rx,Vector3D.X_AXIS);
			//			modelMatrix.appendRotation(rz,Vector3D.Z_AXIS);
			//			modelMatrix.appendTranslation(0.1,-0.1,0);
			modelMatrix.appendScale(sx,sy,1);
			modelMatrix.appendTranslation(nx,ny,0);
			
			//modelMatrix.appendScale(1,_gameWidth / _gameHeight,1);
			
			modelViewProjection.identity();
			modelViewProjection.append(modelMatrix);
			modelViewProjection.append(viewMatrix);
			//modelViewProjection.append(projectionMatrix);
			
		}
	}
}