package renderer;

import kernel.CTypes;
/**
 * ...
 * @author bdubois
 */

interface I2DContainer 
{
	private var m_2DObjects	: Array<C2DQuad>;
	
	public function GetElements()	: Array<C2DQuad>	{}
	
	public function AddElement( _Object : C2DQuad )		: Result	{}
	
	public function GetChildIndex( _Object : C2DQuad )	: Int	{}
	
	/* Debug function */
	public function ShowTree( ? _Depth : Int ) : Void	{}
}