package renderer;

/**
 * ...
 * @author bdubois
 */
import CDriver;
import kernel.Glb;
import kernel.CTypes;
import math.CV2D;
import math.Registers;

enum E_Unit
{
	RATIO;
	PX;
	PERCENTAGE;
}

class C2DInterface
{
	private var m_2DObject	: C2DQuad;
	private var m_Parent	: C2DContainer;
	
	public function new( _Object : C2DQuad, ?_Container : C2DContainer ) 
	{
		Set2DObject( _Object );

		if ( _Container == null )
		{
			m_Parent	= null;
		}
		else
		{
			SetParent( _Container );
			m_Parent.AddElement( m_2DObject );
		}
	}
	
	public function Set2DObject( _Object : C2DQuad )
	{
		m_2DObject = _Object;
	}
	
	public function Get2DObject() : C2DQuad
	{
		return m_2DObject;
	}
	
	public function SetParent( _Container : C2DContainer )
	{
		m_Parent = _Container;
	}
	
	public function GetParent() : C2DContainer
	{
		return m_Parent;
	}
	
	public function SetEltSize( _Unit : E_Unit, _Size : CV2D ) : Void
	{
		var l_x 			: Float;
		var l_y 			: Float;
		
		var l_Size			: CV2D	= new CV2D( _Size.x, _Size.y );
		var l_NewSize		: CV2D	= new CV2D( 0, 0 );
		
		var l_ParentSize	: CV2D	= new CV2D( 0, 0 );
		if ( m_Parent == null )
		{
			l_ParentSize.Set( Glb.GetSystem().m_Display.GetAspectRatio(), 1 );
		}
		else
		{
			l_ParentSize.Copy( m_Parent.GetSize() );
		}
		
		
		// Converting percentage to ratio ( between 0 and 1 )
		if ( _Unit == PERCENTAGE )
		{
			l_Size.Set(	_Size.x * 0.01,
						_Size.y * 0.01 );
			_Unit = RATIO;
		}
		
		// Converting ratio to pixels
		if ( _Unit == RATIO )
		{
			/*\ if element size is (0, 0) will wait to fit parent size (keeping image ratio) */
			if ( CV2D.AreEqual( l_Size, CV2D.ZERO ) &&  CV2D.AreEqual( m_2DObject.GetSize(), CV2D.ZERO ) )
			{
				m_NeedToFitParent = true;
				return;
			}
			else
			{
				if ( CV2D.AreEqual( l_Size, CV2D.ZERO ) )	// fit inside parent keeping image ratio
				{
					var l_ImgRatio	= m_2DObject.GetSize().x / m_2DObject.GetSize().y;
					if ( l_ParentSize.x / l_ParentSize.y > l_ImgRatio ) // Fit to parent height
					{
						l_Size.Set(	l_ParentSize.y * l_ImgRatio,	l_ParentSize.y );
					}
					else															// Fit to parent width
					{
						l_Size.Set(	l_ParentSize.x,					l_ParentSize.y / l_ImgRatio );
					}
				}
				else	
				{
					l_Size.Set(	l_Size.x * l_ParentSize.x,
								l_Size.y * l_ParentSize.y );
				}
			}
			// convert parent ratio to pixels
			l_Size.Set(	l_Size.x * Glb.GetSystem().m_Display.m_Height ,
						l_Size.y * Glb.GetSystem().m_Display.m_Height );
		}
		
		m_NeedToFitParent = false;
		// Now size is in pixels (if not already)
		if ( CV2D.AreEqual( m_2DObject.GetSize(), CV2D.ZERO ) )
		{
			l_NewSize.Copy( l_Size );
		}
		else
		{
			// X
			if (l_Size.x == 0 )
			{
				if ( m_2DObject.GetSize().x == 0 )		{	l_x = 0; }	
				else
				{	if ( m_2DObject.GetSize().y == 0 )	{	l_x = m_2DObject.GetSize().x * l_Size.y / m_2DObject.GetSize().y;	}
				
					else					{	l_x = m_2DObject.GetSize().x;	}
				}	
			}else							{	l_x = l_Size.x;	}
			//
			// Y
			if ( l_Size.y == 0 )
			{
				if ( m_2DObject.GetSize().y == 0 )		{	l_y = 0; }	
				else
				{	if ( m_2DObject.GetSize().x == 0 )	{	l_y = m_2DObject.GetSize().y * l_Size.x / m_2DObject.GetSize().x;	}
					
					else					{	l_y = m_2DObject.GetSize().y;	}
				}
			}else							{	l_y = l_Size.y;	}
			//
			l_NewSize.Set( l_x, l_y );
		}
		l_NewSize.Set(	l_NewSize.x / Glb.GetSystem().m_Display.m_Height,
						l_NewSize.y / Glb.GetSystem().m_Display.m_Height );
		m_2DObject.SetSize( l_NewSize );
	}
	
	public function SetEltPivot( _Type : String, ?_Pos : CV2D ) : Void
	{
		var l_Pos : CV2D = new CV2D( 0, 0 );
		switch ( _Type )
		{
			case "center"	: l_Pos.Set( 0.5, 0.5 );
			case "TL"		: l_Pos.Set( 0  , 0   );
			case "pivot"	: l_Pos.Copy( _Pos );
		}
		m_2DObject.SetPivot( l_Pos );
	}
	
	public function SetEltPos( _Unit : E_Unit, _Pos : CV2D ) : Void
	{
		var l_ParentSize	: CV2D	= new CV2D( 0, 0 );
		var l_ParentPos		: CV2D	= new CV2D( 0, 0 );
		if ( m_Parent == null )
		{
			l_ParentSize.Set( Glb.GetSystem().m_Display.GetAspectRatio(), 1 );
			l_ParentPos.Set( 0, 0 );
		}
		else
		{
			l_ParentSize.Copy( m_Parent.GetSize() );
			l_ParentPos.Copy( m_Parent.GetTL() );
		}
		
		var l_Pos			: CV2D	= new CV2D( _Pos.x, _Pos.y );
		
		// Convert to ratio
		if ( _Unit == PERCENTAGE )
		{
			l_Pos.Set( _Pos.x * 0.01, _Pos.y * 0.01 );
			_Unit	= RATIO;
		}
		
		// Convert to pixels
		if ( _Unit == RATIO )
		{
			l_Pos.Set(	l_ParentSize.x * l_Pos.x * Glb.GetSystem().m_Display.m_Height,
						l_ParentSize.y * l_Pos.y * Glb.GetSystem().m_Display.m_Height );
		}
		
		// Convert to homogenous screen unit
		l_Pos.Set(	l_Pos.x / Glb.GetSystem().m_Display.m_Height,
					l_Pos.y / Glb.GetSystem().m_Display.m_Height );
		
		// Add parent origin
		l_Pos.Set(	l_Pos.x + l_ParentPos.x,
					l_Pos.y + l_ParentPos.y );
					
		m_2DObject.SetPosition( new CV2D( l_Pos.x, l_Pos.y ) );
	}
	
	public function Update() : Result
	{
		m_2DObject.Update();
		if ( m_NeedToFitParent && m_2DObject.GetSize().x != 0 && m_2DObject.GetSize().y != 0 )
		{
			m_NeedToFitParent = false;
			SetEltSize( RATIO, CV2D.ZERO ); // The element will fit parent size keeping aspect ratio
											// Was not possible before knowing image aspect ratio
		}
		return SUCCESS;
	}
	
	public function NeedUpdate() : Bool
	{
		return m_NeedToFitParent;
	}
	
	private var m_NeedToFitParent	: Bool;
}