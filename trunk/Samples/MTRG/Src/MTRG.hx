/**
 * ...
 * @author de
 */

package ;

import flash.display.BitmapData;
import driver.as.renderer.C2DImageAS;
import flash.Lib;
import haxe.TimerQueue;

import kernel.Glb;
import kernel.CSystem;
import kernel.CTypes;
import kernel.CDebug;

enum GAME_STAGE
{
	GS_INIT;
	GS_STARTING;
	GS_RUNNING;
}

class MTRG implements SystemProcess
{
	public static var s_Instance : MTRG; 
	public var m_State : GAME_STAGE;
	public var m_Gameplay : Game;
	public var m_LoadTimer : TimerQueue;
	
	
	public var m_Stats : CStatistics;
	public var m_Player : CPlayer;
	
	public function new() 
	{
		s_Instance = this;
	
		m_Stats =  new CStatistics();
		m_Player = new CPlayer();
		
		m_State = GS_INIT;
	}
	
	public function Startup()
	{
		m_State = GS_STARTING;
		m_Gameplay = new Game();
		m_Gameplay.Initialize();
		
		m_LoadTimer = new TimerQueue(10);
		
		var l_This = this;
		var l_LoadCheckFunc = null;
		l_LoadCheckFunc = 
			function()
			{
				var l_Done = true;
				if (! l_This.m_Gameplay.IsLoaded())
				{
					l_Done = false;
				}

				if(l_Done)
				{
					l_This.m_State = GS_RUNNING;
				}
				else
				{
					l_This.m_LoadTimer.add( l_LoadCheckFunc );
				}
			}
			
		m_LoadTimer.add( l_LoadCheckFunc );
	}
	

	function UpdateGame()
	{
		m_Gameplay.Update();
	}
	
	public function AfterUpdate() : Result
	{
		return SUCCESS;
	}
	
	public function BeforeUpdate() : Result
	{
		
		switch( s_Instance.m_State )
		{
			case GS_INIT:
				s_Instance.Startup();
				
			case GS_STARTING:
				s_Instance.m_State = GS_RUNNING;
				
			case GS_RUNNING:
				s_Instance.UpdateGame();
		}

		return SUCCESS;
	}

	public function AfterDraw() : Result
	{
		return SUCCESS;
	}
	
	public function BeforeDraw() : Result
	{
		return SUCCESS;
	}
	
	public static function main()
	{
		var l_MTRG = new MTRG();

		Lib.fscommand( "allowscale", "true");
		Lib.fscommand( "showmenu", "false");
		
		//WIDTH = Lib.fscommand.stage.width;
		//HEIGHT = Lib.current.stage.height;
		
		CDebug.CONSOLEMSG("w=" +WIDTH+ " h=" +HEIGHT);
		if( Glb.g_System == null )
		{
			CDebug.CONSOLEMSG("no g_system");
		}
		else 
		{
			CDebug.CONSOLEMSG("system init");
			Glb.g_System.Initialize();
			CDebug.CONSOLEMSG("main loop");
			
			Glb.g_System.m_Process = l_MTRG;
			
			Glb.g_System.MainLoop();
		}
	}
	
	public static var WIDTH : Float = 600;
	public static var HEIGHT : Float = 800;
	public static var ASTEROIDS_HEIGHT : Float = 275;
	public static var BOARD_X : Float = 100;
	public static var BOARD_WIDTH : Float = WIDTH - BOARD_X;
	
}