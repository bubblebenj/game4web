/**
 * ...
 * @author de
 */

package renderer;

import math.CV2D;
import math.CRect2D;

class C2DQuad extends CDrawObject
{
	public function new() 
	{
		super();
		m_Rect = new CRect2D();
	}
	
	
	public var m_Rect : CRect2D;
}