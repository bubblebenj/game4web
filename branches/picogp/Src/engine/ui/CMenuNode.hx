/**
 * ...
 * @author Benjamin Dubois
 */

package ui;

import CDriver;
import CTypes;

import math.CMatrix44;

import renderer.C2DContainer;

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

class CMenuNode				// C&D MenuState
{
	private var m_Id			: NodeId;
	private var	m_MenuGraph		: CMenuGraph;
	private var m_EltsContainer	: C2DContainer;
	
	public function new( _Id : String ) 
	{
		m_Id			= _Id;
		m_EltsContainer	= null;
	}
	
	/*
	 * LOGIC PART
	 */
	public function GetId() : String
	{
		return	m_Id;
	}
	
	public function GetContainer() : C2DContainer
	{
		return m_EltsContainer;
	}
	
	public function SetContainer( _Container : C2DContainer ) : Void
	{
		m_EltsContainer	= _Container;
		m_EltsContainer.m_Name	= m_Id;
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
	
	public function Update() : Result
	{
		m_EltsContainer.Update();
		//m_EltsContainer.ShowTree();
		return SUCCESS;
	}
	
	/*
	 * GRAPHIC PART
	 */
	public function Activate() : Result
	{
		m_EltsContainer.Activate();
		return SUCCESS;
	}
	
	public function FadeIn() : Void
	{
		Activate();
		GetContainer().SetVisible( true );
		var l_Tween = new CTween( m_EltsContainer.SetAlpha, 0, 1, 150, CLinear.Float_VaryIn, EnableButtons  );
		l_Tween.Start();
	}
	
	public function FadeOut() : Void
	{
		DisableButtons();
		var l_Tween = new CTween( m_EltsContainer.SetAlpha, 1, 0, 250, CLinear.Float_VaryIn, Unactivate );
		l_Tween.Start();
	}
	
	private function Unactivate() : Result
	{
		m_EltsContainer.Shut();
		return SUCCESS;
	}
	
	public function EnableButtons() : Void
	{
		for ( i_Element in m_EltsContainer.GetElements() )
		{
			if ( Type.getClassName( Type.getClass( i_Element ) ) == "logic.CButton" )
			{
				cast( i_Element, CButton).Enable();
			}
		}
	}
	
	public function DisableButtons() : Void
	{
		for ( i_Element in m_EltsContainer.GetElements() )
		{
			if ( Type.getClassName( Type.getClass( i_Element ) ) == "logic.CButton" )
			{
				cast( i_Element, CButton).Disable();
			}
		}
	}
}