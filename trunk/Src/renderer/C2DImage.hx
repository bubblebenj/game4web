/**
 * ...
 * @author Benjamin Dubois
 */

package renderer;

import kernel.CTypes;
import math.CV2D;

class C2DImage extends C2DQuad
{
	private	var m_SrcSize			: CV2D;
	
	public function new()
	{
		super();
		SetSize( new CV2D( 40, 60 ) );
		MoveTo( new CV2D( 40, 60 ) );
	}
	
	private function FillQuad() : Result
	{
		//dunno exactly what to do out of the driver
		return SUCCESS;
	}
}