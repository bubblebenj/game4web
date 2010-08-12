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

class CBeegonMainClient
{
	inline public static var m_WorldUnit	: Float	= 40.0;		// Unit vector that defined coordinate are 40 pixel long
	
	static var m_Pause						: Bool;
	
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
		
		#if DebugInfo
			var DebugSprite	: Sprite		= new Sprite();
			DebugSprite.graphics.beginFill( 0x0000CC, 0.1);
			DebugSprite.graphics.lineStyle( 1, 0xCC0000, 0.5 );
			DebugSprite.graphics.drawRect(0 , 0, CBeegonMainClient.m_WorldUnit/2, CBeegonMainClient.m_WorldUnit);
			DebugSprite.graphics.endFill();
			//Glb.g_System.GetRenderer().m_SwfRoot.addChild( DebugSprite );
		#end

		var g_ImageTest	: C2DImageAS	= new C2DImageAS();
		g_ImageTest.Load( "./Data/vertical_hexcell1.png" );
		//Glb.g_System.GetRenderer().AddToScene( g_ImageTest );
		
    }
	
	public static function UpdateCallback() : Result
	{
		var l_Coordinate	: CV2D = Glb.g_System.m_Mouse.m_Coordinate;
		
		#if DebugInfo
			/* Mouse
			 **********/
			//trace ( "[ " + l_Coordinate.x + " ][ " + l_Coordinate.y + " ]" );
			
		#end
		return SUCCESS;
	}
	
	static function RenderCallback() : Result
	{
		return SUCCESS;
	}
} 
