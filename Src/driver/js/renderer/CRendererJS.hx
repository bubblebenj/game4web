/**
 * ...
 * @author de
 */

package driver.js.renderer;

import driver.js.renderer.CGlQuad;
import driver.js.renderer.CViewportJS;
import math.CMatrix44;

import kernel.Glb;
import kernel.CTypes;

import renderer.CRenderer;
import renderer.CViewport;





class CRendererJS extends CRenderer
{
	public function new() 
	{
		super();
	}
	
	public override function  Initialize() : Result
	{
		super.Initialize();
		
		trace("CRendererJS::init");
		return SUCCESS;
	}
	
	public override function BeginScene() : Result
	{
		var l_FrameCount = ( 8* Glb.g_System.GetFrameCount()) % 255;
		
		//trace("CRendererJS::begin");
		Glb.g_SystemJS.GetGL().ClearColor( l_FrameCount/255.0,0,0,1 );
		Glb.g_SystemJS.GetGL().ClearDepth( 1000.0 );

		Glb.g_SystemJS.GetGL().Clear( CGL.COLOR_BUFFER_BIT | CGL.DEPTH_BUFFER_BIT );
		
		super.BeginScene();
		
		return SUCCESS;
	}

	public override function BuildViewport() : CViewport
	{
		return new CViewportJS();
	}
	
	public override function Render( _VpId : Int) : Result
	{
		m_NbDrawn = 0;

		for( _DOs in m_Scene )
		{
			if ( 	_DOs != null 
			&&		_DOs.Draw( _VpId ) == SUCCESS )
			{
				m_NbDrawn++;
			}
		}
		
		return SUCCESS;
	}
	
	public var m_NbDrawn : Int;
}