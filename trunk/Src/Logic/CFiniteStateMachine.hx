package logic;

/**
 * ...
 * @author bdubois
 */

class CTransition < TState, TActuator >
{
	public var m_SrcState	: TState;
	public var m_Actuator	: TActuator; 	// Event / Trigger / Input
	public var m_TgtState	: TState;
	public var m_Callback	: Void -> Void;
	
	public function new( _SrcState : TState, _Actuator : TActuator, _TgtState	: TState, _TransitionFunction	: Void -> Void )	: Void
	{
		m_SrcState			= _SrcState;
		m_Actuator			= _Actuator;
		m_TgtState			= _TgtState;
		m_Callback			= _TransitionFunction;
		#if CTransition
			trace ( m_Callback );
		#end
	}
}

class CFiniteStateMachine < TState, TActuator >
{
	private	var m_CurrentState			: TState;

	public var m_CurrentActuator(GetActuator, SetActuator)		: TActuator;
	public	var m_TransitionList		: Array < CTransition < TState, TActuator > > ;
	
	/* /!\ No default state, be carefull to initialise the FSM before using it. */
	public function new()
	{
		m_TransitionList	= new Array();
	}
	
	public function Initialize( _State : TState )	: Void
	{
		SetState( _State );
	}	
	
	private function SetActuator( _Actuator	: TActuator )	: TActuator
	{
		m_CurrentActuator	= _Actuator;
		if ( _Actuator != null )
		{
			HandleTransition();	
		}
		return m_CurrentActuator;
	}
	
	public function GetCurrentState()	: TState
	{
		return m_CurrentState;
	}
	
	private function GetActuator()	: TActuator
	{
		return	m_CurrentActuator;
	}
	
	/* A transition is identified by a couple : a source state and a trigger (a state transition condition)
	 * it determines the target state and what to do during the transition ( */
	public function AddTransition( 	_SrcState	: TState,	_Actuator	: TActuator,
									_TgtState	: TState,	_Callback	: Void -> Void)	: Void
	{
		#if CFiniteStateMachine
			trace ( "\t \t [ -- FSM.AddTransition ( _SrcState " + _SrcState );
			trace ( "\t \t \t \t \t \t , _Actuator : " 	+ _Actuator );
			trace ( "\t \t \t \t \t \t , _TgtState : "	+ _TgtState );
			trace ( "\t \t \t \t \t \t , _Callback : "	+ _Callback + " )" );
		#end
		var l_AlreadyExist	: Bool	= false;
		
		for ( i_Transition in m_TransitionList )
		{
			// If the transition already exists
			if ( _SrcState == i_Transition.m_SrcState && _Actuator == i_Transition.m_Actuator )
			{
				l_AlreadyExist		= true;
				#if CFiniteStateMachine
					trace	( "This transition already exist" );
				#end
			}
		}
		if ( ! l_AlreadyExist )
		{
			var l_Trans	: CTransition<TState, TActuator>;
			l_Trans = new CTransition( _SrcState, _Actuator, _TgtState, _Callback );
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
			if ( m_CurrentState == i_Transition.m_SrcState && m_CurrentActuator == i_Transition.m_Actuator )
			{
				//trace( "Actuator : " + m_CurrentActuator);
				#if CFiniteStateMachine
					trace ( i_Transition.m_Actuator );
				#end
				if ( i_Transition.m_Callback != null)
				{
					i_Transition.m_Callback();			// Making transition
				}
				SetState( i_Transition.m_TgtState );	// Changing state
				m_CurrentActuator	= null;
			}
		}
	}
	
	private function SetState( _State	: TState )	: Void
	{
		m_CurrentState = _State;
		//trace( "State : "+m_CurrentState );
	}
}
