/**
 * ...
 * @author de
 */

package ;


import CMinion;
import flash.display.BlendMode;
import flash.display.Shape;
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


enum GameState
{
	GS_INVALID;
	GS_FIRST_FRAME;
	GS_LOADING;
	GS_RUNNING;
	GS_PAUSED;
}

enum DNDState
{
	DND_FREE;
	DND_SOME( _Mob : CMinion );
}

//might need to check those in
enum ZOrder
{
	ZO_BG;
	ZO_MINION_PAD;
	ZO_MOTHERSHIP;
	ZO_ASTEROIDS;
	ZO_SPACESHIP;
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
	
	//game play
	public var 	m_PlacingLimitLine : Shape;
	public var 	m_PlaceLimit : Float;
	
	public var 	m_ActiveMonsterList : List<CMinion>; 
	
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
		
		m_ActiveMonsterList = new List<CMinion>();
		m_Mothership = new CMothership();
	}
	
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
	
	public function SetVisible( _onOff : Bool )
	{
		m_BG.m_Img.SetVisible(_onOff);
		m_Pad.visible = _onOff;
		m_Ship.m_Ship.visible = _onOff;
		Lambda.iter( m_Asteroids, function( a ) { a.visible = _onOff;  });
	}
	
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
			a.visible = true;
			i++;
			
			m_CollMan.Add(a);
		}
		
		m_Ship = new CSpaceShip();
		m_Ship.Initialize();
		m_State = GS_FIRST_FRAME;
		
		m_RscSpaceInvader = cast kernel.Glb.GetSystem().GetRscMan().Load( CRscImage.RSC_ID, "Data/spaceinvader.png" ); 
		
		m_PlacingLimitLine = new Shape();
		m_PlacingLimitLine.blendMode = BlendMode.ADD;
		m_PlacingLimitLine.graphics.lineStyle( 3, 0x00FF00, 0.75);
		m_PlacingLimitLine.graphics.moveTo(MTRG.BOARD_X, m_PlaceLimit * MTRG.HEIGHT );
		m_PlacingLimitLine.graphics.lineTo(MTRG.WIDTH, m_PlaceLimit * MTRG.HEIGHT );
		m_PlacingLimitLine.visible = true;
		Glb.GetRendererAS().AddToSceneAS(m_PlacingLimitLine);
		
		m_Mothership.Initialize();
	}
	
	public function GameOver( _Win : Bool )
	{
		CDebug.CONSOLEMSG("You " + (_Win ? "WIN" : "LOSE")+ "!!!");
	}
	
	public function OnLoaded()
	{
		Glb.GetRendererAS().SendToBack( m_BG.GetDisplayObject() ) ;
		Glb.GetRendererAS().SendToFront( m_Pad.GetDisplayObject() ) ;
		
		CDebug.CONSOLEMSG("Loaded");
	}
	
	public function PlaceCurrentDND()
	{
		switch( m_DND)
		{
			case DND_SOME(_Mob):
			if (Glb.GetInputManager().GetMouse().GetPosition().y <= m_PlaceLimit )
			{
				_Mob.x = Glb.GetInputManager().GetMouse().GetPosition().x * MTRG.HEIGHT;
				_Mob.y = Glb.GetInputManager().GetMouse().GetPosition().y * MTRG.HEIGHT;
				_Mob.visible = true;
				m_ActiveMonsterList.add( _Mob );
			}
			else
			{
				_Mob.visible = false;
				m_MinionHelper.Delete( _Mob );
			}
			default: CDebug.BREAK("Should not happen");
		}
		m_DND = DND_FREE;
		//trace("PlaceCurrentDND");
	}
	

	
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
				CDebug.CONSOLEMSG("Touched");
			}
			else
			{
				CDebug.CONSOLEMSG("Missed");
			}
		}
		#end
		
		#if debug
		if ( Glb.GetInputManager().GetKeyboard().IsKeyDown( CKeyCodes.KEY_P)
		&&	!Glb.GetInputManager().GetKeyboard().WasKeyDown(CKeyCodes.KEY_P))
		{
			if (m_State == GS_RUNNING)
			{
				m_State = GS_PAUSED;
			}
			else if (m_State == GS_PAUSED)
			{
				m_State = GS_RUNNING;
			}
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
			}
			
			if ( IsLoaded())
			{
				OnLoaded(); 
				//SetVisible(false);
				m_State = GS_RUNNING;
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
		m_CollMan.Update();
		
		//quick tasking filtering
		m_Tasks =  Lambda.filter( 
									Lambda.map(m_Tasks, function( t) { return ( t.Update() == false ) ? t : null;} ),
									function(x) { return x != null; }
									);
									
		Lambda.iter( Lambda.list( m_ActiveMonsterList), function(x) { x.Update(); } );
		
		m_Mothership.Update();
	}
	
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
		
	}
	
}