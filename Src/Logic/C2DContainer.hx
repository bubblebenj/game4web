/**
 * ...
 * @author Benjamin Dubois
 */

package logic;

import kernel.CDebug;
import kernel.CTypes;
import math.Registers;

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
				m_2DObjects.push( _Object );
			}
		}
		return SUCCESS;
	}
	
	/* 
	 * Position
	 */
	private inline function MoveChilds( _Pos : CV2D )
	{
		for ( i_Object in m_2DObjects )
		{
			CV2D.Sub( Registers.V2_0, i_Object.GetCenter(), GetCenter() );
			CV2D.Add( Registers.V2_0, Registers.V2_0, _Pos );
			i_Object.SetCenterPosition( Registers.V2_0 );
		}
	}
	 
	public function SetCenterPosition( _Pos : CV2D ) : Void
	{
		MoveChilds( _Pos );
		m_Rect.m_Center.Copy( _Pos );
	}
	
	public function SetTLPosition( _Pos : CV2D ) : Void
	{
		CV2D.Scale( Registers.V2_0, 0.5, m_Rect.m_Size );
		CV2D.Add( Registers.V2_1, _Pos, Registers.V2_0 );
		
		SetCenterPosition( Registers.V2_1 );
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
		SetCenterPosition( _Pos );
		m_Rect.m_Size.Copy( _Sz);
	}
	
	private inline ScaleChilds( _Ratio : CV2D )
	{
		for ( i_Object in m_2DObjects )
		{
			Registers.V2_0.x	= i_Object.GetSize().x * _Ratio.x;
			Registers.V2_0.y	= i_Object.GetSize().y * _Ratio.y;
			i_Object.SetSize( Registers.V2_0 );
		}
	}
	
	public function SetSize( _Size : CV2D ) : Void
	{
		Registers.V2_1	= GetSize() / _Size;
		ScaleChilds( Registers.V2_1 );
		m_Rect.m_Size.Copy( _Size );
	}
	
	public function SetTLSize( _TL : CV2D, _Sz : CV2D) : Void
	{
		SetSize( _Sz );
		SetTLPosition( _TL );
	}
	
	public function GetSize() : CV2D
	{
		return m_Rect.m_Size;
	}
}