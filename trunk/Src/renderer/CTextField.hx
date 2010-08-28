/**
 * ...
 * @author Benjamin Dubois
 */

package renderer;

import kernel.CTypes;
import renderer.C2DQuad;
import rsc.CRscText;

class CTextField extends C2DQuad
{
	public function new() 
	{
		super();
	}
	
	public function Load( _Path : String ) : Result
	{
		return SUCCESS;
	}
	
	public function SetRsc( _RscText : CRscText ) : Result
	{
		return SUCCESS;
	}
	
}