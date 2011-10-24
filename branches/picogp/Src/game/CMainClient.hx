


import editor.CEditorPanel;
import kernel.CSystem;
import kernel.Glb;
import CTypes;							// <--
import CDebug;		
import renderer.camera.CPerspectiveCamera;
import rsc.CRscDAE;

import input.CKeyboard;
import input.CKeyCodes;
import input.CMouse;

import algorithms.CBitArray;

import renderer.CRscTexture;

import math.CV2D;
import math.CV3D;
import math.Registers;

import renderer.C2DQuad;
import renderer.CRenderer;

import renderer.camera.CCamera;
import renderer.camera.COrthoCamera;

import renderer.I2DImage;

import rsc.CRscImage;

import CDriver;
import driver.js.renderer.C2DImageJS;


#if js
	import CGL;
#end

enum STAGE
{
	STAGE_INIT;
	STAGE_UPDATE;
}


typedef IntPair = {
	var m_Rsc : Int;
	var m_Func : String -> Int;
 };
 

class CMainClient implements SystemProcess
{
	var m_Stage	: STAGE;
	var m_Quad	: C2DImage;
	//static var m_Mouse	: CMouse; 					// <--
	var m_Cpt	: Int;						// <--
	
	var m_Img	: CRscImage;
	
	//static var m_Editor : CEditorPanel = new CEditorPanel();
	
	public function new()
	{
		m_Stage = STAGE_INIT;
	}
	
	#if js
	public function InitGameJS()
	{
		//var l_Ab : ArrayBuffer = new ArrayBuffer( [0,1] );
		
		//m_Mouse		= Glb.g_System.GetMouse();		// <--
		m_Cpt		= 15;							// <--
		
		var l_OrthoCam : COrthoCamera = cast(Glb.g_System.GetRenderer().GetCamera( CRenderer.CAM_ORTHO_0 ), COrthoCamera);
		var l_CamPos : CV3D = new CV3D(0, 0, 0);
	
		l_OrthoCam.SetPosition( l_CamPos );
		
		l_OrthoCam.SetWidth( 1.0 );
		l_OrthoCam.SetHeight( 1.0 );
		
		l_OrthoCam.SetNear( 0.1 );
		l_OrthoCam.SetFar( 1000.0 );
		
		var l_PersCam : CPerspectiveCamera = cast Glb.g_System.GetRenderer().GetCamera( CRenderer.CAM_PERSPECTIVE_0 );
		
		
		
		m_Quad = new C2DImage();
		m_Quad.Initialize();
		
		m_Quad.SetCenterSize( CV2D.HALF, CV2D.ONE );
		m_Quad.SetCamera( CRenderer.VP_FULLSCREEN , l_OrthoCam );
		
		m_Quad.SetVisible( true );
		
		//m_Img = cast( Glb.g_System.GetRscMan().Load( CRscTexture.RSC_ID, "https://cvs.khronos.org/svn/repos/registry/trunk/public/webgl/doc/spec/WebGL-Logo.png" ), CRscImage);
		
		//m_Img = cast( Glb.g_System.GetRscMan().Load( CRscImage.RSC_ID, "http://www.alsacreations.com/xmedia/doc/full/webgl.gif" ), CRscImage);
		//m_Img = cast( Glb.g_System.GetRscMan().Load( CRscImage.RSC_ID, "http://spidergl.org/examples/data/image0.png" ), CRscImage);
		//m_Img = cast( Glb.g_System.GetRscMan().Load( CRscImage.RSC_ID, "../Data/Gfx/images/FX_EarthClod.png" ), CRscImage);
		
		m_Img = cast( Glb.g_System.GetRscMan().Load( CRscImage.RSC_ID, "http://workspace.com/G4W/Data/Gfx/images/FX_EarthClod.png" ), CRscImage);
		CDebug.ASSERT(m_Img!= null);
		
		m_Quad.SetRsc( m_Img );
		
		//m_Quad.SetUV( CV2D.ZERO, CV2D.ONE );
		//m_Quad.GetMaterial().AttachTexture( 0, m_Tex );
		//m_Quad.GetPrimitive().
		
		//m_Quad.Dump();
		
		Glb.GetRendererJS().AddToScene( m_Quad );

	}
	#end
	
	public function AfterDraw()
	{
		return SUCCESS;
	}
	
	public function AfterUpdate()
	{
		return SUCCESS;
	}
	
	public static var DATA_ROOT :String = "http://workspace.com/G4W/Data/";
	public var mesh : CRscDAE;
	public function InitGame()
	{
		mesh = cast Glb.g_System.GetRscMan().Load( CRscDAE.RSC_ID, DATA_ROOT + "Gfx/Teapot.dae");
		
		#if js
		InitGameJS();
		#end
		
		if(null == Glb.GetInputManager().GetKeyboard()) 
		{
			CDebug.CONSOLEMSG(  "ERROR" );
		}
		else
		{
			CDebug.CONSOLEMSG(  "KeyBoard OK" );
		}
		
		//var l_Img :C2DImage =  CPlatform.Newer( Type.typeof(C2DImage) );
		//var l_Img :C2DImage = new C2DImage();
		//CDebug.CONSOLEMSG(  "type of 2dimg : " + (Std.is(l_Img,C2DImage) ? "yes" : "No") );
		//m_Quad.Dump();
		
	
	}
	
	
	public function UpdateGame()
	{
		Glb.g_System.GetRscMan().Update();
		
		if (m_Cpt > 15)								// <--
		{											// <--
			//CDebug.CONSOLEMSG( m_Mouse.m_Coordinate.Trace() + " " + (( m_Mouse.m_Out ) ? " Out !" : " In " ) ); // <--
			m_Cpt = 0; 								// <--
		}											// <--
		else	m_Cpt++;							// <--
		
		//m_Quad.SetSize( new CV2D(m_Cpt/15.0,m_Cpt/15.0) );
		
		if ( 	Glb.GetInputManager().GetKeyboard() != null
		&&		!Glb.GetInputManager().GetKeyboard().IsKeyDown( CKeyCodes.KEY_A )
		&&		Glb.GetInputManager().GetKeyboard().WasKeyDown( CKeyCodes.KEY_A )
		)
		{
			CDebug.CONSOLEMSG( "A");
		}
		/*a
		
		if ( 	null != Glb.GetInputManager().GetKeyboard() 
		&&		Glb.GetInputManager().GetKeyboard().IsKeyDown( CKeyCodes.KEY_SHIFT )
		//&&		Glb.GetInputManager().GetKeyboard().WasKeyDown( CKeyCodes.KEY_A )
		)
		{
			CDebug.CONSOLEMSG( "SHIFT");
		}
		*/
	}
	
	
	public function BeforeUpdate() : Result
	{
		switch(m_Stage)
		{
			case STAGE_INIT:
				InitGame();
				m_Stage = STAGE_UPDATE;
			case STAGE_UPDATE:
				UpdateGame();
		}
		
		//if( Glb.GetInputManager().)
		{
			
		}
		return SUCCESS;
	}

	
	public function BeforeDraw() : Result
	{
		return SUCCESS;
	}
	
	
	static function main()
	{
		

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
			
			Glb.g_System.m_Process = new CMainClient();
			//Glb.g_System.m_BeforeUpdate =  UpdateCallback;
			//Glb.g_System.m_BeforeDraw	=  RenderCallback;
		}
	}
}