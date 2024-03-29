/**
 * ...
 * @author de
 */

package renderer;

import CDriver;

import math.Constants;
import math.CV2D;
import math.CRect2D;
import math.Registers;
import rsc.CRscMan;
import kernel.Glb;
import renderer.CMaterial;

class C2DQuad extends CDrawObject
{
	public var	m_Rect		: CRect2D;
	private var m_Pivot		: CV2D;
	
	private var	m_Rotation	: Float;
	private var m_Scale		: CV2D;

	public var m_Camera	: C2DCamera;
	
	public var m_Color : CColor;
	public var m_Blend : MAT_BLEND_MODE;
		
	public function new() 
	{
		super();
		m_Rect		= new CRect2D();
		m_Pivot		= new CV2D( 0.5, 0.5 ); // Center
		m_Scale		= new CV2D( 0,0 );
		m_Rotation	= 0;
		m_Color = new CColor();
		m_Blend = MAT_BLEND_MODE.MBM_BLEND;
		//m_Camera	= new C2DCamera();
	}
	
	/* Need to be acces via another function - maybe a bad idea ^^ */
	private function Intersects( _Point : CV2D ) : Bool
	{
		if( _Point == null )
		{
			return false;
		}
		else
		{	
			var l_TL : CV2D	= GetTL();
			var l_BR : CV2D = GetPosition( { x : 1.0 , y : 1.0 } );
			
			return	_Point.x >= l_TL.x
			&&		_Point.y >= l_TL.y
			&&		_Point.x <= l_BR.x
			&&		_Point.y <= l_BR.y;
		}
	}
	public function IsReady() : Bool
	{
		return true;
	}
	
	public function SetTHECamera( _Camera : C2DCamera ): Void
	{
		m_Camera	= _Camera;
	}
	
	/*
	 * Pivot
	 */
	/* Pivot inside the quad between (0,0) and (1,1) */
	public inline function SetPivot( _Pos : CV2D ) : Void
	{
		m_Pivot.Copy( _Pos );
	}
	
	public inline function GetPivot() : CV2D
	{
		return m_Pivot;
	}
	
	/* 
	 * Position
	 */
	public function SetPosition( _Pos : CV2D ) : Void
	{
		m_Rect.m_TL.Set(	_Pos.x - m_Pivot.x * m_Rect.m_Size.x,
							_Pos.y - m_Pivot.y * m_Rect.m_Size.y );
	}
		
	public function SetTLPosition( _Pos : CV2D ) : Void
	{
		m_Rect.m_TL.Copy( _Pos );
	}
	
	public function SetCenterPosition( _Pos : CV2D ) : Void
	{
		m_Rect.m_TL.Set(	_Pos.x - 0.5 * m_Rect.m_Size.x,
							_Pos.y - 0.5 * m_Rect.m_Size.y );
	}
	
	/* Set _Handle to { x : 1.0, y : 0.0 } to get the top right corner position
	 * if _Handle is NOT set it return the pivot position */
	public function GetPosition( ?_V2dHandle : { x : Float, y : Float } ) : CV2D
	{
		var l_Pos	: CV2D	= new CV2D( 0, 0 );
		if ( _V2dHandle == null )
		{
			l_Pos.Set( m_Rect.m_TL.x + m_Pivot.x * m_Rect.m_Size.x,
								m_Rect.m_TL.y + m_Pivot.y * m_Rect.m_Size.y );
		}
		else
		{
			l_Pos.Set( m_Rect.m_TL.x + _V2dHandle.x * m_Rect.m_Size.x,
								m_Rect.m_TL.y + _V2dHandle.y * m_Rect.m_Size.y );
		}
		return l_Pos;
	}
	
	public function GetTL() : CV2D
	{
		return m_Rect.m_TL;
	}
	
	/* 
	 * Size
	 */
	/* /!\ Not tested
	 * Set as the "original" size -> scale = (1,1) */
	//public function SetSizeForceScale( _Size : CV2D ) : Void
	//{
		//m_Scale.Set( 1, 1 );
		//
		//var l_PivotCoord	= CV2D.NewCopy( GetPosition() );
		//m_Rect.m_Size.Copy( _Size );
		//SetPosition( l_PivotCoord );
	//}
	 
	/* Set size and adjust scale */
	public function SetSize( _Size : CV2D ) : Void
	{
		if ( CV2D.AreAbsEqual( m_Scale, CV2D.ZERO ) )
		{
			// initialize scale
			m_Scale.Set( 1, 1 );
		}
		else
		{
			// Set new scale value
			m_Scale.Set(	_Size.x * m_Scale.x / GetSize().x,
							_Size.y * m_Scale.y / GetSize().y );
		}
		var l_PivotCoord	= CV2D.NewCopy( GetPosition() );
		m_Rect.m_Size.Copy( _Size );
		SetPosition( l_PivotCoord );
	}
	
	public inline function GetSize() : CV2D
	{
		return m_Rect.m_Size;
	}
	
	public function SetTLSize( _Pos : CV2D, _Sz : CV2D ) : Void
	{
		m_Rect.m_Size.Copy( _Sz );
		SetTLPosition( _Pos );
	}
	
	public function SetCenterSize( _Pos : CV2D,_Sz : CV2D ) : Void
	{
		m_Rect.m_Size.Copy( _Sz );
		SetCenterPosition( _Pos );
	}
	
	public function SetTLBR( _TL : CV2D,_BR : CV2D  ) : Void
	{
		m_Rect.m_Size.Set(	_BR.x - _TL.x,
							_BR.y - _TL.y );
		SetTLPosition( _TL );
	}
	
	/* 
	 * Rotation
	 */
	/* Set the rotation using a radian value */
	public function SetRotation( _Rad : Float )
	{
		// NB : Y axis is inverted, so angles are clockwise instead of counterclockwise
		m_Rotation = _Rad % ( 2 * Math.PI );
	}
	
	public function GetRotation() : Float
	{
		return m_Rotation;
	}
	
	/* Debug functions */
	public function DebugInfo( ?_Prefix : String ) : Void
	{
		trace( _Prefix +" " + this +", Pos: " + GetPosition().toString()+ ", Pivot: " + GetPivot().toString() + ", Sz: " + GetSize().toString() + ", Vis : " + m_Visible );
	}
}