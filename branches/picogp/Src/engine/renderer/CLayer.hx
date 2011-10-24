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
	
	private var w_Pos				: CV2D;
	
	public function new()
	{
		super();
		m_Camera	= new C2DCameraAS();
		SetTHECamera( m_Camera );
		m_Camera.m_Name	= m_Name;
		m_Pivot			= new CV2D( 0, 0 );
		w_Pos			= new CV2D( 0, 0 );
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
	
	public function MoveTHECamera( _Pos : CV2D )
	{
		m_Camera.SetPosition( _Pos );
		//CV2D.Sub( w_Pos, CV2D.ZERO, m_Camera.m_Coordinate );
		//CV2D.Sub( w_Pos, w_Pos, m_HalfScreen );
		//SetPosition( w_Pos );
	}
}