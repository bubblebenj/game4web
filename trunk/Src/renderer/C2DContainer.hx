package renderer;

/**
 * ...
 * @author bdubois
 */

import CDriver;
import driver.as.renderer.C2DQuadAS;
import flash.media.Camera;

import kernel.Glb;

import kernel.CDebug;
import kernel.CTypes;

import math.CV2D;
import math.Registers;

import renderer.C2DQuad;
import renderer.camera.C2DCamera;



class C2DContainer extends C2DQuad
{
	public 	var m_Name		: String;
	private var m_2DObjects	: Array<C2DQuad>;
	
	public function new()
	{
		super();
		m_Name			= "anonymous";
		m_2DObjects		= new Array<C2DQuad>();
		SetSize( CV2D.ONE );
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
	public override function SetPosition( _Pos : CV2D ) : Void
	{
		var l_ObjPos : CV2D = new CV2D( 0, 0 );
		for ( i_Object in m_2DObjects )
		{
			l_ObjPos.Set(	_Pos.x + i_Object.GetPosition().x - GetPosition().x,
							_Pos.y + i_Object.GetPosition().y - GetPosition().y );
			i_Object.SetPosition( l_ObjPos );
		}
		super.SetPosition( _Pos );
	}
	 
	public override function SetCenterPosition( _Pos : CV2D ) : Void
	{
		var l_ObjPos	: CV2D = new CV2D( 0, 0 );
		var l_Delta		: CV2D = new CV2D(	_Pos.x - GetPosition( { x : 0.5, y : 0.5 } ).x ,
											_Pos.y - GetPosition( { x : 0.5, y : 0.5 } ).y );
		for ( i_Object in m_2DObjects )
		{
			//l_ObjPos.Set(	_Pos.x + i_Object.GetPosition().x - GetPosition( { x : 0.5, y : 0.5 } ).x,
				//			_Pos.y + i_Object.GetPosition().y - GetPosition( { x : 0.5, y : 0.5 } ).y );
			CV2D.Add( l_ObjPos, i_Object.GetPosition(), l_Delta );
			i_Object.SetPosition( l_ObjPos );
		}
		super.SetCenterPosition( _Pos );
	}
	
	public override function SetTLPosition( _Pos : CV2D ) : Void
	{
		var l_ObjPos : CV2D = new CV2D( 0, 0 );
		for ( i_Object in m_2DObjects )
		{
			l_ObjPos.Set(	_Pos.x + i_Object.GetPosition().x - GetPosition( { x : 0.0, y : 0.0 } ).x,
							_Pos.y + i_Object.GetPosition().y - GetPosition( { x : 0.0, y : 0.0 } ).y );
			i_Object.SetPosition( l_ObjPos );
		}
		super.SetTLPosition( _Pos );
	}
	
	/* 
	 * Size
	 */
	private inline function ScaleAndMoveChildren( _Ratio : { x : Float, y : Float } )
	{
		for ( i_Object in m_2DObjects )
		{
			// 1st scale		
			var l_V2D	= new CV2D(	i_Object.GetSize().x * _Ratio.x,
									i_Object.GetSize().y * _Ratio.y );
			i_Object.SetSize( l_V2D );
			
			// 2nd adapt the relative position
			l_V2D.Set( 	( i_Object.GetTL().x - GetTL().x ) * _Ratio.x,
						( i_Object.GetTL().y - GetTL().y ) * _Ratio.y );
			i_Object.SetTLPosition( l_V2D );
		}
	}
	
	public override function SetSize( _Size : CV2D ) : Void
	{
		if ( _Size.x != 0 && _Size.y != 0 )
		{
			ScaleAndMoveChildren( {	x : (_Size.x / GetSize().x),
									y : (_Size.y / GetSize().y) } );
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
	public override function DebugInfo( ?_Prefix : String ) : Void
	{
		if ( _Prefix == null )
		{
			_Prefix = "";
		}
		trace( _Prefix +" " + this +" Name: " + m_Name+", Pos: " + GetPosition().ToString()+ ", Pivot: " + GetPivot().ToString() + ", Sz: " + GetSize().ToString() );
	}
	
	public function ShowTree( ? _Depth : Int ) : Void
	{
		_Depth	= ( _Depth == null ) ? 0 : _Depth;
		
		var l_Tabs	: String	= "";
		for ( i in 0 ... _Depth )
		{
			l_Tabs	= l_Tabs + "\t ";
		}
		
		DebugInfo( l_Tabs );
			
		if ( m_2DObjects.length == 0 )
		{
			trace ( l_Tabs + "\t is empty" );
		}
		else
		{
			for ( i_Object in m_2DObjects )
			{
				//trace( Type.getClassName( Type.getClass( i_Object ) ) );
				switch( Type.getClassName( Type.getClass( i_Object ) ) )
				{
					case "renderer.C2DContainer", "logic.CButton", "renderer.CLayer", "CTrack", "CStage", "CHUD" :
					{
						cast( i_Object, C2DContainer).ShowTree( (_Depth + 1) );
					}
					default	:
					{
						i_Object.DebugInfo( l_Tabs + "\t \t" );
					}
				}
			}
		}
	}
}