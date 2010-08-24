package tools;

/**
 * ...
 * @author bdubois
 */

class CTransition < EState, EEvent >
{
	public var m_SrcState		: EState;
	public var m_TriggerEvent	: EEvent; // ~Event : should be an enum, but may work with flash events (discouraged)
	public var m_TgtState		: EState;
	public var m_Callback		: Void -> Void;
	
	public function new( _SrcState : EState, _TriggerEvent : EEvent, _TgtState	: EState, _Callback	: Void -> Void )	: Void
	{
		m_SrcState			= _SrcState;
		m_TriggerEvent		= _TriggerEvent;
		m_TgtState			= _TgtState;
		m_Callback			= _Callback;
		#if CTransition
			trace ( m_Callback );
		#end
	}
}