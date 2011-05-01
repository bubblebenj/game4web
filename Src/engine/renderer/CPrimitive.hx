/**
 * ...
 * @author de
 */

package renderer;

import CTypes;

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
	
	public function SetTexCooArray(  _TexCoords : Array< Float > , _Dyn : Bool) : Void;
	public function SetNormalArray(  _Normals : Array< Float > , _Dyn : Bool) : Void;
	public function SetIndexArray(  _Indexes : Array< Int > , _Dyn : Bool) : Void;
	public function SetVertexArray(  _Vertices : Array< Float > , _Dyn : Bool ) : Void;
	
	public function HasIndexArray() : Bool { return false; }														
	public function HasNormalArray() : Bool { return false; }													
	public function HasTexCoordArray() : Bool { return false; }									
	
	public function LockVertexArray() : Dynamic;
	public function ReleaseVertexArray() : Void;
	
	public function LockTexCoordArray() : Dynamic;
	public function ReleaseTexCoordArray() : Void;
	
	public function BindVertexBuffer() : Result  { return FAILURE;  }
	public function BindNormalBuffer() : Result  { return FAILURE;  }
	public function BindColorBuffer() : Result  { return FAILURE;  }
	public function BindTexCoordBuffer() : Result  { return FAILURE;  }
}