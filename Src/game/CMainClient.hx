


import editor.CEditorPanel;
import kernel.CSystem;
import kernel.Glb;
import kernel.CTypes;
import kernel.CMouse;								// <--
import kernel.CDebug;		

import input.CKeyboard;
import input.CKeyCodes;

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
import test.CSerializableQuad;

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
 

class CMainClient
{
	static var m_Stage	: STAGE;
	static var m_Quad	: CSerializableQuad;
	//static var m_Mouse	: CMouse; 					// <--
	static var m_Cpt	: Int;						// <--
	
	static var m_Img	: CRscImage;
	
	static var m_Editor : CEditorPanel = new CEditorPanel();
	
	#if js
	public static function InitGameJS()
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
		
		
		m_Quad = new CSerializableQuad();
		m_Quad.Initialize();
		
		m_Quad.SetCenterSize( CV2D.HALF, CV2D.ONE );
		m_Quad.SetCamera( CRenderer.VP_FULLSCREEN , l_OrthoCam );
		
		m_Quad.SetVisible( true );
		
		//m_Img = cast( Glb.g_System.GetRscMan().Load( CRscTexture.RSC_ID, "https://cvs.khronos.org/svn/repos/registry/trunk/public/webgl/doc/spec/WebGL-Logo.png" ), CRscImage);
		
		//m_Img = cast( Glb.g_System.GetRscMan().Load( CRscImage.RSC_ID, "http://www.alsacreations.com/xmedia/doc/full/webgl.gif" ), CRscImage);
		m_Img = cast( Glb.g_System.GetRscMan().Load( CRscImage.RSC_ID, "file:///D:/workspace/G4W/Data/Gfx/images/FX_EarthClod.png" ), CRscImage);
		CDebug.ASSERT(m_Img!= null);
		
		m_Quad.SetRsc( m_Img );
		
		//m_Quad.SetUV( CV2D.ZERO, CV2D.ONE );
		//m_Quad.GetMaterial().AttachTexture( 0, m_Tex );
		//m_Quad.GetPrimitive().
		
		m_Quad.Dump();

	}
	#end
	
	public static function TestBitArray()
	{
	
		var l_Ar = new CBitArray(32);
		
		l_Ar.Fill(false);
		if (l_Ar !=null)
		{
			l_Ar.Set(32, true);
		}
		
		if (l_Ar.Is(32) )
		{
			CDebug.CONSOLEMSG("t0 ok");
		}
		else 
		{
			CDebug.CONSOLEMSG("t0 wrong");
		}
		
		if (l_Ar.Is(33) )
		{
			CDebug.CONSOLEMSG("t1 ok");
		}
		else 
		{
			CDebug.CONSOLEMSG("t1 wrong");
		}
	}
	
	public static function InitGame()
	{
		var l_Arr : Array<IntPair> = new Array<IntPair>();
	
		l_Arr[0] = { 	m_Rsc : 33,
						m_Func : function(_Path : String) { return 666;  }};
						
		CDebug.CONSOLEMSG("Lambda = " + l_Arr[0].m_Func("bla") );
		
		
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
		var l_Img :C2DImage = new C2DImage();
		
		CDebug.CONSOLEMSG(  "type of 2dimg : " + (Std.is(l_Img,C2DImage) ? "yes" : "No") );
		
		m_Quad.Dump();
		
	
	}
	
	public static function UpdateGame()
	{
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
		
		//if( Glb.GetInputManager().)
		{
			
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