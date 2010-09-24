/**
 * ...
 * @author Benjamin Dubois
 */

package tools.transition.interpolation;

import math.CV2D;
import math.Registers;

class CLinear
{
	// FLOAT
	public static function Float_VaryIn( _CurrentTime : Float, _InitialValue : Float, _FinalValue: Float, _Duration : Float ) : Float
	{
		return ( _CurrentTime / _Duration ) * ( _FinalValue - _InitialValue ) + _InitialValue;
	}
	
	public static function Float_VaryOut( _CurrentTime : Float, _InitialValue : Float, _FinalValue: Float, _Duration : Float ) : Float
	{
		return ( _CurrentTime / _Duration ) * ( _FinalValue - _InitialValue ) + _InitialValue;
	}
	
	public static function Float_VaryInOut( _CurrentTime : Float, _InitialValue : Float, _FinalValue: Float, _Duration : Float ) : Float
	{
		return ( _CurrentTime / _Duration ) * ( _FinalValue - _InitialValue ) + _InitialValue;
	}
	
	// CV2D
	public static function CV2D_VaryIn( _CurrentTime : Float, _InitialValue : CV2D, _FinalValue: CV2D, _Duration : Float ) : CV2D
	{
		Registers.V2_8.x = ( _CurrentTime / _Duration ) * ( _FinalValue.x - _InitialValue.x ) + _InitialValue.x;
		Registers.V2_8.y = ( _CurrentTime / _Duration ) * ( _FinalValue.y - _InitialValue.y ) + _InitialValue.y;
		trace( Registers.V2_8.ToString() );
		return Registers.V2_8;
	}
	
	public static function CV2D_VaryOut( _CurrentTime : Float, _InitialValue : CV2D, _FinalValue: CV2D, _Duration : Float ) : CV2D
	{
		Registers.V2_8.x = ( _CurrentTime / _Duration ) * ( _FinalValue.x - _InitialValue.x ) + _InitialValue.x;
		Registers.V2_8.y = ( _CurrentTime / _Duration ) * ( _FinalValue.y - _InitialValue.y ) + _InitialValue.y;
		return Registers.V2_8;
	}
	
	public static function CV2D_VaryInOut( _CurrentTime : Float, _InitialValue : CV2D, _FinalValue: CV2D, _Duration : Float ) : CV2D
	{
		Registers.V2_8.x = ( _CurrentTime / _Duration ) * ( _FinalValue.x - _InitialValue.x ) + _InitialValue.x;
		Registers.V2_8.y = ( _CurrentTime / _Duration ) * ( _FinalValue.y - _InitialValue.y ) + _InitialValue.y;
		return Registers.V2_8;
	}
}