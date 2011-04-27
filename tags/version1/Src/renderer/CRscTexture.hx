/**
 * ...
 * @author de
 */

package renderer;

import kernel.Glb;
import kernel.CTypes;

import rsc.CRsc;
import rsc.CRscMan;
import rsc.CRscImage;


class CRscTexture extends CRsc
{
	public static var 	RSC_ID = CRscMan.RSC_COUNT++;
	
	var m_RscImage : CRscImage;
	
	public override function GetType() : Int
	{
		return RSC_ID;
	}
	
	public function new() 
	{
		super();
		m_RscImage = null;
	}
	
	public override function SetPath( _Path : String ) : Void 
	{
		super.SetPath(_Path);
		if ( _Path != null )
		{
			m_RscImage = cast( Glb.g_System.GetRscMan().Load( CRscImage.RSC_ID, _Path ), CRscImage );
		}
		else
		{
			m_RscImage = cast(Glb.g_System.GetRscMan().Create( CRscImage.RSC_ID ), CRscImage );
		}
	}
	
	public function Activate( ?_Stage : Int ) : Result
	{
		
		return SUCCESS;
	}
}