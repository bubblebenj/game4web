/**
 * ...
 * @author BDubois
 */

package logic;
import CDriver;
import math.CV2D;

import haxe.xml.Fast;
import Xml;
import haxe.Resource;

import kernel.CTypes;
import kernel.CDebug;
import kernel.Glb;

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
				//trace( "Shutting " + m_LastState );
				m_States.get( m_LastState ).Shut();
			}
			//trace( "Activating " + l_CurrentState );
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
			m_States.set( _MenuNode.GetId(), _MenuNode );
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
			SetStyle( m_States.get( l_FMenuNode.att.id ), l_Fbody );
			
			for ( i_FImages in l_Fbody.nodes.image )
			{
				var l_C2DImage	: C2DImage	= new C2DImage();
				l_C2DImage.Load( i_FImages.att.src );
				SetStyle( l_C2DImage, i_FImages, m_States.get( l_FMenuNode.att.id ) );
				GetMenuNode( l_FMenuNode.att.id ).AddObject( l_C2DImage );
			}
			
			for ( i_FDiv in l_Fbody.nodes.div )
			{
				if ( i_FDiv.has.href )	// if a button
				{
					//var l_Button	= new C2DButton();
					//l_Button
					
					if ( i_FDiv.has.name )
					{
						GetMenuNode( l_FMenuNode.att.id ).AddTransition( i_FDiv.att.href, i_FDiv.att.name );
					}
					else
					{
						GetMenuNode( l_FMenuNode.att.id ).AddTransition( i_FDiv.att.href );
					}
				}
			}
		}
	}
	
	private function SetStyle( _Object : C2DQuad, _FObject : Fast, ?_ObjectParent : C2DQuad )
	{		
		var FStyle		: Fast = new Fast( Xml.parse( haxe.Resource.getString( "menustyle") ).firstElement() );
		var l_Size 				: CV2D = new CV2D( 0, 0 );
		var l_Coordinate		: CV2D = new CV2D( 0, 0 );
		
		var l_ParentSize		: CV2D = new CV2D( 0, 0 );
		var l_ParentCoordinate	: CV2D = new CV2D( 0, 0 );
		if ( _ObjectParent == null )
		{
			l_ParentSize.Set( Glb.g_System.m_Display.m_Width, Glb.g_System.m_Display.m_Height );
			l_ParentCoordinate.Set(	0, 0 );
		}
		else
		{
			l_ParentSize.Copy(			_ObjectParent.GetSize() );
			l_ParentCoordinate.Copy(	_ObjectParent.GetTL() );
		}
		
		//for ( i_FStyle in FStyle.nodes.class )
		//{
			//if ( i_FStyle.att.name == _FastObj.att.id )
			//{
				//
			//}
		//}
		for ( l_FObjStyle in FStyle.nodes.id )
		{
			if ( l_FObjStyle.att.name == _FObject.att.id )
			{
				trace( ">>>>>>>>>>>>>>>"+_Object+">>"+l_FObjStyle.att.name + " " +_FObject.att.id );
				var l_x : Float;
				var l_y : Float;
				
				// SIZE
				switch( l_FObjStyle.node.size.att.scale )
				{
					case "fit" :
					{
						l_Size.Copy( l_ParentSize );
					}
					case "keep_ratio" :
					{
						l_x	= ( l_FObjStyle.node.size.att.x == "" ) ? 1 : Std.parseFloat(l_FObjStyle.node.size.att.x);
						l_y = ( l_FObjStyle.node.size.att.y == "" ) ? 1 : Std.parseFloat(l_FObjStyle.node.size.att.y);
						l_Size.Set( Std.parseFloat(l_FObjStyle.node.size.att.x), Std.parseFloat(l_FObjStyle.node.size.att.y) );
						var l_Ratio : Float = Math.min( l_ParentSize.x / l_x, l_ParentSize.y / l_y );
						CV2D.Scale( l_Size, l_Ratio, l_Size );
					}
					case "exact" :
					{
						l_x = ( l_FObjStyle.node.size.att.x == "" ) ? 0 : Std.parseFloat(l_FObjStyle.node.size.att.x);
						l_y = ( l_FObjStyle.node.size.att.y == "" ) ? 0 : Std.parseFloat(l_FObjStyle.node.size.att.y);
						trace( "DDDDDDDDDDDDDDDDDDDDDD"+l_x + " " + l_y );
						l_Size.Set( l_x, l_y );
					}
					default	: // fit
					{
						l_Size.Copy( l_ParentSize );
					}
				}
				trace ( " Size"+l_Size.ToString() );
				_Object.SetSize( l_Size );
				
				// COORDINATE
				switch ( l_FObjStyle.node.align.att.handle )
				{
					case "%"	:
					{
						l_Coordinate.Set(	l_ParentSize.x * Std.parseFloat(FStyle.node.body.node.size.att.x),
											l_ParentSize.y * Std.parseFloat(FStyle.node.body.node.size.att.y) );
					}
					case "px"	:
					{
						l_Coordinate.Set(	Std.parseFloat(FStyle.node.body.node.size.att.x),
											Std.parseFloat(FStyle.node.body.node.size.att.y) );
					}
				}
				
				trace ( " Coordinate"+l_Coordinate.ToString() );
				
				switch ( l_FObjStyle.node.align.att.handle )
				{
					case "TL"		: _Object.SetRelativeTLPosition( l_ParentCoordinate, l_Coordinate );
					case "center"	: _Object.SetRelativeCenterPosition( l_ParentCoordinate, l_Coordinate );
				}
			}
		}
	}
}
