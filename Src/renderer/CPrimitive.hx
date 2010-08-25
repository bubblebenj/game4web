/**
 * ...
 * @author de
 */

package renderer;

import kernel.CTypes;

import rsc.CRsc;
import rsc.CRscMan;


class CPrimitive extends CRsc
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
	
	//dyn does not actually ensure double buffering just vb change submission
	
	public function SetTexCooArray(  _TexCoords : Array< Float > ) : Void;
	public function SetNormalArray(  _Normals : Array< Float > ) : Void;
	public function SetIndexArray(  _Indexes : Array< Int > ) : Void;
	public function SetVertexArray(  _Vertices : Array< Float > , _Dyn ) : Void;
	
	public function HasIndex() : Bool														{ return false;  }
	
	public function LockVertexArray() : Dynamic;
	public function ReleaseVertexArray();
}