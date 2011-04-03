/****************************************************
 * MTRG : Motion-Twin recruitment game
 * A game by David Elahee
 * 
 * MTRG is a Space Invader RTS, the goal is to protect your mothership from
 * the random AI that shoots on it.
 * 
 * Powered by Game4Web a cross-platform engine by David Elahee & Benjamin Dubois.
 * 
 * @author de
 ****************************************************/
package ;

/*
 * this class manages the gameplay and its time sequencing
 * */

import CMinion;
import flash.display.BlendMode;
import flash.display.Shape;
import flash.media.Sound;
import flash.system.System;
import haxe.FastList;
import haxe.Log;
import input.CKeyCodes;
import kernel.CDebug;
import kernel.Glb;
import math.CV2D;
import math.Registers;
import MTRG;
import rsc.CRscImage;
import rsc.CRscSitter;

////////////////////gameplay sequencing (not same granularity as game
enum GameState
{
	GS_INVALID;
	GS_FIRST_FRAME;
	GS_LOADING;
	GS_RUNNING;
	GS_PAUSED;
}

////////////////////
enum DNDState
{
	DND_FREE;
	DND_SOME( _Mob : CMinion );
}

//ok let s go
class Game 
{
	//some drawings
	var m_BG : CBG;
	var m_Asteroids : FastList< CAsteroid >;
	
	//fast tasking , i don 't love tweens
	public var m_Tasks : List<CTimedTask>;
	
	public var m_Ship : CSpaceShip;
	public var m_CollMan : CCollManager;
	public var m_Mothership : CMothership;
	
	//UI
	var m_Pad : CMinionPad;
	var m_State : GameState;
	
	
	//some things that shoudn be there
	public var  m_RscSpaceInvader : CRscImage;
	public var  m_DND : DNDState;
	
	public var 	m_MinionHelper: CMinionHelper;
	public var	m_ProjectileHelper: CProjectileHelper;
	
	//game play
	public var 	m_PlacingLimitLine : Shape;
	public var 	m_PlaceLimit : Float;
	
	////////////////////////////////////////////////////////////
	public function new() 
	{
		m_BG = null;
		m_Asteroids = null;
		m_Pad = null;
		m_Ship = null;
		m_State = GS_INVALID;
		m_CollMan = null;
		m_Tasks = null;
		m_RscSpaceInvader = null;
		m_DND = DND_FREE;
		m_MinionHelper = new CMinionHelper();
		
		m_PlaceLimit = 0.2;

		m_Mothership = new CMothership();
		m_ProjectileHelper = null;
	}
	
	
	
	////////////////////////////////////////////////////////////
	public function IsLoaded() : Bool
	{
		var l_Answer : Bool = m_BG.IsLoaded() && m_Pad.IsLoaded() && m_Ship.IsLoaded() && m_RscSpaceInvader.IsStreamed() && m_MinionHelper.IsLoaded();
		
		//early escape
		if (!l_Answer)
		{
			return l_Answer;
		}
		l_Answer = Lambda.fold( m_Asteroids, function( a, b ) { return a.IsLoaded() && b;  }, l_Answer);
		return l_Answer;
	}
	
	////////////////////////////////////////////////////////////
	public function SetVisible( _onOff : Bool )
	{
		m_BG.m_Img.SetVisible(_onOff);
		m_Pad.visible = _onOff;
		m_Ship.SetVisible( _onOff );
		Lambda.iter( m_Asteroids, function( a ) { a.visible = _onOff;  } );
		m_PlacingLimitLine.visible = _onOff;
		m_Mothership.SetVisible(_onOff);
	}
	
	////////////////////////////////////////////////////////////
	public function Initialize()
	{	
		Log.setColor(0xFF0000);
		
		m_Tasks = new List<CTimedTask>();
		m_CollMan = new CCollManager();
		
		m_BG = new CBG();
		m_BG.Initialize();
		
		m_Pad = new CMinionPad();
		m_Pad.Initialize();
	
		m_Asteroids = new FastList<CAsteroid>();
		var l_NbAster = Std.int( 16 + Math.random() * 4 );
		
		for ( i in 0...l_NbAster )
		{
			m_Asteroids.add( new CAsteroid() );
		}
		
		var i = 0;
		for( a in m_Asteroids )
		{
			a.Initialize();
			a.x = MTRG.BOARD_X + (i / (l_NbAster - 1) ) * (MTRG.BOARD_WIDTH - CAsteroid.MAX_WIDTH * 2.0) + CAsteroid.MAX_WIDTH;
			
			if (i < l_NbAster-3)
			{
				a.x += ((Math.random() < 0.5) ? -1:1)  * ( Math.random() * CAsteroid.MAX_WIDTH - CAsteroid.MAX_WIDTH * 0.5);
			}
			a.y = MTRG.HEIGHT * 0.5 + (Math.random() - 0.5) * MTRG.ASTEROIDS_HEIGHT;
			//a.y = 300;
			i++;
			
			m_CollMan.Add(a);
		}
		
		m_Ship = new CSpaceShip();
		m_Ship.Initialize();
		
		m_RscSpaceInvader = cast kernel.Glb.GetSystem().GetRscMan().Load( CRscImage.RSC_ID, "Data/spaceinvader.png" ); 
		
		m_PlacingLimitLine = new Shape();
		m_PlacingLimitLine.blendMode = BlendMode.ADD;
		m_PlacingLimitLine.graphics.lineStyle( 3, 0x00FF00, 0.15);
		m_PlacingLimitLine.graphics.moveTo(MTRG.BOARD_X, m_PlaceLimit * MTRG.HEIGHT );
		m_PlacingLimitLine.graphics.lineTo(MTRG.WIDTH, m_PlaceLimit * MTRG.HEIGHT );
		m_PlacingLimitLine.visible = false;
		Glb.GetRendererAS().AddToSceneAS(m_PlacingLimitLine);
		
		m_Mothership.Initialize();
		
		m_ProjectileHelper = new CProjectileHelper();
		m_ProjectileHelper.Initialize();
		
		m_State = GS_FIRST_FRAME;
	}

	
	////////////////////////////////////////////////////////////
	public function GameOver( _Win : Bool )
	{
		CDebug.CONSOLEMSG("You " + (_Win ? "WIN" : "LOSE") + "!!!");
		MTRG.s_Instance.m_State = GS_END_SCREEN(_Win);
	}
	
	////////////////////////////////////////////////////////////
	public function OnLoaded()
	{
		Glb.GetRendererAS().SendToBack( m_BG.GetDisplayObject() ) ;
		Glb.GetRendererAS().SendToFront( m_Pad.GetDisplayObject() ) ;
	}
	
	
	////////////////////////////////////////////////////////////
	public function PlaceCurrentDND()
	{
		switch( m_DND)
		{
			case DND_SOME(_Mob):
			if (Glb.GetInputManager().GetMouse().GetPosition().y <= m_PlaceLimit )
			{
				_Mob.m_Center.Copy( Glb.GetInputManager().GetMouse().GetPosition() );
				_Mob.visible = true;
				_Mob.m_HasAI = true;
			}
			else
			{
				_Mob.visible = false;
				m_MinionHelper.Delete( _Mob );
			}
			default: CDebug.BREAK("Should not happen");
		}
		m_DND = DND_FREE;
		//CDebug.CONSOLEMSG("PlaceCurrentDND");
	}

	////////////////////////////////////////////////////////////
	public function Start()
	{
		m_State = GS_FIRST_FRAME;
	}

	////////////////////////////////////////////////////////////
	public function Update()
	{
		/*
		 * */
		
		#if debug
		if( Glb.GetInputManager().GetMouse().IsDown())
		{
			if( CCollManager.TestCircleRect( Glb.GetInputManager().GetMouse().GetPosition(), 1 / MTRG.HEIGHT,
							CV2D.Sub( Registers.V2_0, m_Mothership.m_Center, new CV2D(128 / MTRG.HEIGHT,16/ MTRG.HEIGHT)),
							CV2D.Add( Registers.V2_1, m_Mothership.m_Center, new CV2D(128 / MTRG.HEIGHT,16/ MTRG.HEIGHT))
						))
			{
				//CDebug.CONSOLEMSG("Touched");
			}
			else
			{
				//CDebug.CONSOLEMSG("Missed");
			}
		}
		#end
		
		#if debug
		if( Glb.GetInputManager().GetMouse().IsDown())
		{
			if( CCollManager.TestCircleRect( Glb.GetInputManager().GetMouse().GetPosition(), 1 / MTRG.HEIGHT,
							CV2D.Sub( Registers.V2_0, m_Mothership.m_Center, new CV2D(128 / MTRG.HEIGHT,16/ MTRG.HEIGHT)),
							CV2D.Add( Registers.V2_1, m_Mothership.m_Center, new CV2D(128 / MTRG.HEIGHT,16/ MTRG.HEIGHT))
						))
			{
				//CDebug.CONSOLEMSG("Touched");
			}
			else
			{
				//CDebug.CONSOLEMSG("Missed");
			}
		}
		#end
		
		#if debug
		if ( Glb.GetInputManager().GetKeyboard().IsKeyDown( CKeyCodes.KEY_ADD)
		&&	!Glb.GetInputManager().GetKeyboard().WasKeyDown(CKeyCodes.KEY_ADD))
		{
			Glb.g_System.m_SpeedFactor += 0.5;
		}
		
		if ( Glb.GetInputManager().GetKeyboard().IsKeyDown( CKeyCodes.KEY_SUBTRACT)
		&&	!Glb.GetInputManager().GetKeyboard().WasKeyDown(CKeyCodes.KEY_SUBTRACT))
		{
			Glb.g_System.m_SpeedFactor -= 0.5;
		}
		
		if ( Glb.GetInputManager().GetKeyboard().IsKeyDown( CKeyCodes.KEY_MULTIPLY)
		&&	!Glb.GetInputManager().GetKeyboard().WasKeyDown(CKeyCodes.KEY_MULTIPLY))
		{
			Glb.g_System.m_SpeedFactor = 1;
		}
		
		if ( Glb.GetInputManager().GetKeyboard().IsKeyDown( CKeyCodes.KEY_F1)
		&&	!Glb.GetInputManager().GetKeyboard().WasKeyDown(CKeyCodes.KEY_F1))
		{
			CDebug.CONSOLEMSG( m_CollMan.toString() );
		}
		#end
		
		switch(m_State)
		{
			case GS_FIRST_FRAME: m_State = GS_LOADING;
			case GS_LOADING: 
			
			if (!m_MinionHelper.IsLoaded()
			&&	m_RscSpaceInvader.IsStreamed() )
			{
				m_MinionHelper.Initialize();
				m_Pad.Populate();
				OnLoaded();
			}
			
			if ( IsLoaded())
			{
				OnLoaded(); 
				//SetVisible(false);
				//m_State = GS_RUNNING;
			}
			else
			{
				return;
			}
			case GS_PAUSED: Glb.GetSystem().m_IsPaused = true; return;
			case GS_RUNNING: Glb.GetSystem().m_IsPaused = false;
			
			case GS_INVALID: CDebug.CONSOLEMSG("Fatal error");  return;
		}
				
		for(a in m_Asteroids)
		{
			a.Update();
		}
		
		m_Pad.Update();
		m_Ship.Update();
		m_MinionHelper.Update();
		m_Mothership.Update();
		m_ProjectileHelper.Update();
		m_CollMan.Update();
		
		//quick tasking filtering
		m_Tasks =  Lambda.filter( 
									Lambda.map(m_Tasks, function( t) { return ( t.Update() == false ) ? t : null;} ),
									function(x) { return x != null; }
									);
	}
	
	////////////////////////////////////////////////////////////
	public function Shut()
	{
		for(a in m_Asteroids)
		{
			a.Shut();
		}
		m_Asteroids = null;
		
		m_BG.Shut();
		m_BG = null;
		
		m_Pad.Shut();
		m_Pad = null;
		
		m_Ship.Shut();
		m_Ship = null;
		
		m_CollMan  = null;
		m_Tasks = null;
		
		m_MinionHelper.Shut();
		m_MinionHelper = null;
		
		m_Mothership.Shut();
		m_Mothership = null;
		
		m_ProjectileHelper.Shut();
		m_ProjectileHelper = null;
		
		Glb.GetRendererAS().RemoveFromSceneAS(m_PlacingLimitLine);
		System.gc();
		System.gc();
	}
	
}