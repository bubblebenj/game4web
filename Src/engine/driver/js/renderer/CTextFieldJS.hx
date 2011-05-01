package driver.js.renderer;

import kernel.CTypes;
import kernel.Glb;

import renderer.C2DQuad;
import renderer.ITextField;

import rsc.CRscText;
import rsc.CRscMan;

/**
 * ...
 * @author bdubois
 */

class CTextFieldJS extends C2DQuad, implements ITextField 
{
	public function new() 
	{
		super();
	}
	
	public function Load( _Path )	: Result
	{
		//var l_RscMan : CRscMan = Glb.g_System.GetRscMan();
		//
		//var l_Res = SetRsc( cast( l_RscMan.Load( CRscText.RSC_ID , _Path ), CRscTextJS ) );
		
		//return l_Res;
		return SUCCESS;
	}
	
	public function SetRsc( _Rsc : CRscText )	: Result
	{
		var l_Res = ( m_RscText != null) ? SUCCESS : FAILURE;
		
		return l_Res;
	}
	
	public function SetText( _Text : String ) : Void
	{
	}
	
	private function CreateTextField() : Void
	{
	}
	
	public override function Update() : Result
	{
		return SUCCESS;
	}
	
	private var m_RscText	: CRscText;
}