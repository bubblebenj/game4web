
package kernel;

import flash.events.Event;
import flash.Lib;
import kernel.CTypes;
import haxe.Timer;
import haxe.TimerQueue;
import kernel.Glb;
import kernel.CDisplay;
import math.Utils;
import renderer.CRenderer;
import rsc.CRscCommonFactory;
import rsc.CRscMan;
import rsc.CRsc;

class CSystem
{
	public function GetGameTime() : Float
	{
		return m_GameTime;
	}
	
	public function GetFrameTime() : Float
	{
		return m_FrameTime;
	}
	
	public function GetGameDeltaTime() : Float
	{
		return m_GameDeltaTime;
	}
	
	public function GetDeltaTime() : Float
	{
		return m_FrameDeltaTime;
	}
	
	public function GetFrameRate()	: Int
	{
		return FRAMERATE;
	}
	
	public function new()
	{
		m_FrameTime = 0;
		m_GameTime = 0;
		
		m_FrameDeltaTime = 0;
		m_GameDeltaTime = 0;
		m_ForceFPS = 0;
		
		m_Process = null;
		
		m_RscMan = null;
		m_Renderer = null;
		
		m_InputManager	= null;
		
		m_Display = new CDisplay();
		
		m_IsPaused = false;
		
		//CDebug.CONSOLEMSG("Master system newed");
	}
	
	public function Initialize() : Result
	{
		m_SysTimer = new TimerQueue( Utils.RoundNearest( DT * 1000 ));
		
		m_RscMan = new CRscMan();
		m_RscMan.Initialize();
		
		return SUCCESS;
	}
	
	#if flash
	public static  function ClosedStaticUpdate(e)	: Void
	{
		 Glb.StaticUpdate();
	}
	#end
	
	public function MainLoop()
	{
		// Glb.StaticUpdate actually do g_System.Update();
		#if flash
		Lib.current.addEventListener( Event.ENTER_FRAME, ClosedStaticUpdate );
		#else
		m_SysTimer.add( Glb.StaticUpdate );
		#end
	}
	
	public function Update()
	{
		//trace("CSystem::Update");
		m_FrameCount++;
		
		//if (m_FrameCount > 20)
		{
			//TODO : fixme
			m_FrameDeltaTime = (DT);
			
			m_FrameTime += m_FrameDeltaTime;
			
			if(m_ForceFPS != 0)
			{
				m_FrameDeltaTime = 1.0 / m_ForceFPS;
			}
			
			if(!m_IsPaused)
			{
				m_GameDeltaTime = m_FrameDeltaTime;	
			}
			else
			{
				m_GameDeltaTime = 0;
			}
			
			m_GameTime += m_GameDeltaTime;
			
			
			
			if( m_Process != null)
			{
				m_Process.BeforeUpdate();
			}
			
			//trace("CSystem::Bf Updt");
			
			if( m_Process != null)
			{
				m_Process.AfterUpdate();
			}
			
			//trace("CSystem::Af Updt");
			if( m_Process != null)
			{
				m_Process.BeforeDraw();
			}
			
			//trace("CSystem::rd Updt");
			m_Renderer.Update();
			
			//trace("CSystem::af Drw");
			if( m_Process != null)
			{
				m_Process.AfterDraw();
			}
			
			GetInputManager().Update();
		}
		
		
		//trace("CSystem::Adding timer");
		#if flash
		
		#else
		m_SysTimer.add( Glb.StaticUpdate );
		#end
	}
	
	
	public function GetRscMan() : CRscMan
	{
		return m_RscMan;
	}
	
	public function GetFrameCount() : Int
	{
		return m_FrameCount;
	}
	
	public inline function GetRenderer() : CRenderer
	{
		return m_Renderer;
	}
	
	public inline function GetInputManager() : CInputManager
	{
		return m_InputManager;
	}
	
	public function InitializeRscBuilders() : Result
	{
		CDebug.CONSOLEMSG("Builders created");
		
		//GetRscMan().AddBuilder( CMenuGraph.RSC_ID, 	m_RscCommonFactory );
		
		return SUCCESS;
	}
	
	public var m_Process : SystemProcess;
	
	public static inline var FRAMERATE : Int = 60;
	public static inline var DT : Float = 1.0 / FRAMERATE;
	
			var m_FrameTime	: Float;
			var m_GameTime : Float;
	
			var m_FrameDeltaTime : Float;
			var m_GameDeltaTime : Float;
			var m_ForceFPS : Float;
	
			var m_FrameCount : Int;
	
	public 	var m_IsPaused : Bool;
	
			var m_SysTimer : haxe.TimerQueue;  
	
			var m_RscMan	: CRscMan;
			var m_Renderer	: CRenderer;
			
			var m_InputManager	: CInputManager;
			
	private	var m_RscCommonFactory	: CRscCommonFactory;
	
	public 	var m_Display:  CDisplay;
}


