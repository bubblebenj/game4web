/**
 * ...
 * @author bdubois
 * 
 */

import driver.as.renderer.CTextFieldAS;
import kernel.CMouse;
import logic.CMenuGraph;
import logic.CMenuNode;
import renderer.C2DImage;

import game.beegon.CAvatar;
import game.beegon.CHexaGrid;
import game.beegon.CGameInputManager;

import rsc.CRsc;
import kernel.CTypes;
import kernel.Glb;
import math.CV2D;

enum STAGE
{
	STAGE_INIT;
	STAGE_UPDATE;
}

class CBeegonMainClient
{
	inline public static var m_WorldUnit	: Float	= 40.0;		// Unit vector that defined coordinate are 40 pixel long
	static var 	m_Stage 					: STAGE;
	static var	g_GameMenu					: CMenuGraph;

	// /!\ TEMP
	#if DebugInfo
		static var m_Cpt					: Int;
		static var g_Avatar					: CAvatar;
		static var g_Grid					: CHexaGrid;
		static var m_InputManager			: CGameInputManager;
		static var m_TestImage				: C2DImage;
		static var m_TestText				: CTextFieldAS;
	#end
	
	public static function main()	: Void
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
			
			Glb.g_System.m_BeforeUpdate	=  UpdateCallback;
			Glb.g_System.m_BeforeDraw	=  RenderCallback;
		}
		
		// /!\ TEMP
		#if DebugInfo
		m_Cpt = 125;
		#end
    }
	
	public static function UpdateCallback() : Result
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
	
	public static function InitGame()
	{
		trace ( " Initialising game .. " );
		
		g_GameMenu	= new CMenuGraph();
		g_GameMenu.AddMenuNode( new CMenuNode( "MainMenu" ) );
		g_GameMenu.AddMenuNode( new CMenuNode( "Game" ) );
		g_GameMenu.AddMenuNode( new CMenuNode( "Option" ) );
		g_GameMenu.GetMenuNode( "MainMenu" ).AddTransition( "Game" );
		g_GameMenu.GetMenuNode( "MainMenu" ).AddTransition( "Option" );
		g_GameMenu.GetMenuNode( "Game" ).AddTransition( "MainMenu", "QuitGame" );
		g_GameMenu.GetMenuNode( "Option" ).AddTransition( "MainMenu" );
		g_GameMenu.Initialise( "MainMenu" );
		
		
		g_Grid 		= new CHexaGrid( 7, 36 );
		g_Grid.InitCellArray();
		
		g_Avatar	= new CAvatar ();
		g_Avatar.SetSprite( "./Data/AvatarTypeA_64_64.png" );
		g_Avatar.SetSpeed( m_WorldUnit * 0.7 );
		
		m_InputManager = new CGameInputManager( g_Avatar, g_GameMenu );
		
		m_TestText = new CTextFieldAS();
		m_TestText.Load( "test" );
		
		var l_V2D_Pos	: CV2D = new CV2D( 600, 30 );
		m_TestText.SetTLPosition( l_V2D_Pos );
		
		#if flash10
			InitGameAS();
		#end
		trace ( " done " );
	}
	
	#if flash10
	public static function InitGameAS()
	{
		trace ( " \t \t Initialising AS .." );
		trace ( " \t \t done " );
	}
	#end
	
	public static function UpdateGame()
	{
		//trace( "Update");
		m_TestText.Update();
		var l_Mouse	: CMouse	= Glb.g_System.GetMouse();
		
		g_Grid.Update();
		
		m_InputManager.Update();
		
		g_Avatar.Update();
		
		#if DebugInfo
			/* Mouse
			 **********/
			if (m_Cpt > 125)
			{
				//trace( "g_Avatar.SetCoordinate( l_V2D );");
				//trace ( l_Mouse.m_Coordinate.Trace() + " " + (( l_Mouse.m_Out ) ? " Out !" : " In " ));	m_Cpt = 0; 
			}
			else	m_Cpt++;
		#end
	}
	
	static function RenderCallback() : Result
	{
		g_Grid.Draw();
		return SUCCESS;
	}
} 
