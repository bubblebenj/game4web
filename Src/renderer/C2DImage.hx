/**
 * ...
 * @author Benjamin Dubois
 */

package renderer;

import kernel.CTypes;
import math.CV2D;

// must inherit from 2DQuad
class C2DImage extends C2DQuad
{
	private	var m_SrcSize		: CV2D;
	
	public function new()
	{
		super();
		
		m_SrcSize		= new CV2D(0,0);
	}
}