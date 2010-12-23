package tools;

/**
 * ...
 * @author bdubois
 */

import kernel.Glb;
import kernel.CTypes;
import rsc.CRsc;
import rsc.CRscMan;
import rsc.CRscText;
 
class CText 
{
	public var m_Text : String;
	
	public function new()
	{
		m_RscText	= null;
		m_Loading		= false;
	}
	
	public function Load( _Path )	: Result
	{
		var l_RscMan : CRscMan = Glb.g_System.GetRscMan();
		
		m_RscText	= cast( l_RscMan.Load( CRscText.RSC_ID , _Path ), CRscText );
		m_Loading	= true;
		return SUCCESS;
	}
	
	public function Update() : Result
	{
		if ( 	m_RscText != null
		&& 		m_RscText.m_State == E_STATE.STREAMED
		&&		m_Loading )
		{
			m_Loading	= false;
			m_Text		= m_RscText.GetTextData();
		}
		return SUCCESS;
	}
	
	public function IsLoaded() : Bool
	{
		return m_RscText.IsStreamed() && ! m_Loading;
	}
	
	private	var m_Loading	: Bool;
	private var m_RscText	: CRscText;
}