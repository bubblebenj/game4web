/**
 * ...
 * @author BDubois
 */

package logic;
import CDriver;

import haxe.xml.Fast;
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
	
	private var m_LastState	: NodeId;
	private var m_States	: Hash<CMenuNode>;		// menu pages - C&D MenuState
	private var m_Actuators	: Hash<CMenuTransition>;		// links between menu pages	- C&D ???
	private var m_FSM		: CFiniteStateMachine<NodeId, TransitionId>;
	
	public function new()
	{
		super();
		m_States	= new Hash<CMenuNode>();
		m_Actuators	= new Hash<CMenuTransition>();
		m_FSM		= new CFiniteStateMachine();
		m_LastState	= "init";
	}
	
	public function Load( _XMLPath : String ) : Result
	{
		return SUCCESS;
	}
	
	public function Initialise( _NodeId : NodeId ) : Void
	{
		m_FSM.Initialise( _NodeId );
		
	}
	
	public function Update()	: Void
	{
		var l_CurrentState	: NodeId	= m_FSM.GetCurrentState();
		if ( l_CurrentState != m_LastState )
		{
			if ( m_LastState != "init" )
			{
				m_States.get( m_LastState ).Shut();
			}

			m_States.get( l_CurrentState ).Activate();
			m_LastState	= l_CurrentState;
		}
		m_States.get( m_LastState ).Update();
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
	
	public function CreateGraph( )
	{
		var l_FGraph	: Fast = new Fast( Xml.parse( haxe.Resource.getString( "menugraph") ).firstElement() );
		
		var l_graphXML : Xml = Xml.parse( haxe.Resource.getString( "menugraph") ).firstElement();
		
		for ( l_FMenuNode in l_FGraph.nodes.page )
		{
			AddMenuNode( new CMenuNode( l_FMenuNode.att.id ) );
		}
		
		for ( l_FMenuNode in l_FGraph.nodes.page )
		{
			var l_Fbody	= l_FMenuNode.node.div; // body
			for ( i_Images in l_Fbody.nodes.image )
			{
				var l_C2DImage	: C2DImage	= new C2DImage();
				l_C2DImage.Load( i_Images.att.src );
				
				GetMenuNode( l_FMenuNode.att.id ).AddObject( l_C2DImage );
			}
			
			for ( i_Div in l_Fbody.nodes.div )
			{
				if ( i_Div.has.href )	// if a button
				{
					//var l_Button	= new C2DButton();
					//l_Button
					
					if ( i_Div.has.name )
					{
						GetMenuNode( l_FMenuNode.att.id ).AddTransition( i_Div.att.href, i_Div.att.name );
					}
					else
					{
						GetMenuNode( l_FMenuNode.att.id ).AddTransition( i_Div.att.href );
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

enum StyleSelector { ID; CLASS; }