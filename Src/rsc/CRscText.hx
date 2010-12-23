/**
 * ...
 * @author Benjamin Dubois
 */

package rsc;

import kernel.CTypes;

import rsc.CRsc;
import rsc.CRscMan;

class CRscText extends CRsc
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
	
	public function GetTextData() : String
	{
		return null;
	}
}