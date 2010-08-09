


import kernel.CSystem;
import kernel.Glb;
import kernel.CTypes;

import math.CV2D;
import math.CV3D;
import math.Registers;

import renderer.C2DQuad;
import renderer.CRenderer;

import renderer.camera.CCamera;
import renderer.camera.COrthoCamera;

#if js
	import driver.js.renderer.CGlQuad;
	import CGL;
#end

enum STAGE
{
	STAGE_INIT;
	STAGE_UPDATE;
}

class CMainClient
{
	static var m_Stage : STAGE;
	static var m_Quad : C2DQuad;
	
	#if js
	public static function InitGameJS()
	{
		var l_OrthoCam : COrthoCamera = cast(Glb.g_System.GetRenderer().GetCamera( CRenderer.CAM_ORTHO_0 ), COrthoCamera);
		var l_CamPos : CV3D = new CV3D(0, 0, -1);
	
		l_OrthoCam.SetPosition( l_CamPos );
		
		l_OrthoCam.SetWidth( 1.0 );
		l_OrthoCam.SetHeight( 1.0 );
		
		l_OrthoCam.SetNear( 0.1 );
		l_OrthoCam.SetFar( 1000.0 );
		
		/*
		m_Quad = new CGlQuad();
		m_Quad.Initialize();
		
		m_Quad.m_Rect.m_TL.Copy( CV2D.ZERO );
		CV2D.Sub( m_Quad.m_Rect.m_TL, m_Quad.m_Rect.m_TL, CV2D.HALF );
		
		m_Quad.m_Rect.m_BR.Copy( CV2D.ZERO );
		CV2D.Add( m_Quad.m_Rect.m_BR, m_Quad.m_Rect.m_BR, CV2D.HALF );
		
		m_Quad.SetCamera( CRenderer.VP_FULLSCREEN , l_OrthoCam );
		
		m_Quad.SetVisible( true );
		*/
	}
	#end
	
	public static function InitGame()
	{
		#if js
		InitGameJS();
		#end
	}
	
	public static function UpdateGame()
	{
		
	}
	
	
	static function UpdateCallback() : Result
	{
		switch(m_Stage)
		{
			case STAGE_INIT:
				InitGame();
				m_Stage = STAGE_UPDATE;
			case STAGE_UPDATE:
				UpdateGame();
		}
		return SUCCESS;
	}

	
	static function RenderCallback() : Result
	{
		return SUCCESS;
	}
	
	
	static function main()
	{
		m_Stage = STAGE_INIT;

		if( Glb.g_System == null )
		{
			trace("no g_system");
		}
		else 
		{
			trace("system init");
			Glb.g_System.Initialize();
			trace("main loop");
			Glb.g_System.MainLoop();
			
			Glb.g_System.m_BeforeUpdate =  UpdateCallback;
			Glb.g_System.m_BeforeDraw =  RenderCallback;
		}
	}
}