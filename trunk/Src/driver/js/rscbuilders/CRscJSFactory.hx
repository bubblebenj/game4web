/**
 * ...
 * @author de
 */

package driver.js.rscbuilders;

import driver.js.renderer.CMaterialJS;
import driver.js.renderer.CViewportJS;
import driver.js.renderer.CRenderStatesJS;

import kernel.CTypes;

import renderer.CTexture;
import renderer.CMaterial;
import renderer.CViewport;
import renderer.CRenderStates;

import rsc.CRscBuilder;
import rsc.CRsc;


class CRscJSFactory extends CRscBuilder 
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
			case CMaterial.RSC_ID:
			l_Rsc =	new CMaterialJS();
			
			case CTexture.RSC_ID:
			l_Rsc =	new CTexture();
			
			case CRenderStates.RSC_ID:
			l_Rsc =	new CRenderStatesJS();
			
			case CViewport.RSC_ID:
			l_Rsc =	new CViewportJS();
				
			default: trace("*_* CRscJSFactory :: Error: target type not found : " + _Type ); 
			l_Rsc = null;
		}
		
		
		return l_Rsc;
	}

	
}