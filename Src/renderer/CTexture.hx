/**
 * ...
 * @author de
 */

package renderer;

import kernel.CTypes;
import rsc.CRsc;
import rsc.CRscMan;


class CTexture extends CRsc
{
	public static var 	RSC_ID = CRscMan.RSC_COUNT++;
	public override function GetType() : Int
	{
		return RSC_ID;
	}
	
	public function new() 
	{
		super();
	}
	
	public function Activate() : Result
	{
		
		return SUCCESS;
	}
}