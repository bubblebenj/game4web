/**
 * ...
 * @author Benjamin Dubois
 */

package logic;

import kernel.CTypes;
import math.CMatrix44;
import tools.transition.CTransitionManager;
import tools.transition.CTween;
import tools.transition.interpolation.CLinear;

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
	private var m_TwMnger		: CTransitionManager;
	
	public function new( _Id : String ) 
	{
		super();
		m_Id		= _Id;
		m_TwMnger	= new CTransitionManager();
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
	
	public function FadeIn()
	{
		EnableButtons();
		Activate();
		m_TwMnger.AddTween( "FADING", this.SetAlpha, 0, 1, 300, CLinear.Float_VaryIn );
		m_TwMnger.Start( "FADING" );
		
	}
	
	public function FadeOut()
	{
		DisableButtons();
		m_TwMnger.AddTween( "FADING", this.SetAlpha, 1, 0, 300, CLinear.Float_VaryIn );
		m_TwMnger.Start( "FADING" );

			//Shut();

	}
	
	public function EnableButtons()
	{
		for ( i_Object in m_2DObjects )
		{
			if ( Type.getClassName( Type.getClass( i_Object ) ) == "logic.CButton" )
			{
				cast( i_Object, CButton).Enable();
			}
		}
	}
	
	public function DisableButtons()
	{
		for ( i_Object in m_2DObjects )
		{
			if ( Type.getClassName( Type.getClass( i_Object ) ) == "logic.CButton" )
			{
				cast( i_Object, CButton).Disable();
			}
		}
	}
	
	public function SetGraph( _MenuGraph : CMenuGraph ) : Void
	{
		m_MenuGraph = _MenuGraph;
	}
	
	public override function Update() : Result
	{
		super.Update();
		m_TwMnger.Update();
		return SUCCESS;
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