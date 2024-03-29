/**
 * ...
 * @author BDubois
 */

package ui;

import haxe.xml.Fast;
import Xml;

import CDriver;
import CTypes;

import kernel.Glb;
import kernel.CInputManager;

import logic.CFiniteStateMachine;
import ui.CMenuNode;
import ui.CMenuTransition;
import ui.CButton;

import math.CV2D;

import rsc.CRsc;
import rsc.CRscMan;

import renderer.C2DQuad;
import renderer.C2DContainer;
import renderer.C2DInterface;

import tools.CXml;
import swfclient.Globals;

class CMenuGraph extends CRsc			// C&D Menu
{
	private var m_MenuGraph			: CXml;
	private var m_MenuStyle			: CXml;
	private var m_InterfaceBuilder	: List<C2DInterface>;
	
	public static var 	RSC_ID = CRscMan.RSC_COUNT++;
	public override function GetType() : Int
	{
		return RSC_ID;
	}
	
	private var m_Loaded		: Bool;
	
	private var m_LastState	: NodeId;
	private var m_States	: Hash<CMenuNode>;				// menu pages - C&D MenuState
	private var m_Actuators	: Hash<CMenuTransition>;		// links between menu pages	- C&D ???
	private var m_FSM		: CFiniteStateMachine<NodeId, TransitionId>;
	
	public function new()
	{
		super();
		m_States	= new Hash<CMenuNode>();
		m_Actuators	= new Hash<CMenuTransition>();
		m_FSM		= new CFiniteStateMachine();
		m_LastState	= "init";
		m_MenuGraph	= new CXml();
		m_MenuStyle	= new CXml();
		m_InterfaceBuilder	= new List<C2DInterface>();
		m_Loaded	= false;
	}
	
	public function Load( _XMLGraphPath : String, _XMLStylePath : String ) : Result
	{
		m_MenuGraph.Load( _XMLGraphPath );
		m_MenuStyle.Load( _XMLStylePath );
		return SUCCESS;
	}
	
	public function Initialize( _NodeId : NodeId ) : Void
	{
		m_FSM.Initialize( _NodeId );
	}
	
	public function GetCurrentState() : NodeId
	{
		return m_FSM.GetCurrentState();
	}
	
	public function Update()	: Void
	{
		
		if ( m_Loaded == false )
		{
			m_MenuGraph.Update();
			m_MenuStyle.Update();
			if ( m_MenuGraph.m_Text != null &&  m_MenuStyle.m_Text != null )
			{
				CreateGraph();
			}
		}
		else
		{
			var l_CurrentState	: NodeId	= m_FSM.GetCurrentState();
			if ( l_CurrentState != m_LastState )
			{
				if ( m_LastState != "init" )
				{
					m_States.get( m_LastState ).FadeOut();
				}
				m_States.get( l_CurrentState ).FadeIn();
				m_LastState	= l_CurrentState;
			}
			m_States.get( m_LastState ).Update();
			//m_States.get( m_LastState ).GetContainer().ShowTree();
		}
		if ( m_InterfaceBuilder.length > 0 )
		{
			for ( i_Interface in m_InterfaceBuilder )
			{
				if ( i_Interface.NeedUpdate() )
				{
					i_Interface.Update();
				}
				else
				{
					m_InterfaceBuilder.remove( i_Interface );
				}
			}
		}
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
			//CDebug.CONSOLEMSG( " No Transition Id specified trying \"" + _Id +"\" " );
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
	
	public function CreateGraph()
	{
		var l_Xml		: Xml	= Xml.parse( m_MenuGraph.m_Text );
		var l_FGraph	: Fast	= new Fast( l_Xml.firstElement() );
		
		// First creating all possible states
		for ( i_FMenuNode in l_FGraph.nodes.page )
		{
			if ( i_FMenuNode.att.id == "Stage" )
			{
				AddMenuNode( new CMenuNode( "Stage" ) );
				GetMenuNode( "Stage" ).SetContainer( Globals.g_Stage );
			}
			else
			{
				AddMenuNode( new CMenuNode( i_FMenuNode.att.id ) );
				GetMenuNode( i_FMenuNode.att.id ).SetContainer( new C2DContainer() );
			}
		}
		var i = 0;
		// then making transition
		for ( i_FMenuNode in l_FGraph.nodes.page )
		{
			//trace( i_FMenuNode.att.id );
			RecurseDiv( GetMenuNode( i_FMenuNode.att.id ).GetContainer(), i_FMenuNode, null, GetMenuNode( i_FMenuNode.att.id ) );
		}
		m_Loaded = true;
	}
	
	private function RecurseDiv( _CurrentDiv : C2DContainer, _FCurrentDiv : Fast, _Parent : C2DContainer, _MenuNode : CMenuNode )
	{
		ApplyStyle( _CurrentDiv, _FCurrentDiv, _Parent );
		
		for ( i_FImages in _FCurrentDiv.nodes.image )
		{
			var l_C2DImage	: C2DImage	= new C2DImage();
			l_C2DImage.Load( i_FImages.att.src );
			ApplyStyle( l_C2DImage, i_FImages, _CurrentDiv );
			_CurrentDiv.AddElement( l_C2DImage );
		}
		
		for ( i_FSubDiv in _FCurrentDiv.nodes.div )
		{
			var l_NewDiv	: C2DContainer;
			if ( i_FSubDiv.has.href )	// if a button
			{
				l_NewDiv	= new CButton();
				if ( i_FSubDiv.has.name )
				{
					if ( _MenuNode.AddTransition( i_FSubDiv.att.href, i_FSubDiv.att.name ) == SUCCESS )
					{
						cast( l_NewDiv, CButton ).SetCmd( Actuate, [i_FSubDiv.att.name] );
						l_NewDiv.m_Name	= i_FSubDiv.att.name;
					}
				}
				else
				{
					if ( _MenuNode.AddTransition( i_FSubDiv.att.href ) == SUCCESS )
					{
						cast( l_NewDiv, CButton ).SetCmd( Actuate, ["Transition_" + _MenuNode.GetId() +"_to_" + i_FSubDiv.att.href] );
						l_NewDiv.m_Name	= "Transition_" + _MenuNode.GetId() +"_to_" + i_FSubDiv.att.href;
					}
				}
			}
			else
			{
				l_NewDiv	= new C2DContainer();
			}
			_CurrentDiv.AddElement( l_NewDiv );
			RecurseDiv( l_NewDiv, i_FSubDiv, _CurrentDiv, _MenuNode );
		}
	}
	
	private function ApplyStyle( _Object : C2DQuad, _FObject : Fast, _ObjectParent : C2DContainer )
	{		
		//trace( " " + _ObjectParent +" - " + _Object + " >");
		var FStyle		: Fast = new Fast( Xml.parse( m_MenuStyle.m_Text ).firstElement() );
		
		//var l_ParentSize		: CV2D = new CV2D( 0, 0 );
		//var l_ParentCoordinate	: CV2D = new CV2D( 0, 0 );
		//if ( _ObjectParent == null )
		//{
			//l_ParentSize.Set( Glb.GetSystem().m_Display.GetAspectRatio(), 1 );
			//l_ParentCoordinate.Set(	0, 0 );
		//}
		//else
		//{
			//l_ParentSize.Copy(			_ObjectParent.GetSize() );
			//l_ParentCoordinate.Copy(	_ObjectParent.GetTL() );
		//}
		
		var NoStyleDefined	: Bool	= true;
		if ( _FObject.has.type )
		{
			for ( i_FStyle in FStyle.nodes.type )
			{
				if ( i_FStyle.att.name == _FObject.att.type )
				{
					//trace( "\t > SET TYPE STYLE > " + i_FStyle.att.name );
					SetStyle( _Object, i_FStyle, /* l_ParentSize, l_ParentCoordinate */ _ObjectParent);
				}
			}
			NoStyleDefined	= false;
		}
		if ( _FObject.has.id )
		{
			for ( i_FStyle in FStyle.nodes.id )
			{	
				if ( i_FStyle.att.name == _FObject.att.id )
				{
					//trace( "\t >  SET ID STYLE  > " + i_FStyle.att.name );
					SetStyle( _Object, i_FStyle, /* l_ParentSize, l_ParentCoordinate */ _ObjectParent);
				}
			}
			NoStyleDefined	= false;
		}
		//if ( NoStyleDefined )
		//{
			//_Object.SetTLPosition( l_ParentCoordinate );
		//}
	}

	private function SetStyle( _Object : C2DQuad, _FStyle : Fast, /*_ParentSize : CV2D, _ParentCoordinate : CV2D*/ _ObjectParent : C2DContainer)	: Void
	{
		//var l_Size 				: CV2D = new CV2D( 1, 1 );
		//var l_Coordinate		: CV2D = new CV2D( 0, 0 );
		
		var l_Interface			: C2DInterface;
		if ( _ObjectParent == null )
		{
			l_Interface	= new C2DInterface( _Object );
		}
		else
		{
			l_Interface	= new C2DInterface( _Object, _ObjectParent );
		}
		
		var l_Unit	: E_Unit;
		var l_x : Float;
		var l_y : Float;
		
		if ( (! _FStyle.hasNode.size) && (! _FStyle.hasNode.handle) && (! _FStyle.hasNode.pos) )
		{
			trace( "No style define in this Xml extract" );
		}
		else
		{
			// SIZE
			if ( _FStyle.hasNode.size )
			{
				switch( _FStyle.node.size.att.unit )
				{
					case "%" :
					{
						l_Unit	= E_Unit.PERCENTAGE;
					}
					case "/" :
					{
						l_Unit	= E_Unit.RATIO;
					}
					case "px" :
					{
						l_Unit	= E_Unit.PX;
					}
					default	:
					{
						l_Unit	= E_Unit.PX;
						trace( _FStyle.node.size.att.unit + " isn't a correct value for attribute unit" );
						trace( "Accepted values scale=\" '%' , '/' or 'px'\". Using pixels" );
					}
				}
				l_x	= ( _FStyle.node.size.att.x == "" ) ? 0 : Std.parseFloat( _FStyle.node.size.att.x );
				l_y = ( _FStyle.node.size.att.y == "" ) ? 0 : Std.parseFloat( _FStyle.node.size.att.y );
				l_Interface.SetEltSize( l_Unit, new CV2D( l_x, l_y ) );
			}
			
			// PIVOT
			if ( _FStyle.hasNode.handle )
			{
				switch ( _FStyle.node.handle.att.type )
				{
					case "TL"	:
					{
						l_Interface.SetEltPivot( TL );
					}
					case "center"	:
					{
						l_Interface.SetEltPivot( CENTER );
					}
					case "pivot"	:
					{
						l_x	= ( _FStyle.node.handle.att.x == "" ) ? 0.5 : Std.parseFloat( _FStyle.node.handle.att.x );
						l_y = ( _FStyle.node.handle.att.y == "" ) ? 0.5 : Std.parseFloat( _FStyle.node.handle.att.y );
						l_Interface.SetEltPivot( CUSTOM, new CV2D( l_x, l_y ) );
					}
					default		:
					{
						l_Interface.SetEltPivot( CENTER );
						trace( _FStyle.node.handle.att.type + " isn't a correct value for attribute type" );
						trace( "Accepted values type=\" 'TL' , 'center' or 'pivot' \". Using center" );
					}
				}
			}
			
			// COORDINATE
			if ( _FStyle.hasNode.pos )
			{
				switch ( _FStyle.node.pos.att.unit )
				{
					case "%" :
					{
						l_Unit	= E_Unit.PERCENTAGE;
					}
					case "/" :
					{
						l_Unit	= E_Unit.RATIO;
					}
					case "px" :
					{
						l_Unit	= E_Unit.PX;
					}
					default	:
					{
						l_Unit	= E_Unit.PX;
						trace( _FStyle.node.pos.att.unit + " isn't a correct value for attribute unit" );
						trace( "Accepted values scale=\" '%' , '/' or 'px'\". Using pixels" );
					}
				}
				l_x	= ( _FStyle.node.pos.att.x == "" ) ? 0 : Std.parseFloat( _FStyle.node.pos.att.x );
				l_y = ( _FStyle.node.pos.att.y == "" ) ? 0 : Std.parseFloat( _FStyle.node.pos.att.y );
				l_Interface.SetEltPos( l_Unit, new CV2D( l_x, l_y ) );
			}
			
			//trace ( "\t \t  Coordinate (center) :" + _Object.GetCenter().ToString() + ">>> Size : " + _Object.GetSize().ToString() );
			m_InterfaceBuilder.add( l_Interface );
		}
	}
}
