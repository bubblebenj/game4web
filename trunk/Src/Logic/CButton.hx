/**
 * ...
 * @author Benjamin Dubois
 */

package logic;

import kernel.Glb;
import kernel.CTypes;

import logic.CFiniteStateMachine;
import logic.C2DContainer;
import logic.CMenuTransition;

enum BUTTON_INTERACTION_STATE 
{
	B_IST_UP;
	B_IST_DOWN;
	B_IST_CANCELLED;
	B_IST_DESABLED;
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
	private var	m_Callback		: TransitionId -> Void;
	private var m_Transition	: TransitionId;
	
	
	public function new() 
	{
		super();

		m_InteractFSM		= new CFiniteStateMachine<BUTTON_INTERACTION_STATE, BUTTON_TRANS_CONDITION>();
		CreateActuators();
		m_InteractFSM.Initialize( B_IST_DESABLED );
	}
	
	public function SetAction( _Callback	: TransitionId -> Void, _Transition	: TransitionId )
	{
		m_Callback		= _Callback;
		m_Transition	= _Transition;
	}
	
	private function CreateActuators()			: Void
	{
		m_InteractFSM.AddTransition( B_IST_UP,			B_TC_PRESSED,	B_IST_DOWN,			TrBtPressed );
		m_InteractFSM.AddTransition( B_IST_DOWN,		B_TC_RELEASED,	B_IST_UP,			TrBtUsed );
		m_InteractFSM.AddTransition( B_IST_DOWN,		B_TC_MOUSE_OUT,	B_IST_CANCELLED,	TrBtCancel );
		m_InteractFSM.AddTransition( B_IST_CANCELLED,	B_TC_RELEASED,	B_IST_UP,			TrBtFreed );
		
		m_InteractFSM.AddTransition( B_IST_DESABLED,	B_TC_SET_ON,	B_IST_UP,			TrBtOn );
		m_InteractFSM.AddTransition( B_IST_UP,			B_TC_SET_OFF,	B_IST_DESABLED,		TrBtOff );
	}
	
	public function MouseOver() : Bool
	{
		return Intersects( Glb.GetInputManager().m_Mouse.m_Coordinate );
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
			if ( Glb.GetInputManager().m_Mouse.m_Down )
			{
				m_InteractFSM.m_CurrentActuator = B_TC_PRESSED;
			}
		}
		if ( ! Glb.GetInputManager().m_Mouse.m_Down )
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
		m_Callback( m_Transition );
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