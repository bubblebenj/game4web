/**
 * ...
 * @author Benjamin Dubois
 */

package renderer;

import kernel.CTypes;
import math.CV2D;

// must inherit from 2DQuad
class C2DImage extends CDrawObject
{
	private	var m_PathToImg		: String;
	private	var m_SrcSize		: CV2D;
	private var m_2DQuad		: C2DQuad; // <-- degage !!
	
	public function new()
	{
		super();
		m_2DQuad		= new C2DQuad();
		m_SrcSize		= new CV2D(0,0);
	}
	
	// We suppose that the 2DQuad is already centered
	public function SetSize( _Size : CV2D ) : Void
	{
		m_2DQuad.SetSize( _Size );
	}
	
	private function FillQuad() : Result
	{
		//dunno exactly what to do out of the driver
		return SUCCESS;
	}
}