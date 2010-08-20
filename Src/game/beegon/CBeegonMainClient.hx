/**
 * ...
 * @author bdubois
 * 
 */

import driver.as.renderer.C2DImageAS;
import kernel.CMouse;

import game.beegon.CAvatar;
import game.beegon.CHexaGrid;

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
	static var 	m_Stage 					: STAGE;
	inline public static var m_WorldUnit	: Float	= 40.0;		// Unit vector that defined coordinate are 40 pixel long

	// /!\ TEMP
	#if DebugInfo
	static var m_Cpt						: Int;
	static var g_ImageTest					: C2DImageAS;
	static var g_Avatar						: CAvatar;
	static var g_Grid						: CHexaGrid;
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
		
		g_ImageTest	= new C2DImageAS();
		g_ImageTest.Load( "./Data/vertical_hexcell1.png" );
		
		g_Avatar	= new CAvatar ();
		g_Avatar.SetSprite( "./Data/AvatarTypeA_64_64.png" );
		
		g_Grid 		= new CHexaGrid( 6, 40 );
		g_Grid.InitCellArray();
		
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
		var l_V2D : CV2D = new CV2D( 40, 40 );
		//g_ImageTest.SetSize( l_V2D );
		//g_ImageTest.MoveTo( l_V2D );
		//
		CV2D.Scale( l_V2D, 4, l_V2D );
		CV2D.Scale( l_V2D, 0.5, l_V2D );
		g_Avatar.SetSize( l_V2D );
		
		var l_Mouse	: CMouse	= Glb.g_System.GetMouse();
		
		g_Grid.Update();
		
		#if DebugInfo
			/* Mouse
			 **********/
			if (m_Cpt > 125)
			{
				//trace( "g_Avatar.SetCoordinate( l_V2D );");
				g_Avatar.SetCoordinate( l_V2D );
				trace ( l_Mouse.m_Coordinate.Trace() + " " + (( l_Mouse.m_Out ) ? " Out !" : " In " ));	m_Cpt = 0; 
				//g_Grid.Draw();
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
