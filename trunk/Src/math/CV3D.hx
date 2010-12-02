package math;

import math.Constants;
import math.Registers;

class CV3D
{
	public var x		: Float;
	public var y		: Float;
	public var z		: Float;
	
	public function new ( _x, _y, _z )
	{
		x = _x; 
		y = _y;
		z = _z;
	}
	
	public function Set( _x , _y, _z ) : Void
	{
		x = _x;
		y = _y;
		z = _z;
	}
	
	public inline function Copy( _V  : CV3D ) : Void
	{
		x = _V .x;
		y = _V .y;
		z = _V .z;
	}

	
	public static inline function Add( _VOut : CV3D, _V0 : CV3D, _V1 :  CV3D ) :  Void
	{
		_VOut.x = _V0.x + _V1.x;
		_VOut.y = _V0.y + _V1.y;
		_VOut.z = _V0.z + _V1.z;
	}
	
	public static inline function Sub( _VOut : CV3D, _V0 : CV3D, _V1 :  CV3D ) :  Void
	{
		_VOut.x = _V0.x - _V1.x;
		_VOut.y = _V0.y - _V1.y;
		_VOut.z = _V0.z - _V1.z;
	}
	
	public static inline function Scale( _VOut : CV3D, _a : Float, _V : CV3D ) :  Void
	{
		_VOut.x = _a * _V.x;
		_VOut.y	= _a * _V.y;
		_VOut.z	= _a * _V.z;
	}
	
	public static inline function Normalize( _InOut : CV3D )
	{
		var l_InvLen = 1.0 / _InOut.Norm();
		
		_InOut.x *= l_InvLen;
		_InOut.y *= l_InvLen;
		_InOut.z *= l_InvLen;
	}
	
	public inline function Norm2()
	{
		return x * x + y * y + z * z;
	}
	
	public inline function Norm()
	{
		return Math.sqrt(x * x + y * y + z * z);
	}
	
	
	public static inline var ZERO 	: CV3D = new CV3D(0, 0, 0);
	public static inline var ONE 	: CV3D = new CV3D(1, 1, 1);
	public static inline var HALF 	: CV3D = new CV3D(0.5, 0.5, 0.5);
}
