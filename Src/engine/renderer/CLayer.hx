package renderer;

/**
 * ...
 * @author bdubois
 */

import CDriver;
import driver.as.renderer.C2DQuadAS;
import flash.media.Camera;

import kernel.Glb;

import CDebug;
import CTypes;

import math.CV2D;
import math.Registers;

import renderer.C2DQuad;
import renderer.camera.C2DCamera;
import driver.as.renderer.C2DCameraAS;

import rsc.CRscMan;



class CLayer extends C2DContainer
{
	private	static var m_HalfScreen	: CV2D = new CV2D( 0.5 * Glb.GetSystem().m_Display.GetAspectRatio(), 0.5 );	
	
	public function new()
	{
		super();
		m_Camera	= new C2DCameraAS();
		SetTHECamera( m_Camera );
		m_Camera.m_Name	= m_Name;
	}
	
	public override function AddElement( _Object : C2DQuad ) : Result
	{
		var l_Res = super.AddElement( _Object );
		if ( l_Res == SUCCESS )
		{
			_Object.SetTHECamera( m_Camera );
			return SUCCESS;
		}
		return l_Res;
	}	
	
	public function MoveTHECamera( _Pos : CV2D ) : Void
	{
		m_Camera.SetPosition( _Pos );
	}
	
	public function setZoom( _value : Float ) : Void
	{
		m_Camera.SetScale( _value );
	}
	
	public function getZoom() : Float
	{
		return m_Camera.m_Scale;
	}
}