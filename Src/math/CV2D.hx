package math;

class CV2D
{
	public var x		: Float;
	public var y		: Float;
	
	public function new ( _x , _y )
	{
		x = _x; 
		y = _y;
	}
	
	public function Set( _x , _y ) : Void
	{
		x = _x;
		y = _y;
	}
	
	public inline function Copy( _xy : CV2D ) : Void
	{
		x = _xy.x;
		y = _xy.y;
	}
	
	public static inline function Add( _VOut : CV2D, _V0 : CV2D, _V1 :  CV2D ) :  Void
	{
		_VOut.x = _V0.x + _V1.x;
		_VOut.y = _V0.y + _V1.y;
	}
	
	public static inline function Sub( _VOut : CV2D, _V0 : CV2D, _V1 :  CV2D ) :  Void
	{
		_VOut.x = _V0.x - _V1.x;
		_VOut.y = _V0.y - _V1.y;
	}
	
	public static inline var ZERO 	: CV2D = new CV2D(0, 0);
	public static inline var ONE 	: CV2D = new CV2D(1, 1);
	public static inline var HALF 	: CV2D = new CV2D(0.5, 0.5);
}
