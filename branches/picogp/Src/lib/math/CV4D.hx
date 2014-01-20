/**
 * ...
 * @author de
 */

package math;

class CV4D
{
	public var x		: Float;
	public var y		: Float;
	public var z		: Float;
	public var w		: Float;
	
	public function new ( _x , _y , _z , _w )
	{
		x = _x; 
		y = _y;
		z = _z;
		w = _w;
	}
	
	public function Set( _x , _y , _z , _w) : Void
	{
		x = _x; 
		y = _y;
		z = _z;
		w = _w;
	}
	
	public inline function CopyV2D( _xy : CV2D , _zw : CV2D ) : Void
	{
		x = _xy.x;
		y = _xy.y;
		
		z = _zw.x;
		w = _zw.y;
	}
	
	public function Flatten() : Array<Float>
	{
		var l_Arr = new Array<Float>();
		
		//avoid late alloc
		l_Arr[3] = w;
		l_Arr[2] = z;
		l_Arr[1] = y;
		l_Arr[0] = x;
		
		return l_Arr;
	}
	
	public inline function Copy( _xyzw : CV4D ) : Void
	{
		x = _xyzw.x;
		y = _xyzw.y;
		z = _xyzw.z;
		w = _xyzw.w;
	}
	
	public static inline function Add( _VOut : CV4D, _V0 : CV4D, _V1 :  CV4D ) :  Void
	{
		_VOut.x = _V0.x + _V1.x;
		_VOut.y = _V0.y + _V1.y;
		_VOut.z = _V0.z + _V1.z;
		_VOut.w = _V0.w + _V1.w;
	}
	
	public static inline function Sub( _VOut : CV4D, _V0 : CV4D, _V1 :  CV4D ) :  Void
	{
		_VOut.x = _V0.x - _V1.x;
		_VOut.y = _V0.y - _V1.y;
		_VOut.z = _V0.z - _V1.z;
		_VOut.w = _V0.w - _V1.w;
	}
	
	public static inline function Dot(  _V0 : CV4D, _V1 :  CV4D ) :  Float
	{
		return 	_V0.x * _V1.x
		+ 		_V0.y * _V1.y
		+ 		_V0.z * _V1.z
		+ 		_V0.w * _V1.w;
	}
	
	public static inline function LengthSq( _V0 : CV4D ) :  Float
	{
		return 	Dot(_V0, _V0);
	}
	
	public static inline function Length( _V0 : CV4D ) :  Float
	{
		return 	Math.sqrt( Dot(_V0, _V0) );
	}
	
	public static inline function Scale( _VOut :CV4D, _a : Float, _V : CV4D ) :  Void
	{
		_VOut.x = _a * _V.x;
		_VOut.y	= _a * _V.y;
		_VOut.z	= _a * _V.z;
		_VOut.w	= _a * _V.w;
	}
	
	public inline function Trace() : String
	{
		return ("CV4D( "+x+" , "+y+" , "+z+", "+w+")" );
	}
	
	public static var ZERO	(default, never) : CV4D = new CV4D(0, 0 , 0 ,0);
	public static var ONE	(default, never) : CV4D = new CV4D(1, 1 ,1 ,1);
	public static var HALF	(default, never) : CV4D = new CV4D(0.5, 0.5,0.5,0.5);
}