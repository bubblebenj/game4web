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



class CLayer extends C2DContainer
{
	public 	var m_Camera	: C2DCamera;
	
	public function new()
	{
		super();
		m_Camera		= new C2DCamera();
	}
	
	public function SetTHECamera( _Camera: C2DCamera ): Void
	{
		m_Camera	= _Camera;
		SetCenterPosition( m_Camera.m_Coordinate );
	}
	
	public function MoveTHECamera( _Pos : CV2D )
	{
		m_Camera.SetPosition( _Pos );
		SetCenterPosition( m_Camera.m_Coordinate );
	}
}