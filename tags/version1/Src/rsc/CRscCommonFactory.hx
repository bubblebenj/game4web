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
		/*
		var l_Rsc : CRsc = null;
		
		switch( _Type )
		{
			case CMenuGraph.RSC_ID:
			l_Rsc =	new CMenuGraph();
			
			//CDebug.CONSOLEMSG("CRscASFactory:Initialize : " + _Path);
			
			default: trace("CRscASFactory :: Error: target type not found : " + _Type ); 
			l_Rsc = null;
		}
		*/
		return null;
	}
}