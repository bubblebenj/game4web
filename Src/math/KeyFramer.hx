/**
 * ...
 * @author de
 */

package math;

interface KeyFramer< KeyType >
{
	private var CKeyContainer<KeyType> m_Data;
	
	//interpolates item in slot i
	public function Interpolate( _i0 : Int, _i1 : Int, _Ratio : Float , );
}