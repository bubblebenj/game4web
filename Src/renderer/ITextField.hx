/**
 * ...
 * @author Benjamin Dubois
 */

package renderer;

import kernel.CTypes;
import renderer.C2DQuad;
import rsc.CRscText;

interface ITextField
{
	public function Load( _Path : String ) : Result	{}
	
	public function SetRsc( _RscText : CRscText ) : Result	{}
}