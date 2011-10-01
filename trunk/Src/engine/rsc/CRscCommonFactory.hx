/**
 * ...
 * @author Benjamin Dubois
 */

package rsc;

import rsc.CRsc;
import rsc.CRscBuilder;
//import logic.CMenuGraph;

class CRscCommonFactory extends CRscBuilder 
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
			case CMenuDAE.RSC_ID:
			l_Rsc =	new CRscDAE();
			
			default: trace("CRscASFactory :: Error: target type not found : " + _Type ); 
			l_Rsc = null;
		}
		
		return null;
	}
}