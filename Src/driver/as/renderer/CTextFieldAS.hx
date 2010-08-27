/**
 * ...
 * @author Benjamin Dubois
 */

package driver.as.renderer;

import driver.as.rsc.CRscTextAS;
import flash.text.TextField;

import kernel.CTypes;
import kernel.Glb;

import math.CV2D;
import renderer.CTextField;

import rsc.CRsc;
import rsc.CRscMan;
import rsc.CRscText;

class CTextFieldAS extends CTextField
{
	public function new() 
	{
		super();
		m_TextField			= new TextField();
		#if DebugInfo
			m_TextField.border	= true;
		#end
		m_TextField.selectable	= false;
	}
	
	public override function Activate() : Result
	{
		return SUCCESS;
	}
	
	
	
	public function Load( _Path )	: Result
	{
		var l_RscMan : CRscMan = Glb.g_System.GetRscMan();
		
		m_RscText = cast( l_RscMan.Load( CRscText.RSC_ID , _Path ), CRscTextAS );
		var l_Res = (m_RscText != null) ? SUCCESS : FAILURE;
		
		Glb.GetRendererAS().AddToScene( this );
		return l_Res;
	}
	
	public override function Update() : Result
	{
		
		if ( 	m_RscText != null
		&& 		m_RscText.m_State == E_STATE.STREAMED )
		{
			//CDebug.CONSOLEMSG("Stream finished");
			m_TextField.text	= m_RscText.GetText();
			
			SetVisible(true);
			//CDebug.CONSOLEMSG("Activating" + m_TextField);
		}
		return SUCCESS;
	}
	
	public function Shut() : Result
	{
		Glb.GetRendererAS().RemoveFromScene( this );
		Glb.GetRendererAS().RemoveFromSceneAS( m_TextField );
		return SUCCESS;
	}
	
	public override function SetVisible( _Vis : Bool ) : Void
	{
		super.SetVisible( _Vis );
		
		m_TextField.visible = _Vis;
		Glb.GetRendererAS().AddToSceneAS( m_TextField );
	}
	
	public function IsReady() : Bool 
	{
		return m_TextField != null;
	}
	
	public override function SetSize( _Size : CV2D ) : Void
	{
		super.SetSize( _Size );
		if ( m_TextField != null )
		{	
			m_TextField.width	= _Size.x;
			m_TextField.height	= _Size.y;
		}
	}
	
	public override function SetCenterPosition( _Pos : CV2D ) : Void
	{
		super.SetCenterPosition( _Pos );
		if (m_TextField != null)
		{
			m_TextField.x	= GetTL().x;
			m_TextField.y	= GetTL().y;
		}
	}
	
	public override function SetTLPosition( _Pos : CV2D ) : Void
	{
		super.SetTLPosition( _Pos );
		if (m_TextField != null)
		{
			m_TextField.x = _Pos.x;
			m_TextField.y = _Pos.y;
		}
	}
	
	private var m_TextField		: TextField;	// container - AS specific 
	private var m_RscText		: CRscTextAS; 		// content - CRscTextAS !
}