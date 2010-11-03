/**
 * ...
 * @author bdubois
 */

package driver.as.renderer;


import CDriver;
import flash.display.Sprite;

import renderer.C2DQuad;
import renderer.I2DContainer;
import kernel.CDebug;
import kernel.CTypes;
import math.Registers;

import math.CRect2D;
import math.CV2D;

import renderer.C2DQuad;

class C2DContainerAS extends C2DQuadAS, implements I2DContainer
{
	private var m_2DObjects	: Array<C2DQuad>;
	private var m_CameraAS	: C2DCameraAS;
	
	public function new()
	{
		super();
		m_2DObjects		= new Array<C2DQuad>();
		m_DisplayObject	= new Sprite();
		m_CameraAS		= new C2DCameraAS();
	}
	
	public function GetElements() : Array<C2DQuad>
	{
		return m_2DObjects;
	}
	
	public function AddElement( _Object : C2DQuad ) : Result
	{
		
		if ( m_DisplayObject != null )
		{
			if ( Reflect.hasField( _Object, "m_DisplayObject" ) )
			{
				if ( cast ( _Object, C2DQuadAS ).m_DisplayObject != null )
				{
					cast ( m_DisplayObject, Sprite ).addChild( cast ( _Object, C2DQuadAS ).m_DisplayObject );
				}
			}
		}
		
		var l_AlreadyExists : Bool = false;
		for ( i_2DObject in m_2DObjects )
		{
			if ( i_2DObject == _Object )
			{
				CDebug.CONSOLEMSG( "This object has already been added to the container" );
				l_AlreadyExists = true;
			}
		}
		if ( l_AlreadyExists )
		{
			return FAILURE;
		}
		else
		{
			m_2DObjects.push( _Object );
			return SUCCESS;
		}
	}
	
	public function GetChildIndex( _Object : C2DQuad ) : Int
	{
		for ( i in 0 ... m_2DObjects.length )
		{
			if ( m_2DObjects[i] == _Object )
			{
				return i;
			}
		}
		return -1;
	}
	
	/* 
	 * Position
	 */
	public override function SetCenterPosition( _Pos : CV2D ) : Void
	{
		for ( i_Object in m_2DObjects )
		{
			CV2D.Sub( Registers.V2_0, i_Object.GetCenter(), GetCenter() );	// Shift
			CV2D.Add( Registers.V2_0, _Pos, Registers.V2_0 );
			i_Object.SetCenterPosition( Registers.V2_0 );
		}
		super.SetCenterPosition( _Pos );
	}
	
	public override function SetTLPosition( _Pos : CV2D ) : Void
	{
		for ( i_Object in m_2DObjects )
		{
			CV2D.Sub( Registers.V2_0, i_Object.GetCenter(), GetCenter() );	// Shift
			CV2D.Add( Registers.V2_0, _Pos, Registers.V2_0 );
			i_Object.SetTLPosition( Registers.V2_0 );
		}
		super.SetTLPosition( _Pos );
	}
	
	/* 
	 * Size
	 */
	private inline function ScaleChilds( _Ratio : CV2D )
	{
		for ( i_Object in m_2DObjects )
		{
			Registers.V2_0.x	= i_Object.GetSize().x * _Ratio.x;
			Registers.V2_0.y	= i_Object.GetSize().y * _Ratio.y;
			i_Object.SetSize( Registers.V2_0 );
		}
	}
	
	public override function SetSize( _Size : CV2D ) : Void
	{
		Registers.V2_1.x	= GetSize().x / _Size.x;
		Registers.V2_1.y	= GetSize().y / _Size.y;
		ScaleChilds( Registers.V2_1 );
		super.SetSize( _Size );
	}
	
	public override function SetTLSize( _TL : CV2D, _Sz : CV2D ) : Void
	{
		SetSize( _Sz );
		SetTLPosition( _TL );
	}
	
	public override function SetVisible( _Vis : Bool ) : Void
	{
		super.SetVisible( _Vis );
		for ( i_Object in m_2DObjects )
		{
			i_Object.SetVisible( _Vis );
		}
	}
	
	public override function SetAlpha( _Value : Float ) : Void
	{
		super.SetAlpha( _Value );
		for ( i_Object in m_2DObjects )
		{
			i_Object.SetAlpha( _Value );
		}
	}
	
	public override function Activate() : Result
	{
		super.Activate();
		for ( i_Object in m_2DObjects )
		{
			i_Object.Activate();
		}
		return SUCCESS;
	}
	
	public override function Shut() : Result
	{
		super.Shut();
		for ( i_Object in m_2DObjects )
		{
			i_Object.Shut();
		}
		return SUCCESS;
	}
	
	public override function Update() : Result
	{
		super.Update();
		for ( i_Object in m_2DObjects )
		{
			i_Object.Update();
		}
		var l_InvMatrix = m_CameraAS.m_Matrix.clone();
		l_InvMatrix.invert();
		cast ( m_DisplayObject, Sprite ).transform.matrix = l_InvMatrix;
		return SUCCESS;
	}
	
	/* Debug function */
	public function ShowTree( ? _Depth : Int ) : Void
	{
		_Depth	= ( _Depth == null ) ? 0 : _Depth;
		
		var l_Tabs	: String	= "";
		for ( i in 0 ... _Depth )
		{
			l_Tabs	= l_Tabs + "\t ";
		}
		
		trace( l_Tabs + this );
		
		if ( m_2DObjects.length == 0 )
		{
			trace ( "\t is empty" );
		}
		else
		{
			trace( l_Tabs + "Listing Child" );
			for ( i_Object in m_2DObjects )
			{
				if ( Type.getClassName( Type.getClass( i_Object ) ) == "logic.C2DContainer" )
				{
					cast( i_Object, C2DContainer).ShowTree( (_Depth + 1) );
				}
				else
				{
					trace( l_Tabs + "\t " + i_Object );
				}
			}
		}
	}
}