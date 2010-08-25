/**
 * ...
 * @author de
 */

package driver.js.rscbuilders;

import driver.js.kernel.CMouseJS;
import driver.js.renderer.CMaterialJS;
import driver.js.renderer.CPrimitiveJS;
import driver.js.renderer.CRenderStatesJS;
import driver.js.renderer.CViewportJS;
import driver.js.renderer.CTextureJS;

import kernel.CTypes;
import kernel.CMouse;

import renderer.CTexture;
import renderer.CMaterial;
import renderer.CViewport;
import renderer.CRenderStates;
import renderer.CPrimitive;

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
			l_Rsc =	new CTextureJS();
			
			case CPrimitive.RSC_ID:
			l_Rsc =	new CPrimitiveJS();
			
			case CRenderStates.RSC_ID:
			l_Rsc =	new CRenderStatesJS();
			
			case CViewport.RSC_ID:
			l_Rsc =	new CViewportJS();
			
			case CMouse.RSC_ID:
			l_Rsc =	new CMouseJS();
				
			default: trace("*_* CRscJSFactory :: Error: target type not found : " + _Type ); 
			l_Rsc = null;
		}
		
		
		return l_Rsc;
	}

	
}