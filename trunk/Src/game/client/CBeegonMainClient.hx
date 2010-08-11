/**
 * ...
 * @author bdubois
 * 
 */

import flash.display.MovieClip;
import flash.events.KeyboardEvent;
import flash.display.Sprite;

import driver.as.renderer.C2DImageAS;
import kernel.CMouse;

import kernel.Glb;
import math.CV2D;

class CBeegonMainClient
{
	inline public static var m_WorldUnit	: Float	= 40.0;		// Unit vector that defined coordinate are 40 pixel long
	public var m_Root						: MovieClip;
	public var m_Pause						: Bool;
	
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
				
				Glb.g_System.m_BeforeUpdate =  UpdateCallback;
				Glb.g_System.m_BeforeDraw =  RenderCallback;
			}
		}
		 
		m_Root	= Lib.current;
		
		#if DebugInfo
			var DebugSprite	: Sprite		= new Sprite();
			DebugSprite.graphics.beginFill( 0x0000CC, 0.1);
			DebugSprite.graphics.lineStyle( 1, 0xCC0000, 0.5 );
			DebugSprite.graphics.drawRect(0 , 0, CBeegonMainClient.m_WorldUnit, CBeegonMainClient.m_WorldUnit);
			DebugSprite.graphics.endFill();
			g_Game.m_Root.addChild( DebugSprite );
		#end
		
		var g_ImageTest	: C2DImageAS	= new C2DImageAS();
		g_ImageTest.Load( "./Data/vertical_hexcell1.png" );
    }
	
	public static function UpdateCallback()	: Void
	{
		var l_Coordinate	: CV2D = Glb.g_System.m_Mouse.m_Coordinate;
		
		#if DebugInfo
			/* Mouse
			 **********/
			trace ( "[ " + l_Coordinate.x + " ][ " + l_Coordinate.y + " ]" );
			
			//l_Grid_x	= l_Coordinate.x - m_Stage.m_Grid.Global().x;
			//l_Grid_y	= l_Coordinate.y - m_Stage.m_Grid.Global().y;
			
			//trace ( "[ " + l_Grid_x + " ][ " + l_Grid_y + " ]" );
			
			//l_PosHexaSouris = m_Stage.m_Grid.FromOrthoToHexa( new CVector2D( l_Grid_x, l_Grid_y ) );
			//trace ( "Cell[ " + l_PosHexaSouris.x + " ][ " + l_PosHexaSouris.y + " ]" );
			
		#end
	}
} 
