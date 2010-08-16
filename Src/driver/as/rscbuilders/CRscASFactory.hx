/**
 * ...
 * @author Benjamin Dubois
 */

package driver.as.rscbuilders;

import driver.as.rsc.CRscImageAS;
import kernel.CTypes;

import rsc.CRscBuilder;
import rsc.CRsc;

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
			l_Rsc.Initialize();
			
			default: trace("*_* CRscASFactory :: Error: target type not found : " + _Type ); 
			l_Rsc = null;
		}
		
		return l_Rsc;
	}
}