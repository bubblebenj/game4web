/**
 * ...
 * @author de
 */

package math;

class Utils 
{
	public static function RoundNearest( _F0 : Float ) : Int
	{
		if(_F0<0)
		{
			return Std.int(_F0 - 0.5);
		}
		else
		{
			return Std.int(_F0 + 0.5);
		}
	}
	
	public static function RoundNearestF( _F0 : Float ) : Float
	{
		if(_F0<0)
		{
			return Std.int(_F0 - 0.5);
		}
		else
		{
			return Std.int(_F0 + 0.5);
		}
	}
	
	public static function PosMod( _Dividend : Int, _Divisor : Int ) : Int
	{
		var l_Res	= _Dividend % _Divisor;
		if ( l_Res < 0 ) { l_Res += _Divisor; }
		return l_Res;
	}
	
	public static inline function Clamp( _A : Float, _Min : Float, _Max : Float ) : Float
	{
		//return Math.min( _Max, Math.max( _A, _Min ) );
		if ( _A < _Min )
		{
			return _Min;
		}
		else
		{
			if ( _A > _Max )
			{
				return _Max;
			}
			else
			{
				return _A;
			}
		}
	}
	
	public static inline function Clampi( _A : Int, _Min :  Int, _Max : Int ) :  Int
	{
		//return Math.min( _Max, Math.max( _A, _Min ) );
		if ( _A < _Min )
		{
			return _Min;
		}
		else
		{
			if ( _A > _Max )
			{
				return _Max;
			}
			else
			{
				return _A;
			}
		}
	}
	
	/* Remove extra digits from a float. Useful for debug */
	public static function CutDigits( _Nb : Float, _NbDigits : Int ) : Float
	{
		_Nb *= Math.pow( 10, _NbDigits);
		_Nb = RoundNearestF( _Nb );
		_Nb /= Math.pow( 10, _NbDigits);
		return _Nb;
	}
	
	
	/* Maximum base 16, NbDigits allow to add 0 left to the number to complete to have NbDigits char */
	public static function IntToStr(	_Nb		: Int, ?_Base : Int = 10 ) : String
	{								var	_StrNb	: String;
		if ( _Base > 16 )
		{
			return null;
		}
		else
		{
			_StrNb	= "";
			var l_Digits	: Array<String> = [ '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F' ];
			
			var l_End		: Bool	= false;
			var l_IsNegatif	: Bool	= false; 
			if ( _Nb < 0 )
			{
				l_IsNegatif	= true;
				_Nb	= -_Nb;
			}
			while( ! l_End )
			{
				if ( _Nb >= _Base )
				{
					_StrNb = l_Digits[ _Nb % _Base ] + _StrNb;
					_Nb		= Math.floor( _Nb / _Base );
					
				}
				else
				{
					_StrNb = l_Digits[_Nb] + _StrNb;
					l_End	= true;
				}
			}
			if ( l_IsNegatif )
			{
				_StrNb	= "-" + _StrNb;
			}
			return _StrNb;
		}
	}
	
	// Add extra zero before the string representation of an Int
	public static function FillWithZero(	_StrNb			: String, _MinNbDigits : Int )
	{								var		_ResultStrNb	: String	= "";
		
		var l_MissingZero	: Int		= _MinNbDigits - _StrNb.length;
		
		if ( l_MissingZero > 0 )
		{
			for ( i in 0 ... l_MissingZero )
			{
				_ResultStrNb += "0";
			}
		}
		_ResultStrNb += _StrNb;
		return _ResultStrNb;
	}
	
	public static inline function IsNear( _x : Float ,_y : Float , _Mag : Float) : Bool
	{
		return Math.abs( _x - _y  ) < _Mag;
	}
	
	
	public static inline function AbsEq( _x : Float ,_y : Float ) : Bool
	{
		return Math.abs( _x - _y  ) < Constants.EPSILON;
	}
	
	public static inline function RelEq( _x : Float ,_y  : Float  ) : Bool
	{
		return Math.abs( _x - _y  ) < (Math.max(_x,_y) * Constants.EPSILON);
	}
}