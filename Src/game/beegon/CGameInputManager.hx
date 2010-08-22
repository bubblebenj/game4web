/**
 * ...
 * @author Benjamin Dubois
 */

package game.beegon;

import haxe.Timer;

import tools.CFiniteStateMachine;
import kernel.Glb;
import math.CV2D;

enum MOUSE_STATE
{
	RELEASED;
	PRESSED;
	HELD;
}

enum MOUSE_TRANS_CONDITION
{
	DOWN;
	UP;
	HIT_TIMEOUT;
}

class CGameInputManager 
{
	public	var m_MouseFSM				: CFiniteStateMachine<MOUSE_STATE, MOUSE_TRANS_CONDITION>;
	public	var	m_LastMousePosition		: CV2D;
	public	var m_LastMouseLeftBtDown	: Bool;
	public	var	m_Avatar				: CAvatar;
	
	public function new( _Avatar	: CAvatar ) 
	{
		m_HoldDelay = 200;
		m_MouseFSM	= new CFiniteStateMachine( MOUSE_STATE.RELEASED );
		InitMouseFSM();
		m_Avatar	= _Avatar;
	}
	
	public function InitMouseFSM()			: Void
	{
		m_MouseFSM.AddTransition( MOUSE_STATE.RELEASED,	MOUSE_TRANS_CONDITION.DOWN,			MOUSE_STATE.PRESSED,	TrMousePressed );
		m_MouseFSM.AddTransition( MOUSE_STATE.PRESSED,	MOUSE_TRANS_CONDITION.UP,			MOUSE_STATE.RELEASED,	TrMouseHit );
		m_MouseFSM.AddTransition( MOUSE_STATE.PRESSED,	MOUSE_TRANS_CONDITION.HIT_TIMEOUT,	MOUSE_STATE.HELD,		TrMouseHeld );
		m_MouseFSM.AddTransition( MOUSE_STATE.HELD,		MOUSE_TRANS_CONDITION.UP,			MOUSE_STATE.RELEASED,	TrMouseReleased );
		trace ( m_MouseFSM.m_TransitionList[0] );
	}
	
	public function TrMousePressed()	: Void
	{
		// Start timer
		#if CInputButton
			trace ( "Mouse pressed" );
		#end
		m_Timer			= new Timer( m_HoldDelay );		//ms
		m_Timer.run 	= onTimeOut;
	}
	
	public function TrMouseHit()	: Void
	{
		m_Timer.stop();
		#if CInputButton
			trace ( "Mouse hit" );
		#end
		m_Avatar.TeleportTo( m_LastMousePosition );
	}
	
	public function TrMouseHeld()		: Void
	{
		#if CInputButton
			trace ( "Mouse held" );
		#end
		m_Avatar.SetFollowCursor( true );
	}
	
	public function TrMouseReleased()		: Void
	{
		#if CInputButton
			trace ( "Mouse released" );
		#end
		m_Avatar.SetFollowCursor( false );
	}
	
	private function onTimeOut()	: Void
	{
		#if CInputButton
			trace ( " ! TimeOut ! " );
		#end
		m_MouseFSM.SetEvent( HIT_TIMEOUT );
		m_Timer.stop();
	}
	
	public function Update()	: Void
	{
		if ( Glb.GetInputManager().m_Mouse.m_Down != m_LastMouseLeftBtDown )
		{
			m_LastMouseLeftBtDown	= Glb.GetInputManager().m_Mouse.m_Down;
			m_LastMousePosition		= Glb.GetInputManager().m_Mouse.m_Coordinate;
			m_MouseFSM.SetEvent( Glb.GetInputManager().m_Mouse.m_Down ? MOUSE_TRANS_CONDITION.DOWN : MOUSE_TRANS_CONDITION.UP );
			trace( m_MouseFSM.GetEvent() );
		}
		m_MouseFSM.Update();
	}
	
	private var m_HoldDelay : Int;
	private	var m_Timer		: Timer;
}