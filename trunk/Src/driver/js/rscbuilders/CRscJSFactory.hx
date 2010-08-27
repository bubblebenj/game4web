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
import driver.js.renderer.CRscTextureJS;
import driver.js.renderer.CRscImageJS;

import kernel.CTypes;
import kernel.CMouse;
import kernel.CDebug;

import renderer.CRscTexture;
import renderer.CMaterial;
import renderer.CViewport;
import renderer.CRenderStates;
import renderer.CPrimitive;

import rsc.CRscBuilder;
import rsc.CRsc;
import rsc.CRscImage;

/*
typedef BuildPair = {
		var m_Rsc : RSC_TYPES;
		var m_Func : String -> CRsc;
	 };
*/

class CRscJSFactory extends CRscBuilder 
{
	
	
	public function new() 
	{
		super();
		
		/*
		var l_Arr : Array<BuildPair> = new Array<BuildPair>();
	
		l_Arr[0] = { 	m_Rsc : CMaterial.RSC_ID,
						m_Func : function(_Path : String) { return cast new CMaterialJS();  }};
		*/
		//var l_NewInstance = l_BuildFunc( "d:\\temp" );
		
	}
	
	public override function Build( _Type : RSC_TYPES, _Path : String ) : CRsc
	{
		var l_Rsc : CRsc = null;
		
		switch( _Type )
		{
			case CMaterial.RSC_ID:
			l_Rsc =	new CMaterialJS();
			
			case CRscTexture.RSC_ID:
			l_Rsc =	new CRscTextureJS();
			
			case CPrimitive.RSC_ID:
			l_Rsc =	new CPrimitiveJS();
			
			case CRenderStates.RSC_ID:
			l_Rsc =	new CRenderStatesJS();
			
			case CViewport.RSC_ID:
			l_Rsc =	new CViewportJS();
			
			case CMouse.RSC_ID:
			l_Rsc =	new CMouseJS();
			
			case CRscTexture.RSC_ID:
			l_Rsc =	new CRscTextureJS();
			CDebug.CONSOLEMSG("Newing CRscTexture : " + l_Rsc.GetType());
			
			case CRscImage.RSC_ID:
			l_Rsc =	new CRscImageJS();
			CDebug.CONSOLEMSG("Newing CRscImage : " + l_Rsc.GetType());
				
			default: CDebug.CONSOLEMSG("*_* CRscJSFactory :: Error: target type not found : " + _Type ); 
			l_Rsc = null;
		}
		
		
		return l_Rsc;
	}

	
}