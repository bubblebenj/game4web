/**
 * ...
 * @author Benjamin Dubois
 */

package driver.as.rscbuilders;

import driver.as.kernel.CMouseAS;
import driver.as.rsc.CRscImageAS;
import driver.as.rsc.CRscTextAS;

import kernel.CTypes;
import kernel.CDebug;
import kernel.CMouse;

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
			
			//CDebug.CONSOLEMSG("CRscASFactory:Initialize : " + _Path);
			
			default: trace("CRscASFactory :: Error: target type not found : " + _Type ); 
			l_Rsc = null;
		}
		
		return l_Rsc;
	}
}