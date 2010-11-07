package renderer;

/**
 * ...
 * @author bdubois
 */

import CDriver;

import kernel.Glb;

import kernel.CDebug;
import kernel.CTypes;

import math.CV2D;
import math.Registers;

import renderer.C2DQuad;
import renderer.I2DContainer;
import renderer.camera.C2DCamera;



class C2DContainer extends C2DQuad, implements I2DContainer
{
	public 	var m_Name		: String;
	private var m_2DObjects	: Array<C2DQuad>;
	private var m_Camera	: C2DCamera;
	
	public function new()
	{
		super();
		m_Name			= "anonymous";
		m_2DObjects		= new Array<C2DQuad>();
		m_Camera		= new C2DCamera();
	}
	
	public function GetCamera()	: C2DCamera
	{
		return m_Camera;
	}
	
	public function GetElements() : Array<C2DQuad>
	{
		return m_2DObjects;
	}
	
	public function AddElement( _Object : C2DQuad ) : Result
	{
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
		var l_Center	= GetCenter();
		super.SetCenterPosition( _Pos );
		for ( i_Object in m_2DObjects )
		{
			CV2D.Sub( Registers.V2_0, i_Object.GetCenter(), l_Center );	// Shift
			CV2D.Add( Registers.V2_0, _Pos, Registers.V2_0 );
			i_Object.SetCenterPosition( Registers.V2_0 );
		}
	}
	
	public override function SetTLPosition( _Pos : CV2D ) : Void
	{
		var l_Center	= GetCenter();
		super.SetTLPosition( _Pos );
		for ( i_Object in m_2DObjects )
		{
			CV2D.Sub( Registers.V2_0, i_Object.GetCenter(), l_Center );	// Shift
			CV2D.Add( Registers.V2_0, _Pos, Registers.V2_0 );
			i_Object.SetTLPosition( Registers.V2_0 );
		}
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
		if ( _Size.x != 0 && _Size.y != 0 )
		{
			Registers.V2_1.x	= _Size.x / GetSize().x;
			Registers.V2_1.y	= _Size.y / GetSize().y;
			ScaleChilds( Registers.V2_1 );
		}
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
		return SUCCESS;
	}
	
	/* Debug functions */
	public function DebugInfo() : String
	{
		return this +" Name: " + m_Name +", Pos: " + GetCenter().ToString() + ", Sz: " + GetSize().ToString();
	}
	
	public function ShowTree( ? _Depth : Int ) : Void
	{
		_Depth	= ( _Depth == null ) ? 0 : _Depth;
		
		var l_Tabs	: String	= "";
		for ( i in 0 ... _Depth )
		{
			l_Tabs	= l_Tabs + "\t ";
		}
		
		trace( l_Tabs + DebugInfo() );
			
		if ( m_2DObjects.length == 0 )
		{
			trace ( l_Tabs + "\t is empty" );
		}
		else
		{
			for ( i_Object in m_2DObjects )
			{
				switch( Type.getClassName( Type.getClass( i_Object ) ) )
				{
					case "renderer.C2DContainer", "logic.CButton" :
					{
						cast( i_Object, C2DContainer).ShowTree( (_Depth + 1) );
					}
				}
			}
		}
	}
}