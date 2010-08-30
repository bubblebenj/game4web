/**
 * ...
 * @author Benjamin Dubois
 */

package logic;

import kernel.CDebug;
import kernel.CTypes;

import logic.IContent;

import math.CRect2D;
import math.CV2D;

import renderer.C2DQuad;

class C2DContainer implements IContent
{
	public function new() 
	{
		m_Rect		= new CRect2D();
		m_2DObjects	= new Array<C2DQuad>();
	}
	
	private var m_Rect		: CRect2D;
	private var m_2DObjects	: Array<C2DQuad>;
	
	public function AddObject( _Object : C2DQuad ) : Result
	{
		for ( i_2DObject in m_2DObjects )
		{
			if ( i_2DObject == _Object )
			{
				CDebug.CONSOLEMSG( "This object has already been added to the container" );
				return FAILURE;
			}
			else
			{
				
			}
		}
		return SUCCESS;
	}
	
	
	/*** Everything above is a strict copy of C2DQuad ***/
	/* 
	 * Position
	 */
	public function SetCenterPosition( _Pos : CV2D ) : Void
	{
		m_Rect.m_Center.Copy( _Pos);
	}
	
	public function SetTLPosition( _Pos : CV2D ) : Void
	{
		CV2D.Scale( Registers.V2_0, 0.5, m_Rect.m_Size );
		CV2D.Add( m_Rect.m_Center, _Pos, Registers.V2_0 );
	}
	
	public function GetCenter(): CV2D
	{
		return m_Rect.m_Center;
	}
	
	public function GetTL() : CV2D
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
	
	public function GetSize() : CV2D
	{
		return m_Rect.m_Size;
	}
}