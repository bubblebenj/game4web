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
	
	public function new( _SrcState : TState, _Actuator : TActuator, _TgtState	: TState, _Callback	: Void -> Void )	: Void
	{
		m_SrcState			= _SrcState;
		m_Actuator			= _Actuator;
		m_TgtState			= _TgtState;
		m_Callback			= _Callback;
		#if CTransition
			trace ( m_Callback );
		#end
	}
}