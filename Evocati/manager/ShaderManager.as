package Evocati.manager
{
	import com.adobe.utils.AGALMiniAssembler;
	
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Program3D;
	import flash.utils.Dictionary;

	public class ShaderManager
	{
		private var _programList:Dictionary
		private var _ctx3d:Context3D;
		private var _vertexShaderList:Dictionary;
		private var _pixelShaderList:Dictionary;
		
		public function ShaderManager(ctx:Context3D)
		{
			_ctx3d = ctx;
			_vertexShaderList = new Dictionary();
			_pixelShaderList = new Dictionary();
			_programList = new Dictionary();
			initShaders();
			
		}
		
		private function initShaders():void
		{
			/**顶点着色器*/
			_vertexShaderList["POST_COMMON"] = 
				"mov op, va0\n" +
				// 传递mesh顶点坐标给像素着色器
				"mov v0, va0\n" +
				// 传递纹理坐标给像素着色器
				"mov v1, va1\n" +
				// 传递顶点颜色数据给像素着色器
				"mov v2, va2\n" +
				"mov v3, va3\n" +
				"mov v4, va4\n";
			
			_vertexShaderList["COMMON"] = 
				// 设置空间位置和旋转和缩放  
				"m44 vt0, va0, vc0\n" +
				"mov op, vt0\n" +
				// 传递mesh顶点坐标给像素着色器
				"mov v0, vt0\n" +
				// 传递纹理坐标给像素着色器
				"div vt1, va1, vc6\n"+
				"mul vt1, vt1, vc4\n" +
				"add vt2.xyzw, vt1.xyzw, vc4.zwzw\n" +
				"mov v1, vt2\n" +
				// 传递顶点颜色数据给像素着色器
				"mov v2, va2\n"+
				"mov v3, va3\n" +
				"mov v4, va4\n";
			
			_vertexShaderList["MAP"] = 
				// 设置空间位置和旋转和缩放  
				"m44 vt0, va0, vc0\n" +
				"mov op, vt0\n" +
				// 传递mesh顶点坐标给像素着色器
				"mov v0, vt0\n" +
				// 传递纹理坐标给像素着色器
//				"mul vt1, va1, vc4\n" +    // 归一化
//				"div vt2, vt1, vc6\n" +
//				"mov v1, vt2\n" +
				"mov v1, va1\n" +
				// 传递顶点颜色数据给像素着色器
				"mov v2, va2\n" +
				"mov v3, va3\n" +
				"mov v4, va4\n";
			
			_vertexShaderList["BATCH"] = 
				//归一化
				"div vt0, va0, vc5\n" +
				// 设置空间位置和旋转和缩放  
				"m44 op, vt0, vc0\n" +
				// 传递mesh顶点坐标给像素着色器
				"mov v0, vt0\n" +
				// 传递纹理坐标给像素着色器
				"div vt1.xyzw, va1.xyzw, vc6.xyzw\n" +
				"mov v1, vt1\n" +
				// 传递顶点颜色数据给像素着色器
				"mov v2, va2\n" +
				"mov v3, va3\n" +
				"mov v4, va4\n";
			
			_vertexShaderList["PARTICLE_BATCH"] = 
				"mov vt0, va0\n" +
				//移动位置x = vx*t y = vy*t - g*t^2
				"mul vt1.xyz, va3.xyz, va4.x\n" +
				"mov vt1.w, va4.x\n" +
				"mul vt1.w, vt1.w, vt1.w\n" +
				"mul vt1.w, vt1.w, vc7.x\n" +
				"sub vt1.y, vt1.y, vt1.w\n" +
				"add vt0.xyz, vt0.xyz, vt1.xyz\n" +
				//归一化
				"div vt0, vt0, vc5\n" +
				// 设置空间位置和旋转和缩放  
				"m44 op, vt0, vc0\n" +
				// 传递mesh顶点坐标给像素着色器
				"mov v0, vt0\n" +
				// 传递纹理坐标给像素着色器
				"div vt2.xyzw, va1.xyzw, vc6.xyzw\n" +
				"mov v1, vt2\n" +
				// 传递顶点颜色数据给像素着色器
				"mov v2, va2\n" +
				// 传递时间数据给像素着色器
				"mov v4, va4\n";
			
			_vertexShaderList["PARTICLE_LINK"] = 
				"mov vt0, va0\n" +
				//归一化
				"div vt0, vt0, vc5\n" +
				// 设置空间位置和旋转和缩放  
				"m44 op, vt0, vc0\n" +
				// 传递mesh顶点坐标给像素着色器
				"mov v0, vt0\n" +
				// 传递纹理坐标给像素着色器
				"mov v1, va1\n" +
				// 传递时间数据给像素着色器
				"mov v2, va2\n" +
				"mov v3, va3\n" +
				// 传递消隐数据给像素着色器
				"mov v4, va4\n";
			
			/**像素着色器*/
			
			_pixelShaderList["COMMON"] =
				"tex ft0, v1, fs0 <2d,nearest,nomip>\n"+
				"mov oc, ft0\n";     
			_pixelShaderList["COMMON_DXT1"] =
				"tex ft0, v1, fs0 <2d,linear,nomip,dxt1>\n"+
				"mov oc, ft0\n";
			_pixelShaderList["COMMON_FOG_DXT1"] =
				"mov ft0, v0\n"+
				"sub ft0, ft0, fc0\n"+
				"mul ft0, ft0, ft0\n"+
				"add ft0.y, ft0.y, ft0.x\n"+
				"tex ft1, v1, fs0 <2d,nearest,nomip,dxt1>\n"+
				"mul ft0.y, ft0.y, ft0.w\n"+
				"sub ft1, ft1, ft0.y\n"+
				"mov oc, ft1\n"; 
			
			_pixelShaderList["COMMON_DXT5"] =
				"tex ft0, v1, fs0 <2d,nearest,nomip,dxt5>\n"+
				"mov oc, ft0\n";
			_pixelShaderList["COMMON_PARTICLE_DXT5"] =
				"tex ft0, v1, fs0 <2d,linear,nomip,dxt5>\n"+
				"mul ft0.w, ft0.w, v4.y\n"+
				"mov oc, ft0\n";
			_pixelShaderList["COMMON_PARTICLE_LINK_DXT5"] =
				"tex ft0, v1, fs0 <2d,linear,nomip,dxt5>\n"+
				"mul ft0.w, ft0.w, v2.y\n"+
				"mov oc, ft0\n";
			_pixelShaderList["COMMON_FOG_DXT5"] =
				"mov ft0, v0\n"+
				"sub ft0, ft0, fc0\n"+
				"mul ft0, ft0, ft0\n"+
				"add ft0.y, ft0.y, ft0.x\n"+
				"tex ft1, v1, fs0 <2d,nearest,nomip,dxt5>\n"+
				"mul ft0.y, ft0.y, ft0.w\n"+
				"sub ft1, ft1, ft0.y\n"+
				"mov oc, ft1\n"; 
			
			/**后处理*/
			_pixelShaderList["POST_TEST"] =
				"tex ft0, v1, fs0 <2d,linear,nomip>\n"+
				"mov oc, ft0\n"; 
			
			_pixelShaderList["POST_BLOOM"] =
				"tex ft0, v1, fs0 <2d,linear,nomip>\n"+
				"tex ft1, v1, fs1 <2d,linear,nomip>\n"+
				"add oc, ft0, ft1\n"; 
			
			_pixelShaderList["POST_BLUR_HORIZONTAL"] =
				"mov ft1, v1\n" +    //采样
				"tex ft0, ft1, fs0 <2d,linear,nomip>\n"+
				"mul ft0, ft0, fc0.wwww\n" +
				
				"sub ft1.x, ft1.x, fc0.x\n" +       //移动采样位置（水平)
				"tex ft2, ft1, fs0 <2d,linear,nomip>\n"+
				"mul ft2, ft2, fc1.wwww\n" +        //乘以高斯系数
				"add ft0, ft0, ft2\n" +
				
				"sub ft1.x, ft1.x, fc0.x\n" +      
				"tex ft2, ft1, fs0 <2d,linear,nomip>\n"+
				"mul ft2, ft2, fc1.zzzz\n" +
				"add ft0, ft0, ft2\n" +
				
				"sub ft1.x, ft1.x, fc0.x\n" +
				"tex ft2, ft1, fs0 <2d,linear,nomip>\n"+
				"mul ft2, ft2, fc1.yyyy\n" +
				"add ft0, ft0, ft2\n" +
				
				"sub ft1.x, ft1.x, fc0.x\n" +
				"tex ft2, ft1, fs0 <2d,linear,nomip>\n"+
				"mul ft2, ft2, fc1.xxxx\n" +
				"add ft0, ft0, ft2\n" +
				
				"add ft1.x, ft1.x, fc0.x\n" +
				"add ft1.x, ft1.x, fc0.x\n" +
				"add ft1.x, ft1.x, fc0.x\n" +
				"add ft1.x, ft1.x, fc0.x\n" +
				"add ft1.x, ft1.x, fc0.x\n" +
				"tex ft2, ft1, fs0 <2d,linear,nomip>\n"+
				"mul ft2, ft2, fc1.wwww\n" +
				"add ft0, ft0, ft2\n" +
				
				"add ft1.x, ft1.x, fc0.x\n" +
				"tex ft2, ft1, fs0 <2d,linear,nomip>\n"+
				"mul ft2, ft2, fc1.zzzz\n" +
				"add ft0, ft0, ft2\n" +
				
				"add ft1.x, ft1.x, fc0.x\n" +
				"tex ft2, ft1, fs0 <2d,linear,nomip>\n"+
				"mul ft2, ft2, fc1.yyyy\n" +
				"add ft0, ft0, ft2\n" +
				
				"add ft1.x, ft1.x, fc0.x\n" +
				"tex ft2, ft1, fs0 <2d,linear,nomip>\n"+
				"mul ft2, ft2, fc1.xxxx\n" +
				"add ft0, ft0, ft2\n";
			
			_pixelShaderList["POST_BLUR_VERTICAL"] =
				"mov ft1, v1\n" +
				"tex ft0, ft1, fs0 <2d,linear,nomip>\n"+
				"mul ft0, ft0, fc0.wwww\n" +
				
				"sub ft1.y, ft1.y, fc0.x\n" +
				"tex ft2, ft1, fs0 <2d,linear,nomip>\n"+
				"mul ft2, ft2, fc1.wwww\n" +
				"add ft0, ft0, ft2\n" +
				
				"sub ft1.y, ft1.y, fc0.x\n" +
				"tex ft2, ft1, fs0 <2d,linear,nomip>\n"+
				"mul ft2, ft2, fc1.zzzz\n" +
				"add ft0, ft0, ft2\n" +
				
				"sub ft1.y, ft1.y, fc0.x\n" +
				"tex ft2, ft1, fs0 <2d,linear,nomip>\n"+
				"mul ft2, ft2, fc1.yyyy\n" +
				"add ft0, ft0, ft2\n" +
				
				"sub ft1.y, ft1.y, fc0.x\n" +
				"tex ft2, ft1, fs0 <2d,linear,nomip>\n"+
				"mul ft2, ft2, fc1.xxxx\n" +
				"add ft0, ft0, ft2\n" +
				
				"add ft1.y, ft1.y, fc0.x\n" +
				"add ft1.y, ft1.y, fc0.x\n" +
				"add ft1.y, ft1.y, fc0.x\n" +
				"add ft1.y, ft1.y, fc0.x\n" +
				"add ft1.y, ft1.y, fc0.x\n" +
				"tex ft2, ft1, fs0 <2d,linear,nomip>\n"+
				"mul ft2, ft2, fc1.wwww\n" +
				"add ft0, ft0, ft2\n" +
				
				"add ft1.y, ft1.y, fc0.x\n" +
				"tex ft2, ft1, fs0 <2d,linear,nomip>\n"+
				"mul ft2, ft2, fc1.zzzz\n" +
				"add ft0, ft0, ft2\n" +
				
				"add ft1.y, ft1.y, fc0.x\n" +
				"tex ft2, ft1, fs0 <2d,linear,nomip>\n"+
				"mul ft2, ft2, fc1.yyyy\n" +
				"add ft0, ft0, ft2\n" +
				
				"add ft1.y, ft1.y, fc0.x\n" +
				"tex ft2, ft1, fs0 <2d,linear,nomip>\n"+
				"mul ft2, ft2, fc1.xxxx\n" +
				"add ft0, ft0, ft2\n";
				
			_pixelShaderList["POST_BLUR_P2"] =
				"mov oc, ft0\n";  
			
			_pixelShaderList["POST_RADIAL_BLUR_P1"] =
				"mov ft3, fc1\n" + //以下拷贝变换矩阵到临时寄存器
				"mov ft4, fc2\n" +
				"mov ft5, fc3\n" +
				"mov ft6, fc4\n" +
				"mov ft0, v1\n" + //拷贝纹理坐标到临时寄存器
				// 采样纹理数据传递给颜色输出
				"tex ft1, ft0, fs0 <2d,linear,nomip>\n";
			
			_pixelShaderList["POST_RADIAL_BLUR_P2"] =
				"sub ft3.x, ft3.x, fc0.z\n" + //矩阵缩小scalex
				"sub ft4.y, ft4.y, fc0.z\n" + //矩阵缩小scaley
				"add ft3.w, ft3.w, fc0.x\n" + //位置缩放变换到图片中心
				"add ft4.w, ft4.w, fc0.y\n" +
				"m44 ft0, v1, ft3\n" + //应用矩阵变换
				"tex ft2, ft0, fs0<2d,linear,nomip>\n" + //采样
				"add ft1, ft1, ft2\n" ; //累加到颜色临时变量
			
			_pixelShaderList["POST_DIR_BLUR_P2"] =
				"mov ft7, fc0\n" +
				"mul ft7.xy, ft7.xy, fc0.zz\n" +
				"add ft3.w, ft3.w, ft7.x\n" + //矩阵平移 x
				"add ft4.w, ft4.w, ft7.y\n" + //矩阵平移 y
				"m44 ft0, v1, ft3\n" + //应用矩阵变换
				"tex ft2, ft0, fs0<2d,linear,nomip>\n" + //采样
				"add ft1, ft1, ft2\n" ; //累加到颜色临时变量
			
			_pixelShaderList["POST_RADIAL_BLUR_P3"] =
				"div ft1, ft1, fc0.w\n" +//除以步数以得到平均值
				"mov oc, ft1\n"; //输出颜色
			
		}
		
		public function setShaders(typeV:String, typeP:String):void
		{
			var vertexShaderAssembler:AGALMiniAssembler = new AGALMiniAssembler();
			var arrV:Array = typeV.split("+");
			var resV:String = "";
			for each(var str:String in arrV)
			{
				var arr:Array = str.split("@");
				if(arr.length == 2)
				{
					var num:int = int(arr[1]);
					while(num--)
					{
						resV += _vertexShaderList[arr[0]];
					}
				}
				else if(arr.length == 1)
				{
					resV += _vertexShaderList[arr[0]];
				}
			}
			vertexShaderAssembler.assemble
				( 
					Context3DProgramType.VERTEX,
					resV
				); 
			
			
			var fragmentShaderAssembler:AGALMiniAssembler = new AGALMiniAssembler();
			var arrP:Array = typeP.split("+");
			var resP:String = "";
			for each(var strv:String in arrP)
			{
				arr = strv.split("@");
				if(arr.length == 2)
				{
					 num = int(arr[1]);
					while(num--)
					{
						resP += _pixelShaderList[arr[0]];
					}
				}
				else if(arr.length == 1)
				{
					resP += _pixelShaderList[arr[0]];
				}
			}
			fragmentShaderAssembler.assemble
				( 
					Context3DProgramType.FRAGMENT,  
					resP
				);
			
			_programList[typeV+'&'+typeP] = _ctx3d.createProgram();
			_programList[typeV+'&'+typeP].upload(vertexShaderAssembler.agalcode, 
				fragmentShaderAssembler.agalcode);	
		}
		
		public function getShaders(typeV:String, typeP:String):Program3D
		{
			if(_programList[typeV+'&'+typeP] != undefined)
				return _programList[typeV+'&'+typeP];
			else
				return null;
		}
	}
}