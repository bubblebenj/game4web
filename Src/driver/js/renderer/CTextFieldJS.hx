package driver.js.renderer;
import renderer.C2DQuad;

/**
 * ...
 * @author bdubois
 */

class CTextFieldJS extends C2DQuad, implements I2DImage 
{
	public function new() 
	{
		
	}
	
	public function Load( _Path )	: Result
	{
		var l_RscMan : CRscMan = Glb.g_System.GetRscMan();
		
		var l_Res = SetRsc( cast( l_RscMan.Load( CRscText.RSC_ID , _Path ), CRscTextJS ) );
		
		return l_Res;
	}
	
	public function SetRsc( _Rsc : CRscText )	: Result
	{
		var l_Res = ( m_RscText != null) ? SUCCESS : FAILURE;
		
		return l_Res;
	}
	
	private function CreateTextField() : Void
	{

	}
	
	public override function Update() : Result
	{
		return SUCCESS;
	}

}