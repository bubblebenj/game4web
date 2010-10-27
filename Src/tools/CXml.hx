/**
 * ...
 * @author bdubois
 */

 package tools;

import kernel.Glb;
import kernel.CTypes;
import rsc.CRsc;
import rsc.CRscMan;
import rsc.CRscText;

class CXml extends CText
{
	public function new() 
	{
		super();
	}
	
	public function IsLoaded() : E_STATE
	{
		return m_RscText.m_State;
	}
}