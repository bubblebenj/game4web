package driver.js.rsc;



import driver.js.renderer.CPrimitiveJS;
import driver.js.rsc.CRscVertexShader;
import driver.js.rsc.CRscFragmentShader;
import driver.js.kernel.CSystemJS;

import math.CMatrix44;

import kernel.CTypes;
import kernel.Glb;
import kernel.CSystem;
import kernel.CDebug;

import rsc.CRsc;
import rsc.CRscMan;

import renderer.CRscShader;

import CGL;


class CRscShaderProgram extends CRscShader
{
	public static var 	RSC_ID = CRscMan.RSC_COUNT++;
	
	public var			m_VtxSh : CRscVertexShader;
	public var			m_FragSh : CRscFragmentShader;
	
	public var 			m_Uniforms : Hash< WebGLUniformLocation >;
	public var 			m_Program :	WebGLProgram; 
	
	public static inline var ATTR_VERTEX : Int 	= 1 << 0;
	public static inline var ATTR_NORMAL : Int 	= 1 << 1;
	public static inline var ATTR_COLOR  : Int	= 1 << 2;
	
	public static inline var ATTR_VERTEX_INDEX : Int 	= 0;
	public static inline var ATTR_NORMAL_INDEX : Int 	= 1;
	public static inline var ATTR_COLOR_INDEX  : Int	= 2;
	
	public static inline var ATTR_MAX_INDEX  : Int	= 3;
	
	public static inline var ATTR_NAME_COLOR  	: String	= "_Color";
	public static inline var ATTR_NAME_VERTEX  	: String	= "_Vertex";
	public static inline var ATTR_NAME_NORMAL  	: String	= "_Normal";
	
	public var			m_AttribsMask : Int;
	
	public function new()
	{
		super();
		
		m_AttribsMask = 0;
		m_VtxSh = null;
		m_FragSh = null;
		m_Uniforms = null;
	}
	
	public function CreateAttributeMask() : Void
	{
		if( m_VtxSh.m_Body.lastIndexOf( ATTR_NAME_VERTEX ) != -1 )
		{
			m_AttribsMask |= ATTR_VERTEX;
		}
		
		if( m_VtxSh.m_Body.lastIndexOf( ATTR_NAME_COLOR ) != -1)
		{
			m_AttribsMask |= ATTR_COLOR;
		}
		
		if( m_VtxSh.m_Body.lastIndexOf( ATTR_NAME_NORMAL ) != -1)
		{
			m_AttribsMask |= ATTR_NORMAL;
		}
	}
	
	public function BindAttributes() : Void
	{
		var l_Gl : CGL = Glb.g_SystemJS.GetGL();
		
		if ( m_AttribsMask & ATTR_VERTEX != 0)
		{
			l_Gl.BindAttributeLocation( m_Program, ATTR_VERTEX_INDEX, ATTR_NAME_VERTEX);
		}
		
		if ( m_AttribsMask & ATTR_COLOR != 0)
		{
			l_Gl.BindAttributeLocation( m_Program, ATTR_COLOR_INDEX, ATTR_NAME_COLOR);
		}
		
		if ( m_AttribsMask & ATTR_NORMAL != 0)
		{
			l_Gl.BindAttributeLocation( m_Program, ATTR_NORMAL_INDEX, ATTR_NAME_NORMAL);
		}
	}
	
	public function LinkPrimitive( _Prim : CPrimitiveJS ) : Void
	{
		var l_Gl : CGL = Glb.g_SystemJS.GetGL();
		
		if( m_AttribsMask & ATTR_VERTEX != 0 )
		{
			l_Gl.EnableVertexAttribArray( ATTR_VERTEX_INDEX );
			l_Gl.VertexAttribPointer(ATTR_VERTEX_INDEX, _Prim.GetFloatPerVtx(), CGL.FLOAT, false, 0, 0);
		}
	}
	
	public function Initialize( _Path ) : Result
	{
		var l_Gl : CGL = Glb.g_SystemJS.GetGL();
		
		CDebug.CONSOLEMSG("Creating Shader Program :" + _Path);
		m_Uniforms = new Hash< WebGLUniformLocation >();
		
		var l_Rsc : CRsc = Glb.g_System.GetRscMan().Load( CRscVertexShader.RSC_ID, _Path + ".vsh" );
		if (l_Rsc == null )
		{
			CDebug.CONSOLEMSG("Unable to create vsh resource :" + _Path);
			return FAILURE;
		}
		
		m_VtxSh = cast( l_Rsc , CRscVertexShader);
		
		l_Rsc = Glb.g_System.GetRscMan().Load( CRscFragmentShader.RSC_ID, _Path + ".fsh" );
		if (l_Rsc == null )
		{
			CDebug.CONSOLEMSG("Unable to create fsh resource :" + _Path);
			return FAILURE;
		}
		
		m_FragSh = cast( l_Rsc, CRscFragmentShader);
			
		m_Program = l_Gl.CreateProgram();
		if (m_Program == null )
		{
			return FAILURE;
		}
		
		CreateAttributeMask();
		
		var l_Res = Compile();
		if ( l_Res == SUCCESS )
		{
			 l_Res = Link();
		}
		else 
		{
			CDebug.CONSOLEMSG("Unable to compile shader :" + _Path);
		}
		return (l_Res == SUCCESS) ? SUCCESS : FAILURE;
	}
	
	public inline function DeclUniform(_Name : String) : Void
	{
		m_Uniforms.set(_Name, Glb.g_SystemJS.GetGL().GetUniformLocation( _Name ) );
	}
	
	public function Uniform1f( _Name : String, _f0 : Float )
	{
		if ( !m_Uniforms.exists(_Name))
		{
			DeclUniform(_Name);
		}
		
		var l_Loc :  WebGLUniformLocation = m_Uniforms.get(_Name);
		if ( l_Loc != null )
		{
			Glb.g_SystemJS.GetGL().Uniform1f( l_Loc, _f0 );
		}
		
	}
	
	public function UniformMatrix4fv( _Name : String, _m0 : CMatrix44 )
	{
		if ( !m_Uniforms.exists(_Name))
		{
			DeclUniform(_Name);
		}
		
		var l_Loc :  WebGLUniformLocation = m_Uniforms.get(_Name);
		if ( l_Loc != null )
		{
			Glb.g_SystemJS.GetGL().UniformMatrix4f( l_Loc, new WebGLFloatArray( _m0.m_Buffer ) );
		}
	}
	
	public override function  Activate() : Result 
	{
		if( super.Activate() == SUCCESS )
		{
			var l_Gl : CGL = Glb.g_SystemJS.GetGL();
			l_Gl.UseProgram( m_Program );
		}
		return SUCCESS;
	}
	
	public override function  Link() : Result 
	{
		if ( m_Status >= CRscShader.SHADER_STATUS_LINKED)
		{
			return SUCCESS;
		}
		
		var l_Gl : CGL = Glb.g_SystemJS.GetGL();
		
		l_Gl.AttachShader(m_Program,m_VtxSh.m_Object);
		l_Gl.AttachShader(m_Program,m_FragSh.m_Object);
		
		BindAttributes();
		
		l_Gl.LinkProgram(m_Program);
		
		if( l_Gl.GetProgramParameter( m_Program, CGL.LINK_STATUS ) == 0)
		{
			var l_Error = l_Gl.GetProgramInfoLog ( m_Program);
			trace("Error in program linking:"+l_Error);

			return FAILURE;
		}

		m_Status = CRscShader.SHADER_STATUS_LINKED;
		return SUCCESS;
	}
	
	public override function Compile() : Result
	{
		if ( m_VtxSh != null)
		{
			if(m_VtxSh.Compile()==FAILURE)
			{
				return FAILURE;
			}
		}
		else 
		{
			return FAILURE;
		}
		
		if ( m_FragSh != null)
		{
			if ( m_FragSh.Compile() == FAILURE )
			{
				return FAILURE;
			}
		}
		else 
		{
			return FAILURE;
		}
		
		m_Status = CRscShader.SHADER_STATUS_COMPILED;
		
		return SUCCESS;
	}
}