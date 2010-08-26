


import kernel.CSystem;
import kernel.Glb;
import kernel.CTypes;
import kernel.CMouse;								// <--
import kernel.CDebug;		

import renderer.CRscTexture;

import math.CV2D;
import math.CV3D;
import math.Registers;

import renderer.C2DQuad;
import renderer.CRenderer;

import renderer.camera.CCamera;
import renderer.camera.COrthoCamera;

import rsc.CRscImage;

#if js
	import driver.js.renderer.C2DImageJS;
	import CGL;
#end

enum STAGE
{
	STAGE_INIT;
	STAGE_UPDATE;
}

class CMainClient
{
	static var m_Stage	: STAGE;
	static var m_Quad	: C2DImageJS;
	static var m_Mouse	: CMouse; 					// <--
	static var m_Cpt	: Int;						// <--
	
	static var m_Img	: CRscImage;
	
	#if js
	public static function InitGameJS()
	{
		//var l_Ab : ArrayBuffer = new ArrayBuffer( [0,1] );
		
		m_Mouse		= Glb.g_System.GetMouse();		// <--
		m_Cpt		= 15;							// <--
		
		var l_OrthoCam : COrthoCamera = cast(Glb.g_System.GetRenderer().GetCamera( CRenderer.CAM_ORTHO_0 ), COrthoCamera);
		var l_CamPos : CV3D = new CV3D(0, 0, 0);
	
		l_OrthoCam.SetPosition( l_CamPos );
		
		l_OrthoCam.SetWidth( 1.0 );
		l_OrthoCam.SetHeight( 1.0 );
		
		l_OrthoCam.SetNear( 0.1 );
		l_OrthoCam.SetFar( 1000.0 );
		
		
		m_Quad = new C2DImageJS();
		m_Quad.Initialize();
		
		m_Quad.SetCenterSize( CV2D.HALF, CV2D.ONE );
		m_Quad.SetCamera( CRenderer.VP_FULLSCREEN , l_OrthoCam );
		
		m_Quad.SetVisible( true );
		
		//m_Img = cast( Glb.g_System.GetRscMan().Load( CRscTexture.RSC_ID, "https://cvs.khronos.org/svn/repos/registry/trunk/public/webgl/doc/spec/WebGL-Logo.png" ), CRscImage);
		
		m_Img = cast( Glb.g_System.GetRscMan().Load( CRscImage.RSC_ID, "http://www.alsacreations.com/xmedia/doc/full/webgl.gif" ), CRscImage);
		CDebug.ASSERT(m_Img!= null);
		
		m_Quad.SetRsc( m_Img );
		m_Quad.SetUV( CV2D.ZERO, CV2D.ONE );
		//m_Quad.GetMaterial().AttachTexture( 0, m_Tex );
		//m_Quad.GetPrimitive().
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
		if (m_Cpt > 15)								// <--
		{											// <--
			trace ( m_Mouse.m_Coordinate.Trace() + " " + (( m_Mouse.m_Out ) ? " Out !" : " In " )); // <--
			m_Cpt = 0; 								// <--
		}											// <--
		else	m_Cpt++;							// <--
		
		//m_Quad.SetSize( new CV2D(m_Cpt/15.0,m_Cpt/15.0) );
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