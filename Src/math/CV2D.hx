package math;
import renderer.CViewport;

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
	
	public static inline function Scale( _VOut : CV2D, _a : Float, _V : CV2D ) :  Void
	{
		_VOut.x = _a * _V.x;
		_VOut.y	= _a * _V.y;
	}
	
	public static inline function AreEqual( _V0 : CV2D, _V1 :  CV2D ) : Bool
	{
		return ( _V0.x != _V1.x || _V0.y != _V1.y ) ? false : true;
	}
	
	public static inline function AreNotEqual( _V0 : CV2D, _V1 :  CV2D ) : Bool
	{
		return ( _V0.x != _V1.x || _V0.y != _V1.y ) ? true : false;
	}
	
	public inline function Norm2()
	{
		return x * x + y * y;
	}
	
	public inline function Norm()
	{
		return Math.sqrt(x * x + y * y);
	}
	
	/*
	 * Test
	 */
	public inline function AnonymCopy( _V2D : { x : Float, y : Float } )
	{
		x = _V2D.x;
		y = _V2D.y;
	}
	
	public static inline function AnonymAdd( _V0 : { x : Float, y : Float }, _V1 : { x : Float, y : Float } ) : { x : Float, y : Float }
	{
		return { x : _V0.x + _V1.x, y : _V0.y + _V1.y };
	}
	
	public static inline function AnonymSub( _V0 : { x : Float, y : Float }, _V1 : { x : Float, y : Float } ) : { x : Float, y : Float }
	{
		return { x : _V0.x - _V1.x, y : _V0.y - _V1.y };
	}
	
	public static inline function AnonymScale( _V : { x : Float, y : Float }, _a : Float ) : { x : Float, y : Float }
	{
		return { x : _a * _V.x, y : _a * _V.y };
	}
	/*
	 * End Test
	 */
	
	public inline function ToString() : String
	{
		return ("[x="+Utils.CutDigits(x, 3)+" , y="+Utils.CutDigits(y, 3)+" ]");
	}
	
	public static inline function ToStringStatic( _V2D : { x : Float, y : Float } ) : String
	{
		return ("( "+_V2D.x+" , "+_V2D.y+" )");
	}
	
	public static inline function GetDistance( _V0 : CV2D, _V1 :  CV2D ) : Float
	{
		return Math.sqrt( Math.pow( (_V1.x - _V0.x), 2 ) + Math.pow( (_V1.y - _V0.y), 2 ) );
	}
	
	public static inline var ZERO 		: CV2D = new CV2D(0, 0);
	public static inline var ONE 		: CV2D = new CV2D(1, 1);
	public static inline var HALF 		: CV2D = new CV2D(0.5, 0.5);
}
