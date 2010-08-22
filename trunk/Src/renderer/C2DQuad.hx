/**
 * ...
 * @author de
 */

package renderer;

import math.CV2D;
import math.CRect2D;
import math.Registers;

class C2DQuad extends CDrawObject
{
	public function new() 
	{
		super();
		m_Rect = new CRect2D();
	}
	
	public var m_Rect : CRect2D;
	
	public function SetPosition( _Pos : CV2D ) : Void
	{
		CV2D.Add( m_Rect.m_BR, _Pos, GetSize() );
		m_Rect.m_TL.Copy( _Pos );
	}
	
	public function SetSize( _Size : CV2D ) : Void
	{
		CV2D.Add( m_Rect.m_BR, m_Rect.m_TL, _Size );
	}
	
	public function GetSize() : CV2D
	{
		CV2D.Sub( Registers.V2_0, m_Rect.m_BR, m_Rect.m_TL );
		return Registers.V2_0;
	}
}