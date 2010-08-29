/**
 * ...
 * @author BDubois
 */

package logic;

import Xml;
import haxe.Resource;

import kernel.CTypes;
import kernel.CDebug;

import logic.CFiniteStateMachine;
import logic.CMenuNode;
import logic.CMenuTransition;

import rsc.CRsc;
import rsc.CRscMan;

import renderer.C2DQuad;

class CMenuGraph extends CRsc			// C&D Menu
{
	public static var 	RSC_ID = CRscMan.RSC_COUNT++;
	public override function GetType() : Int
	{
		return RSC_ID;
	}
	
	private var m_States	: Hash<CMenuNode>;		// menu pages - C&D MenuState
	private var m_Actuators	: Hash<CMenuTransition>;		// links between menu pages	- C&D ???
	private var m_FSM		: CFiniteStateMachine<NodeId, TransitionId>;
	
	public function new()
	{
		super();
		m_States	= new Hash<CMenuNode>();
		m_Actuators	= new Hash<CMenuTransition>();
		m_FSM		= new CFiniteStateMachine();
	}
	
	public function Load( _XMLPath : String ) : Result
	{
		return SUCCESS;
	}
	
	public function Initialise( _NodeId : NodeId ) : Void
	{
		m_FSM.Initialise( _NodeId );
	}
	
	/* Gives the last triggered actuator to the FSM */
	public function Actuate( _TransitionId : TransitionId )
	{
		m_FSM.m_CurrentActuator = _TransitionId;
	}
	
	public function GetMenuNode( _Id : NodeId )	: CMenuNode
	{
		return m_States.get( _Id );
	}
	
	public function AddMenuNode( _MenuNode : CMenuNode ) : Result
	{
		if ( m_States.exists( _MenuNode.GetId() ) )
		{
			CDebug.CONSOLEMSG( " Node identifier \"" + _MenuNode.GetId() +"\" already exists. Can't add this node." );
			return FAILURE;
		}
		else
		{
			_MenuNode.SetGraph( this );
			m_States.set( _MenuNode.GetId(), _MenuNode);
			return SUCCESS;
		}
	}
	
	public function CreateMenuTransition( ?_Id : String, _SrcNode : CMenuNode, _TgtNode	: CMenuNode, _Transition	: Void -> Void ) : Result
	{
		var l_Res	: Result = SUCCESS;
		
		if ( _Id == null )
		{
			_Id = "Transition_"+_SrcNode.GetId() +"_to_"+ _TgtNode.GetId();
			CDebug.CONSOLEMSG( " No Transition Id specified trying \"" + _Id +"\" " );
		}
		
		if ( m_Actuators.exists( _Id ) )
		{
			CDebug.CONSOLEMSG( " Transition identifier \"" + _Id +"\" already exists. Can't create this Transition." );
			l_Res = FAILURE;
		}
		else
		{
			// NB : we could have added the nodes on the fly but it's not desirable.
			if ( !m_States.exists( _SrcNode.GetId() ) ) 
			{
				CDebug.CONSOLEMSG( "Source node identifier \"" + _SrcNode.GetId() +"\" doesn't exist yet." );
				CDebug.CONSOLEMSG( "\t Please create it then ADD IT BEFORE you try to create an Transition involving it." );
				l_Res = FAILURE;
			}
			if ( !m_States.exists( _TgtNode.GetId() ) )
			{
				CDebug.CONSOLEMSG( "Target node identifier \"" + _TgtNode.GetId() +"\" doesn't exist yet." );
				CDebug.CONSOLEMSG( "\t Please create it then ADD IT BEFORE you try to create a transition involving it." );
				l_Res = FAILURE;
			}
		}
		
		if ( l_Res != FAILURE )
		{
			// Last warn if a transition involving the same source an target node exists
			for ( i_Transition in m_FSM.m_TransitionList )
			{
				if ( i_Transition.m_SrcState == _SrcNode.GetId() && i_Transition.m_TgtState == _TgtNode.GetId() )
				{
					CDebug.CONSOLEMSG( "A transition involving the source node \"" + _SrcNode.GetId() +"\"and the target node \"" + _TgtNode.GetId() +"\" already exists." );
					CDebug.CONSOLEMSG( "\t Please check if you aren't duplicating it. It will be created anyway" );
				}
			}
			RegisterMenuTransition( new CMenuTransition( _Id ) );
			m_FSM.AddTransition( _SrcNode.GetId(), _Id, _TgtNode.GetId(), _Transition );
		}
		return l_Res;
	}
	
	/* The graph is updated when Actuate()  */
	public function Update()
	{
	}
	
	private function RegisterMenuTransition( _MenuTransition : CMenuTransition ) : Result
	{
		if ( m_Actuators.exists( _MenuTransition.GetId() ) )
		{
			CDebug.CONSOLEMSG( " Transition identifier \"" + _MenuTransition.GetId() +"\" already exists. Can't add this Transition." );
			return FAILURE;
		}
		else
		{
			m_Actuators.set( _MenuTransition.GetId(), _MenuTransition );
			return SUCCESS;
		}
	}
	
	public function CreateGraph()
	{
		var l_graphXML : Xml = Xml.parse( haxe.Resource.getString( "menugraph") ).firstElement();
		
		// MenuNodes creation : NB doesn't work with - in l_graphXML - (Child)
		for ( i_MenuNode in l_graphXML.elements() )
		{
			AddMenuNode( new CMenuNode( i_MenuNode.get("id") ) );
		}
		//
		for ( i_MenuNode in l_graphXML.elements() )
		{
			var l_Content	: Xml	= i_MenuNode.firstElement(); //id = body
			
			for ( i_Images in l_Content.elementsNamed("image") )
			{
				
			}
			
			for ( i_Div in l_Content.elementsNamed("div") )
			{
				if ( i_Div.exists("href") )
				{
					trace ( i_Div.get("id") + "<>" + i_Div.get("href"));
					
					if ( i_Div.exists("name" ) )
					{
						GetMenuNode( i_MenuNode.get("id") ).AddTransition( i_Div.get("href"), i_Div.get("name") );
					}
					else
					{
						GetMenuNode( i_MenuNode.get("id") ).AddTransition( i_Div.get("href") );
					}
				}
			}
			
		}
	}
	
	private function SetStyle( _Selector : StyleSelector, _Object : C2DQuad )
	{
		var styleXML : Xml = Xml.parse( haxe.Resource.getString( "menustyle") ).firstElement();
	}
}

enum StyleSelector{ ID; CLASS;}
