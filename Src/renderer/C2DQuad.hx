/**
 * ...
 * @author de
 */

package renderer;

import math.Constants;
import math.CV2D;
import math.CRect2D;
import math.Registers;
import renderer.camera.C2DCamera;

class C2DQuad extends CDrawObject
{
	public var	m_Rect		: CRect2D;
	private var m_Pivot		: CV2D;
	
	private var	m_Rotation	: Float;

		
	public function new() 
	{
		super();
		m_Rect		= new CRect2D();
		m_Pivot		= new CV2D( 0.5, 0.5 ); // Center
		
		m_Rotation	= 0;
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
	public function SetSize( _Size : CV2D ) : Void
	{
		//Registers.V2_9.Copy( GetPosition() );
		var l_PivotCoord	= new CV2D( GetPosition().x, GetPosition().y );
		trace( GetPosition().ToString());
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
		m_Rect.m_Size.Copy( _Sz);
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
		trace( _Rad + " % " + 2 + " * " + Math.PI );
		m_Rotation = _Rad % ( 2 * Math.PI );
		trace( m_Rotation );
	}
	
	public function GetRotation() : Float
	{
		return m_Rotation;
	}
	
	/* Debug functions */
	public function DebugInfo( ?_Prefix : String ) : Void
	{
		trace( _Prefix +" " + this +", Pos: " + GetPosition().ToString()+ ", Pivot: " + GetPivot().ToString() + ", Sz: " + GetSize().ToString() );
	}
}