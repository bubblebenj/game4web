$estr = function() { return js.Boot.__string_rec(this,''); }
if(typeof math=='undefined') math = {}
math.CMatrix44 = function(p) { if( p === $_ ) return; {
	this.m_Buffer = new Array();
	{
		this.Zero();
		this.m_Buffer[0] = 1;
		this.m_Buffer[5] = 1;
		this.m_Buffer[10] = 1;
		this.m_Buffer[15] = 1;
	}
}}
math.CMatrix44.__name__ = ["math","CMatrix44"];
math.CMatrix44.Translate = function(_Out,_In,_x,_y,_z) {
	var l_Temp = math.Registers.M0;
	{
		l_Temp.Zero();
		l_Temp.m_Buffer[0] = 1;
		l_Temp.m_Buffer[5] = 1;
		l_Temp.m_Buffer[10] = 1;
		l_Temp.m_Buffer[15] = 1;
	}
	l_Temp.m_Buffer[12] = _x;
	l_Temp.m_Buffer[13] = _y;
	l_Temp.m_Buffer[14] = _z;
	math.CMatrix44.Mult(_Out,_In,l_Temp);
}
math.CMatrix44.Mult = function(_Out,_M0,_M1) {
	_Out.Zero();
	{
		var _g = 0;
		while(_g < 3) {
			var _i = _g++;
			{
				var _g1 = 0;
				while(_g1 < 3) {
					var _j = _g1++;
					_Out.m_Buffer[_i * 4 + _j] = _M0.m_Buffer[_i * 4 + _j] * _M1.m_Buffer[_j * 4 + _i] + _Out.m_Buffer[_i * 4 + _j];
				}
			}
		}
	}
}
math.CMatrix44.Det22 = function(a,b,c,d) {
	return a * d - b * c;
}
math.CMatrix44.Det33 = function(a1,a2,a3,b1,b2,b3,c1,c2,c3) {
	return (a1 * (b2 * c3 - b3 * c2) - b1 * (a2 * c3 - a3 * c2)) + c1 * (a2 * b3 - a3 * b2);
}
math.CMatrix44.Ortho = function(_Out,_left,_right,_bottom,_top,_near,_far) {
	var l_tx = -(_left + _right) / (_right - _left);
	var l_ty = -(_top + _bottom) / (_top - _bottom);
	var l_tz = -(_far + _near) / (_far - _near);
	{
		_Out.Zero();
		_Out.m_Buffer[0] = 1;
		_Out.m_Buffer[5] = 1;
		_Out.m_Buffer[10] = 1;
		_Out.m_Buffer[15] = 1;
	}
	_Out.m_Buffer[0] = 2 / (_right - _left);
	_Out.m_Buffer[1] = 0;
	_Out.m_Buffer[2] = 0;
	_Out.m_Buffer[3] = 0;
	_Out.m_Buffer[4] = 0;
	_Out.m_Buffer[5] = 2 / (_top - _bottom);
	_Out.m_Buffer[6] = 0;
	_Out.m_Buffer[7] = 0;
	_Out.m_Buffer[8] = 0;
	_Out.m_Buffer[9] = 0;
	_Out.m_Buffer[10] = -2 / (_far - _near);
	_Out.m_Buffer[11] = 0;
	_Out.m_Buffer[12] = l_tx;
	_Out.m_Buffer[13] = l_ty;
	_Out.m_Buffer[14] = l_tz;
	_Out.m_Buffer[15] = 1;
}
math.CMatrix44.prototype.Adjoint = function(_Out) {
	var a1 = this.m_Buffer[0];
	var b1 = this.m_Buffer[1];
	var c1 = this.m_Buffer[2];
	var d1 = this.m_Buffer[3];
	var a2 = this.m_Buffer[4];
	var b2 = this.m_Buffer[5];
	var c2 = this.m_Buffer[6];
	var d2 = this.m_Buffer[7];
	var a3 = this.m_Buffer[8];
	var b3 = this.m_Buffer[9];
	var c3 = this.m_Buffer[10];
	var d3 = this.m_Buffer[11];
	var a4 = this.m_Buffer[12];
	var b4 = this.m_Buffer[13];
	var c4 = this.m_Buffer[14];
	var d4 = this.m_Buffer[15];
	{
		_Out.m_Buffer[0] = math.CMatrix44.Det33(b2,b3,b4,c2,c3,c4,d2,d3,d4);
		_Out.m_Buffer[1] = -math.CMatrix44.Det33(a2,a3,a4,c2,c3,c4,d2,d3,d4);
		_Out.m_Buffer[2] = math.CMatrix44.Det33(a2,a3,a4,b2,b3,b4,d2,d3,d4);
		_Out.m_Buffer[3] = -math.CMatrix44.Det33(a2,a3,a4,b2,b3,b4,c2,c3,c4);
		_Out.m_Buffer[4] = -math.CMatrix44.Det33(b1,b3,b4,c1,c3,c4,d1,d3,d4);
		_Out.m_Buffer[5] = math.CMatrix44.Det33(a1,a3,a4,c1,c3,c4,d1,d3,d4);
		_Out.m_Buffer[6] = -math.CMatrix44.Det33(a1,a3,a4,b1,b3,b4,d1,d3,d4);
		_Out.m_Buffer[7] = math.CMatrix44.Det33(a1,a3,a4,b1,b3,b4,c1,c3,c4);
		_Out.m_Buffer[8] = math.CMatrix44.Det33(b1,b2,b4,c1,c2,c4,d1,d2,d4);
		_Out.m_Buffer[9] = -math.CMatrix44.Det33(a1,a2,a4,c1,c2,c4,d1,d2,d4);
		_Out.m_Buffer[10] = math.CMatrix44.Det33(a1,a2,a4,b1,b2,b4,d1,d2,d4);
		_Out.m_Buffer[11] = -math.CMatrix44.Det33(a1,a2,a4,b1,b2,b4,c1,c2,c4);
		_Out.m_Buffer[12] = -math.CMatrix44.Det33(b1,b2,b3,c1,c2,c3,d1,d2,d3);
		_Out.m_Buffer[13] = math.CMatrix44.Det33(a1,a2,a3,c1,c2,c3,d1,d2,d3);
		_Out.m_Buffer[14] = -math.CMatrix44.Det33(a1,a2,a3,b1,b2,b3,d1,d2,d3);
		_Out.m_Buffer[15] = math.CMatrix44.Det33(a1,a2,a3,b1,b2,b3,c1,c2,c3);
	}
}
math.CMatrix44.prototype.Copy = function(_Mat) {
	var _g = 0;
	while(_g < 16) {
		var i = _g++;
		this.m_Buffer[i] = _Mat.m_Buffer[i];
	}
}
math.CMatrix44.prototype.Det44 = function() {
	var a1 = this.m_Buffer[0];
	var b1 = this.m_Buffer[1];
	var c1 = this.m_Buffer[2];
	var d1 = this.m_Buffer[3];
	var a2 = this.m_Buffer[4];
	var b2 = this.m_Buffer[5];
	var c2 = this.m_Buffer[6];
	var d2 = this.m_Buffer[7];
	var a3 = this.m_Buffer[8];
	var b3 = this.m_Buffer[9];
	var c3 = this.m_Buffer[10];
	var d3 = this.m_Buffer[11];
	var a4 = this.m_Buffer[12];
	var b4 = this.m_Buffer[13];
	var c4 = this.m_Buffer[14];
	var d4 = this.m_Buffer[15];
	return ((a1 * math.CMatrix44.Det33(b2,b3,b4,c2,c3,c4,d2,d3,d4) - b1 * math.CMatrix44.Det33(a2,a3,a4,c2,c3,c4,d2,d3,d4)) + c1 * math.CMatrix44.Det33(a2,a3,a4,b2,b3,b4,d2,d3,d4)) - d1 * math.CMatrix44.Det33(a2,a3,a4,b2,b3,b4,c2,c3,c4);
}
math.CMatrix44.prototype.Frustum = function(_left,_right,_bottom,_top,_znear,_zfar) {
	var l_X = (2 * _znear) / (_right - _left);
	var l_Y = (2 * _znear) / (_top - _bottom);
	var l_A = (_right + _left) / (_right - _left);
	var l_B = (_top + _bottom) / (_top - _bottom);
	var l_C = -(_zfar + _znear) / (_zfar - _znear);
	var l_D = ((-2 * _zfar) * _znear) / (_zfar - _znear);
	{
		this.m_Buffer[0] = l_X;
		this.m_Buffer[1] = 0;
		this.m_Buffer[2] = 0;
		this.m_Buffer[3] = 0;
		this.m_Buffer[4] = 0;
		this.m_Buffer[5] = l_Y;
		this.m_Buffer[6] = 0;
		this.m_Buffer[7] = 0;
		this.m_Buffer[8] = l_A;
		this.m_Buffer[9] = l_B;
		this.m_Buffer[10] = l_C;
		this.m_Buffer[11] = -1;
		this.m_Buffer[12] = 0;
		this.m_Buffer[13] = 0;
		this.m_Buffer[14] = l_D;
		this.m_Buffer[15] = 0;
	}
}
math.CMatrix44.prototype.Get = function(_i,_j) {
	return this.m_Buffer[_i * 4 + _j];
}
math.CMatrix44.prototype.Identity = function() {
	this.Zero();
	this.m_Buffer[0] = 1;
	this.m_Buffer[5] = 1;
	this.m_Buffer[10] = 1;
	this.m_Buffer[15] = 1;
}
math.CMatrix44.prototype.Invert = function(_Out) {
	var l_Det = this.Det44();
	if(Math.abs(l_Det) < 1e-6) {
		return false;
	}
	this.Adjoint(_Out);
	this.MultScalar(_Out,1.0 / l_Det);
	return true;
}
math.CMatrix44.prototype.LookAt = function(eyex,eyey,eyez,centerx,centery,centerz,upx,upy,upz) {
	var l_Matrix = new math.CMatrix44();
	var zx = eyex - centerx;
	var zy = eyey - centery;
	var zz = eyez - centerz;
	var mag = Math.sqrt((zx * zx + zy * zy) + zz * zz);
	if(mag > 1e-6) {
		var l_InvMag = 1.0 / mag;
		zx *= l_InvMag;
		zy *= l_InvMag;
		zz *= l_InvMag;
	}
	var yx = upx;
	var yy = upy;
	var yz = upz;
	var xx = yy * zz - yz * zy;
	var xy = -yx * zz + yz * zx;
	var xz = yx * zy - yy * zx;
	yx = zy * xz - zz * xy;
	yy = -zx * xz + zz * xx;
	yx = zx * xy - zy * xx;
	var mag1 = Math.sqrt((xx * xx + xy * xy) + xz * xz);
	if(Math.abs(mag1) > 1e-6) {
		xx /= mag1;
		xy /= mag1;
		xz /= mag1;
	}
	mag1 = Math.sqrt((yx * yx + yy * yy) + yz * yz);
	if(Math.abs(mag1) > 1e-6) {
		yx /= mag1;
		yy /= mag1;
		yz /= mag1;
	}
	{
		l_Matrix.m_Buffer[0] = xx;
		l_Matrix.m_Buffer[1] = xy;
		l_Matrix.m_Buffer[2] = xz;
		l_Matrix.m_Buffer[3] = 0;
		l_Matrix.m_Buffer[4] = yx;
		l_Matrix.m_Buffer[5] = yy;
		l_Matrix.m_Buffer[6] = yz;
		l_Matrix.m_Buffer[7] = 0;
		l_Matrix.m_Buffer[8] = zx;
		l_Matrix.m_Buffer[9] = zy;
		l_Matrix.m_Buffer[10] = zz;
		l_Matrix.m_Buffer[11] = 0;
		l_Matrix.m_Buffer[12] = 0;
		l_Matrix.m_Buffer[13] = 0;
		l_Matrix.m_Buffer[14] = 0;
		l_Matrix.m_Buffer[15] = 1;
	}
	math.CMatrix44.Translate(l_Matrix,l_Matrix,-eyex,-eyey,-eyez);
	math.CMatrix44.Mult(this,this,l_Matrix);
}
math.CMatrix44.prototype.M = function(_i,_j,_f) {
	this.m_Buffer[_i * 4 + _j] = _f;
}
math.CMatrix44.prototype.MultScalar = function(_InOut,_f) {
	var _g = 0;
	while(_g < 16) {
		var i = _g++;
		this.m_Buffer[i] *= _f;
	}
}
math.CMatrix44.prototype.Perspective = function(_fovy,_aspect,_znear,_zfar) {
	var l_ymax = _znear * Math.tan((_fovy * Math.PI) / 360.0);
	var l_ymin = -l_ymax;
	var l_xmin = l_ymin * _aspect;
	var l_xmax = l_ymax * _aspect;
	return this.Frustum(l_xmin,l_xmax,l_ymin,l_ymax,_znear,_zfar);
}
math.CMatrix44.prototype.Set = function(_00,_01,_02,_03,_10,_11,_12,_13,_20,_21,_22,_23,_30,_31,_32,_33) {
	this.m_Buffer[0] = _00;
	this.m_Buffer[1] = _01;
	this.m_Buffer[2] = _02;
	this.m_Buffer[3] = _03;
	this.m_Buffer[4] = _10;
	this.m_Buffer[5] = _11;
	this.m_Buffer[6] = _12;
	this.m_Buffer[7] = _13;
	this.m_Buffer[8] = _20;
	this.m_Buffer[9] = _21;
	this.m_Buffer[10] = _22;
	this.m_Buffer[11] = _23;
	this.m_Buffer[12] = _30;
	this.m_Buffer[13] = _31;
	this.m_Buffer[14] = _32;
	this.m_Buffer[15] = _33;
}
math.CMatrix44.prototype.Trace = function() {
	kernel.CDebug.CONSOLEMSG(((((((this.m_Buffer[0] + ",") + this.m_Buffer[1]) + ",") + this.m_Buffer[2]) + ",") + this.m_Buffer[3]) + "\n",{ fileName : "CMatrix44.hx", lineNumber : 103, className : "math.CMatrix44", methodName : "Trace"});
	kernel.CDebug.CONSOLEMSG(((((((this.m_Buffer[4] + ",") + this.m_Buffer[5]) + ",") + this.m_Buffer[6]) + ",") + this.m_Buffer[7]) + "\n",{ fileName : "CMatrix44.hx", lineNumber : 104, className : "math.CMatrix44", methodName : "Trace"});
	kernel.CDebug.CONSOLEMSG(((((((this.m_Buffer[8] + ",") + this.m_Buffer[9]) + ",") + this.m_Buffer[10]) + ",") + this.m_Buffer[11]) + "\n",{ fileName : "CMatrix44.hx", lineNumber : 105, className : "math.CMatrix44", methodName : "Trace"});
	kernel.CDebug.CONSOLEMSG(((((((this.m_Buffer[12] + ",") + this.m_Buffer[13]) + ",") + this.m_Buffer[14]) + ",") + this.m_Buffer[15]) + "\n",{ fileName : "CMatrix44.hx", lineNumber : 106, className : "math.CMatrix44", methodName : "Trace"});
}
math.CMatrix44.prototype.Translation = function(_x,_y,_z) {
	{
		this.Zero();
		this.m_Buffer[0] = 1;
		this.m_Buffer[5] = 1;
		this.m_Buffer[10] = 1;
		this.m_Buffer[15] = 1;
	}
	this.m_Buffer[12] = _x;
	this.m_Buffer[13] = _y;
	this.m_Buffer[14] = _z;
}
math.CMatrix44.prototype.Zero = function() {
	var _g = 0;
	while(_g < 16) {
		var i = _g++;
		this.m_Buffer[i] = 0;
	}
}
math.CMatrix44.prototype.m_Buffer = null;
math.CMatrix44.prototype.__class__ = math.CMatrix44;
math.CV3D = function(_x,_y,_z) { if( _x === $_ ) return; {
	this.x = _x;
	this.y = _y;
	this.z = _z;
}}
math.CV3D.__name__ = ["math","CV3D"];
math.CV3D.Add = function(_VOut,_V0,_V1) {
	_VOut.x = _V0.x + _V1.x;
	_VOut.y = _V0.y + _V1.y;
	_VOut.z = _V0.z + _V1.z;
}
math.CV3D.Sub = function(_VOut,_V0,_V1) {
	_VOut.x = _V0.x - _V1.x;
	_VOut.y = _V0.y - _V1.y;
	_VOut.z = _V0.z - _V1.z;
}
math.CV3D.Normalize = function(_InOut) {
	var l_InvLen = 1.0 / Math.sqrt((_InOut.x * _InOut.x + _InOut.y * _InOut.y) + _InOut.z * _InOut.z);
	_InOut.x *= l_InvLen;
	_InOut.y *= l_InvLen;
	_InOut.z *= l_InvLen;
}
math.CV3D.prototype.Copy = function(_V) {
	this.x = _V.x;
	this.y = _V.y;
	this.z = _V.z;
}
math.CV3D.prototype.Norm = function() {
	return Math.sqrt((this.x * this.x + this.y * this.y) + this.z * this.z);
}
math.CV3D.prototype.Norm2 = function() {
	return (this.x * this.x + this.y * this.y) + this.z * this.z;
}
math.CV3D.prototype.Set = function(_x,_y,_z) {
	this.x = _x;
	this.y = _y;
	this.z = _z;
}
math.CV3D.prototype.x = null;
math.CV3D.prototype.y = null;
math.CV3D.prototype.z = null;
math.CV3D.prototype.__class__ = math.CV3D;
math.Registers = function() { }
math.Registers.__name__ = ["math","Registers"];
math.Registers.prototype.__class__ = math.Registers;
if(typeof rsc=='undefined') rsc = {}
rsc.CRsc = function(p) { if( p === $_ ) return; {
	this.m_Ref = 0;
	this.m_Path = "";
	this.m_SingleLoad = false;
}}
rsc.CRsc.__name__ = ["rsc","CRsc"];
rsc.CRsc.prototype.AddRef = function() {
	kernel.CDebug.ASSERT(this.m_Ref >= 0,{ fileName : "CRsc.hx", lineNumber : 46, className : "rsc.CRsc", methodName : "AddRef"});
	this.m_Ref++;
}
rsc.CRsc.prototype.Copy = function(_InRsc) {
	kernel.CDebug.ASSERT(this.GetType() == _InRsc.GetType(),{ fileName : "CRsc.hx", lineNumber : 26, className : "rsc.CRsc", methodName : "Copy"});
}
rsc.CRsc.prototype.GetPath = function() {
	return this.m_Path;
}
rsc.CRsc.prototype.GetType = function() {
	return -1;
}
rsc.CRsc.prototype.IsSingleLoaded = function() {
	return this.m_SingleLoad;
}
rsc.CRsc.prototype.Release = function() {
	kernel.CDebug.ASSERT(this.m_Ref >= 0,{ fileName : "CRsc.hx", lineNumber : 62, className : "rsc.CRsc", methodName : "Release"});
	this.m_Ref--;
	if(this.m_Ref == 0) {
		kernel.Glb.g_System.GetRscMan().ForceDelete(this);
	}
}
rsc.CRsc.prototype.SetPath = function(_Path) {
	this.m_Path = ((_Path != null)?_Path.toLowerCase():null);
}
rsc.CRsc.prototype.SetSingleLoaded = function(_OnOff) {
	this.m_SingleLoad = _OnOff;
}
rsc.CRsc.prototype.m_Path = null;
rsc.CRsc.prototype.m_Ref = null;
rsc.CRsc.prototype.m_SingleLoad = null;
rsc.CRsc.prototype.__class__ = rsc.CRsc;
rsc.CRscMan = function(p) { if( p === $_ ) return; {
	this.m_Repository = null;
	this.m_Builders = null;
}}
rsc.CRscMan.__name__ = ["rsc","CRscMan"];
rsc.CRscMan.prototype.AddBuilder = function(_Type,_Builder) {
	kernel.CDebug.ASSERT(_Builder != null,{ fileName : "CRscMan.hx", lineNumber : 28, className : "rsc.CRscMan", methodName : "AddBuilder"});
	this.m_Builders.set(_Type,_Builder);
	return kernel.Result.SUCCESS;
}
rsc.CRscMan.prototype.Copy = function(_Rsc) {
	kernel.CDebug.ASSERT(this.m_Builders.get(_Rsc.GetType()) != null,{ fileName : "CRscMan.hx", lineNumber : 58, className : "rsc.CRscMan", methodName : "Copy"});
	var l_Rsc = this.m_Builders.get(_Rsc.GetType()).Build(_Rsc.GetType(),null);
	if(l_Rsc != null) {
		l_Rsc.AddRef();
		l_Rsc.SetPath(null);
		l_Rsc.SetSingleLoaded(true);
	}
	l_Rsc.Copy(_Rsc);
	return l_Rsc;
}
rsc.CRscMan.prototype.Create = function(_Type) {
	var l_Builder = this.m_Builders.get(_Type);
	if(l_Builder == null) {
		kernel.CDebug.CONSOLEMSG("No builder for rsc type : " + _Type,{ fileName : "CRscMan.hx", lineNumber : 38, className : "rsc.CRscMan", methodName : "Create"});
		return null;
	}
	else {
		var l_Rsc = l_Builder.Build(_Type,null);
		if(l_Rsc != null) {
			l_Rsc.AddRef();
			l_Rsc.SetPath(null);
			l_Rsc.SetSingleLoaded(true);
			return l_Rsc;
		}
	}
	return null;
}
rsc.CRscMan.prototype.ForceDelete = function(_R) {
	this.m_Repository.set(_R.GetPath(),null);
}
rsc.CRscMan.prototype.Initialize = function() {
	this.m_Repository = new Hash();
	this.m_Builders = new IntHash();
	return kernel.Result.SUCCESS;
}
rsc.CRscMan.prototype.Load = function(_Type,_Path,_SingleLoad) {
	kernel.CDebug.ASSERT(_Path != null,{ fileName : "CRscMan.hx", lineNumber : 74, className : "rsc.CRscMan", methodName : "Load"});
	if(_SingleLoad != null && _SingleLoad != true && _Path != null) {
		var l_CandRsc = this.m_Repository.get(_Path);
		if(l_CandRsc != null && !l_CandRsc.IsSingleLoaded()) {
			l_CandRsc.AddRef();
			return l_CandRsc;
		}
	}
	var l_Builder = this.m_Builders.get(_Type);
	if(l_Builder == null) {
		haxe.Log.trace(((("No builder for rsc: " + _Type) + "(") + _Path) + ")",{ fileName : "CRscMan.hx", lineNumber : 89, className : "rsc.CRscMan", methodName : "Load"});
		return null;
	}
	else {
		var l_Rsc = l_Builder.Build(_Type,_Path);
		if(l_Rsc != null) {
			l_Rsc.AddRef();
			l_Rsc.SetPath(_Path);
			l_Rsc.SetSingleLoaded(((_SingleLoad == null)?false:_SingleLoad));
		}
		return l_Rsc;
	}
}
rsc.CRscMan.prototype.Shut = function() {
	this.m_Repository = null;
	this.m_Builders = null;
	return kernel.Result.SUCCESS;
}
rsc.CRscMan.prototype.m_Builders = null;
rsc.CRscMan.prototype.m_Repository = null;
rsc.CRscMan.prototype.__class__ = rsc.CRscMan;
if(typeof renderer=='undefined') renderer = {}
renderer.CViewport = function(p) { if( p === $_ ) return; {
	this.m_x = 0;
	this.m_y = 0;
	this.m_h = 0;
	this.m_w = 0;
	this.m_VpRatio = 1;
	rsc.CRsc.apply(this,[]);
}}
renderer.CViewport.__name__ = ["renderer","CViewport"];
renderer.CViewport.__super__ = rsc.CRsc;
for(var k in rsc.CRsc.prototype ) renderer.CViewport.prototype[k] = rsc.CRsc.prototype[k];
renderer.CViewport.prototype.Activate = function() {
	return kernel.Result.SUCCESS;
}
renderer.CViewport.prototype.ComputeRatio = function() {
	this.m_VpRatio = 1;
}
renderer.CViewport.prototype.GetType = function() {
	return renderer.CViewport.RSC_ID;
}
renderer.CViewport.prototype.GetVpRatio = function() {
	return this.m_VpRatio;
}
renderer.CViewport.prototype.Initialize = function(_x,_y,_h,_w) {
	this.m_x = _x;
	this.m_y = _y;
	this.m_h = _h;
	this.m_w = _w;
}
renderer.CViewport.prototype.m_VpRatio = null;
renderer.CViewport.prototype.m_h = null;
renderer.CViewport.prototype.m_w = null;
renderer.CViewport.prototype.m_x = null;
renderer.CViewport.prototype.m_y = null;
renderer.CViewport.prototype.__class__ = renderer.CViewport;
renderer.CMaterial = function(p) { if( p === $_ ) return; {
	rsc.CRsc.apply(this,[]);
	this.m_Mode = renderer.MAT_BLEND_MODE.MBM_OPAQUE;
	this.m_Alpha = 1;
}}
renderer.CMaterial.__name__ = ["renderer","CMaterial"];
renderer.CMaterial.__super__ = rsc.CRsc;
for(var k in rsc.CRsc.prototype ) renderer.CMaterial.prototype[k] = rsc.CRsc.prototype[k];
renderer.CMaterial.prototype.Activate = function() {
	if(this.m_Shader.Activate() == kernel.Result.FAILURE) {
		return kernel.Result.FAILURE;
	}
	return kernel.Result.SUCCESS;
}
renderer.CMaterial.prototype.GetType = function() {
	return renderer.CMaterial.RSC_ID;
}
renderer.CMaterial.prototype.SetBlendMode = function(_Mode) {
	this.m_Mode = _Mode;
}
renderer.CMaterial.prototype.SetShader = function(_Sh) {
	if(this.m_Shader != null) {
		this.m_Shader.Release();
		this.m_Shader = null;
	}
	if(_Sh != null) {
		_Sh.AddRef();
	}
	this.m_Shader = _Sh;
}
renderer.CMaterial.prototype.m_Alpha = null;
renderer.CMaterial.prototype.m_Mode = null;
renderer.CMaterial.prototype.m_Shader = null;
renderer.CMaterial.prototype.m_Textures = null;
renderer.CMaterial.prototype.__class__ = renderer.CMaterial;
if(typeof driver=='undefined') driver = {}
if(!driver.js) driver.js = {}
if(!driver.js.renderer) driver.js.renderer = {}
driver.js.renderer.CMaterialJS = function(p) { if( p === $_ ) return; {
	renderer.CMaterial.apply(this,[]);
}}
driver.js.renderer.CMaterialJS.__name__ = ["driver","js","renderer","CMaterialJS"];
driver.js.renderer.CMaterialJS.__super__ = renderer.CMaterial;
for(var k in renderer.CMaterial.prototype ) driver.js.renderer.CMaterialJS.prototype[k] = renderer.CMaterial.prototype[k];
driver.js.renderer.CMaterialJS.prototype.Activate = function() {
	var l_GL = kernel.Glb.g_SystemJS.m_GlObject;
	var $e = (this.m_Mode);
	switch( $e[1] ) {
	case 3:
	{
		l_GL.Disable(3042);
	}break;
	case 0:
	{
		l_GL.BlendEquation(32774);
		l_GL.Enable(3042);
		l_GL.BlendFunc(770,1);
		l_GL.Enable(3042);
	}break;
	case 1:
	{
		l_GL.BlendEquation(32778);
		l_GL.Enable(3042);
		l_GL.BlendFunc(770,1);
		l_GL.Enable(3042);
	}break;
	case 2:
	{
		l_GL.BlendEquation(32774);
		l_GL.Enable(3042);
		l_GL.BlendFunc(770,771);
		l_GL.Enable(3042);
	}break;
	}
	return renderer.CMaterial.prototype.Activate.apply(this,[]);
}
driver.js.renderer.CMaterialJS.prototype.__class__ = driver.js.renderer.CMaterialJS;
List = function(p) { if( p === $_ ) return; {
	this.length = 0;
}}
List.__name__ = ["List"];
List.prototype.add = function(item) {
	var x = [item];
	if(this.h == null) this.h = x;
	else this.q[1] = x;
	this.q = x;
	this.length++;
}
List.prototype.clear = function() {
	this.h = null;
	this.q = null;
	this.length = 0;
}
List.prototype.filter = function(f) {
	var l2 = new List();
	var l = this.h;
	while(l != null) {
		var v = l[0];
		l = l[1];
		if(f(v)) l2.add(v);
	}
	return l2;
}
List.prototype.first = function() {
	return (this.h == null?null:this.h[0]);
}
List.prototype.h = null;
List.prototype.isEmpty = function() {
	return (this.h == null);
}
List.prototype.iterator = function() {
	return { h : this.h, hasNext : function() {
		return (this.h != null);
	}, next : function() {
		if(this.h == null) return null;
		var x = this.h[0];
		this.h = this.h[1];
		return x;
	}}
}
List.prototype.join = function(sep) {
	var s = new StringBuf();
	var first = true;
	var l = this.h;
	while(l != null) {
		if(first) first = false;
		else s.b[s.b.length] = sep;
		s.b[s.b.length] = l[0];
		l = l[1];
	}
	return s.b.join("");
}
List.prototype.last = function() {
	return (this.q == null?null:this.q[0]);
}
List.prototype.length = null;
List.prototype.map = function(f) {
	var b = new List();
	var l = this.h;
	while(l != null) {
		var v = l[0];
		l = l[1];
		b.add(f(v));
	}
	return b;
}
List.prototype.pop = function() {
	if(this.h == null) return null;
	var x = this.h[0];
	this.h = this.h[1];
	if(this.h == null) this.q = null;
	this.length--;
	return x;
}
List.prototype.push = function(item) {
	var x = [item,this.h];
	this.h = x;
	if(this.q == null) this.q = x;
	this.length++;
}
List.prototype.q = null;
List.prototype.remove = function(v) {
	var prev = null;
	var l = this.h;
	while(l != null) {
		if(l[0] == v) {
			if(prev == null) this.h = l[1];
			else prev[1] = l[1];
			if(this.q == l) this.q = prev;
			this.length--;
			return true;
		}
		prev = l;
		l = l[1];
	}
	return false;
}
List.prototype.toString = function() {
	var s = new StringBuf();
	var first = true;
	var l = this.h;
	s.b[s.b.length] = "{";
	while(l != null) {
		if(first) first = false;
		else s.b[s.b.length] = ", ";
		s.b[s.b.length] = Std.string(l[0]);
		l = l[1];
	}
	s.b[s.b.length] = "}";
	return s.b.join("");
}
List.prototype.__class__ = List;
if(typeof kernel=='undefined') kernel = {}
kernel.CDebug = function() { }
kernel.CDebug.__name__ = ["kernel","CDebug"];
kernel.CDebug.ASSERT = function(_Obj,pos) {
	if(!_Obj) {
		haxe.Log.trace((("Assert in " + pos.className) + "::") + pos.methodName,pos);
	}
}
kernel.CDebug.CONSOLEMSG = function(_Msg,pos) {
	haxe.Log.trace(_Msg,{ fileName : "CDebug.hx", lineNumber : 15, className : "kernel.CDebug", methodName : "CONSOLEMSG"});
}
kernel.CDebug.prototype.__class__ = kernel.CDebug;
renderer.MAT_BLEND_MODE = { __ename__ : ["renderer","MAT_BLEND_MODE"], __constructs__ : ["MBM_ADD","MBM_SUB","MBM_BLEND","MBM_OPAQUE"] }
renderer.MAT_BLEND_MODE.MBM_ADD = ["MBM_ADD",0];
renderer.MAT_BLEND_MODE.MBM_ADD.toString = $estr;
renderer.MAT_BLEND_MODE.MBM_ADD.__enum__ = renderer.MAT_BLEND_MODE;
renderer.MAT_BLEND_MODE.MBM_BLEND = ["MBM_BLEND",2];
renderer.MAT_BLEND_MODE.MBM_BLEND.toString = $estr;
renderer.MAT_BLEND_MODE.MBM_BLEND.__enum__ = renderer.MAT_BLEND_MODE;
renderer.MAT_BLEND_MODE.MBM_OPAQUE = ["MBM_OPAQUE",3];
renderer.MAT_BLEND_MODE.MBM_OPAQUE.toString = $estr;
renderer.MAT_BLEND_MODE.MBM_OPAQUE.__enum__ = renderer.MAT_BLEND_MODE;
renderer.MAT_BLEND_MODE.MBM_SUB = ["MBM_SUB",1];
renderer.MAT_BLEND_MODE.MBM_SUB.toString = $estr;
renderer.MAT_BLEND_MODE.MBM_SUB.__enum__ = renderer.MAT_BLEND_MODE;
if(typeof haxe=='undefined') haxe = {}
haxe.TimerQueue = function(delay) { if( delay === $_ ) return; {
	this.delay = (delay == null?1:delay);
	this.q = new Array();
}}
haxe.TimerQueue.__name__ = ["haxe","TimerQueue"];
haxe.TimerQueue.prototype.add = function(f) {
	this.q.push(f);
	if(this.t == null) {
		this.t = new haxe.Timer(this.delay);
		this.t.run = $closure(this,"process");
	}
}
haxe.TimerQueue.prototype.delay = null;
haxe.TimerQueue.prototype.process = function() {
	var f = this.q.shift();
	if(f == null) {
		this.t.stop();
		this.t = null;
		return;
	}
	f();
}
haxe.TimerQueue.prototype.q = null;
haxe.TimerQueue.prototype.t = null;
haxe.TimerQueue.prototype.__class__ = haxe.TimerQueue;
math.Constants = function() { }
math.Constants.__name__ = ["math","Constants"];
math.Constants.prototype.__class__ = math.Constants;
if(!renderer.camera) renderer.camera = {}
renderer.camera.CCamera = function(p) { if( p === $_ ) return; {
	this.m_Near = 0.0001;
	this.m_Far = 1000.0;
	this.m_Fov = ((3.1415926535897932384626433 * 2.0) / 360.0) * 54.4;
	this.m_AspectRatio = 4.0 / 3.0;
	this.m_Up = new math.CV3D(0,1,0);
	this.m_Pos = new math.CV3D(0,0,5);
	this.m_Dir = new math.CV3D(0,0,-1);
	this.m_VPMatrix = new math.CMatrix44();
}}
renderer.camera.CCamera.__name__ = ["renderer","camera","CCamera"];
renderer.camera.CCamera.prototype.BuildMatrix = function(_Out) {
	return kernel.Result.SUCCESS;
}
renderer.camera.CCamera.prototype.GetFar = function() {
	return this.m_Near;
}
renderer.camera.CCamera.prototype.GetMatrix = function() {
	return this.m_VPMatrix;
}
renderer.camera.CCamera.prototype.GetNear = function() {
	return this.m_Far;
}
renderer.camera.CCamera.prototype.GetPosition = function() {
	return this.m_Pos;
}
renderer.camera.CCamera.prototype.SetFar = function(_Far) {
	this.m_Far = _Far;
}
renderer.camera.CCamera.prototype.SetNear = function(_Near) {
	this.m_Near = _Near;
}
renderer.camera.CCamera.prototype.SetPosition = function(_Pos) {
	this.m_Pos.Copy(_Pos);
}
renderer.camera.CCamera.prototype.SetUp = function(_Up) {
	this.m_Up.Copy(_Up);
}
renderer.camera.CCamera.prototype.Update = function() {
	return this.BuildMatrix(this.m_VPMatrix);
}
renderer.camera.CCamera.prototype.m_AspectRatio = null;
renderer.camera.CCamera.prototype.m_Dir = null;
renderer.camera.CCamera.prototype.m_Far = null;
renderer.camera.CCamera.prototype.m_Fov = null;
renderer.camera.CCamera.prototype.m_Near = null;
renderer.camera.CCamera.prototype.m_Pos = null;
renderer.camera.CCamera.prototype.m_Up = null;
renderer.camera.CCamera.prototype.m_VPMatrix = null;
renderer.camera.CCamera.prototype.__class__ = renderer.camera.CCamera;
renderer.CPrimitive = function(p) { if( p === $_ ) return; {
	rsc.CRsc.apply(this,[]);
}}
renderer.CPrimitive.__name__ = ["renderer","CPrimitive"];
renderer.CPrimitive.__super__ = rsc.CRsc;
for(var k in rsc.CRsc.prototype ) renderer.CPrimitive.prototype[k] = rsc.CRsc.prototype[k];
renderer.CPrimitive.prototype.GetType = function() {
	return renderer.CPrimitive.RSC_ID;
}
renderer.CPrimitive.prototype.SetVertexArray = function(_Vertices) {
	null;
}
renderer.CPrimitive.prototype.__class__ = renderer.CPrimitive;
rsc.CRscBuilder = function(p) { if( p === $_ ) return; {
	null;
}}
rsc.CRscBuilder.__name__ = ["rsc","CRscBuilder"];
rsc.CRscBuilder.prototype.Build = function(_Type,_Path) {
	return null;
}
rsc.CRscBuilder.prototype.__class__ = rsc.CRscBuilder;
if(!driver.js.rscbuilders) driver.js.rscbuilders = {}
driver.js.rscbuilders.CRscJSFactory = function(p) { if( p === $_ ) return; {
	rsc.CRscBuilder.apply(this,[]);
}}
driver.js.rscbuilders.CRscJSFactory.__name__ = ["driver","js","rscbuilders","CRscJSFactory"];
driver.js.rscbuilders.CRscJSFactory.__super__ = rsc.CRscBuilder;
for(var k in rsc.CRscBuilder.prototype ) driver.js.rscbuilders.CRscJSFactory.prototype[k] = rsc.CRscBuilder.prototype[k];
driver.js.rscbuilders.CRscJSFactory.prototype.Build = function(_Type,_Path) {
	var l_Rsc = null;
	switch(_Type) {
	case renderer.CMaterial.RSC_ID:{
		l_Rsc = new driver.js.renderer.CMaterialJS();
	}break;
	case renderer.CTexture.RSC_ID:{
		l_Rsc = new renderer.CTexture();
	}break;
	case renderer.CPrimitive.RSC_ID:{
		l_Rsc = new driver.js.renderer.CPrimitiveJS();
	}break;
	case renderer.CRenderStates.RSC_ID:{
		l_Rsc = new driver.js.renderer.CRenderStatesJS();
	}break;
	case renderer.CViewport.RSC_ID:{
		l_Rsc = new driver.js.renderer.CViewportJS();
	}break;
	default:{
		haxe.Log.trace("*_* CRscJSFactory :: Error: target type not found : " + _Type,{ fileName : "CRscJSFactory.hx", lineNumber : 54, className : "driver.js.rscbuilders.CRscJSFactory", methodName : "Build"});
		l_Rsc = null;
	}break;
	}
	return l_Rsc;
}
driver.js.rscbuilders.CRscJSFactory.prototype.__class__ = driver.js.rscbuilders.CRscJSFactory;
kernel.CSystem = function(p) { if( p === $_ ) return; {
	this.m_FrameTime = 0;
	this.m_GameTime = 0;
	this.m_FrameDeltaTime = 0;
	this.m_GameDeltaTime = 0;
	this.m_ForceFPS = 0;
	this.m_BeforeDraw = null;
	this.m_AfterDraw = null;
	this.m_BeforeUpdate = null;
	this.m_AfterUpdate = null;
	this.m_RscMan = null;
	this.m_Renderer = null;
	this.m_Display = new kernel.CDisplay();
}}
kernel.CSystem.__name__ = ["kernel","CSystem"];
kernel.CSystem.prototype.GetDeltaTime = function() {
	return this.m_FrameDeltaTime;
}
kernel.CSystem.prototype.GetFrameCount = function() {
	return this.m_FrameCount;
}
kernel.CSystem.prototype.GetFrameTime = function() {
	return this.m_FrameTime;
}
kernel.CSystem.prototype.GetGameDeltaTime = function() {
	return this.m_GameDeltaTime;
}
kernel.CSystem.prototype.GetGameTime = function() {
	return this.m_GameTime;
}
kernel.CSystem.prototype.GetRenderer = function() {
	return this.m_Renderer;
}
kernel.CSystem.prototype.GetRscMan = function() {
	return this.m_RscMan;
}
kernel.CSystem.prototype.Initialize = function() {
	this.m_SysTimer = new haxe.TimerQueue(60);
	this.m_RscMan = new rsc.CRscMan();
	this.m_RscMan.Initialize();
	return kernel.Result.SUCCESS;
}
kernel.CSystem.prototype.MainLoop = function() {
	this.m_SysTimer.add($closure(kernel.Glb,"StaticUpdate"));
}
kernel.CSystem.prototype.Update = function() {
	this.m_FrameCount++;
	{
		this.m_FrameDeltaTime = (1.0 / 60);
		this.m_FrameTime += this.m_FrameDeltaTime;
		if(this.m_ForceFPS != 0) {
			this.m_FrameDeltaTime = 1.0 / this.m_ForceFPS;
		}
		if(this.m_IsPaused) {
			this.m_GameDeltaTime = this.m_FrameDeltaTime;
		}
		else {
			this.m_GameDeltaTime = 0;
		}
		this.m_GameTime += this.m_GameDeltaTime;
		if(this.m_BeforeUpdate != null) {
			this.m_BeforeUpdate();
		}
		if(this.m_AfterUpdate != null) {
			this.m_AfterUpdate();
		}
		if(this.m_BeforeDraw != null) {
			this.m_BeforeDraw();
		}
		this.m_Renderer.Update();
		if(this.m_AfterDraw != null) {
			this.m_AfterDraw();
		}
	}
	this.m_SysTimer.add($closure(kernel.Glb,"StaticUpdate"));
}
kernel.CSystem.prototype.m_AfterDraw = null;
kernel.CSystem.prototype.m_AfterUpdate = null;
kernel.CSystem.prototype.m_BeforeDraw = null;
kernel.CSystem.prototype.m_BeforeUpdate = null;
kernel.CSystem.prototype.m_Display = null;
kernel.CSystem.prototype.m_ForceFPS = null;
kernel.CSystem.prototype.m_FrameCount = null;
kernel.CSystem.prototype.m_FrameDeltaTime = null;
kernel.CSystem.prototype.m_FrameTime = null;
kernel.CSystem.prototype.m_GameDeltaTime = null;
kernel.CSystem.prototype.m_GameTime = null;
kernel.CSystem.prototype.m_IsPaused = null;
kernel.CSystem.prototype.m_Renderer = null;
kernel.CSystem.prototype.m_RscMan = null;
kernel.CSystem.prototype.m_SysTimer = null;
kernel.CSystem.prototype.__class__ = kernel.CSystem;
if(!driver.js.kernel) driver.js.kernel = {}
driver.js.kernel.CSystemJS = function(p) { if( p === $_ ) return; {
	kernel.CSystem.apply(this,[]);
	this.m_GlObject = null;
	this.m_RscJSFactory = null;
}}
driver.js.kernel.CSystemJS.__name__ = ["driver","js","kernel","CSystemJS"];
driver.js.kernel.CSystemJS.__super__ = kernel.CSystem;
for(var k in kernel.CSystem.prototype ) driver.js.kernel.CSystemJS.prototype[k] = kernel.CSystem.prototype[k];
driver.js.kernel.CSystemJS.prototype.GetGL = function() {
	return this.m_GlObject;
}
driver.js.kernel.CSystemJS.prototype.Initialize = function() {
	kernel.CSystem.prototype.Initialize.apply(this,[]);
	this.m_Renderer = new driver.js.renderer.CRendererJS();
	this.m_Renderer.Initialize();
	this.InitializeGL();
	this.m_RscJSFactory = new driver.js.rscbuilders.CRscJSFactory();
	this.InitializeRscBuilders();
	return kernel.Result.SUCCESS;
}
driver.js.kernel.CSystemJS.prototype.InitializeGL = function() {
	haxe.Log.trace("CSystemJS::Getting GL context",{ fileName : "CSystemJS.hx", lineNumber : 57, className : "driver.js.kernel.CSystemJS", methodName : "InitializeGL"});
	this.m_GlObject = new CGL("FinalRenderTarget");
	if(this.m_GlObject != null) {
		haxe.Log.trace("JS object created",{ fileName : "CSystemJS.hx", lineNumber : 61, className : "driver.js.kernel.CSystemJS", methodName : "InitializeGL"});
	}
	else {
		haxe.Log.trace("JS object creation failure",{ fileName : "CSystemJS.hx", lineNumber : 65, className : "driver.js.kernel.CSystemJS", methodName : "InitializeGL"});
	}
	haxe.Log.trace("Hello World !",{ fileName : "CSystemJS.hx", lineNumber : 68, className : "driver.js.kernel.CSystemJS", methodName : "InitializeGL"});
	kernel.CDebug.ASSERT(this.m_Display != null,{ fileName : "CSystemJS.hx", lineNumber : 70, className : "driver.js.kernel.CSystemJS", methodName : "InitializeGL"});
	this.m_Display.m_Width = kernel.Glb.g_SystemJS.m_GlObject.GetViewportWidth();
	this.m_Display.m_Height = kernel.Glb.g_SystemJS.m_GlObject.GetViewportHeight();
	return kernel.Result.SUCCESS;
}
driver.js.kernel.CSystemJS.prototype.InitializeRscBuilders = function() {
	kernel.CDebug.CONSOLEMSG("Builders created",{ fileName : "CSystemJS.hx", lineNumber : 108, className : "driver.js.kernel.CSystemJS", methodName : "InitializeRscBuilders"});
	this.GetRscMan().AddBuilder(driver.js.rsc.CRscVertexShader.RSC_ID,new driver.js.rscbuilders.CRscBuilderDocElem());
	this.GetRscMan().AddBuilder(driver.js.rsc.CRscShaderProgram.RSC_ID,new driver.js.rscbuilders.CRscBuilderDocElem());
	this.GetRscMan().AddBuilder(driver.js.rsc.CRscFragmentShader.RSC_ID,new driver.js.rscbuilders.CRscBuilderDocElem());
	this.GetRscMan().AddBuilder(renderer.CMaterial.RSC_ID,this.m_RscJSFactory);
	this.GetRscMan().AddBuilder(renderer.CTexture.RSC_ID,this.m_RscJSFactory);
	this.GetRscMan().AddBuilder(renderer.CViewport.RSC_ID,this.m_RscJSFactory);
	this.GetRscMan().AddBuilder(renderer.CRenderStates.RSC_ID,this.m_RscJSFactory);
	this.GetRscMan().AddBuilder(renderer.CPrimitive.RSC_ID,this.m_RscJSFactory);
	return kernel.Result.SUCCESS;
}
driver.js.kernel.CSystemJS.prototype.Inspect = function() {
	var l_Exts = this.m_GlObject.GetSupportedExtensions();
	if(l_Exts != null) {
		{
			var _g = 0;
			while(_g < l_Exts.length) {
				var l_Ext = l_Exts[_g];
				++_g;
				haxe.Log.trace("Found Ext : " + l_Ext,{ fileName : "CSystemJS.hx", lineNumber : 89, className : "driver.js.kernel.CSystemJS", methodName : "Inspect"});
			}
		}
		if(l_Exts.length == 0) {
			haxe.Log.trace("CSystemJS : found no exts! ",{ fileName : "CSystemJS.hx", lineNumber : 94, className : "driver.js.kernel.CSystemJS", methodName : "Inspect"});
		}
	}
	else {
		haxe.Log.trace("CSystemJS : no exts! ",{ fileName : "CSystemJS.hx", lineNumber : 99, className : "driver.js.kernel.CSystemJS", methodName : "Inspect"});
	}
	return kernel.Result.SUCCESS;
}
driver.js.kernel.CSystemJS.prototype.m_GlObject = null;
driver.js.kernel.CSystemJS.prototype.m_RscJSFactory = null;
driver.js.kernel.CSystemJS.prototype.__class__ = driver.js.kernel.CSystemJS;
renderer.CRscShader = function(p) { if( p === $_ ) return; {
	rsc.CRsc.apply(this,[]);
}}
renderer.CRscShader.__name__ = ["renderer","CRscShader"];
renderer.CRscShader.__super__ = rsc.CRsc;
for(var k in rsc.CRsc.prototype ) renderer.CRscShader.prototype[k] = rsc.CRsc.prototype[k];
renderer.CRscShader.prototype.Activate = function() {
	if(this.m_Status == 0) {
		if(this.Compile() == kernel.Result.FAILURE) {
			return kernel.Result.FAILURE;
		}
		if(this.Link() == kernel.Result.FAILURE) {
			return kernel.Result.FAILURE;
		}
	}
	return kernel.Result.SUCCESS;
}
renderer.CRscShader.prototype.Compile = function() {
	return kernel.Result.SUCCESS;
}
renderer.CRscShader.prototype.Link = function() {
	return kernel.Result.SUCCESS;
}
renderer.CRscShader.prototype.m_Status = null;
renderer.CRscShader.prototype.__class__ = renderer.CRscShader;
kernel.Glb = function() { }
kernel.Glb.__name__ = ["kernel","Glb"];
kernel.Glb.GetRenderer = function() {
	return kernel.Glb.g_System.m_Renderer;
}
kernel.Glb.GetSystem = function() {
	return kernel.Glb.g_System;
}
kernel.Glb.StaticUpdate = function() {
	kernel.Glb.g_System.Update();
}
kernel.Glb.prototype.__class__ = kernel.Glb;
renderer.Z_EQUATION = { __ename__ : ["renderer","Z_EQUATION"], __constructs__ : ["Z_LESSER","Z_LESSER_EQ","Z_GREATER","Z_GREATER_EQ"] }
renderer.Z_EQUATION.Z_GREATER = ["Z_GREATER",2];
renderer.Z_EQUATION.Z_GREATER.toString = $estr;
renderer.Z_EQUATION.Z_GREATER.__enum__ = renderer.Z_EQUATION;
renderer.Z_EQUATION.Z_GREATER_EQ = ["Z_GREATER_EQ",3];
renderer.Z_EQUATION.Z_GREATER_EQ.toString = $estr;
renderer.Z_EQUATION.Z_GREATER_EQ.__enum__ = renderer.Z_EQUATION;
renderer.Z_EQUATION.Z_LESSER = ["Z_LESSER",0];
renderer.Z_EQUATION.Z_LESSER.toString = $estr;
renderer.Z_EQUATION.Z_LESSER.__enum__ = renderer.Z_EQUATION;
renderer.Z_EQUATION.Z_LESSER_EQ = ["Z_LESSER_EQ",1];
renderer.Z_EQUATION.Z_LESSER_EQ.toString = $estr;
renderer.Z_EQUATION.Z_LESSER_EQ.__enum__ = renderer.Z_EQUATION;
renderer.CRenderStates = function(p) { if( p === $_ ) return; {
	rsc.CRsc.apply(this,[]);
	this.m_ZRead = true;
	this.m_ZWrite = true;
	this.m_ZEq = renderer.Z_EQUATION.Z_GREATER_EQ;
	this.m_VPMatrix = new math.CMatrix44();
	this.m_VPMatrix.Identity();
}}
renderer.CRenderStates.__name__ = ["renderer","CRenderStates"];
renderer.CRenderStates.__super__ = rsc.CRsc;
for(var k in rsc.CRsc.prototype ) renderer.CRenderStates.prototype[k] = rsc.CRsc.prototype[k];
renderer.CRenderStates.GetType = function() {
	return renderer.CRenderStates.RSC_ID;
}
renderer.CRenderStates.prototype.Activate = function() {
	return kernel.Result.SUCCESS;
}
renderer.CRenderStates.prototype.Copy = function(_Rsc) {
	rsc.CRsc.prototype.Copy.apply(this,[_Rsc]);
	var l_Rs = (function($this) {
		var $r;
		var tmp = _Rsc;
		$r = (Std["is"](tmp,renderer.CRenderStates)?tmp:(function($this) {
			var $r;
			throw "Class cast error";
			return $r;
		}($this)));
		return $r;
	}(this));
	this.m_ZRead = l_Rs.m_ZRead;
	this.m_ZWrite = l_Rs.m_ZWrite;
	this.m_ZEq = l_Rs.m_ZEq;
	this.m_VPMatrix.Copy(l_Rs.m_VPMatrix);
}
renderer.CRenderStates.prototype.Reset = function() {
	this.m_ZRead = true;
	this.m_ZWrite = true;
	this.m_ZEq = renderer.Z_EQUATION.Z_GREATER_EQ;
}
renderer.CRenderStates.prototype.SetCurrentVPMatrix = function(_Mat) {
	this.m_VPMatrix = _Mat;
}
renderer.CRenderStates.prototype.m_VPMatrix = null;
renderer.CRenderStates.prototype.m_ZEq = null;
renderer.CRenderStates.prototype.m_ZRead = null;
renderer.CRenderStates.prototype.m_ZWrite = null;
renderer.CRenderStates.prototype.__class__ = renderer.CRenderStates;
math.CRect2D = function(p) { if( p === $_ ) return; {
	this.m_TL = new math.CV2D(0,0);
	this.m_BR = new math.CV2D(0,0);
}}
math.CRect2D.__name__ = ["math","CRect2D"];
math.CRect2D.prototype.m_BR = null;
math.CRect2D.prototype.m_TL = null;
math.CRect2D.prototype.__class__ = math.CRect2D;
IntIter = function(min,max) { if( min === $_ ) return; {
	this.min = min;
	this.max = max;
}}
IntIter.__name__ = ["IntIter"];
IntIter.prototype.hasNext = function() {
	return this.min < this.max;
}
IntIter.prototype.max = null;
IntIter.prototype.min = null;
IntIter.prototype.next = function() {
	return this.min++;
}
IntIter.prototype.__class__ = IntIter;
renderer.camera.COrthoCamera = function(p) { if( p === $_ ) return; {
	renderer.camera.CCamera.apply(this,[]);
	this.m_Height = 0;
	this.m_Width = 0;
}}
renderer.camera.COrthoCamera.__name__ = ["renderer","camera","COrthoCamera"];
renderer.camera.COrthoCamera.__super__ = renderer.camera.CCamera;
for(var k in renderer.camera.CCamera.prototype ) renderer.camera.COrthoCamera.prototype[k] = renderer.camera.CCamera.prototype[k];
renderer.camera.COrthoCamera.prototype.BuildMatrix = function(_Out) {
	var l_Left = this.m_Pos.x;
	var l_Right = this.m_Pos.x + this.m_Width;
	var l_Bottom = this.m_Pos.y + this.m_Height;
	var l_Top = this.m_Pos.y;
	math.CMatrix44.Ortho(_Out,0,1,0,1,this.m_Near,this.m_Far);
	return kernel.Result.SUCCESS;
}
renderer.camera.COrthoCamera.prototype.SetHeight = function(_H) {
	this.m_Height = _H;
}
renderer.camera.COrthoCamera.prototype.SetWidth = function(_W) {
	this.m_Width = _W;
}
renderer.camera.COrthoCamera.prototype.m_Height = null;
renderer.camera.COrthoCamera.prototype.m_Width = null;
renderer.camera.COrthoCamera.prototype.__class__ = renderer.camera.COrthoCamera;
driver.js.rscbuilders.CRscBuilderDocElem = function(p) { if( p === $_ ) return; {
	rsc.CRscBuilder.apply(this,[]);
}}
driver.js.rscbuilders.CRscBuilderDocElem.__name__ = ["driver","js","rscbuilders","CRscBuilderDocElem"];
driver.js.rscbuilders.CRscBuilderDocElem.__super__ = rsc.CRscBuilder;
for(var k in rsc.CRscBuilder.prototype ) driver.js.rscbuilders.CRscBuilderDocElem.prototype[k] = rsc.CRscBuilder.prototype[k];
driver.js.rscbuilders.CRscBuilderDocElem.prototype.Build = function(_Type,_Path) {
	if(_Type == driver.js.rsc.CRscShaderProgram.RSC_ID) {
		var l_Ret = new driver.js.rsc.CRscShaderProgram();
		l_Ret.Initialize(_Path);
		if(l_Ret == null) {
			kernel.CDebug.CONSOLEMSG("Unable to create shader prgm ",{ fileName : "CRscBuilderDocElem.hx", lineNumber : 35, className : "driver.js.rscbuilders.CRscBuilderDocElem", methodName : "Build"});
		}
		return l_Ret;
	}
	var l_Script = js.Lib.document.getElementById(_Path);
	if(!l_Script) {
		kernel.CDebug.CONSOLEMSG((("*_* Error: script " + _Path) + " not found for type : ") + _Type,{ fileName : "CRscBuilderDocElem.hx", lineNumber : 44, className : "driver.js.rscbuilders.CRscBuilderDocElem", methodName : "Build"});
		return null;
	}
	var l_ScriptType = l_Script.type;
	if(_Type == driver.js.rsc.CRscVertexShader.RSC_ID) {
		var l_Ret = new driver.js.rsc.CRscVertexShader();
		kernel.CDebug.CONSOLEMSG("Initializing vsh :" + _Path,{ fileName : "CRscBuilderDocElem.hx", lineNumber : 53, className : "driver.js.rscbuilders.CRscBuilderDocElem", methodName : "Build"});
		l_Ret.Initialize(l_Script);
		return l_Ret;
	}
	if(_Type == driver.js.rsc.CRscFragmentShader.RSC_ID) {
		var l_Ret = new driver.js.rsc.CRscFragmentShader();
		kernel.CDebug.CONSOLEMSG("Initializing fsh:" + _Path,{ fileName : "CRscBuilderDocElem.hx", lineNumber : 61, className : "driver.js.rscbuilders.CRscBuilderDocElem", methodName : "Build"});
		l_Ret.Initialize(l_Script);
		return l_Ret;
	}
	haxe.Log.trace("*_* Error: target type not found : " + _Type,{ fileName : "CRscBuilderDocElem.hx", lineNumber : 66, className : "driver.js.rscbuilders.CRscBuilderDocElem", methodName : "Build"});
	return null;
}
driver.js.rscbuilders.CRscBuilderDocElem.prototype.m_Path = null;
driver.js.rscbuilders.CRscBuilderDocElem.prototype.__class__ = driver.js.rscbuilders.CRscBuilderDocElem;
renderer.camera.CPerspectiveCamera = function(p) { if( p === $_ ) return; {
	this.m_Projection = new math.CMatrix44();
	this.m_View = new math.CMatrix44();
	renderer.camera.CCamera.apply(this,[]);
}}
renderer.camera.CPerspectiveCamera.__name__ = ["renderer","camera","CPerspectiveCamera"];
renderer.camera.CPerspectiveCamera.__super__ = renderer.camera.CCamera;
for(var k in renderer.camera.CCamera.prototype ) renderer.camera.CPerspectiveCamera.prototype[k] = renderer.camera.CCamera.prototype[k];
renderer.camera.CPerspectiveCamera.prototype.BuildMatrix = function(_Out) {
	math.CV3D.Add(math.Registers.V0,this.m_Pos,this.m_Dir);
	this.m_Projection.Identity();
	this.m_Projection.Perspective(this.m_Fov,this.m_AspectRatio,this.m_Near,this.m_Far);
	this.m_View.Identity();
	this.m_View.LookAt(this.m_Pos.x,this.m_Pos.y,this.m_Pos.z,math.Registers.V0.x,math.Registers.V0.y,math.Registers.V0.z,this.m_Up.x,this.m_Up.y,this.m_Up.z);
	math.CMatrix44.Mult(_Out,this.m_View,this.m_Projection);
	return kernel.Result.SUCCESS;
}
renderer.camera.CPerspectiveCamera.prototype.SetDirection = function(_Dir) {
	this.m_Dir.Copy(_Dir);
}
renderer.camera.CPerspectiveCamera.prototype.SetFov = function(_Fov) {
	this.m_Fov = _Fov;
}
renderer.camera.CPerspectiveCamera.prototype.m_Projection = null;
renderer.camera.CPerspectiveCamera.prototype.m_View = null;
renderer.camera.CPerspectiveCamera.prototype.__class__ = renderer.camera.CPerspectiveCamera;
if(typeof js=='undefined') js = {}
js.Boot = function() { }
js.Boot.__name__ = ["js","Boot"];
js.Boot.__unhtml = function(s) {
	return s.split("&").join("&amp;").split("<").join("&lt;").split(">").join("&gt;");
}
js.Boot.__trace = function(v,i) {
	var msg = (i != null?((i.fileName + ":") + i.lineNumber) + ": ":"");
	msg += js.Boot.__unhtml(js.Boot.__string_rec(v,"")) + "<br/>";
	var d = document.getElementById("haxe:trace");
	if(d == null) alert("No haxe:trace element defined\n" + msg);
	else d.innerHTML += msg;
}
js.Boot.__clear_trace = function() {
	var d = document.getElementById("haxe:trace");
	if(d != null) d.innerHTML = "";
	else null;
}
js.Boot.__closure = function(o,f) {
	var m = o[f];
	if(m == null) return null;
	var f1 = function() {
		return m.apply(o,arguments);
	}
	f1.scope = o;
	f1.method = m;
	return f1;
}
js.Boot.__string_rec = function(o,s) {
	if(o == null) return "null";
	if(s.length >= 5) return "<...>";
	var t = typeof(o);
	if(t == "function" && (o.__name__ != null || o.__ename__ != null)) t = "object";
	switch(t) {
	case "object":{
		if(o instanceof Array) {
			if(o.__enum__ != null) {
				if(o.length == 2) return o[0];
				var str = o[0] + "(";
				s += "\t";
				{
					var _g1 = 2, _g = o.length;
					while(_g1 < _g) {
						var i = _g1++;
						if(i != 2) str += "," + js.Boot.__string_rec(o[i],s);
						else str += js.Boot.__string_rec(o[i],s);
					}
				}
				return str + ")";
			}
			var l = o.length;
			var i;
			var str = "[";
			s += "\t";
			{
				var _g = 0;
				while(_g < l) {
					var i1 = _g++;
					str += ((i1 > 0?",":"")) + js.Boot.__string_rec(o[i1],s);
				}
			}
			str += "]";
			return str;
		}
		var tostr;
		try {
			tostr = o.toString;
		}
		catch( $e0 ) {
			{
				var e = $e0;
				{
					return "???";
				}
			}
		}
		if(tostr != null && tostr != Object.toString) {
			var s2 = o.toString();
			if(s2 != "[object Object]") return s2;
		}
		var k = null;
		var str = "{\n";
		s += "\t";
		var hasp = (o.hasOwnProperty != null);
		for( var k in o ) { ;
		if(hasp && !o.hasOwnProperty(k)) continue;
		if(k == "prototype" || k == "__class__" || k == "__super__" || k == "__interfaces__") continue;
		if(str.length != 2) str += ", \n";
		str += ((s + k) + " : ") + js.Boot.__string_rec(o[k],s);
		}
		s = s.substring(1);
		str += ("\n" + s) + "}";
		return str;
	}break;
	case "function":{
		return "<function>";
	}break;
	case "string":{
		return o;
	}break;
	default:{
		return String(o);
	}break;
	}
}
js.Boot.__interfLoop = function(cc,cl) {
	if(cc == null) return false;
	if(cc == cl) return true;
	var intf = cc.__interfaces__;
	if(intf != null) {
		var _g1 = 0, _g = intf.length;
		while(_g1 < _g) {
			var i = _g1++;
			var i1 = intf[i];
			if(i1 == cl || js.Boot.__interfLoop(i1,cl)) return true;
		}
	}
	return js.Boot.__interfLoop(cc.__super__,cl);
}
js.Boot.__instanceof = function(o,cl) {
	try {
		if(o instanceof cl) {
			if(cl == Array) return (o.__enum__ == null);
			return true;
		}
		if(js.Boot.__interfLoop(o.__class__,cl)) return true;
	}
	catch( $e1 ) {
		{
			var e = $e1;
			{
				if(cl == null) return false;
			}
		}
	}
	switch(cl) {
	case Int:{
		return Math.ceil(o%2147483648.0) === o;
	}break;
	case Float:{
		return typeof(o) == "number";
	}break;
	case Bool:{
		return o === true || o === false;
	}break;
	case String:{
		return typeof(o) == "string";
	}break;
	case Dynamic:{
		return true;
	}break;
	default:{
		if(o == null) return false;
		return o.__enum__ == cl || (cl == Class && o.__name__ != null) || (cl == Enum && o.__ename__ != null);
	}break;
	}
}
js.Boot.__init = function() {
	js.Lib.isIE = (typeof document!='undefined' && document.all != null && typeof window!='undefined' && window.opera == null);
	js.Lib.isOpera = (typeof window!='undefined' && window.opera != null);
	Array.prototype.copy = Array.prototype.slice;
	Array.prototype.insert = function(i,x) {
		this.splice(i,0,x);
	}
	Array.prototype.remove = (Array.prototype.indexOf?function(obj) {
		var idx = this.indexOf(obj);
		if(idx == -1) return false;
		this.splice(idx,1);
		return true;
	}:function(obj) {
		var i = 0;
		var l = this.length;
		while(i < l) {
			if(this[i] == obj) {
				this.splice(i,1);
				return true;
			}
			i++;
		}
		return false;
	});
	Array.prototype.iterator = function() {
		return { cur : 0, arr : this, hasNext : function() {
			return this.cur < this.arr.length;
		}, next : function() {
			return this.arr[this.cur++];
		}}
	}
	var cca = String.prototype.charCodeAt;
	String.prototype.cca = cca;
	String.prototype.charCodeAt = function(i) {
		var x = cca.call(this,i);
		if(isNaN(x)) return null;
		return x;
	}
	var oldsub = String.prototype.substr;
	String.prototype.substr = function(pos,len) {
		if(pos != null && pos != 0 && len != null && len < 0) return "";
		if(len == null) len = this.length;
		if(pos < 0) {
			pos = this.length + pos;
			if(pos < 0) pos = 0;
		}
		else if(len < 0) {
			len = (this.length + len) - pos;
		}
		return oldsub.apply(this,[pos,len]);
	}
	$closure = js.Boot.__closure;
}
js.Boot.prototype.__class__ = js.Boot;
haxe.Timer = function(time_ms) { if( time_ms === $_ ) return; {
	this.id = haxe.Timer.arr.length;
	haxe.Timer.arr[this.id] = this;
	this.timerId = window.setInterval(("haxe.Timer.arr[" + this.id) + "].run();",time_ms);
}}
haxe.Timer.__name__ = ["haxe","Timer"];
haxe.Timer.delay = function(f,time_ms) {
	var t = new haxe.Timer(time_ms);
	t.run = function() {
		t.stop();
		f();
	}
	return t;
}
haxe.Timer.stamp = function() {
	return Date.now().getTime() / 1000;
}
haxe.Timer.prototype.id = null;
haxe.Timer.prototype.run = function() {
	null;
}
haxe.Timer.prototype.stop = function() {
	if(this.id == null) return;
	window.clearInterval(this.timerId);
	haxe.Timer.arr[this.id] = null;
	if(this.id > 100 && this.id == haxe.Timer.arr.length - 1) {
		var p = this.id - 1;
		while(p >= 0 && haxe.Timer.arr[p] == null) p--;
		haxe.Timer.arr = haxe.Timer.arr.slice(0,p + 1);
	}
	this.id = null;
}
haxe.Timer.prototype.timerId = null;
haxe.Timer.prototype.__class__ = haxe.Timer;
IntHash = function(p) { if( p === $_ ) return; {
	this.h = {}
	if(this.h.__proto__ != null) {
		this.h.__proto__ = null;
		delete(this.h.__proto__);
	}
	else null;
}}
IntHash.__name__ = ["IntHash"];
IntHash.prototype.exists = function(key) {
	return this.h[key] != null;
}
IntHash.prototype.get = function(key) {
	return this.h[key];
}
IntHash.prototype.h = null;
IntHash.prototype.iterator = function() {
	return { ref : this.h, it : this.keys(), hasNext : function() {
		return this.it.hasNext();
	}, next : function() {
		var i = this.it.next();
		return this.ref[i];
	}}
}
IntHash.prototype.keys = function() {
	var a = new Array();
	
			for( x in this.h )
				a.push(x);
		;
	return a.iterator();
}
IntHash.prototype.remove = function(key) {
	if(this.h[key] == null) return false;
	delete(this.h[key]);
	return true;
}
IntHash.prototype.set = function(key,value) {
	this.h[key] = value;
}
IntHash.prototype.toString = function() {
	var s = new StringBuf();
	s.b[s.b.length] = "{";
	var it = this.keys();
	{ var $it2 = it;
	while( $it2.hasNext() ) { var i = $it2.next();
	{
		s.b[s.b.length] = i;
		s.b[s.b.length] = " => ";
		s.b[s.b.length] = Std.string(this.get(i));
		if(it.hasNext()) s.b[s.b.length] = ", ";
	}
	}}
	s.b[s.b.length] = "}";
	return s.b.join("");
}
IntHash.prototype.__class__ = IntHash;
kernel.CDisplay = function(p) { if( p === $_ ) return; {
	this.m_Width = 0;
	this.m_Height = 0;
}}
kernel.CDisplay.__name__ = ["kernel","CDisplay"];
kernel.CDisplay.prototype.m_Height = null;
kernel.CDisplay.prototype.m_Width = null;
kernel.CDisplay.prototype.__class__ = kernel.CDisplay;
kernel.Result = { __ename__ : ["kernel","Result"], __constructs__ : ["SUCCESS","FAILURE"] }
kernel.Result.FAILURE = ["FAILURE",1];
kernel.Result.FAILURE.toString = $estr;
kernel.Result.FAILURE.__enum__ = kernel.Result;
kernel.Result.SUCCESS = ["SUCCESS",0];
kernel.Result.SUCCESS.toString = $estr;
kernel.Result.SUCCESS.__enum__ = kernel.Result;
kernel.Delegate = function() { }
kernel.Delegate.__name__ = ["kernel","Delegate"];
kernel.Delegate.prototype.Apply = function() {
	return kernel.Result.SUCCESS;
}
kernel.Delegate.prototype.__class__ = kernel.Delegate;
renderer.CDrawObject = function(p) { if( p === $_ ) return; {
	this.m_VpMask = -2147483648 - 1;
	this.m_Visible = false;
	this.m_Transfo = new math.CMatrix44();
	this.m_Transfo.Identity();
	this.m_Cameras = new Array();
}}
renderer.CDrawObject.__name__ = ["renderer","CDrawObject"];
renderer.CDrawObject.prototype.Activate = function() {
	return kernel.Result.SUCCESS;
}
renderer.CDrawObject.prototype.Draw = function(_Vp) {
	return kernel.Result.SUCCESS;
}
renderer.CDrawObject.prototype.Initialize = function() {
	return kernel.Result.SUCCESS;
}
renderer.CDrawObject.prototype.IsVisible = function() {
	return this.m_Visible;
}
renderer.CDrawObject.prototype.SetCamera = function(_VpIndex,_Cam) {
	if(_VpIndex < 0 || _VpIndex >= renderer.CRenderer.VP_MAX) {
		return kernel.Result.FAILURE;
	}
	this.m_Cameras[_VpIndex] = _Cam;
	return kernel.Result.SUCCESS;
}
renderer.CDrawObject.prototype.SetTransfo = function(_Transfo) {
	this.m_Transfo.Copy(_Transfo);
}
renderer.CDrawObject.prototype.SetVisible = function(_Vis) {
	this.m_Visible = _Vis;
	if(this.m_Visible) {
		kernel.Glb.g_System.m_Renderer.AddToScene(this);
	}
	else {
		kernel.Glb.g_System.m_Renderer.RemoveFromScene(this);
	}
}
renderer.CDrawObject.prototype.Update = function() {
	return kernel.Result.SUCCESS;
}
renderer.CDrawObject.prototype.m_Cameras = null;
renderer.CDrawObject.prototype.m_Transfo = null;
renderer.CDrawObject.prototype.m_Visible = null;
renderer.CDrawObject.prototype.m_VpMask = null;
renderer.CDrawObject.prototype.__class__ = renderer.CDrawObject;
renderer.C2DQuad = function(p) { if( p === $_ ) return; {
	renderer.CDrawObject.apply(this,[]);
	this.m_Rect = new math.CRect2D();
}}
renderer.C2DQuad.__name__ = ["renderer","C2DQuad"];
renderer.C2DQuad.__super__ = renderer.CDrawObject;
for(var k in renderer.CDrawObject.prototype ) renderer.C2DQuad.prototype[k] = renderer.CDrawObject.prototype[k];
renderer.C2DQuad.prototype.MoveTo = function(_Pos) {
	var l_V = new math.CV2D(0,0);
	math.CV2D.Sub(l_V,this.m_Rect.m_BR,this.m_Rect.m_TL);
	{
		l_V.x = 0.5 * l_V.x;
		l_V.y = 0.5 * l_V.y;
	}
	math.CV2D.Sub(this.m_Rect.m_TL,_Pos,l_V);
	math.CV2D.Add(this.m_Rect.m_BR,_Pos,l_V);
}
renderer.C2DQuad.prototype.SetSize = function(_Size) {
	var l_CurrentPos = new math.CV2D(0,0);
	math.CV2D.Add(l_CurrentPos,this.m_Rect.m_TL,this.m_Rect.m_BR);
	{
		l_CurrentPos.x = 0.5 * l_CurrentPos.x;
		l_CurrentPos.y = 0.5 * l_CurrentPos.y;
	}
	var l_halfSize = new math.CV2D(0,0);
	{
		l_halfSize.x = 0.5 * _Size.x;
		l_halfSize.y = 0.5 * _Size.y;
	}
	math.CV2D.Sub(this.m_Rect.m_TL,l_CurrentPos,l_halfSize);
	math.CV2D.Add(this.m_Rect.m_BR,l_CurrentPos,l_halfSize);
}
renderer.C2DQuad.prototype.m_Rect = null;
renderer.C2DQuad.prototype.__class__ = renderer.C2DQuad;
driver.js.renderer.CGLCube = function(p) { if( p === $_ ) return; {
	renderer.CDrawObject.apply(this,[]);
	this.m_MatrixCache = null;
}}
driver.js.renderer.CGLCube.__name__ = ["driver","js","renderer","CGLCube"];
driver.js.renderer.CGLCube.__super__ = renderer.CDrawObject;
for(var k in renderer.CDrawObject.prototype ) driver.js.renderer.CGLCube.prototype[k] = renderer.CDrawObject.prototype[k];
driver.js.renderer.CGLCube.prototype.Draw = function(_Vp) {
	this.m_Matrix = new math.CMatrix44();
	this.m_Matrix.Identity();
	math.CMatrix44.Ortho(this.m_Matrix,0,1,0,1,0.01,100);
	var l_Trans = new math.CMatrix44();
	{
		l_Trans.Zero();
		l_Trans.m_Buffer[0] = 1;
		l_Trans.m_Buffer[5] = 1;
		l_Trans.m_Buffer[10] = 1;
		l_Trans.m_Buffer[15] = 1;
	}
	var l_MVP = new math.CMatrix44();
	{
		l_MVP.Zero();
		l_MVP.m_Buffer[0] = 1;
		l_MVP.m_Buffer[5] = 1;
		l_MVP.m_Buffer[10] = 1;
		l_MVP.m_Buffer[15] = 1;
	}
	math.CMatrix44.Mult(l_MVP,this.m_Matrix,l_Trans);
	var l_Err = kernel.Glb.g_SystemJS.m_GlObject.GetError();
	if(l_Err != 0) {
		kernel.CDebug.CONSOLEMSG("GlError:PreActivate:" + l_Err,{ fileName : "CGLCube.hx", lineNumber : 83, className : "driver.js.renderer.CGLCube", methodName : "Draw"});
	}
	this.m_RS.Activate();
	kernel.Glb.g_SystemJS.m_GlObject.Disable(2884);
	this.m_ShdrPrgm.Activate();
	var l_vertices = [1.0,1.0,5.5,0.0,1.0,5.5,1.0,0.0,5.5,0.0,0.0,5.5];
	this.m_Primitive.SetVertexArray(l_vertices);
	this.m_ShdrPrgm.LinkPrimitive(this.m_Primitive);
	this.m_MatrixCache = new WebGLFloatArray(l_MVP.m_Buffer);
	var l_Err1 = kernel.Glb.g_SystemJS.m_GlObject.GetError();
	if(l_Err1 != 0) {
		kernel.CDebug.CONSOLEMSG("GlError:PreSetUniform:" + l_Err1,{ fileName : "CGLCube.hx", lineNumber : 107, className : "driver.js.renderer.CGLCube", methodName : "Draw"});
	}
	this.m_ShdrPrgm.UniformMatrix4fv("u_MVPMatrix",false,this.m_MatrixCache);
	this.m_Matrix.Trace();
	kernel.Glb.g_SystemJS.m_GlObject.DrawArrays(5,0,4);
	var l_Err2 = kernel.Glb.g_SystemJS.m_GlObject.GetError();
	if(l_Err2 != 0) {
		kernel.CDebug.CONSOLEMSG("GlError:PostDraw:" + l_Err2,{ fileName : "CGLCube.hx", lineNumber : 117, className : "driver.js.renderer.CGLCube", methodName : "Draw"});
	}
	return kernel.Result.SUCCESS;
}
driver.js.renderer.CGLCube.prototype.Initialize = function() {
	var l_RscMan = kernel.Glb.g_System.GetRscMan();
	this.m_RS = (function($this) {
		var $r;
		var tmp = l_RscMan.Create(renderer.CRenderStates.RSC_ID);
		$r = (Std["is"](tmp,driver.js.renderer.CRenderStatesJS)?tmp:(function($this) {
			var $r;
			throw "Class cast error";
			return $r;
		}($this)));
		return $r;
	}(this));
	if(this.m_RS == null) {
		kernel.CDebug.CONSOLEMSG("Unable to createrender states",{ fileName : "CGLCube.hx", lineNumber : 49, className : "driver.js.renderer.CGLCube", methodName : "Initialize"});
	}
	this.m_Primitive = (function($this) {
		var $r;
		var tmp = l_RscMan.Create(renderer.CPrimitive.RSC_ID);
		$r = (Std["is"](tmp,driver.js.renderer.CPrimitiveJS)?tmp:(function($this) {
			var $r;
			throw "Class cast error";
			return $r;
		}($this)));
		return $r;
	}(this));
	if(this.m_Primitive == null) {
		kernel.CDebug.CONSOLEMSG("Unable to create primitive",{ fileName : "CGLCube.hx", lineNumber : 55, className : "driver.js.renderer.CGLCube", methodName : "Initialize"});
	}
	this.m_ShdrPrgm = (function($this) {
		var $r;
		var tmp = l_RscMan.Load(driver.js.rsc.CRscShaderProgram.RSC_ID,"white");
		$r = (Std["is"](tmp,driver.js.rsc.CRscShaderProgram)?tmp:(function($this) {
			var $r;
			throw "Class cast error";
			return $r;
		}($this)));
		return $r;
	}(this));
	this.m_ShdrPrgm.Compile();
	return kernel.Result.SUCCESS;
}
driver.js.renderer.CGLCube.prototype.m_Matrix = null;
driver.js.renderer.CGLCube.prototype.m_MatrixCache = null;
driver.js.renderer.CGLCube.prototype.m_Primitive = null;
driver.js.renderer.CGLCube.prototype.m_RS = null;
driver.js.renderer.CGLCube.prototype.m_ShdrPrgm = null;
driver.js.renderer.CGLCube.prototype.__class__ = driver.js.renderer.CGLCube;
StringBuf = function(p) { if( p === $_ ) return; {
	this.b = new Array();
}}
StringBuf.__name__ = ["StringBuf"];
StringBuf.prototype.add = function(x) {
	this.b[this.b.length] = x;
}
StringBuf.prototype.addChar = function(c) {
	this.b[this.b.length] = String.fromCharCode(c);
}
StringBuf.prototype.addSub = function(s,pos,len) {
	this.b[this.b.length] = s.substr(pos,len);
}
StringBuf.prototype.b = null;
StringBuf.prototype.toString = function() {
	return this.b.join("");
}
StringBuf.prototype.__class__ = StringBuf;
if(!driver.js.rsc) driver.js.rsc = {}
driver.js.rsc.CRscShaderProgram = function(p) { if( p === $_ ) return; {
	renderer.CRscShader.apply(this,[]);
	this.m_AttribsMask = 0;
	this.m_VtxSh = null;
	this.m_FragSh = null;
	this.m_Uniforms = null;
}}
driver.js.rsc.CRscShaderProgram.__name__ = ["driver","js","rsc","CRscShaderProgram"];
driver.js.rsc.CRscShaderProgram.__super__ = renderer.CRscShader;
for(var k in renderer.CRscShader.prototype ) driver.js.rsc.CRscShaderProgram.prototype[k] = renderer.CRscShader.prototype[k];
driver.js.rsc.CRscShaderProgram.prototype.Activate = function() {
	if(renderer.CRscShader.prototype.Activate.apply(this,[]) == kernel.Result.SUCCESS) {
		var l_Gl = kernel.Glb.g_SystemJS.m_GlObject;
		if(l_Gl.GetProgramParameter(this.m_Program,35714) != true) {
			var l_Error = l_Gl.GetProgramInfoLog(this.m_Program);
			if(l_Error != null) {
				kernel.CDebug.CONSOLEMSG("Error in post shader use program: " + l_Error,{ fileName : "CRscShaderProgram.hx", lineNumber : 272, className : "driver.js.rsc.CRscShaderProgram", methodName : "Activate"});
			}
		}
		l_Gl.UseProgram(this.m_Program);
		if(l_Gl.GetProgramParameter(this.m_Program,35714) != true) {
			var l_Error = l_Gl.GetProgramInfoLog(this.m_Program);
			if(l_Error != null) {
				kernel.CDebug.CONSOLEMSG("Error in post shader use program: " + l_Error,{ fileName : "CRscShaderProgram.hx", lineNumber : 284, className : "driver.js.rsc.CRscShaderProgram", methodName : "Activate"});
			}
		}
		var l_GlError = l_Gl.GetError();
		if(l_GlError != 0) {
			kernel.CDebug.CONSOLEMSG("Error in shader program use: " + l_GlError,{ fileName : "CRscShaderProgram.hx", lineNumber : 291, className : "driver.js.rsc.CRscShaderProgram", methodName : "Activate"});
		}
	}
	return kernel.Result.SUCCESS;
}
driver.js.rsc.CRscShaderProgram.prototype.BindAttributes = function() {
	var l_Gl = kernel.Glb.g_SystemJS.m_GlObject;
	if((this.m_AttribsMask & 1) != 0) {
		l_Gl.BindAttribLocation(this.m_Program,0,"_Vertex");
	}
	if((this.m_AttribsMask & 4) != 0) {
		l_Gl.BindAttribLocation(this.m_Program,2,"_Color");
	}
	if((this.m_AttribsMask & 2) != 0) {
		l_Gl.BindAttribLocation(this.m_Program,1,"_Normal");
	}
	if((this.m_AttribsMask & 8) != 0) {
		l_Gl.BindAttribLocation(this.m_Program,3,"_TexCoord");
	}
}
driver.js.rsc.CRscShaderProgram.prototype.Compile = function() {
	if(this.m_VtxSh != null) {
		if(this.m_VtxSh.Compile() == kernel.Result.FAILURE) {
			this.PrintError();
			return kernel.Result.FAILURE;
		}
	}
	else {
		kernel.CDebug.CONSOLEMSG("Can't proceed : Vertex shader is null",{ fileName : "CRscShaderProgram.hx", lineNumber : 362, className : "driver.js.rsc.CRscShaderProgram", methodName : "Compile"});
		return kernel.Result.FAILURE;
	}
	if(this.m_FragSh != null) {
		if(this.m_FragSh.Compile() == kernel.Result.FAILURE) {
			this.PrintError();
			return kernel.Result.FAILURE;
		}
	}
	else {
		kernel.CDebug.CONSOLEMSG("Can't proceed : Fragment shader is null",{ fileName : "CRscShaderProgram.hx", lineNumber : 376, className : "driver.js.rsc.CRscShaderProgram", methodName : "Compile"});
		return kernel.Result.FAILURE;
	}
	this.m_Status = 1;
	return kernel.Result.SUCCESS;
}
driver.js.rsc.CRscShaderProgram.prototype.CreateAttributeMask = function() {
	if(this.m_VtxSh.m_Body.lastIndexOf("_Vertex") != -1) {
		this.m_AttribsMask |= 1;
		kernel.CDebug.CONSOLEMSG("Found Vertex channel.",{ fileName : "CRscShaderProgram.hx", lineNumber : 69, className : "driver.js.rsc.CRscShaderProgram", methodName : "CreateAttributeMask"});
	}
	if(this.m_VtxSh.m_Body.lastIndexOf("_Color") != -1) {
		this.m_AttribsMask |= 4;
		kernel.CDebug.CONSOLEMSG("Found Color channel.",{ fileName : "CRscShaderProgram.hx", lineNumber : 75, className : "driver.js.rsc.CRscShaderProgram", methodName : "CreateAttributeMask"});
	}
	if(this.m_VtxSh.m_Body.lastIndexOf("_Normal") != -1) {
		this.m_AttribsMask |= 2;
		kernel.CDebug.CONSOLEMSG("Found Normal channel.",{ fileName : "CRscShaderProgram.hx", lineNumber : 81, className : "driver.js.rsc.CRscShaderProgram", methodName : "CreateAttributeMask"});
	}
	if(this.m_VtxSh.m_Body.lastIndexOf("_TexCoord") != -1) {
		this.m_AttribsMask |= 8;
		kernel.CDebug.CONSOLEMSG("Found tex coord.",{ fileName : "CRscShaderProgram.hx", lineNumber : 87, className : "driver.js.rsc.CRscShaderProgram", methodName : "CreateAttributeMask"});
	}
}
driver.js.rsc.CRscShaderProgram.prototype.DeclUniform = function(_Name) {
	var l_Loc = kernel.Glb.g_SystemJS.m_GlObject.GetUniformLocation(this.m_Program,_Name);
	if(l_Loc == null) {
		kernel.CDebug.CONSOLEMSG(("Unable to get uniform location: <" + _Name) + ">",{ fileName : "CRscShaderProgram.hx", lineNumber : 216, className : "driver.js.rsc.CRscShaderProgram", methodName : "DeclUniform"});
	}
	this.m_Uniforms.set(_Name,l_Loc);
}
driver.js.rsc.CRscShaderProgram.prototype.Initialize = function(_Path) {
	var l_Gl = kernel.Glb.g_SystemJS.m_GlObject;
	kernel.CDebug.CONSOLEMSG("Creating Shader Program :" + _Path,{ fileName : "CRscShaderProgram.hx", lineNumber : 162, className : "driver.js.rsc.CRscShaderProgram", methodName : "Initialize"});
	this.m_Uniforms = new Hash();
	var l_Rsc = kernel.Glb.g_System.GetRscMan().Load(driver.js.rsc.CRscVertexShader.RSC_ID,_Path + ".vsh");
	if(l_Rsc == null) {
		kernel.CDebug.CONSOLEMSG("Unable to create vsh resource :" + _Path,{ fileName : "CRscShaderProgram.hx", lineNumber : 168, className : "driver.js.rsc.CRscShaderProgram", methodName : "Initialize"});
		return kernel.Result.FAILURE;
	}
	this.m_VtxSh = (function($this) {
		var $r;
		var tmp = l_Rsc;
		$r = (Std["is"](tmp,driver.js.rsc.CRscVertexShader)?tmp:(function($this) {
			var $r;
			throw "Class cast error";
			return $r;
		}($this)));
		return $r;
	}(this));
	l_Rsc = kernel.Glb.g_System.GetRscMan().Load(driver.js.rsc.CRscFragmentShader.RSC_ID,_Path + ".fsh");
	if(l_Rsc == null) {
		kernel.CDebug.CONSOLEMSG("Unable to create fsh resource :" + _Path,{ fileName : "CRscShaderProgram.hx", lineNumber : 177, className : "driver.js.rsc.CRscShaderProgram", methodName : "Initialize"});
		return kernel.Result.FAILURE;
	}
	this.m_FragSh = (function($this) {
		var $r;
		var tmp = l_Rsc;
		$r = (Std["is"](tmp,driver.js.rsc.CRscFragmentShader)?tmp:(function($this) {
			var $r;
			throw "Class cast error";
			return $r;
		}($this)));
		return $r;
	}(this));
	this.m_Program = l_Gl.CreateProgram();
	if(this.m_Program == null) {
		return kernel.Result.FAILURE;
	}
	this.CreateAttributeMask();
	var l_Res = this.Compile();
	if(l_Res == kernel.Result.SUCCESS) {
		l_Res = this.Link();
		if(l_Res == kernel.Result.SUCCESS) {
			kernel.CDebug.CONSOLEMSG("Success linking shader :" + _Path,{ fileName : "CRscShaderProgram.hx", lineNumber : 197, className : "driver.js.rsc.CRscShaderProgram", methodName : "Initialize"});
		}
		else {
			kernel.CDebug.CONSOLEMSG("Unable to link shader :" + _Path,{ fileName : "CRscShaderProgram.hx", lineNumber : 201, className : "driver.js.rsc.CRscShaderProgram", methodName : "Initialize"});
		}
	}
	else {
		kernel.CDebug.CONSOLEMSG("Unable to compile shader :" + _Path,{ fileName : "CRscShaderProgram.hx", lineNumber : 206, className : "driver.js.rsc.CRscShaderProgram", methodName : "Initialize"});
	}
	return ((l_Res == kernel.Result.SUCCESS)?kernel.Result.SUCCESS:kernel.Result.FAILURE);
}
driver.js.rsc.CRscShaderProgram.prototype.Link = function() {
	if(this.m_Status >= 2) {
		return kernel.Result.SUCCESS;
	}
	var l_Gl = kernel.Glb.g_SystemJS.m_GlObject;
	l_Gl.AttachShader(this.m_Program,this.m_VtxSh.m_Object);
	l_Gl.AttachShader(this.m_Program,this.m_FragSh.m_Object);
	this.BindAttributes();
	l_Gl.LinkProgram(this.m_Program);
	kernel.CDebug.ASSERT(l_Gl.GetAttribLocation(this.m_Program,"_Vertex") == 0,{ fileName : "CRscShaderProgram.hx", lineNumber : 335, className : "driver.js.rsc.CRscShaderProgram", methodName : "Link"});
	if(l_Gl.GetProgramParameter(this.m_Program,35714) != true) {
		var l_Error = l_Gl.GetProgramInfoLog(this.m_Program);
		kernel.CDebug.CONSOLEMSG("Error in program linking:" + l_Error,{ fileName : "CRscShaderProgram.hx", lineNumber : 340, className : "driver.js.rsc.CRscShaderProgram", methodName : "Link"});
		return kernel.Result.FAILURE;
	}
	kernel.CDebug.CONSOLEMSG("Shader Linked",{ fileName : "CRscShaderProgram.hx", lineNumber : 344, className : "driver.js.rsc.CRscShaderProgram", methodName : "Link"});
	this.m_Status = 2;
	return kernel.Result.SUCCESS;
}
driver.js.rsc.CRscShaderProgram.prototype.LinkPrimitive = function(_Prim) {
	var l_Gl = kernel.Glb.g_SystemJS.m_GlObject;
	if((this.m_AttribsMask & 1) != 0) {
		l_Gl.EnableVertexAttribArray(0);
		l_Gl.VertexAttribPointer(0,_Prim.GetFloatPerVtx(),5126,false,0,0);
		var l_Err = kernel.Glb.g_SystemJS.m_GlObject.GetError();
		if(l_Err != 0) {
			kernel.CDebug.CONSOLEMSG("GlError:VertexAttribPointer:" + l_Err,{ fileName : "CRscShaderProgram.hx", lineNumber : 128, className : "driver.js.rsc.CRscShaderProgram", methodName : "LinkPrimitive"});
		}
		else {
			kernel.CDebug.CONSOLEMSG("*",{ fileName : "CRscShaderProgram.hx", lineNumber : 132, className : "driver.js.rsc.CRscShaderProgram", methodName : "LinkPrimitive"});
		}
	}
	if((this.m_AttribsMask & 2) != 0) {
		l_Gl.EnableVertexAttribArray(1);
		l_Gl.VertexAttribPointer(1,_Prim.GetFloatPerNormal(),5126,false,0,0);
	}
	if((this.m_AttribsMask & 4) != 0) {
		l_Gl.EnableVertexAttribArray(2);
		l_Gl.VertexAttribPointer(2,_Prim.GetFloatPerColor(),5126,false,0,0);
	}
	if((this.m_AttribsMask & 8) != 0) {
		l_Gl.EnableVertexAttribArray(3);
		l_Gl.VertexAttribPointer(3,_Prim.GetFloatPerTexCoord(),5126,false,0,0);
	}
	return kernel.Result.SUCCESS;
}
driver.js.rsc.CRscShaderProgram.prototype.PrintError = function() {
	var l_Gl = kernel.Glb.g_SystemJS.m_GlObject;
	if(l_Gl.GetProgramParameter(this.m_Program,35713) != true) {
		var l_Error = l_Gl.GetProgramInfoLog(this.m_Program);
		if(l_Error != null) {
			kernel.CDebug.CONSOLEMSG("Error in shader program compiling: " + l_Error,{ fileName : "CRscShaderProgram.hx", lineNumber : 305, className : "driver.js.rsc.CRscShaderProgram", methodName : "PrintError"});
		}
	}
	if(l_Gl.GetProgramParameter(this.m_Program,35714) == 0) {
		var l_Error = l_Gl.GetProgramInfoLog(this.m_Program);
		if(l_Error != null) {
			kernel.CDebug.CONSOLEMSG("Error in shader program linking: " + l_Error,{ fileName : "CRscShaderProgram.hx", lineNumber : 314, className : "driver.js.rsc.CRscShaderProgram", methodName : "PrintError"});
		}
	}
}
driver.js.rsc.CRscShaderProgram.prototype.Uniform1f = function(_Name,_f0) {
	if(!this.m_Uniforms.exists(_Name)) {
		this.DeclUniform(_Name);
	}
	var l_Loc = this.m_Uniforms.get(_Name);
	if(l_Loc != null) {
		kernel.Glb.g_SystemJS.m_GlObject.Uniform1f(l_Loc,_f0);
	}
}
driver.js.rsc.CRscShaderProgram.prototype.UniformMatrix4fv = function(_Name,_Transpose,_m0) {
	if(!this.m_Uniforms.exists(_Name)) {
		this.DeclUniform(_Name);
		kernel.CDebug.CONSOLEMSG("DeclaredUniformMatrix4fv " + _Name,{ fileName : "CRscShaderProgram.hx", lineNumber : 241, className : "driver.js.rsc.CRscShaderProgram", methodName : "UniformMatrix4fv"});
	}
	var l_Loc = this.m_Uniforms.get(_Name);
	if(l_Loc != null) {
		kernel.Glb.g_SystemJS.m_GlObject.UniformMatrix4f(l_Loc,_Transpose,_m0);
	}
	else {
		kernel.CDebug.CONSOLEMSG("UnableToSetUniformMatrix4fv",{ fileName : "CRscShaderProgram.hx", lineNumber : 251, className : "driver.js.rsc.CRscShaderProgram", methodName : "UniformMatrix4fv"});
	}
	var l_Err = kernel.Glb.g_SystemJS.m_GlObject.GetError();
	if(l_Err != 0) {
		kernel.CDebug.CONSOLEMSG("GlError:postSetUniform4fv:" + l_Err,{ fileName : "CRscShaderProgram.hx", lineNumber : 257, className : "driver.js.rsc.CRscShaderProgram", methodName : "UniformMatrix4fv"});
	}
}
driver.js.rsc.CRscShaderProgram.prototype.m_AttribsMask = null;
driver.js.rsc.CRscShaderProgram.prototype.m_FragSh = null;
driver.js.rsc.CRscShaderProgram.prototype.m_Program = null;
driver.js.rsc.CRscShaderProgram.prototype.m_Uniforms = null;
driver.js.rsc.CRscShaderProgram.prototype.m_VtxSh = null;
driver.js.rsc.CRscShaderProgram.prototype.__class__ = driver.js.rsc.CRscShaderProgram;
driver.js.renderer.CViewportJS = function(p) { if( p === $_ ) return; {
	renderer.CViewport.apply(this,[]);
}}
driver.js.renderer.CViewportJS.__name__ = ["driver","js","renderer","CViewportJS"];
driver.js.renderer.CViewportJS.__super__ = renderer.CViewport;
for(var k in renderer.CViewport.prototype ) driver.js.renderer.CViewportJS.prototype[k] = renderer.CViewport.prototype[k];
driver.js.renderer.CViewportJS.prototype.Activate = function() {
	kernel.Glb.g_SystemJS.m_GlObject.Viewport(this.m_x * kernel.Glb.g_System.m_Display.m_Width,this.m_y * kernel.Glb.g_System.m_Display.m_Height,this.m_w * kernel.Glb.g_System.m_Display.m_Width,this.m_h * kernel.Glb.g_System.m_Display.m_Height);
	return kernel.Result.SUCCESS;
}
driver.js.renderer.CViewportJS.prototype.__class__ = driver.js.renderer.CViewportJS;
math.CV2D = function(_x,_y) { if( _x === $_ ) return; {
	this.x = _x;
	this.y = _y;
}}
math.CV2D.__name__ = ["math","CV2D"];
math.CV2D.Add = function(_VOut,_V0,_V1) {
	_VOut.x = _V0.x + _V1.x;
	_VOut.y = _V0.y + _V1.y;
}
math.CV2D.Sub = function(_VOut,_V0,_V1) {
	_VOut.x = _V0.x - _V1.x;
	_VOut.y = _V0.y - _V1.y;
}
math.CV2D.Scale = function(_VOut,_a,_V) {
	_VOut.x = _a * _V.x;
	_VOut.y = _a * _V.y;
}
math.CV2D.prototype.Copy = function(_xy) {
	this.x = _xy.x;
	this.y = _xy.y;
}
math.CV2D.prototype.Set = function(_x,_y) {
	this.x = _x;
	this.y = _y;
}
math.CV2D.prototype.x = null;
math.CV2D.prototype.y = null;
math.CV2D.prototype.__class__ = math.CV2D;
renderer.CRenderer = function(p) { if( p === $_ ) return; {
	this.m_Vps = new Array();
	{
		var _g1 = 0, _g = renderer.CRenderer.VP_MAX;
		while(_g1 < _g) {
			var i = _g1++;
			this.m_Vps[i] = null;
		}
	}
	this.m_Cameras = new Array();
	{
		var _g1 = 0, _g = renderer.CRenderer.VP_MAX;
		while(_g1 < _g) {
			var i = _g1++;
			this.m_Cameras[i] = null;
		}
	}
	this.m_CurrentVPMatrix = null;
}}
renderer.CRenderer.__name__ = ["renderer","CRenderer"];
renderer.CRenderer.prototype.AddToScene = function(_Obj) {
	this.m_Scene.push(_Obj);
}
renderer.CRenderer.prototype.BeginScene = function() {
	{
		var _g = 0, _g1 = this.m_Cameras;
		while(_g < _g1.length) {
			var l_Cams = _g1[_g];
			++_g;
			if(l_Cams != null) {
				l_Cams.Update();
			}
		}
	}
	this.m_BackScene.clear();
	{ var $it3 = this.m_Scene.iterator();
	while( $it3.hasNext() ) { var l_do = $it3.next();
	{
		this.m_BackScene.push(l_do);
	}
	}}
	{ var $it4 = this.m_BackScene.iterator();
	while( $it4.hasNext() ) { var l_do = $it4.next();
	{
		l_do.Update();
	}
	}}
	this.m_Scene.clear();
	this.m_Scene = this.m_BackScene.filter(function(_) {
		return true;
	});
	return kernel.Result.SUCCESS;
}
renderer.CRenderer.prototype.BuildViewport = function() {
	return null;
}
renderer.CRenderer.prototype.EndScene = function() {
	return kernel.Result.SUCCESS;
}
renderer.CRenderer.prototype.GetCamera = function(_CamIndex) {
	return this.m_Cameras[_CamIndex];
}
renderer.CRenderer.prototype.GetViewProjection = function() {
	return this.m_CurrentVPMatrix;
}
renderer.CRenderer.prototype.Initialize = function() {
	this.m_Vps[renderer.CRenderer.VP_FULLSCREEN] = this.BuildViewport();
	this.m_Vps[renderer.CRenderer.VP_FULLSCREEN].Initialize(0,0,1,1);
	this.m_Cameras[renderer.CRenderer.CAM_PERSPECTIVE_0] = new renderer.camera.CPerspectiveCamera();
	this.m_Cameras[renderer.CRenderer.CAM_ORTHO_0] = new renderer.camera.COrthoCamera();
	this.m_Scene = new List();
	this.m_BackScene = new List();
	return kernel.Result.SUCCESS;
}
renderer.CRenderer.prototype.RemoveFromScene = function(_Obj) {
	this.m_Scene.remove(_Obj);
}
renderer.CRenderer.prototype.Render = function(_VpId) {
	return kernel.Result.SUCCESS;
}
renderer.CRenderer.prototype.Update = function() {
	var l_BegRes = this.BeginScene();
	if(l_BegRes == kernel.Result.FAILURE) {
		return kernel.Result.FAILURE;
	}
	{
		var _g1 = 0, _g = this.m_Vps.length;
		while(_g1 < _g) {
			var l_VpId = _g1++;
			if(this.m_Vps[l_VpId] != null) {
				this.m_Vps[l_VpId].Activate();
				var l_RdrRes = this.Render(l_VpId);
				if(l_RdrRes == kernel.Result.FAILURE) {
					return kernel.Result.FAILURE;
				}
			}
		}
	}
	var l_Endres = this.EndScene();
	if(l_Endres == kernel.Result.FAILURE) {
		return kernel.Result.FAILURE;
	}
	return kernel.Result.SUCCESS;
}
renderer.CRenderer.prototype.m_BackScene = null;
renderer.CRenderer.prototype.m_Cameras = null;
renderer.CRenderer.prototype.m_CurrentVPMatrix = null;
renderer.CRenderer.prototype.m_Scene = null;
renderer.CRenderer.prototype.m_Vps = null;
renderer.CRenderer.prototype.__class__ = renderer.CRenderer;
driver.js.renderer.CGlQuad = function(p) { if( p === $_ ) return; {
	renderer.C2DQuad.apply(this,[]);
	this.m_Material = null;
	this.m_ShdrPrgm = null;
}}
driver.js.renderer.CGlQuad.__name__ = ["driver","js","renderer","CGlQuad"];
driver.js.renderer.CGlQuad.__super__ = renderer.C2DQuad;
for(var k in renderer.C2DQuad.prototype ) driver.js.renderer.CGlQuad.prototype[k] = renderer.C2DQuad.prototype[k];
driver.js.renderer.CGlQuad.prototype.Activate = function() {
	var l_MatActivation = this.m_Material.Activate();
	if(l_MatActivation == kernel.Result.FAILURE) {
		kernel.CDebug.CONSOLEMSG("CGLQuad:unable to activate mat",{ fileName : "CGlQuad.hx", lineNumber : 203, className : "driver.js.renderer.CGlQuad", methodName : "Activate"});
		return kernel.Result.FAILURE;
	}
	var l_ShdrActivation = this.m_ShdrPrgm.Activate();
	if(l_ShdrActivation == kernel.Result.FAILURE) {
		kernel.CDebug.CONSOLEMSG("CGLQuad:unable to activate shdr",{ fileName : "CGlQuad.hx", lineNumber : 210, className : "driver.js.renderer.CGlQuad", methodName : "Activate"});
		return kernel.Result.FAILURE;
	}
	var l_PrgmLink = this.m_ShdrPrgm.LinkPrimitive(this.m_Primitive);
	if(l_PrgmLink == kernel.Result.FAILURE) {
		kernel.CDebug.CONSOLEMSG("CGLQuad:unable to link prim",{ fileName : "CGlQuad.hx", lineNumber : 217, className : "driver.js.renderer.CGlQuad", methodName : "Activate"});
		return kernel.Result.FAILURE;
	}
	var l_RsActivate = this.m_RenderStates.Activate();
	if(l_RsActivate == kernel.Result.FAILURE) {
		kernel.CDebug.CONSOLEMSG("CGLQuad:unable to activate rs",{ fileName : "CGlQuad.hx", lineNumber : 224, className : "driver.js.renderer.CGlQuad", methodName : "Activate"});
		return kernel.Result.FAILURE;
	}
	return kernel.Result.SUCCESS;
}
driver.js.renderer.CGlQuad.prototype.CreateData = function() {
	var l_Array = new Array();
	var l_Z = -10.;
	var l_Scale = 0.5;
	l_Array[0] = 0;
	l_Array[1] = 0;
	l_Array[2] = l_Z;
	l_Array[3] = l_Scale;
	l_Array[4] = 0.0;
	l_Array[5] = l_Z;
	l_Array[6] = 0;
	l_Array[7] = l_Scale;
	l_Array[8] = l_Z;
	this.m_Primitive.SetVertexArray(l_Array);
	var l_IndexArray = new Array();
	l_IndexArray[0] = 0;
	l_IndexArray[1] = 1;
	l_IndexArray[2] = 2;
	this.m_Primitive.SetIndexArray(l_IndexArray);
}
driver.js.renderer.CGlQuad.prototype.Draw = function(_VpId) {
	renderer.C2DQuad.prototype.Draw.apply(this,[_VpId]);
	var l_Vp = kernel.Glb.g_System.m_Renderer.m_Vps[_VpId];
	kernel.CDebug.ASSERT(l_Vp != null,{ fileName : "CGlQuad.hx", lineNumber : 149, className : "driver.js.renderer.CGlQuad", methodName : "Draw"});
	var l_Top = math.Utils.RoundNearest(this.m_Rect.m_TL.y * l_Vp.m_h + l_Vp.m_y);
	var l_Left = math.Utils.RoundNearest((this.m_Rect.m_TL.x * l_Vp.m_VpRatio) * l_Vp.m_w + l_Vp.m_x);
	var l_Bottom = math.Utils.RoundNearest(this.m_Rect.m_BR.y * l_Vp.m_h + l_Vp.m_y);
	var l_Right = math.Utils.RoundNearest((this.m_Rect.m_BR.x * l_Vp.m_VpRatio) * l_Vp.m_w + l_Vp.m_x);
	if(this.Activate() == kernel.Result.FAILURE) {
		kernel.CDebug.CONSOLEMSG("Shader activation failure",{ fileName : "CGlQuad.hx", lineNumber : 158, className : "driver.js.renderer.CGlQuad", methodName : "Draw"});
		return kernel.Result.FAILURE;
	}
	if(this.m_MatrixCache == null) {
		this.m_MatrixCache = new WebGLFloatArray(this.m_Cameras[_VpId].GetMatrix().m_Buffer);
		this.m_Cameras[_VpId].GetMatrix().Trace();
	}
	var l_Err = kernel.Glb.g_SystemJS.m_GlObject.GetError();
	if(l_Err != 0) {
		kernel.CDebug.CONSOLEMSG("GlError:PreSetUniform:" + l_Err,{ fileName : "CGlQuad.hx", lineNumber : 172, className : "driver.js.renderer.CGlQuad", methodName : "Draw"});
	}
	this.m_ShdrPrgm.UniformMatrix4fv("u_MVPMatrix",false,this.m_MatrixCache);
	{
		var l_Err1 = kernel.Glb.g_SystemJS.m_GlObject.GetError();
		if(l_Err1 != 0) {
			kernel.CDebug.CONSOLEMSG("GlError:PreDrawElements:" + l_Err1,{ fileName : "CGlQuad.hx", lineNumber : 183, className : "driver.js.renderer.CGlQuad", methodName : "Draw"});
		}
	}
	kernel.Glb.g_SystemJS.m_GlObject.DrawElements(4,this.m_Primitive.GetNbIndices(),5121,0);
	var l_Err1 = kernel.Glb.g_SystemJS.m_GlObject.GetError();
	if(l_Err1 != 0) {
		kernel.CDebug.CONSOLEMSG("GlError:PostDrawElements:" + l_Err1,{ fileName : "CGlQuad.hx", lineNumber : 192, className : "driver.js.renderer.CGlQuad", methodName : "Draw"});
	}
	return kernel.Result.SUCCESS;
}
driver.js.renderer.CGlQuad.prototype.Initialize = function() {
	var l_RscMan = kernel.Glb.g_System.GetRscMan();
	this.m_ShdrPrgm = (function($this) {
		var $r;
		var tmp = l_RscMan.Load(driver.js.rsc.CRscShaderProgram.RSC_ID,"white");
		$r = (Std["is"](tmp,driver.js.rsc.CRscShaderProgram)?tmp:(function($this) {
			var $r;
			throw "Class cast error";
			return $r;
		}($this)));
		return $r;
	}(this));
	if(this.m_ShdrPrgm != null) {
		kernel.CDebug.CONSOLEMSG("create gl quad shader",{ fileName : "CGlQuad.hx", lineNumber : 61, className : "driver.js.renderer.CGlQuad", methodName : "Initialize"});
	}
	else {
		kernel.CDebug.CONSOLEMSG("unable gl quad shader",{ fileName : "CGlQuad.hx", lineNumber : 65, className : "driver.js.renderer.CGlQuad", methodName : "Initialize"});
	}
	var l_Res = (this.m_ShdrPrgm != null?kernel.Result.SUCCESS:kernel.Result.FAILURE);
	if(l_Res == kernel.Result.SUCCESS) {
		this.m_ShdrPrgm.Compile();
	}
	this.m_Material = (function($this) {
		var $r;
		var tmp = l_RscMan.Create(renderer.CMaterial.RSC_ID);
		$r = (Std["is"](tmp,renderer.CMaterial)?tmp:(function($this) {
			var $r;
			throw "Class cast error";
			return $r;
		}($this)));
		return $r;
	}(this));
	if(this.m_Material != null) {
		this.m_Material.SetShader(this.m_ShdrPrgm);
	}
	else {
		kernel.CDebug.CONSOLEMSG("Unable to create material",{ fileName : "CGlQuad.hx", lineNumber : 82, className : "driver.js.renderer.CGlQuad", methodName : "Initialize"});
	}
	this.m_Primitive = (function($this) {
		var $r;
		var tmp = l_RscMan.Create(renderer.CPrimitive.RSC_ID);
		$r = (Std["is"](tmp,driver.js.renderer.CPrimitiveJS)?tmp:(function($this) {
			var $r;
			throw "Class cast error";
			return $r;
		}($this)));
		return $r;
	}(this));
	if(this.m_Primitive == null) {
		kernel.CDebug.CONSOLEMSG("Unable to create primitive",{ fileName : "CGlQuad.hx", lineNumber : 88, className : "driver.js.renderer.CGlQuad", methodName : "Initialize"});
	}
	this.m_RenderStates = (function($this) {
		var $r;
		var tmp = l_RscMan.Create(renderer.CRenderStates.RSC_ID);
		$r = (Std["is"](tmp,driver.js.renderer.CRenderStatesJS)?tmp:(function($this) {
			var $r;
			throw "Class cast error";
			return $r;
		}($this)));
		return $r;
	}(this));
	if(this.m_RenderStates == null) {
		kernel.CDebug.CONSOLEMSG("Unable to create primitive",{ fileName : "CGlQuad.hx", lineNumber : 94, className : "driver.js.renderer.CGlQuad", methodName : "Initialize"});
	}
	this.CreateData();
	return l_Res;
}
driver.js.renderer.CGlQuad.prototype.Shut = function() {
	this.m_ShdrPrgm.Release();
	this.m_ShdrPrgm = null;
	this.m_Material.Release();
	this.m_Material = null;
	return kernel.Result.SUCCESS;
}
driver.js.renderer.CGlQuad.prototype.Update = function() {
	renderer.C2DQuad.prototype.Update.apply(this,[]);
	return kernel.Result.SUCCESS;
}
driver.js.renderer.CGlQuad.prototype.m_Material = null;
driver.js.renderer.CGlQuad.prototype.m_MatrixCache = null;
driver.js.renderer.CGlQuad.prototype.m_Primitive = null;
driver.js.renderer.CGlQuad.prototype.m_RenderStates = null;
driver.js.renderer.CGlQuad.prototype.m_ShdrPrgm = null;
driver.js.renderer.CGlQuad.prototype.__class__ = driver.js.renderer.CGlQuad;
driver.js.renderer.CRendererJS = function(p) { if( p === $_ ) return; {
	renderer.CRenderer.apply(this,[]);
}}
driver.js.renderer.CRendererJS.__name__ = ["driver","js","renderer","CRendererJS"];
driver.js.renderer.CRendererJS.__super__ = renderer.CRenderer;
for(var k in renderer.CRenderer.prototype ) driver.js.renderer.CRendererJS.prototype[k] = renderer.CRenderer.prototype[k];
driver.js.renderer.CRendererJS.prototype.BeginScene = function() {
	var l_FrameCount = (8 * kernel.Glb.g_System.GetFrameCount()) % 255;
	var l_Err = kernel.Glb.g_SystemJS.m_GlObject.GetError();
	if(l_Err != 0) {
		kernel.CDebug.CONSOLEMSG("GlError:PreClear:" + l_Err,{ fileName : "CRendererJS.hx", lineNumber : 46, className : "driver.js.renderer.CRendererJS", methodName : "BeginScene"});
	}
	kernel.Glb.g_SystemJS.m_GlObject.ClearColor(255.0,0,0,1);
	kernel.Glb.g_SystemJS.m_GlObject.ClearDepth(1000.0);
	kernel.Glb.g_SystemJS.m_GlObject.Clear(17664);
	l_Err = kernel.Glb.g_SystemJS.m_GlObject.GetError();
	if(l_Err != 0) {
		kernel.CDebug.CONSOLEMSG("GlError:PostClear:" + l_Err,{ fileName : "CRendererJS.hx", lineNumber : 59, className : "driver.js.renderer.CRendererJS", methodName : "BeginScene"});
	}
	renderer.CRenderer.prototype.BeginScene.apply(this,[]);
	return kernel.Result.SUCCESS;
}
driver.js.renderer.CRendererJS.prototype.BuildViewport = function() {
	return new driver.js.renderer.CViewportJS();
}
driver.js.renderer.CRendererJS.prototype.EndScene = function() {
	var l_Err = kernel.Glb.g_SystemJS.m_GlObject.GetError();
	if(l_Err != 0) {
		kernel.CDebug.CONSOLEMSG("GlError:PreFlush:" + l_Err,{ fileName : "CRendererJS.hx", lineNumber : 72, className : "driver.js.renderer.CRendererJS", methodName : "EndScene"});
	}
	kernel.Glb.g_SystemJS.m_GlObject.Flush();
	l_Err = kernel.Glb.g_SystemJS.m_GlObject.GetError();
	if(l_Err != 0) {
		kernel.CDebug.CONSOLEMSG("GlError:PostFlush:" + l_Err,{ fileName : "CRendererJS.hx", lineNumber : 80, className : "driver.js.renderer.CRendererJS", methodName : "EndScene"});
	}
	return kernel.Result.SUCCESS;
}
driver.js.renderer.CRendererJS.prototype.Initialize = function() {
	renderer.CRenderer.prototype.Initialize.apply(this,[]);
	haxe.Log.trace("CRendererJS::init",{ fileName : "CRendererJS.hx", lineNumber : 34, className : "driver.js.renderer.CRendererJS", methodName : "Initialize"});
	return kernel.Result.SUCCESS;
}
driver.js.renderer.CRendererJS.prototype.Render = function(_VpId) {
	this.m_NbDrawn = 0;
	{ var $it5 = this.m_Scene.iterator();
	while( $it5.hasNext() ) { var _DOs = $it5.next();
	{
		if(_DOs != null && _DOs.Draw(_VpId) == kernel.Result.SUCCESS) {
			this.m_NbDrawn++;
		}
	}
	}}
	return kernel.Result.SUCCESS;
}
driver.js.renderer.CRendererJS.prototype.m_NbDrawn = null;
driver.js.renderer.CRendererJS.prototype.__class__ = driver.js.renderer.CRendererJS;
haxe.Log = function() { }
haxe.Log.__name__ = ["haxe","Log"];
haxe.Log.trace = function(v,infos) {
	js.Boot.__trace(v,infos);
}
haxe.Log.clear = function() {
	js.Boot.__clear_trace();
}
haxe.Log.prototype.__class__ = haxe.Log;
Hash = function(p) { if( p === $_ ) return; {
	this.h = {}
	if(this.h.__proto__ != null) {
		this.h.__proto__ = null;
		delete(this.h.__proto__);
	}
	else null;
}}
Hash.__name__ = ["Hash"];
Hash.prototype.exists = function(key) {
	try {
		key = "$" + key;
		return this.hasOwnProperty.call(this.h,key);
	}
	catch( $e6 ) {
		{
			var e = $e6;
			{
				
				for(var i in this.h)
					if( i == key ) return true;
			;
				return false;
			}
		}
	}
}
Hash.prototype.get = function(key) {
	return this.h["$" + key];
}
Hash.prototype.h = null;
Hash.prototype.iterator = function() {
	return { ref : this.h, it : this.keys(), hasNext : function() {
		return this.it.hasNext();
	}, next : function() {
		var i = this.it.next();
		return this.ref["$" + i];
	}}
}
Hash.prototype.keys = function() {
	var a = new Array();
	
			for(var i in this.h)
				a.push(i.substr(1));
		;
	return a.iterator();
}
Hash.prototype.remove = function(key) {
	if(!this.exists(key)) return false;
	delete(this.h["$" + key]);
	return true;
}
Hash.prototype.set = function(key,value) {
	this.h["$" + key] = value;
}
Hash.prototype.toString = function() {
	var s = new StringBuf();
	s.b[s.b.length] = "{";
	var it = this.keys();
	{ var $it7 = it;
	while( $it7.hasNext() ) { var i = $it7.next();
	{
		s.b[s.b.length] = i;
		s.b[s.b.length] = " => ";
		s.b[s.b.length] = Std.string(this.get(i));
		if(it.hasNext()) s.b[s.b.length] = ", ";
	}
	}}
	s.b[s.b.length] = "}";
	return s.b.join("");
}
Hash.prototype.__class__ = Hash;
STAGE = { __ename__ : ["STAGE"], __constructs__ : ["STAGE_INIT","STAGE_UPDATE"] }
STAGE.STAGE_INIT = ["STAGE_INIT",0];
STAGE.STAGE_INIT.toString = $estr;
STAGE.STAGE_INIT.__enum__ = STAGE;
STAGE.STAGE_UPDATE = ["STAGE_UPDATE",1];
STAGE.STAGE_UPDATE.toString = $estr;
STAGE.STAGE_UPDATE.__enum__ = STAGE;
CMainClient = function() { }
CMainClient.__name__ = ["CMainClient"];
CMainClient.m_Stage = null;
CMainClient.m_Quad = null;
CMainClient.m_Cube = null;
CMainClient.InitGameJS = function() {
	var l_OrthoCam = (function($this) {
		var $r;
		var tmp = kernel.Glb.g_System.m_Renderer.m_Cameras[renderer.CRenderer.CAM_ORTHO_0];
		$r = (Std["is"](tmp,renderer.camera.COrthoCamera)?tmp:(function($this) {
			var $r;
			throw "Class cast error";
			return $r;
		}($this)));
		return $r;
	}(this));
	var l_CamPos = new math.CV3D(0,0,-1);
	l_OrthoCam.SetPosition(l_CamPos);
	l_OrthoCam.SetWidth(1);
	l_OrthoCam.SetHeight(1);
	l_OrthoCam.m_Near = 0.01;
	l_OrthoCam.m_Far = 1000.0;
	CMainClient.m_Quad = new driver.js.renderer.CGlQuad();
	CMainClient.m_Quad.Initialize();
	CMainClient.m_Quad.m_Rect.m_TL.Copy(new math.CV2D(0,0));
	math.CV2D.Sub(CMainClient.m_Quad.m_Rect.m_TL,CMainClient.m_Quad.m_Rect.m_TL,new math.CV2D(0.5,0.5));
	CMainClient.m_Quad.m_Rect.m_BR.Copy(new math.CV2D(0,0));
	math.CV2D.Add(CMainClient.m_Quad.m_Rect.m_BR,CMainClient.m_Quad.m_Rect.m_BR,new math.CV2D(0.5,0.5));
	CMainClient.m_Quad.SetCamera(renderer.CRenderer.VP_FULLSCREEN,l_OrthoCam);
	CMainClient.m_Quad.SetVisible(false);
	CMainClient.m_Cube = new driver.js.renderer.CGLCube();
	CMainClient.m_Cube.Initialize();
	CMainClient.m_Cube.SetVisible(true);
}
CMainClient.InitGame = function() {
	CMainClient.InitGameJS();
}
CMainClient.UpdateGame = function() {
	null;
}
CMainClient.UpdateCallback = function() {
	var $e = (CMainClient.m_Stage);
	switch( $e[1] ) {
	case 0:
	{
		CMainClient.InitGame();
		CMainClient.m_Stage = STAGE.STAGE_UPDATE;
	}break;
	case 1:
	{
		CMainClient.UpdateGame();
	}break;
	}
	return kernel.Result.SUCCESS;
}
CMainClient.RenderCallback = function() {
	return kernel.Result.SUCCESS;
}
CMainClient.main = function() {
	CMainClient.m_Stage = STAGE.STAGE_INIT;
	if(kernel.Glb.g_System == null) {
		haxe.Log.trace("no g_system",{ fileName : "CMainClient.hx", lineNumber : 113, className : "CMainClient", methodName : "main"});
	}
	else {
		haxe.Log.trace("system init",{ fileName : "CMainClient.hx", lineNumber : 117, className : "CMainClient", methodName : "main"});
		kernel.Glb.g_System.Initialize();
		haxe.Log.trace("main loop",{ fileName : "CMainClient.hx", lineNumber : 119, className : "CMainClient", methodName : "main"});
		kernel.Glb.g_System.MainLoop();
		kernel.Glb.g_System.m_BeforeUpdate = $closure(CMainClient,"UpdateCallback");
		kernel.Glb.g_System.m_BeforeDraw = $closure(CMainClient,"RenderCallback");
	}
}
CMainClient.prototype.__class__ = CMainClient;
Std = function() { }
Std.__name__ = ["Std"];
Std["is"] = function(v,t) {
	return js.Boot.__instanceof(v,t);
}
Std.string = function(s) {
	return js.Boot.__string_rec(s,"");
}
Std["int"] = function(x) {
	if(x < 0) return Math.ceil(x);
	return Math.floor(x);
}
Std.parseInt = function(x) {
	var v = parseInt(x);
	if(Math.isNaN(v)) return null;
	return v;
}
Std.parseFloat = function(x) {
	return parseFloat(x);
}
Std.random = function(x) {
	return Math.floor(Math.random() * x);
}
Std.prototype.__class__ = Std;
math.Utils = function() { }
math.Utils.__name__ = ["math","Utils"];
math.Utils.RoundNearest = function(_F0) {
	if(_F0 < 0) {
		return Std["int"](_F0 - 0.5);
	}
	else {
		return Std["int"](_F0 + 0.5);
	}
}
math.Utils.RoundNearestF = function(_F0) {
	if(_F0 < 0) {
		return Std["int"](_F0 - 0.5);
	}
	else {
		return Std["int"](_F0 + 0.5);
	}
}
math.Utils.prototype.__class__ = math.Utils;
driver.js.rsc.CRscVertexShader = function(p) { if( p === $_ ) return; {
	renderer.CRscShader.apply(this,[]);
	this.m_Object = null;
	this.m_Body = "";
}}
driver.js.rsc.CRscVertexShader.__name__ = ["driver","js","rsc","CRscVertexShader"];
driver.js.rsc.CRscVertexShader.__super__ = renderer.CRscShader;
for(var k in renderer.CRscShader.prototype ) driver.js.rsc.CRscVertexShader.prototype[k] = renderer.CRscShader.prototype[k];
driver.js.rsc.CRscVertexShader.prototype.Compile = function() {
	var l_Gl = kernel.Glb.g_SystemJS.m_GlObject;
	l_Gl.ShaderSource(this.m_Object,this.m_Body);
	l_Gl.CompileShader(this.m_Object);
	if(!l_Gl.GetShaderParameter(this.m_Object,35713)) {
		var l_Error = l_Gl.GetShaderInfoLog(this.m_Object);
		if(l_Error != null) {
			kernel.CDebug.CONSOLEMSG("Error in vertex shader compile: " + l_Error,{ fileName : "CRscVertexShader.hx", lineNumber : 85, className : "driver.js.rsc.CRscVertexShader", methodName : "Compile"});
		}
		else {
			kernel.CDebug.CONSOLEMSG("Unknown error in vertex shader compile ",{ fileName : "CRscVertexShader.hx", lineNumber : 89, className : "driver.js.rsc.CRscVertexShader", methodName : "Compile"});
		}
		return kernel.Result.FAILURE;
	}
	kernel.CDebug.CONSOLEMSG("Success in vertex shader compiling.",{ fileName : "CRscVertexShader.hx", lineNumber : 94, className : "driver.js.rsc.CRscVertexShader", methodName : "Compile"});
	return kernel.Result.SUCCESS;
}
driver.js.rsc.CRscVertexShader.prototype.Initialize = function(_Script) {
	var l_Body = _Script.firstChild;
	var l_Prev = null;
	while(l_Body != null) {
		l_Prev = l_Body;
		l_Body = l_Body.nextSibling;
	}
	this.m_Body = l_Prev.nodeValue;
	haxe.Log.trace("CRVS::ShaderBody " + this.m_Body,{ fileName : "CRscVertexShader.hx", lineNumber : 50, className : "driver.js.rsc.CRscVertexShader", methodName : "Initialize"});
	if(_Script.getAttribute("type") == "x-shader/x-fragment") {
		haxe.Log.trace("Initialize vsh , but received fsh",{ fileName : "CRscVertexShader.hx", lineNumber : 54, className : "driver.js.rsc.CRscVertexShader", methodName : "Initialize"});
		return kernel.Result.FAILURE;
	}
	else if(_Script.getAttribute("type") == "x-shader/x-vertex") {
		this.m_Object = kernel.Glb.g_SystemJS.m_GlObject.CreateShader(35633);
	}
	else {
		haxe.Log.trace("cannot init vsh",{ fileName : "CRscVertexShader.hx", lineNumber : 63, className : "driver.js.rsc.CRscVertexShader", methodName : "Initialize"});
		return kernel.Result.FAILURE;
	}
	haxe.Log.trace("Initialize vsh",{ fileName : "CRscVertexShader.hx", lineNumber : 67, className : "driver.js.rsc.CRscVertexShader", methodName : "Initialize"});
	return kernel.Result.SUCCESS;
}
driver.js.rsc.CRscVertexShader.prototype.m_Body = null;
driver.js.rsc.CRscVertexShader.prototype.m_Object = null;
driver.js.rsc.CRscVertexShader.prototype.__class__ = driver.js.rsc.CRscVertexShader;
driver.js.kernel.CTypesJS = function() { }
driver.js.kernel.CTypesJS.__name__ = ["driver","js","kernel","CTypesJS"];
driver.js.kernel.CTypesJS.prototype.__class__ = driver.js.kernel.CTypesJS;
driver.js.renderer.CRenderStatesJS = function(p) { if( p === $_ ) return; {
	renderer.CRenderStates.apply(this,[]);
	this.m_ZEq = renderer.Z_EQUATION.Z_LESSER_EQ;
	this.m_ZRead = true;
	this.m_ZWrite = false;
}}
driver.js.renderer.CRenderStatesJS.__name__ = ["driver","js","renderer","CRenderStatesJS"];
driver.js.renderer.CRenderStatesJS.__super__ = renderer.CRenderStates;
for(var k in renderer.CRenderStates.prototype ) driver.js.renderer.CRenderStatesJS.prototype[k] = renderer.CRenderStates.prototype[k];
driver.js.renderer.CRenderStatesJS.prototype.Activate = function() {
	var l_GL = kernel.Glb.g_SystemJS.m_GlObject;
	if(this.m_ZRead) {
		l_GL.Enable(2929);
	}
	else {
		l_GL.Disable(2929);
	}
	var $e = (this.m_ZEq);
	switch( $e[1] ) {
	case 0:
	{
		l_GL.DepthFunc(513);
	}break;
	case 1:
	{
		l_GL.DepthFunc(515);
	}break;
	case 2:
	{
		l_GL.DepthFunc(516);
	}break;
	case 3:
	{
		l_GL.DepthFunc(518);
	}break;
	}
	l_GL.DepthMask((this.m_ZWrite?true:false));
	return kernel.Result.SUCCESS;
}
driver.js.renderer.CRenderStatesJS.prototype.__class__ = driver.js.renderer.CRenderStatesJS;
renderer.CTexture = function(p) { if( p === $_ ) return; {
	rsc.CRsc.apply(this,[]);
}}
renderer.CTexture.__name__ = ["renderer","CTexture"];
renderer.CTexture.__super__ = rsc.CRsc;
for(var k in rsc.CRsc.prototype ) renderer.CTexture.prototype[k] = rsc.CRsc.prototype[k];
renderer.CTexture.prototype.Activate = function() {
	return kernel.Result.SUCCESS;
}
renderer.CTexture.prototype.GetType = function() {
	return renderer.CTexture.RSC_ID;
}
renderer.CTexture.prototype.__class__ = renderer.CTexture;
driver.js.renderer.CPrimitiveJS = function(p) { if( p === $_ ) return; {
	renderer.CPrimitive.apply(this,[]);
	this.m_NbIndices = 0;
	this.m_NbVertex = 0;
	this.m_NrmlObject = null;
	this.m_TexObject = null;
	this.m_VtxObject = null;
	this.m_IdxObject = null;
	this.m_NrmlNativeBuf = null;
	this.m_TexNativeBuf = null;
	this.m_VtxNativeBuf = null;
	this.m_IdxNativeBuf = null;
}}
driver.js.renderer.CPrimitiveJS.__name__ = ["driver","js","renderer","CPrimitiveJS"];
driver.js.renderer.CPrimitiveJS.__super__ = renderer.CPrimitive;
for(var k in renderer.CPrimitive.prototype ) driver.js.renderer.CPrimitiveJS.prototype[k] = renderer.CPrimitive.prototype[k];
driver.js.renderer.CPrimitiveJS.prototype.GetFloatPerColor = function() {
	return 4;
}
driver.js.renderer.CPrimitiveJS.prototype.GetFloatPerNormal = function() {
	return 3;
}
driver.js.renderer.CPrimitiveJS.prototype.GetFloatPerTexCoord = function() {
	return 4;
}
driver.js.renderer.CPrimitiveJS.prototype.GetFloatPerVtx = function() {
	return 3;
}
driver.js.renderer.CPrimitiveJS.prototype.GetNbIndices = function() {
	return this.m_NbIndices;
}
driver.js.renderer.CPrimitiveJS.prototype.GetNbTriangles = function() {
	return this.m_NbTriangles;
}
driver.js.renderer.CPrimitiveJS.prototype.GetNbVertices = function() {
	return this.m_NbVertex;
}
driver.js.renderer.CPrimitiveJS.prototype.SetIndexArray = function(_Indexes) {
	if(this.m_IdxObject == null) {
		this.m_IdxObject = kernel.Glb.g_SystemJS.m_GlObject.CreateBuffer();
		kernel.Glb.g_SystemJS.m_GlObject.BindBuffer(34963,this.m_IdxObject);
		kernel.CDebug.CONSOLEMSG("bind index buffer",{ fileName : "CPrimitiveJS.hx", lineNumber : 114, className : "driver.js.renderer.CPrimitiveJS", methodName : "SetIndexArray"});
		var l_Err = kernel.Glb.g_SystemJS.m_GlObject.GetError();
		if(l_Err != 0) {
			kernel.CDebug.CONSOLEMSG("GlError:PostBindIndexArray:" + l_Err,{ fileName : "CPrimitiveJS.hx", lineNumber : 119, className : "driver.js.renderer.CPrimitiveJS", methodName : "SetIndexArray"});
		}
	}
	this.m_NbIndices = _Indexes.length;
	this.m_IdxNativeBuf = new WebGLUnsignedByteArray(_Indexes);
	kernel.Glb.g_SystemJS.m_GlObject.BufferData(34963,this.m_IdxNativeBuf,35048);
	kernel.CDebug.CONSOLEMSG("Set index buffer",{ fileName : "CPrimitiveJS.hx", lineNumber : 128, className : "driver.js.renderer.CPrimitiveJS", methodName : "SetIndexArray"});
	var l_Err = kernel.Glb.g_SystemJS.m_GlObject.GetError();
	if(l_Err != 0) {
		kernel.CDebug.CONSOLEMSG("GlError:PostSetIndexArray:" + l_Err,{ fileName : "CPrimitiveJS.hx", lineNumber : 133, className : "driver.js.renderer.CPrimitiveJS", methodName : "SetIndexArray"});
	}
}
driver.js.renderer.CPrimitiveJS.prototype.SetNormalArray = function(_Normals) {
	if(this.m_NrmlObject == null) {
		this.m_NrmlObject = kernel.Glb.g_SystemJS.m_GlObject.CreateBuffer();
		kernel.Glb.g_SystemJS.m_GlObject.BindBuffer(34962,this.m_NrmlObject);
	}
	this.m_NrmlNativeBuf = new WebGLFloatArray(_Normals);
	kernel.Glb.g_SystemJS.m_GlObject.BufferData(34962,this.m_NrmlNativeBuf,35044);
}
driver.js.renderer.CPrimitiveJS.prototype.SetTexCooArray = function(_Coord) {
	if(this.m_TexObject == null) {
		this.m_TexObject = kernel.Glb.g_SystemJS.m_GlObject.CreateBuffer();
		kernel.Glb.g_SystemJS.m_GlObject.BindBuffer(34962,this.m_TexObject);
	}
	this.m_TexNativeBuf = new WebGLFloatArray(_Coord);
	kernel.Glb.g_SystemJS.m_GlObject.BufferData(34962,this.m_TexNativeBuf,35044);
}
driver.js.renderer.CPrimitiveJS.prototype.SetVertexArray = function(_Vertices) {
	this.m_NbTriangles = Std["int"](_Vertices.length / 9);
	this.m_NbVertex = Std["int"](_Vertices.length / 3);
	if(this.m_VtxObject == null) {
		this.m_VtxObject = kernel.Glb.g_SystemJS.m_GlObject.CreateBuffer();
		kernel.Glb.g_SystemJS.m_GlObject.BindBuffer(34962,this.m_VtxObject);
		kernel.CDebug.CONSOLEMSG("Bound vertex buffer",{ fileName : "CPrimitiveJS.hx", lineNumber : 85, className : "driver.js.renderer.CPrimitiveJS", methodName : "SetVertexArray"});
		var l_Err = kernel.Glb.g_SystemJS.m_GlObject.GetError();
		if(l_Err != 0) {
			kernel.CDebug.CONSOLEMSG("GlError:PostBindVertexArray:" + l_Err,{ fileName : "CPrimitiveJS.hx", lineNumber : 90, className : "driver.js.renderer.CPrimitiveJS", methodName : "SetVertexArray"});
		}
	}
	{
		this.m_VtxNativeBuf = new WebGLFloatArray(_Vertices);
		kernel.Glb.g_SystemJS.m_GlObject.BufferData(34962,this.m_VtxNativeBuf,35048);
		kernel.CDebug.CONSOLEMSG("Set vertex buffer",{ fileName : "CPrimitiveJS.hx", lineNumber : 98, className : "driver.js.renderer.CPrimitiveJS", methodName : "SetVertexArray"});
		var l_Err = kernel.Glb.g_SystemJS.m_GlObject.GetError();
		if(l_Err != 0) {
			kernel.CDebug.CONSOLEMSG("GlError:PostSetVertexArray:" + l_Err,{ fileName : "CPrimitiveJS.hx", lineNumber : 103, className : "driver.js.renderer.CPrimitiveJS", methodName : "SetVertexArray"});
		}
	}
}
driver.js.renderer.CPrimitiveJS.prototype.m_IdxNativeBuf = null;
driver.js.renderer.CPrimitiveJS.prototype.m_IdxObject = null;
driver.js.renderer.CPrimitiveJS.prototype.m_NbIndices = null;
driver.js.renderer.CPrimitiveJS.prototype.m_NbTriangles = null;
driver.js.renderer.CPrimitiveJS.prototype.m_NbVertex = null;
driver.js.renderer.CPrimitiveJS.prototype.m_NrmlNativeBuf = null;
driver.js.renderer.CPrimitiveJS.prototype.m_NrmlObject = null;
driver.js.renderer.CPrimitiveJS.prototype.m_TexNativeBuf = null;
driver.js.renderer.CPrimitiveJS.prototype.m_TexObject = null;
driver.js.renderer.CPrimitiveJS.prototype.m_VtxNativeBuf = null;
driver.js.renderer.CPrimitiveJS.prototype.m_VtxObject = null;
driver.js.renderer.CPrimitiveJS.prototype.__class__ = driver.js.renderer.CPrimitiveJS;
driver.js.rsc.CRscFragmentShader = function(p) { if( p === $_ ) return; {
	renderer.CRscShader.apply(this,[]);
	this.m_Body = "";
	this.m_Object = null;
}}
driver.js.rsc.CRscFragmentShader.__name__ = ["driver","js","rsc","CRscFragmentShader"];
driver.js.rsc.CRscFragmentShader.__super__ = renderer.CRscShader;
for(var k in renderer.CRscShader.prototype ) driver.js.rsc.CRscFragmentShader.prototype[k] = renderer.CRscShader.prototype[k];
driver.js.rsc.CRscFragmentShader.prototype.Compile = function() {
	var l_Gl = kernel.Glb.g_SystemJS.m_GlObject;
	l_Gl.ShaderSource(this.m_Object,this.m_Body);
	l_Gl.CompileShader(this.m_Object);
	if(!l_Gl.GetShaderParameter(this.m_Object,35713)) {
		var l_Error = l_Gl.GetShaderInfoLog(this.m_Object);
		if(l_Error != null) {
			kernel.CDebug.CONSOLEMSG("Error in fragment shader compile: " + l_Error,{ fileName : "CRscFragmentShader.hx", lineNumber : 85, className : "driver.js.rsc.CRscFragmentShader", methodName : "Compile"});
		}
		return kernel.Result.FAILURE;
	}
	kernel.CDebug.CONSOLEMSG("Success in fragment shader compiling.",{ fileName : "CRscFragmentShader.hx", lineNumber : 90, className : "driver.js.rsc.CRscFragmentShader", methodName : "Compile"});
	return kernel.Result.SUCCESS;
}
driver.js.rsc.CRscFragmentShader.prototype.Initialize = function(_Script) {
	var l_Body = _Script.firstChild;
	var l_Prev = null;
	while(l_Body != null) {
		l_Prev = l_Body;
		l_Body = l_Body.nextSibling;
	}
	this.m_Body = l_Prev.nodeValue;
	haxe.Log.trace("CRFS::ShaderBody " + this.m_Body,{ fileName : "CRscFragmentShader.hx", lineNumber : 51, className : "driver.js.rsc.CRscFragmentShader", methodName : "Initialize"});
	if(_Script.getAttribute("type") == "x-shader/x-fragment") {
		this.m_Object = kernel.Glb.g_SystemJS.m_GlObject.CreateShader(35632);
	}
	else if(_Script.getAttribute("type") == "x-shader/x-vertex") {
		haxe.Log.trace("Initializing fsh , but received vsh",{ fileName : "CRscFragmentShader.hx", lineNumber : 59, className : "driver.js.rsc.CRscFragmentShader", methodName : "Initialize"});
		return kernel.Result.FAILURE;
	}
	else {
		haxe.Log.trace("cannot recog Initing vsh",{ fileName : "CRscFragmentShader.hx", lineNumber : 64, className : "driver.js.rsc.CRscFragmentShader", methodName : "Initialize"});
		return kernel.Result.FAILURE;
	}
	kernel.CDebug.CONSOLEMSG("Initialized fsh.",{ fileName : "CRscFragmentShader.hx", lineNumber : 68, className : "driver.js.rsc.CRscFragmentShader", methodName : "Initialize"});
	return kernel.Result.SUCCESS;
}
driver.js.rsc.CRscFragmentShader.prototype.m_Body = null;
driver.js.rsc.CRscFragmentShader.prototype.m_Object = null;
driver.js.rsc.CRscFragmentShader.prototype.__class__ = driver.js.rsc.CRscFragmentShader;
js.Lib = function() { }
js.Lib.__name__ = ["js","Lib"];
js.Lib.isIE = null;
js.Lib.isOpera = null;
js.Lib.document = null;
js.Lib.window = null;
js.Lib.alert = function(v) {
	alert(js.Boot.__string_rec(v,""));
}
js.Lib.eval = function(code) {
	return eval(code);
}
js.Lib.setErrorHandler = function(f) {
	js.Lib.onerror = f;
}
js.Lib.prototype.__class__ = js.Lib;
$Main = function() { }
$Main.__name__ = ["@Main"];
$Main.prototype.__class__ = $Main;
$_ = {}
js.Boot.__res = {}
js.Boot.__init();
{
	Math.NaN = Number["NaN"];
	Math.NEGATIVE_INFINITY = Number["NEGATIVE_INFINITY"];
	Math.POSITIVE_INFINITY = Number["POSITIVE_INFINITY"];
	Math.isFinite = function(i) {
		return isFinite(i);
	}
	Math.isNaN = function(i) {
		return isNaN(i);
	}
	Math.__name__ = ["Math"];
}
{
	String.prototype.__class__ = String;
	String.__name__ = ["String"];
	Array.prototype.__class__ = Array;
	Array.__name__ = ["Array"];
	Int = { __name__ : ["Int"]}
	Dynamic = { __name__ : ["Dynamic"]}
	Float = Number;
	Float.__name__ = ["Float"];
	Bool = { __ename__ : ["Bool"]}
	Class = { __name__ : ["Class"]}
	Enum = { }
	Void = { __ename__ : ["Void"]}
}
{
	js.Lib.document = document;
	js.Lib.window = window;
	onerror = function(msg,url,line) {
		var f = js.Lib.onerror;
		if( f == null )
			return false;
		return f(msg,[url+":"+line]);
	}
}
{
	Date.now = function() {
		return new Date();
	}
	Date.fromTime = function(t) {
		var d = new Date();
		d["setTime"](t);
		return d;
	}
	Date.fromString = function(s) {
		switch(s.length) {
		case 8:{
			var k = s.split(":");
			var d = new Date();
			d["setTime"](0);
			d["setUTCHours"](k[0]);
			d["setUTCMinutes"](k[1]);
			d["setUTCSeconds"](k[2]);
			return d;
		}break;
		case 10:{
			var k = s.split("-");
			return new Date(k[0],k[1] - 1,k[2],0,0,0);
		}break;
		case 19:{
			var k = s.split(" ");
			var y = k[0].split("-");
			var t = k[1].split(":");
			return new Date(y[0],y[1] - 1,y[2],t[0],t[1],t[2]);
		}break;
		default:{
			throw "Invalid date format : " + s;
		}break;
		}
	}
	Date.prototype["toString"] = function() {
		var date = this;
		var m = date.getMonth() + 1;
		var d = date.getDate();
		var h = date.getHours();
		var mi = date.getMinutes();
		var s = date.getSeconds();
		return (((((((((date.getFullYear() + "-") + ((m < 10?"0" + m:"" + m))) + "-") + ((d < 10?"0" + d:"" + d))) + " ") + ((h < 10?"0" + h:"" + h))) + ":") + ((mi < 10?"0" + mi:"" + mi))) + ":") + ((s < 10?"0" + s:"" + s));
	}
	Date.prototype.__class__ = Date;
	Date.__name__ = ["Date"];
}
math.CV3D.ZERO = new math.CV3D(0,0,0);
math.CV3D.ONE = new math.CV3D(1,1,1);
math.CV3D.HALF = new math.CV3D(0.5,0.5,0.5);
math.Registers.V0 = new math.CV3D(0,0,0);
math.Registers.V1 = new math.CV3D(0,0,0);
math.Registers.V2 = new math.CV3D(0,0,0);
math.Registers.V3 = new math.CV3D(0,0,0);
math.Registers.V4 = new math.CV3D(0,0,0);
math.Registers.V5 = new math.CV3D(0,0,0);
math.Registers.V6 = new math.CV3D(0,0,0);
math.Registers.V7 = new math.CV3D(0,0,0);
math.Registers.V8 = new math.CV3D(0,0,0);
math.Registers.V9 = new math.CV3D(0,0,0);
math.Registers.V10 = new math.CV3D(0,0,0);
math.Registers.V11 = new math.CV3D(0,0,0);
math.Registers.M0 = new math.CMatrix44();
math.Registers.M1 = new math.CMatrix44();
math.Registers.M2 = new math.CMatrix44();
math.Registers.M3 = new math.CMatrix44();
math.Registers.M4 = new math.CMatrix44();
math.Registers.M5 = new math.CMatrix44();
math.Registers.M6 = new math.CMatrix44();
math.Registers.M7 = new math.CMatrix44();
rsc.CRscMan.RSC_COUNT = 0;
renderer.CViewport.RSC_ID = rsc.CRscMan.RSC_COUNT++;
renderer.CMaterial.RSC_ID = rsc.CRscMan.RSC_COUNT++;
math.Constants.EPSILON = 1e-6;
math.Constants.PI = 3.1415926535897932384626433;
math.Constants.DEG_TO_RAD = (3.1415926535897932384626433 * 2.0) / 360.0;
math.Constants.RAD_TO_DEG = (360.0 / 3.1415926535897932384626433) * 2.0;
math.Constants.INT_MAX = -2147483648 - 1;
math.Constants.INT_MIN = -(-2147483648 - 1);
renderer.CPrimitive.RSC_ID = rsc.CRscMan.RSC_COUNT++;
kernel.CSystem.FRAMERATE = 60;
kernel.CSystem.DT = 1.0 / 60;
renderer.CRscShader.SHADER_STATUS_NONE = 0;
renderer.CRscShader.SHADER_STATUS_COMPILED = 1;
renderer.CRscShader.SHADER_STATUS_LINKED = 2;
renderer.CRscShader.SHADER_STATUS_READY = 3;
kernel.Glb.g_SystemJS = new driver.js.kernel.CSystemJS();
kernel.Glb.g_System = kernel.Glb.g_SystemJS;
renderer.CRenderStates.RSC_ID = rsc.CRscMan.RSC_COUNT++;
haxe.Timer.arr = new Array();
driver.js.rsc.CRscShaderProgram.RSC_ID = rsc.CRscMan.RSC_COUNT++;
driver.js.rsc.CRscShaderProgram.ATTR_VERTEX_INDEX = 0;
driver.js.rsc.CRscShaderProgram.ATTR_NORMAL_INDEX = 1;
driver.js.rsc.CRscShaderProgram.ATTR_COLOR_INDEX = 2;
driver.js.rsc.CRscShaderProgram.ATTR_TEXCOORD_INDEX = 3;
driver.js.rsc.CRscShaderProgram.ATTR_VERTEX = 1;
driver.js.rsc.CRscShaderProgram.ATTR_NORMAL = 2;
driver.js.rsc.CRscShaderProgram.ATTR_COLOR = 4;
driver.js.rsc.CRscShaderProgram.ATTR_TEXCOORD = 8;
driver.js.rsc.CRscShaderProgram.ATTR_MAX_INDEX = 4;
driver.js.rsc.CRscShaderProgram.ATTR_NAME_COLOR = "_Color";
driver.js.rsc.CRscShaderProgram.ATTR_NAME_VERTEX = "_Vertex";
driver.js.rsc.CRscShaderProgram.ATTR_NAME_NORMAL = "_Normal";
driver.js.rsc.CRscShaderProgram.ATTR_NAME_TEXCOORD = "_TexCoord";
math.CV2D.ZERO = new math.CV2D(0,0);
math.CV2D.ONE = new math.CV2D(1,1);
math.CV2D.HALF = new math.CV2D(0.5,0.5);
renderer.CRenderer.CAM_PERSPECTIVE_0 = 0;
renderer.CRenderer.CAM_ORTHO_0 = 1;
renderer.CRenderer.CAM_COUNT = 2;
renderer.CRenderer.VP_FULLSCREEN = 0;
renderer.CRenderer.VP_MAX = 2;
driver.js.rsc.CRscVertexShader.RSC_ID = rsc.CRscMan.RSC_COUNT++;
renderer.CTexture.RSC_ID = rsc.CRscMan.RSC_COUNT++;
driver.js.rsc.CRscFragmentShader.RSC_ID = rsc.CRscMan.RSC_COUNT++;
js.Lib.onerror = null;
$Main.init = CMainClient.main();
