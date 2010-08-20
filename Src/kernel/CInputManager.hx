/**
 * ...
 * @author Benjamin Dubois
 */

package kernel;

import rsc.CRsc;
import rsc.CRscMan;

class CInputManager 
{
	public var  m_Mouse	: CMouse;
	
	public function new() 
	{
		var l_RscMan : CRscMan = Glb.g_System.GetRscMan();
		
		m_Mouse = cast( l_RscMan.Load( CMouse.RSC_ID , "mouse" ) );
	}
}