/**
 * ...
 * @author de
 */

package input;

import kernel.CTypes;

import rsc.CRsc;
import rsc.CRscMan;


class CKeyboard extends CRsc
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
	
	public function Update() : Result;
	
	public function IsKeyDown( _Kc : Int ) : Result;
	public function IsKeyUp( _Kc : Int ) : Result;
}