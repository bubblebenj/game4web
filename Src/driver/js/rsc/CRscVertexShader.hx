/**
 * ...
 * @author de
 */

package driver.js.rsc;

import kernel.CSystem;
import kernel.Glb;
import kernel.CTypes;
import kernel.CDebug;

import js.Dom;
import rsc.CRsc;
import rsc.CRscMan; 

import CGL;

import renderer.CRscShader;

import driver.js.kernel.CTypesJS;
import driver.js.kernel.CSystemJS;

class CRscVertexShader extends CRscShader
{
	public static var	RSC_ID = CRscMan.RSC_COUNT++;
	
	public var			m_Object : WebGLShader;
	public var			m_Body : DOMString;
	
	public function new()
	{
		super();
		m_Object = null;
		m_Body = "";
	}
	
	public function Initialize( _Script : Dom ) : Result 
	{
		var l_Body = _Script.firstChild;
		var l_Prev = null;
		while ( l_Body != null ) 
		{
			l_Prev = l_Body;
			l_Body = l_Body.nextSibling;
		}
		
		m_Body = l_Prev.nodeValue;
		
		trace("CRVS::ShaderBody " + m_Body );

		if (_Script.getAttribute("type")  == "x-shader/x-fragment") 
		{
			trace("Initialize vsh , but received fsh");
			return FAILURE;
		} 
		else if (_Script.getAttribute("type")  == "x-shader/x-vertex") 
		{
			m_Object = Glb.g_SystemJS.GetGL().CreateShader(CGL.VERTEX_SHADER);
		} 
		else 
		{
			trace("cannot init vsh");
			return FAILURE;
		}
		
		trace("Initialize vsh");
		
		return SUCCESS;
	}


	public override function Compile() : Result
	{
		var l_Gl : CGL = Glb.g_SystemJS.GetGL();
		
		l_Gl.ShaderSource(m_Object, m_Body);
		l_Gl.CompileShader(m_Object);
		
		if( !l_Gl.GetShaderParameter( m_Object, CGL.COMPILE_STATUS) ) 
		{
			var l_Error = l_Gl.GetShaderInfoLog ( m_Object );
			if (l_Error != null)
			{
				CDebug.CONSOLEMSG("Error in vertex shader compile: " + l_Error);
			}
			else 
			{
				CDebug.CONSOLEMSG("Unknown error in vertex shader compile " );
			}
			return FAILURE;
		}
		
		CDebug.CONSOLEMSG("Success in vertex shader compiling.");
		return SUCCESS;
	}
	
	
}
