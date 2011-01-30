/**
 * ...
 * @author Benjamin Dubois
 */

package logic;

import CDriver;
import math.CV2D;

import kernel.Glb;
import kernel.CTypes;

import logic.CFiniteStateMachine;

import renderer.C2DContainer;


enum BUTTON_INTERACTION_STATE 
{
	B_IST_UP;
	B_IST_DOWN;
	B_IST_CANCELLED;
	B_IST_DISABLED;
	B_IST_INVALID;
}

enum BUTTON_VISUAL_STATE 
{
	B_VST_IDLE;
	B_VST_PRESS;
	B_VST_RELEASE;
	B_VST_INVALID;
}

enum BUTTON_TRANS_CONDITION
{
	B_TC_RELEASED;
	B_TC_PRESSED;
	B_TC_MOUSE_OUT;
	B_TC_SET_ON;
	B_TC_SET_OFF;
}

class CButton extends C2DContainer
{
	private var m_InteractFSM	: CFiniteStateMachine<BUTTON_INTERACTION_STATE, BUTTON_TRANS_CONDITION>;
	private var	m_Callback		: Dynamic -> Void;
	private var m_Argument		: Array<Dynamic>;
	
	public function new()
	{
		super();
		m_InteractFSM		= new CFiniteStateMachine<BUTTON_INTERACTION_STATE, BUTTON_TRANS_CONDITION>();
		CreateActuators();
		m_InteractFSM.Initialize( B_IST_DISABLED );
	}
	
	public function SetCmd( _Callback	: Dynamic, ?_Argument	: Array<Dynamic> )
	{
		m_Callback		= _Callback;
		if ( _Argument != null )
		{
			m_Argument		= _Argument;
		}
		else
		{
			m_Argument		= new Array<Dynamic>();
		}
	}
	
	private function CreateActuators()			: Void
	{
		m_InteractFSM.AddTransition( B_IST_UP,			B_TC_PRESSED,	B_IST_DOWN,			TrBtPressed );
		m_InteractFSM.AddTransition( B_IST_DOWN,		B_TC_RELEASED,	B_IST_UP,			TrBtUsed );
		m_InteractFSM.AddTransition( B_IST_DOWN,		B_TC_MOUSE_OUT,	B_IST_CANCELLED,	TrBtCancel );
		m_InteractFSM.AddTransition( B_IST_CANCELLED,	B_TC_RELEASED,	B_IST_UP,			TrBtFreed );
		
		m_InteractFSM.AddTransition( B_IST_DISABLED,	B_TC_SET_ON,	B_IST_UP,			TrBtOn );
		m_InteractFSM.AddTransition( B_IST_UP,			B_TC_SET_OFF,	B_IST_DISABLED,		TrBtOff );
	}
	
	public function MouseOver() : Bool
	{
		return Intersects( Glb.GetInputManager().GetMouse().GetPosition() );
	}
	
	public override function Update() : Result
	{
		super.Update();
		
		if ( ! MouseOver() )
		{
			m_InteractFSM.m_CurrentActuator = B_TC_MOUSE_OUT;
		}
		else
		{
			if ( Glb.GetInputManager().GetMouse().IsDown() )
			{
				m_InteractFSM.m_CurrentActuator = B_TC_PRESSED;
			}
		}
		if ( ! Glb.GetInputManager().GetMouse().IsDown() )
		{
			m_InteractFSM.m_CurrentActuator = B_TC_RELEASED;
		}
		
		return SUCCESS;
	}
	
	public override function Activate()	: Result
	{
		super.Activate();
		m_InteractFSM.m_CurrentActuator = B_TC_SET_ON;
		return SUCCESS;
	}
	
	public override function Shut()	: Result
	{
		super.Shut();
		m_InteractFSM.m_CurrentActuator = B_TC_SET_OFF;
		return SUCCESS;
	}
	
	public function Disable()	: Void
	{
		m_InteractFSM.m_CurrentActuator = B_TC_SET_OFF;
	}
	
	public function Enable()	: Void
	{
		m_InteractFSM.m_CurrentActuator = B_TC_SET_ON;
	}

	/*
	 * Callbacks
	 */
	
	private function TrBtPressed()
	{
		// Change visual to a pressed button
	}
	
	private function TrBtUsed()
	{
		Reflect.callMethod( null, m_Callback, m_Argument );
	}
	
	private function TrBtCancel()
	{
		// Change visual to a disabled button
	}
	
	private function TrBtFreed()
	{
		// Change visual to a idle button (up)
	}
	
	private function TrBtOn()
	{
		
	}
	
	private function TrBtOff()
	{
		
	}
}