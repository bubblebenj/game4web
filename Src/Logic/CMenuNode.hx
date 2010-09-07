/**
 * ...
 * @author Benjamin Dubois
 */

package logic;

import kernel.CTypes;

import logic.IContent;

enum EInternalNodeState   	// C&D EMenuState 
{
	STATE_INTRO;
	STATE_MENU;
	STATE_OUTRO;
	STATE_END;
}

typedef NodeId = String;

class CMenuNode extends C2DContainer				// C&D MenuState
{
	private var m_Id			: NodeId;
	private var	m_MenuGraph		: CMenuGraph;
	
	public function new( _Id : String ) 
	{
		super();
		m_Id	= _Id;
	}
	
	/*
	 * LOGIC PART
	 */
	public function GetId() : String
	{
		return	m_Id;
	}
	
	/* _TransitionId : The name you want to use to trigger the transition
	 * _TransitionCallback : The function you want to call */
	public function AddTransition( _TargetId : NodeId, ?_TransitionId : String, ?_TransitionCallback : Void -> Void ) : Result
	{
		if ( _TransitionId == null )
		{
			return m_MenuGraph.CreateMenuTransition( this, m_MenuGraph.GetMenuNode( _TargetId ), _TransitionCallback );
		}
		else
		{
			return m_MenuGraph.CreateMenuTransition( _TransitionId, this, m_MenuGraph.GetMenuNode( _TargetId ), _TransitionCallback );
		}
	}
	
	public function SetGraph( _MenuGraph : CMenuGraph ) : Void
	{
		m_MenuGraph = _MenuGraph;
	}
	
	/*
	 * GRAPHIC PART
	 */
	public override function Activate() : Result
	{
		super.Activate();
		return SUCCESS;
	}
	
	public override function Shut() : Result
	{
		super.Shut();
		return SUCCESS;
	}
}