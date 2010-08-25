package logic;

/**
 * ...
 * @author bdubois
 */

import logic.CTransition;

class CFiniteStateMachine < EState, EEvent >
{
	
	private var m_DefaultState			: EState;
	
	private	var m_CurrentState			: EState;

	private var m_CurrentEvent			: EEvent;
	public	var m_TransitionList		: Array < CTransition < EState, EEvent > > ;
	
	public function new( _DefaultState : EState )
	{
		m_DefaultState		= _DefaultState;
		m_TransitionList	= new Array();
		Initialise();
	}
	
	public function SetState( _State	: EState )	: Void
	{
		m_CurrentState = _State;
	}	
	
	public function SetEvent( _Event	: EEvent )	: Void
	{
		m_CurrentEvent	= _Event;
		trace( "Trigger event : " + m_CurrentEvent);
	}
	
	public function GetEvent()	: EEvent
	{
		return	m_CurrentEvent;
	}
	
	public function Initialise()	: Void
	{
		SetState( m_DefaultState );
	}
	
	public function AddTransition( 	_SrcState	: EState,	_Event		: EEvent,
									_TgtState	: EState,	_Callback	: Void -> Void)	: Void
	{
		#if CFiniteStateMachine
			trace ( "\t \t [ -- FSM.AddTransition ( _SrcState " + _SrcState );
			trace ( "\t \t \t \t \t \t , _Event : " 	+ _Event );
			trace ( "\t \t \t \t \t \t , _TgtState : "	+ _TgtState );
			trace ( "\t \t \t \t \t \t , _Callback : "	+ _Callback + " )" );
		#end
		var l_AlreadyExist	: Bool	= false;
		
		for ( i_Transition in m_TransitionList )
		{
			// If the transition already exists
			if ( _SrcState == i_Transition.m_SrcState && _Event == i_Transition.m_TriggerEvent )
			{
				l_AlreadyExist		= true;
				#if CFiniteStateMachine
					trace	( "This transition already exist" );
				#end
			}
		}
		if ( ! l_AlreadyExist )
		{
			var l_Trans	: CTransition<EState, EEvent>;
			l_Trans = new CTransition( _SrcState, _Event, _TgtState, _Callback );
			#if CFiniteStateMachine
				trace (l_Trans);
			#end
			
			m_TransitionList.push( l_Trans );
			#if CFiniteStateMachine
				trace (m_TransitionList[0]);
			#end
		}
	}
	
	public function HandleTransition()	: Void
	{
		for ( i_Transition in m_TransitionList )
		{
			if ( m_CurrentState == i_Transition.m_SrcState && m_CurrentEvent == i_Transition.m_TriggerEvent )
			{
				#if CFiniteStateMachine
					trace ( i_Transition.m_TriggerEvent );
				#end
				if ( i_Transition.m_Callback != null)
				{
					i_Transition.m_Callback();			// Making transition
				}
				SetState( i_Transition.m_TgtState );	// Changing state
				m_CurrentEvent	= null;
			}
		}
		trace( "State : "+m_CurrentState );
	}
	
	public function Update()	: Void
	{
		if ( m_CurrentEvent	!= null )
		{
			HandleTransition();
		}
	}
}
