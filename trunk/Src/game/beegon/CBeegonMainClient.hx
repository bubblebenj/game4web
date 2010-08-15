/**
 * ...
 * @author bdubois
 * 
 */

import driver.as.renderer.C2DImageAS;
import game.beegon.CAvatar;
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
		m_Cpt = 500;
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
		var l_V2D : CV2D = new CV2D( 40, 40 );
		g_ImageTest.SetSize( l_V2D );
		g_ImageTest.MoveTo( l_V2D );
		
		CV2D.Scale( l_V2D, 4, l_V2D );
		g_Avatar.SetCoordinate( l_V2D );
		CV2D.Scale( l_V2D, 0.5, l_V2D );
		g_Avatar.SetSize( l_V2D );
		
		var l_Mouse	: CV2D = Glb.g_System.m_Mouse.m_Coordinate;
		
		
		//!\ Need to put it in the renderer.
		if ( !g_ImageTest.IsVisible() ) g_ImageTest.SetVisible( true );
		if ( !g_Avatar.m_Sprite.IsVisible() ) g_Avatar.m_Sprite.SetVisible( true );
		
		#if DebugInfo
			/* Mouse
			 **********/
			if (m_Cpt > 500)
			{
				trace ( "[ " + l_Mouse.x + " ][ " + l_Mouse.y + " ]" ); 	m_Cpt = 0; 
			}
			else	m_Cpt++;
		#end
	}
	
	static function RenderCallback() : Result
	{
		return SUCCESS;
	}
} 
