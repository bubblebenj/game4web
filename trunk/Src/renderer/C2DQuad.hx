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
	
	// 2DQuad will be centered on _Pos position
	public function SetPosition( _Pos : CV2D ) : Void
	{
		// Get the 2DQuad size
		var l_V = new CV2D( 0, 0 );
		CV2D.Sub( l_V, m_Rect.m_BR, m_Rect.m_TL );
		// Compute the half size
		CV2D.Scale( l_V, 0.5, l_V );
		// Change coordinates centered
		CV2D.Sub( m_Rect.m_TL, _Pos, l_V );
		CV2D.Add( m_Rect.m_BR, _Pos, l_V );
	}
	
	// We suppose that the 2DQuad is already centered
	public function SetSize( _Size : CV2D ) : Void
	{
		// Get current position (middle of the rect)
		var l_CurrentPos = new CV2D( 0, 0 );
		CV2D.Add(	l_CurrentPos, m_Rect.m_TL, m_Rect.m_BR );
		CV2D.Scale(	l_CurrentPos, 0.5, l_CurrentPos );
		// Change coordinates centered
		var l_halfSize = new CV2D( 0, 0 );
		CV2D.Scale(	l_halfSize, 0.5, _Size );
		// Set new size
		CV2D.Sub( m_Rect.m_TL, l_CurrentPos, l_halfSize );
		CV2D.Add( m_Rect.m_BR, l_CurrentPos, l_halfSize );
	}
}