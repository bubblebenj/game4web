/**
 * ...
 * @author de
 */

package ;
import flash.geom.ColorTransform;
import flash.Lib;
import haxe.FastList;
import haxe.Public;
import input.CKeyCodes;
import rsc.CRscSitter;

import flash.display.BitmapData;
import flash.display.Bitmap;
import driver.as.renderer.C2DImageAS;
import haxe.TimerQueue;

import flash.geom.Point;

import kernel.Glb;
import kernel.CSystem;
import kernel.CTypes;
import kernel.CDebug;

import math.CV2D;
import rsc.CRscImage;

import renderer.CMaterial;
import CMinion;

import MTRG;


enum GameState
{
	GS_INVALID;
	GS_FIRST_FRAME;
	GS_LOADING;
	GS_RUNNING;
	GS_PAUSED;
}

enum ZOrder
{
	ZO_BG;
	ZO_MINION_PAD;
	
	ZO_MOTHERSHIP;
	
	ZO_ASTEROIDS;
	
	ZO_SPACESHIP;
}


class Game 
{
	var m_BG : CBG;
	var m_Asteroids : FastList< CAsteroid >;
	
	public var m_Tasks : List<CTimedTask>;
	
	public var m_Ship : CSpaceShip;
	public var m_CollMan : CCollManager;
	
	//UI
	var m_Pad : CMinionPad;
	var m_State : GameState;
	
	var m_SampleMinion: CMinion;
	//
	public var  m_RscSpaceInvader : CRscImage;
	
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
	}
	
	public function IsLoaded() : Bool
	{
		var l_Answer : Bool = m_BG.IsLoaded() && m_Pad.IsLoaded() && m_Ship.IsLoaded() && m_RscSpaceInvader.IsStreamed();
		
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
		#if debug
		CCollManager.UnitTest();
		#end
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
		
		var l_Sitter = new CRscSitter();
		m_SampleMinion = new CSpaceInvaderMinion();
		
	}
	
	public function OnLoaded()
	{
		Glb.GetRendererAS().SendToBack( m_BG.GetDisplayObject() ) ;
		Glb.GetRendererAS().SendToFront( m_Pad.GetDisplayObject() ) ;
		
		CDebug.CONSOLEMSG("Loaded");
	}
	
	public function Update()
	{
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
		
		switch(m_State)
		{
			case GS_FIRST_FRAME: m_State = GS_LOADING;
			case GS_LOADING: 
			
			if (!m_SampleMinion.IsLoaded()
			&&	m_RscSpaceInvader.IsStreamed() )
			{
				m_SampleMinion.Initialize();
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
		
		m_Ship.Update();
		m_CollMan.Update();
		
		m_Tasks =  Lambda.filter( 
									Lambda.map(m_Tasks, function( t) { return ( t.Update() == false ) ? t : null;} ),
									function(x) { return x != null; }
									);
		
		m_SampleMinion.Update();
		m_SampleMinion.visible = true;
		
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