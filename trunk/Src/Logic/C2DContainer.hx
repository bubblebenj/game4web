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

class C2DContainer extends C2DQuad
{
	public function new() 
	{
		super();
		m_2DObjects	= new Array<C2DQuad>();
	}
	
	private var m_2DObjects	: Array<C2DQuad>;
	
	public function AddObject( _Object : C2DQuad ) : Result
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
		for ( i_Object in m_2DObjects )
		{
			CV2D.Sub( Registers.V2_0, i_Object.GetCenter(), GetCenter() );	// Shift
			i_Object.SetRelativeCenterPosition( _Pos, Registers.V2_0 );
		}
		super.SetCenterPosition( _Pos );
	}
	
	public override function SetTLPosition( _Pos : CV2D ) : Void
	{
		for ( i_Object in m_2DObjects )
		{
			CV2D.Sub( Registers.V2_0, i_Object.GetCenter(), GetCenter() );	// Shift
			i_Object.SetRelativeTLPosition( _Pos, Registers.V2_0 );
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
	
	public override function Activate() : Result
	{
		super.Activate();
		for ( i_Object in m_2DObjects )
		{
			//trace( "\t Activating " + i_Object );
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
	
	/* Debug function */
	public function ListChild() : Void
	{
		if ( m_2DObjects.length == 0 )
		{
			trace ( this + " is empty" );
		}
		else
		{
			trace( "Listing Child" );
			for ( i_Object in m_2DObjects )
			{
				trace( i_Object );
			}
		}
	}
}
