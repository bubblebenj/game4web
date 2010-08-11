/**
 * ...
 * @author bdubois
 * 
 */

import flash.display.MovieClip;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.display.Sprite;
import flash.Lib;
import driver.as.renderer.C2DImageAS;
import kernel.CMouse;

import math.CV2D;

class CBeegonMainClient
{
	inline public static var m_WorldUnit	: Float	= 40.0;		// Unit vector that defined coordinate are 40 pixel long

	#if flash
	public var m_Root						: MovieClip;
	#end
	public var m_Mouse						: CMouse;

	public var m_Pause						: Bool;
	
	#if flash
    public function new( _Parent : MovieClip )	: Void
	#end
	{
		trace ( "\t new CBeegonMainClient" ); 
		
		m_Root				= _Parent;
		m_Mouse				= new CMouse();
		
		flash.Lib.current.addEventListener( Event.ENTER_FRAME, MainLoop );
		trace ( "\t fin new CBeegonMainClient" );
    }
	
	public static function main()	: Void
	{
		/*****
		 * 
		 * INITIALISATION
		 * 
		 ****/
		#if Flash10
			var g_Game		: CBeegonMainClient		= new CBeegonMainClient( Lib.current );
		#end
		#if DebugInfo
			//var DebugSprite	: Sprite		= new Sprite();
			//DebugSprite.graphics.beginFill( 0x0000CC, 0.1);
			//DebugSprite.graphics.lineStyle( 1, 0xCC0000, 0.5 );
			//DebugSprite.graphics.drawRect(0 , 0, CBeegonMainClient.m_WorldUnit, CBeegonMainClient.m_WorldUnit);
			//DebugSprite.graphics.endFill();
			//g_Game.m_Root.addChild( DebugSprite );
		#end
		
		var g_ImageTest	: C2DImageAS	= new C2DImageAS();
    }
	
	public function MainLoop( _Event : Event )	: Void
	{
		var l_Coordinate	: CV2D = m_Mouse.m_Coordinate;
		
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
