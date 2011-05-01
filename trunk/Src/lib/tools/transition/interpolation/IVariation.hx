/**
 * ...
 * @author Benjamin Dubois
 */

package tools.transition.variation;

interface IVariation	// AS easing function
{
	public function VaryIn(		_CurrentTime : Int, _InitialValue : Float, _FinalValue: Float, _Duration : Int ) : Float {}
	
	public function VaryOut(	_CurrentTime : Int, _InitialValue : Float, _FinalValue: Float, _Duration : Int ) : Float {}
	
	public function VaryInOut(	_CurrentTime : Int, _InitialValue : Float, _FinalValue: Float, _Duration : Int ) : Float {}
}