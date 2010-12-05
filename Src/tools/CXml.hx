/**
 * ...
 * @author bdubois
 */

 package tools;

import rsc.CRscText;
import rsc.CRsc;

class CXml extends CText
{
	public function new() 
	{
		super();
	}
	
	public function IsLoaded() : Bool
	{
		return m_RscText.IsStreamed();
	}
}