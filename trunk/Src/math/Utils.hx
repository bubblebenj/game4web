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
	
	/* Remove extra digits from a float. Useful for debug */
	public static function CutDigits( _Nb : Float, _NbDigits : Int ) : Float
	{
		_Nb *= Math.pow( 10, _NbDigits);
		_Nb = RoundNearestF( _Nb );
		_Nb /= Math.pow( 10, _NbDigits);
		return _Nb;
	}
	
	
	/* Maximum base 16 */
	public static function IntToStr( _Nb : Int, _Base : Int ) : String
	{	
		if ( _Base > 16 )
		{
			return null;
		}
		else
		{
			var l_Digits	: Array<String> = [ '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F' ];
			var l_StrNb	= "";
			var l_End	: Bool = false;
			
			while( ! l_End )
			{
				if ( _Nb >= _Base )
				{
					l_StrNb = l_Digits[ _Nb % _Base ] + l_StrNb;
					_Nb		= Math.floor( _Nb / _Base );
					
				}
				else
				{
					l_StrNb = l_Digits[_Nb] + l_StrNb;
					l_End	= true;
				}
			}
			return l_StrNb;
		}
	}
	
}