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
	
	/* 
	 * Position
	 */
	public function SetCenterPosition( _Pos : CV2D ) : Void
	{
		m_Rect.m_Center.Copy( _Pos );
	}
	
	public function SetTLPosition( _Pos : CV2D ) : Void
	{
		CV2D.Scale( Registers.V2_0, 0.5, m_Rect.m_Size );	// Compute shift
		CV2D.Add( m_Rect.m_Center, _Pos, Registers.V2_0 );
	}
	
	public function SetRelativeCenterPosition( _RefPos : CV2D, _Pos : CV2D ) : Void
	{
		CV2D.Add( m_Rect.m_Center, _Pos, _RefPos );
	}
	
	public function SetRelativeTLPosition( _RefPos : CV2D, _Pos : CV2D ) : Void
	{
		CV2D.Add( Registers.V2_1, _Pos, _RefPos );			// Compute new position
		CV2D.Scale( Registers.V2_0, 0.5, m_Rect.m_Size ); 	// Compute shift
		CV2D.Add( m_Rect.m_Center, Registers.V2_1, Registers.V2_0 );
	}
	
	public inline function GetCenter(): CV2D
	{
		return m_Rect.m_Center;
	}
	
	public inline function GetTL() : CV2D
	{
		CV2D.Scale( Registers.V2_0, 0.5, m_Rect.m_Size );
		CV2D.Sub( Registers.V2_0, m_Rect.m_Center, Registers.V2_0 );
		return Registers.V2_0;
	}
	
	/* 
	 * Size
	 */
	public function SetCenterSize( _Pos : CV2D,_Sz : CV2D ) : Void
	{
		m_Rect.m_Center.Copy( _Pos);
		m_Rect.m_Size.Copy( _Sz);
	}
	
	public function SetTLBR( _TL : CV2D,_BR : CV2D  ) : Void
	{
		CV2D.Sub( Registers.V2_0, _TL, _BR );
		
		m_Rect.m_Size.Set( Math.abs(Registers.V2_0.x), Math.abs(Registers.V2_0.y) );
		
		CV2D.Scale( Registers.V2_1, 0.5, m_Rect.m_Size );
		CV2D.Sub( m_Rect.m_Center, _BR , Registers.V2_1);
	}
	
	public function SetTLSize( _TL : CV2D, _Sz : CV2D) : Void
	{
		m_Rect.m_Size.Copy(_Sz);
		CV2D.Scale( Registers.V2_1, 0.5 , m_Rect.m_Size );
		CV2D.Add( m_Rect.m_Center, _TL , Registers.V2_1);
	}
	
	public function SetSize( _Size : CV2D ) : Void
	{
		m_Rect.m_Size.Copy( _Size);
	}
	
	public inline function GetSize() : CV2D
	{
		return m_Rect.m_Size;
	}
}