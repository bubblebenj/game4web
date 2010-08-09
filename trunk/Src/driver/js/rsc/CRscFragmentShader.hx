/**
 * ...
 * @author de
 */

package driver.js.rsc;

import kernel.CTypes;
import kernel.Glb;
import kernel.CSystem
;

import rsc.CRsc;
import rsc.CRscMan;

import renderer.CRscShader;

import js.Dom;
import driver.js.kernel.CTypesJS;
import driver.js.kernel.CSystemJS;
import rsc.CRsc;
import rsc.CRscMan;

import CGL;

class CRscFragmentShader extends CRscShader
{
	public static var 	RSC_ID = CRscMan.RSC_COUNT++;
	
	public var			m_Object : WebGLShader;
	public var			m_Body : DOMString;
	
	public function new()
	{
		super();
		m_Body = "";
		m_Object = null;
	}
	
	public function Initialize(_Script : Dom) : Result 
	{
		var l_Body = _Script.firstChild;
		var l_Prev = null;
		while ( l_Body != null ) 
		{
			l_Prev = l_Body;
			l_Body = l_Body.nextSibling;
		}
		
		m_Body = l_Prev.nodeValue;
		trace("CRFS::ShaderBody " + m_Body );
		
		if (_Script.getAttribute("type")  == "x-shader/x-fragment") 
		{
			m_Object = Glb.g_SystemJS.GetGL().CreateShader(CGL.FRAGMENT_SHADER);
		} 
		else if (_Script.getAttribute("type")  == "x-shader/x-vertex") 
		{
			trace("Initializing fsh , but received vsh");
			return FAILURE;
		} 
		else 
		{
			trace("cannot recog Initing vsh");
			return FAILURE;
		}
		
		return SUCCESS;
	}

	public override function Compile() : Result
	{
		var l_Gl : CGL = Glb.g_SystemJS.GetGL();
		
		l_Gl.ShaderSource(m_Object, m_Body);
		l_Gl.CompileShader(m_Object);
		
		if( !l_Gl.GetShaderParameter( m_Object, CGL.COMPILE_STATUS) ) 
		{
			return FAILURE;
		}
		
		return SUCCESS;
	}
}

typedef CRscPixelShader = CRscFragmentShader;