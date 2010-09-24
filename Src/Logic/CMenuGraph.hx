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
import logic.CButton;

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
	}
	
	public function Load( _XMLPath : String ) : Result
	{
		return SUCCESS;
	}
	
	public function Initialize( _NodeId : NodeId ) : Void
	{
		m_FSM.Initialize( _NodeId );
	}
	
	public function Update()	: Void
	{
		var l_CurrentState	: NodeId	= m_FSM.GetCurrentState();
		if ( l_CurrentState != m_LastState )
		{
			if ( m_LastState != "init" )
			{
				//trace( "Shutting " + m_LastState );
				m_States.get( m_LastState ).FadeOut();
			}
			//trace( "Activating " + l_CurrentState );
			m_States.get( l_CurrentState ).FadeIn();
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
		
		for ( i_FMenuNode in l_FGraph.nodes.page )
		{
			AddMenuNode( new CMenuNode( i_FMenuNode.att.id ) );
		}
		
		for ( i_FMenuNode in l_FGraph.nodes.page )
		{
			RecurseDiv( m_States.get( i_FMenuNode.att.id ), i_FMenuNode, null, GetMenuNode( i_FMenuNode.att.id ) );
		}
		
		#if DebugInfo
			//for ( i_FMenuNode in l_FGraph.nodes.page )
			//{
				//m_States.get( i_FMenuNode.att.id ).ShowTree();
			//}
		#end
	}
	
	private function RecurseDiv( _CurrentDiv : C2DContainer, _FCurrentDiv : Fast, _Parent : C2DContainer, _MenuNode : CMenuNode )
	{
		ApplyStyle( _CurrentDiv, _FCurrentDiv, _Parent );
		
		for ( i_FImages in _FCurrentDiv.nodes.image )
		{
			var l_C2DImage	: C2DImage	= new C2DImage();
			l_C2DImage.Load( i_FImages.att.src );
			ApplyStyle( l_C2DImage, i_FImages, _CurrentDiv );
			_CurrentDiv.AddObject( l_C2DImage );
		}
		
		var l_NewDiv	: C2DContainer;
		for ( i_FSubDiv in _FCurrentDiv.nodes.div )
		{
			
			if ( i_FSubDiv.has.href )	// if a button
			{
				l_NewDiv	= new CButton();
				if ( i_FSubDiv.has.name )
				{
					if ( _MenuNode.AddTransition( i_FSubDiv.att.href, i_FSubDiv.att.name ) == SUCCESS )
					{
						cast( l_NewDiv, CButton ).SetAction( Actuate, i_FSubDiv.att.name );
					}
				}
				else
				{
					if ( _MenuNode.AddTransition( i_FSubDiv.att.href ) == SUCCESS )
					{
						cast( l_NewDiv, CButton ).SetAction( Actuate, "Transition_"+ _MenuNode.GetId() +"_to_"+ i_FSubDiv.att.href );
					}
				}
				
			}
			else
			{
				l_NewDiv	= new C2DContainer();
			}
			_CurrentDiv.AddObject( l_NewDiv );
			RecurseDiv( l_NewDiv, i_FSubDiv, _CurrentDiv, _MenuNode );
		}
	}
	
	private function ApplyStyle( _Object : C2DQuad, _FObject : Fast, _ObjectParent : C2DQuad )
	{		
		trace ("");
		trace( " " + _ObjectParent +" - " + _Object + " >");
		var FStyle		: Fast = new Fast( Xml.parse( haxe.Resource.getString( "menustyle") ).firstElement() );
		
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
		
		var NoStyleDefined	: Bool	= true;
		if ( _FObject.has.type )
		{
			for ( i_FStyle in FStyle.nodes.type )
			{
				if ( i_FStyle.att.name == _FObject.att.type )
				{
					trace( "\t > SET TYPE STYLE > " + i_FStyle.att.name );
					SetStyle( _Object, i_FStyle, l_ParentSize, l_ParentCoordinate );
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
					trace( "\t >  SET ID STYLE  > " + i_FStyle.att.name );
					SetStyle( _Object, i_FStyle, l_ParentSize, l_ParentCoordinate );
				}
			}
			NoStyleDefined	= false;
		}
		if ( NoStyleDefined )
		{
			_Object.SetRelativeTLPosition( l_ParentCoordinate, CV2D.ZERO );
		}
	}

	private function SetStyle( _Object : C2DQuad, _FStyle : Fast, _ParentSize : CV2D, _ParentCoordinate : CV2D )	: Void
	{
		var l_Size 				: CV2D = new CV2D( 0, 0 );
		var l_Coordinate		: CV2D = new CV2D( 0, 0 );
		
		var l_x : Float;
		var l_y : Float;
		
		if ( (! _FStyle.hasNode.size) && (! _FStyle.hasNode.align) )
		{
			trace( "No style define in this Xml extract" );
		}
		else
		{
			// SIZE
			if ( _FStyle.hasNode.size )
			{
				switch( _FStyle.node.size.att.scale )
				{
					case "fit" :
					{
						l_Size.Copy( _ParentSize );
					}
					case "keep_ratio" :
					{
						l_x	= ( _FStyle.node.size.att.x == "" ) ? 1 : Std.parseFloat(_FStyle.node.size.att.x);
						l_y = ( _FStyle.node.size.att.y == "" ) ? 1 : Std.parseFloat(_FStyle.node.size.att.y);
						l_Size.Set( Std.parseFloat(_FStyle.node.size.att.x), Std.parseFloat(_FStyle.node.size.att.y) );
						var l_Ratio : Float = Math.min( _ParentSize.x / l_x, _ParentSize.y / l_y );
						CV2D.Scale( l_Size, l_Ratio, l_Size );
					}
					case "exact" :
					{
						l_x = ( _FStyle.node.size.att.x == "" ) ? 0 : Std.parseFloat(_FStyle.node.size.att.x);
						l_y = ( _FStyle.node.size.att.y == "" ) ? 0 : Std.parseFloat(_FStyle.node.size.att.y);
						l_Size.Set( l_x, l_y );
					}
					default	:
					{
						trace( _FStyle.node.size.att.scale + " isn't a correct value for attribute scale" );
						trace( "Accepted values scale=\"fit|keep_ratio|exact\"" );
					}
				}
				_Object.SetSize( l_Size );
			}
			
			// COORDINATE
			if ( _FStyle.hasNode.align )
			{
				switch ( _FStyle.node.align.att.unit )
				{
					case "%"	:
					{
						//trace( FStyle.node.body.node.size.att.x +" " + FStyle.node.body.node.size.att.y );
						l_Coordinate.Set(	_ParentSize.x * Std.parseFloat(_FStyle.node.align.att.x ) * 0.01,
											_ParentSize.y * Std.parseFloat(_FStyle.node.align.att.y) * 0.01 ) ;
					}
					case "px"	:
					{
						l_Coordinate.Set(	Std.parseFloat(_FStyle.node.align.att.x ),
											Std.parseFloat(_FStyle.node.align.att.y ) );
					}
					default		:
					{
						trace( _FStyle.node.align.att.unit + " isn't a correct value for attribute unit" );
						trace( "Accepted values unit=\"%|px\"" );
					}
				}
							
				switch ( _FStyle.node.align.att.handle )
				{
					case "TL"		: _Object.SetRelativeTLPosition( _ParentCoordinate, l_Coordinate );
					case "center"	: _Object.SetRelativeCenterPosition( _ParentCoordinate, l_Coordinate );
				}
			}
			
			trace ( "\t \t  Coordinate (center) :" + _Object.GetCenter().ToString() + ">>> Size : " + _Object.GetSize().ToString() );
		}
	}
}