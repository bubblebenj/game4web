/**
 * ...
 * @author de
 */

package driver.js.rscbuilders;

import driver.js.rsc.CRscVertexShader;
import driver.js.rsc.CRscFragmentShader;
import driver.js.rsc.CRscShaderProgram;

import kernel.CDebug;

import rsc.CRscBuilder;
import rsc.CRsc;

class CRscBuilderDocElem extends CRscBuilder 
{

	public function new() 
	{
		super();
	}

	public override function Build( _Type : RSC_TYPES, _Path : String ) : CRsc
	{
		if ( _Type == CRscShaderProgram.RSC_ID )
		{
			var l_Ret = new CRscShaderProgram();
			
			l_Ret.Initialize(_Path );
			
			if (l_Ret == null)
			{
				CDebug.CONSOLEMSG("Unable to create shader prgm ");
			}
			
			return l_Ret;
		}
		
		var l_Script : Dynamic = js.Lib.document.getElementById( _Path );
		if (!l_Script) 
		{
			CDebug.CONSOLEMSG("*_* Error: script "+ _Path+" not found for type : " + _Type );
			return null;
		}
		
		var l_ScriptType : Dynamic = l_Script.type;
		
		if( _Type == CRscVertexShader.RSC_ID )
		{
			var l_Ret = new CRscVertexShader();
			CDebug.CONSOLEMSG("Initializing vsh :" + _Path);
			l_Ret.Initialize(l_Script);
			return l_Ret;
		}
		
		if( _Type == CRscFragmentShader.RSC_ID )
		{
			var l_Ret = new CRscFragmentShader();
			CDebug.CONSOLEMSG("Initializing fsh:" + _Path);
			l_Ret.Initialize(l_Script);
			return l_Ret;
		}
		
		trace("*_* Error: target type not found : " + _Type );
		return null;
	}

	
	var m_Path : String;
}