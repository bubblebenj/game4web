/**
 * ...
 * @author bdubois
 * 
 */

import flash.events.KeyboardEvent;
import flash.display.Sprite;
import driver.as.renderer.C2DImageAS;
import kernel.CTypes;
import kernel.Glb;
import math.CV2D;

enum ESHIFT
{
	ESHIFT_NONE;
	ESHIFT_CENTER;
}

class CBeegonMainClient
{
	inline public static var m_WorldUnit	: Float	= 40.0;		// Unit vector that defined coordinate are 40 pixel long
	
	static var m_Pause						: Bool;

	// /!\ TEMP
	#if DebugInfo
	static var m_Cpt						: Int;
	static var g_ImageTest	: C2DImageAS;
	#end
	
	public static function main()	: Void
	{
		/*****
		 * 
		 * INITIALISATION
		 * 
		 ****/
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
				
				Glb.g_System.m_BeforeUpdate	=  UpdateCallback;
				Glb.g_System.m_BeforeDraw	=  RenderCallback;
			}
		}
		
		g_ImageTest	= new C2DImageAS();
		g_ImageTest.Load( "./Data/vertical_hexcell1.png" );
		
		// /!\ TEMP
		#if DebugInfo
		m_Cpt = 0;
		#end
    }
	
	public static function UpdateCallback() : Result
	{
		var l_Coordinate	: CV2D = Glb.g_System.m_Mouse.m_Coordinate;
		
		if ( !g_ImageTest.IsVisible() ) g_ImageTest.SetVisible( true );
		
		#if DebugInfo
			/* Mouse
			 **********/
			if (m_Cpt > 20)
			{
				trace ( "[ " + l_Coordinate.x + " ][ " + l_Coordinate.y + " ]" );
				m_Cpt = 0;
			}
			else
			{
				m_Cpt++;
			}
		#end
		return SUCCESS;
	}
	
	static function RenderCallback() : Result
	{
		return SUCCESS;
	}
} 
