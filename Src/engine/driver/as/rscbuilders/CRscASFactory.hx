/**
 * ...
 * @author Benjamin Dubois
 */

package driver.as.rscbuilders;

import driver.as.input.CKeyboardAS;
import driver.as.input.CMouseAS;
import driver.as.rsc.CRscImageAS;
import driver.as.rsc.CRscTextAS;
import driver.as.renderer.C2DCameraAS;

import CTypes;
import CDebug;
import input.CMouse;
import input.CKeyboard;
import renderer.camera.C2DCamera;

import rsc.CRscBuilder;
import rsc.CRsc;
import rsc.CRscImage;
import rsc.CRscText;

class CRscASFactory extends CRscBuilder 
{
	public function new() 
	{
		super();
	}
	
	public override function Build( _Type : RSC_TYPES, _Path : String ) : CRsc
	{
		var l_Rsc : CRsc = null;
		
		switch( _Type )
		{
			case CRscImage.RSC_ID:
			l_Rsc =	new CRscImageAS();
			
			case CRscText.RSC_ID:
			l_Rsc =	new CRscTextAS();
			
			case CMouse.RSC_ID:
			l_Rsc =	new CMouseAS();
			
			case CKeyboard.RSC_ID:
			l_Rsc =	new CKeyboardAS();
			
			//CDebug.CONSOLEMSG("CRscASFactory:Initialize : " + _Path);
			
			default: trace("CRscASFactory :: Error: target type not found : " + _Type ); 
			l_Rsc = null;
		}
		
		return l_Rsc;
	}
}