//de & bd

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
	
	public static inline function Add( _VOut : CV2D, _V0 : CV2D, _V1 :  CV2D ) :  CV2D
	{
		_VOut.x = _V0.x + _V1.x;
		_VOut.y = _V0.y + _V1.y;
		return _VOut;
	}
	
	public static inline function Incr( _VInOut : CV2D, _V1 :  CV2D ) :  CV2D
	{
		_VInOut.x += _V1.x;
		_VInOut.y += _V1.y;
		return _VInOut;
	}
	
	public static inline function Decr( _VInOut : CV2D, CV2D, _V1 :  CV2D ) :  CV2D
	{
		_VInOut.x -= _V1.x;
		_VInOut.y -= _V1.y;
		return _VInOut;
	}
	
	//computes _V0 - _V1
	public static inline function Sub( _VOut : CV2D, _V0 : CV2D, _V1 :  CV2D ) :  CV2D
	{
		_VOut.x = _V0.x - _V1.x;
		_VOut.y = _V0.y - _V1.y;
		return _VOut;
	}
	
	public static inline function Scale( _VOut : CV2D, _a : Float, _V : CV2D ) :  CV2D
	{
		_VOut.x = _a * _V.x;
		_VOut.y	= _a * _V.y;
		return _VOut;
	}
	
	public static inline function AreAbsEqual( _V0 : CV2D, _V1 :  CV2D ) : Bool
	{
		return Utils.AbsEq(_V0.x , _V1.x) && Utils.AbsEq(_V0.y , _V1.y);
	}
	
	public static inline function AreRelEqual( _V0 : CV2D, _V1 :  CV2D ) : Bool
	{
		return Utils.RelEq(_V0.x , _V1.x) && Utils.RelEq(_V0.y , _V1.y);
	}
	
	
	public static inline function IsNear( _V0 : CV2D, _V1 :  CV2D , _Mag : Float) : Bool
	{
		return GetDistance2( _V0, _V1) < _Mag * _Mag;
	}

	public static inline function Normalize( _InOut : CV2D ) : CV2D
	{
		var l_InvLen = 1.0 / _InOut.Norm();
		
		_InOut.x *= l_InvLen;
		_InOut.y *= l_InvLen;
		
		return _InOut;
	}
	
	public static inline function SafeNormalize( _InOut : CV2D , _Escape: CV2D ) : CV2D
	{
		var l_Norm :Float = _InOut.Norm();
		if( l_Norm > Constants.EPSILON )
		{
			var l_InvLen = 1.0 / l_Norm;
			
			_InOut.x *= l_InvLen;
			_InOut.y *= l_InvLen;
		}
		else
		{
			_InOut.Copy( _Escape);
		}
		
		return _InOut;
	}
	
	public inline function Norm2() : Float
	{
		return x * x + y * y;
	}
	
	public inline function Norm() : Float
	{
		return Math.sqrt(x * x + y * y);
	}
	
	public static function DotProduct( _V0 : CV2D, _V1 :  CV2D ) : Float
	{
		return	_V0.x * _V1.x
			+	_V0.y * _V1.y;
	}
	
	/*
	 * Test
	 */
	/***/
	public static function NewCopy( _V : CV2D ) : CV2D
	{
		return new CV2D( _V.x, _V.y );
	}
	
	public static function OperatorPlus( _V0 : CV2D, _V1 :  CV2D ) : CV2D
	{
		var l_VOut	: CV2D = new CV2D( 0, 0 );
		l_VOut.x = _V0.x + _V1.x;
		l_VOut.y = _V0.y + _V1.y;
		return l_VOut;
	}
	
	public static function OperatorMinus( _V0 : CV2D, _V1 :  CV2D ) : CV2D
	{
		var l_VOut	: CV2D = new CV2D( 0, 0 );
		l_VOut.x = _V0.x - _V1.x;
		l_VOut.y = _V0.y - _V1.y;
		return l_VOut;
	}
	
	public static function OperatorScale( _a : Float, _V : CV2D ) :  CV2D
	{
		var l_VOut	: CV2D = new CV2D( 0, 0 );
		l_VOut.x 	= _a * _V.x;
		l_VOut.y	= _a * _V.y;
		return l_VOut;
	}
	/*
	 * End Test
	 */
	
	public function toString( ?_NbDigits = 3 ) : String
	{
		return ("[ x="+Utils.CutDigits(x, _NbDigits)+",\t y="+Utils.CutDigits(y, _NbDigits)+" ]");
	}
	
	public static inline function ToStringStatic( _V2D : { x : Float, y : Float } ) : String
	{
		return ("( "+_V2D.x+" , "+_V2D.y+" )");
	}
	
	public static inline function GetDistance2( _V0 : CV2D, _V1 :  CV2D ) : Float
	{
		return ( (_V1.x - _V0.x) * (_V1.x - _V0.x) ) + ( (_V1.y - _V0.y) * (_V1.y - _V0.y) );
	}
	
	public static inline function GetDistance( _V0 : CV2D, _V1 :  CV2D ) : Float
	{
		return Math.sqrt( GetDistance2( _V0 , _V1 ) );
	}
	
	public static var ZERO	(default,never)	: CV2D = new CV2D(0, 0);
	public static var ONE	(default,never)	: CV2D = new CV2D(1, 1);
	public static var HALF	(default,never)	: CV2D = new CV2D(0.5, 0.5);
}
