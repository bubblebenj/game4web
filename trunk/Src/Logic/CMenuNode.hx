/**
 * ...
 * @author Benjamin Dubois
 */

package logic;

import logic.IContent;

enum EInternalNodeState   	// C&D EMenuState 
{
	STATE_INTRO;
	STATE_MENU;
	STATE_OUTRO;
	STATE_END;
}

typedef NodeId = String;

class CMenuNode 				// C&D MenuState
{
	private var m_Id			: NodeId;
	private var	m_MenuGraph		: CMenuGraph;
	public	var m_CustomContent	: IContent;
	
	public function new( _Id : String ) 
	{
		m_Id	= _Id;
	}
	
	public function GetId() : String
	{
		return	m_Id;
	}
	
	/* _TransitionId : The name you want to use to trigger the transition
	 * _TransitionCallback : The function you want to call */
	public function AddTransition( _TargetId : NodeId, ?_TransitionId : String, ?_TransitionCallback : Void -> Void )
	{
		if ( _TransitionId == null )
		{
			m_MenuGraph.CreateMenuTransition( this, m_MenuGraph.GetMenuNode( _TargetId ), _TransitionCallback );
		}
		else
		{
			m_MenuGraph.CreateMenuTransition( _TransitionId, this, m_MenuGraph.GetMenuNode( _TargetId ), _TransitionCallback );
		}
		
	}
	
	public function SetGraph( _MenuGraph : CMenuGraph ) : Void
	{
		m_MenuGraph = _MenuGraph;
	}
}