package driver.js.rsc;



import driver.js.renderer.CPrimitiveJS;
import driver.js.rsc.CRscVertexShader;
import driver.js.rsc.CRscFragmentShader;
import driver.js.kernel.CSystemJS;
import renderer.CPrimitive;

import math.CMatrix44;

import CTypes;
import kernel.Glb;
import kernel.CSystem;
import CDebug;

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
	
	public static inline var ATTR_VERTEX_INDEX : Int 	= 0;
	public static inline var ATTR_NORMAL_INDEX : Int 	= ATTR_VERTEX_INDEX + 3;
	public static inline var ATTR_COLOR_INDEX  : Int	= ATTR_VERTEX_INDEX + 2;
	public static inline var ATTR_TEXCOORD_INDEX  : Int	= ATTR_VERTEX_INDEX + 1;
	
	public static inline var ATTR_VERTEX 		: Int 	= 1 << ATTR_VERTEX_INDEX;
	public static inline var ATTR_NORMAL 		: Int 	= 1 << ATTR_NORMAL_INDEX;
	public static inline var ATTR_COLOR  		: Int	= 1 << ATTR_COLOR_INDEX;
	public static inline var ATTR_TEXCOORD 		: Int	= 1 << ATTR_TEXCOORD_INDEX;
	
	public static inline var ATTR_MAX_INDEX  : Int	= ATTR_TEXCOORD_INDEX + 4;
	
	public static inline var ATTR_NAME_COLOR  	: String	= "_Color";
	public static inline var ATTR_NAME_VERTEX  	: String	= "_Vertex";
	public static inline var ATTR_NAME_NORMAL  	: String	= "_Normal";
	public static inline var ATTR_NAME_TEXCOORD	: String	= "_TexCoord";
	
	public var					m_AttribsMask : Int;
	
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
			CDebug.CONSOLEMSG("Found Vertex channel.");
		}
		
		if( m_VtxSh.m_Body.lastIndexOf( ATTR_NAME_COLOR ) != -1)
		{
			m_AttribsMask |= ATTR_COLOR;
			CDebug.CONSOLEMSG("Found Color channel.");
		}
		
		if( m_VtxSh.m_Body.lastIndexOf( ATTR_NAME_NORMAL ) != -1)
		{
			m_AttribsMask |= ATTR_NORMAL;
			CDebug.CONSOLEMSG("Found Normal channel.");
		}
		
		if( m_VtxSh.m_Body.lastIndexOf( ATTR_NAME_TEXCOORD ) != -1)
		{
			m_AttribsMask |= ATTR_TEXCOORD;
			CDebug.CONSOLEMSG("Found Tex coord.");
		}
	}
	
	public function BindAttributes() : Void
	{
		var l_Gl : CGL = Glb.g_SystemJS.GetGL();
		
		if ( m_AttribsMask & ATTR_VERTEX != 0)
		{
			l_Gl.BindAttribLocation( m_Program, ATTR_VERTEX_INDEX, ATTR_NAME_VERTEX);
		}
		
		if ( m_AttribsMask & ATTR_COLOR != 0)
		{
			l_Gl.BindAttribLocation( m_Program, ATTR_COLOR_INDEX, ATTR_NAME_COLOR);
		}
		
		if ( m_AttribsMask & ATTR_NORMAL != 0)
		{
			l_Gl.BindAttribLocation( m_Program, ATTR_NORMAL_INDEX, ATTR_NAME_NORMAL);
		}
		
		if ( m_AttribsMask & ATTR_TEXCOORD != 0)
		{
			l_Gl.BindAttribLocation( m_Program, ATTR_TEXCOORD_INDEX, ATTR_NAME_TEXCOORD);
		}
	}
	
	public override function LinkPrimitive( _Prim : CPrimitive ) : Result
	{
		var l_Gl : CGL = Glb.g_SystemJS.GetGL();
		var l_Prim : CPrimitiveJS = cast _Prim;
		
		
		if( m_AttribsMask & ATTR_VERTEX != 0 )
		{
			_Prim.BindVertexBuffer();
			l_Gl.EnableVertexAttribArray( ATTR_VERTEX_INDEX );
			l_Gl.VertexAttribPointer(ATTR_VERTEX_INDEX, l_Prim.GetFloatPerVtx(), CGL.FLOAT, CGL.FALSE, 0, 0);
			
			var l_Err = Glb.g_SystemJS.GetGL().GetError();
			if ( l_Err  != 0)
			{
				CDebug.CONSOLEMSG("GlError:VertexAttribPointer:Vertex:" + l_Err);
			}
			else 
			{
				//CDebug.CONSOLEMSG("*");
			}
		}
		
		if( m_AttribsMask & ATTR_NORMAL!= 0 )
		{
			_Prim.BindNormalBuffer();
			l_Gl.EnableVertexAttribArray( ATTR_NORMAL_INDEX );
			l_Gl.VertexAttribPointer( ATTR_NORMAL_INDEX, l_Prim.GetFloatPerNormal(), CGL.FLOAT, CGL.FALSE, 0, 0);
			
			var l_Err = Glb.g_SystemJS.GetGL().GetError();
			if ( l_Err  != 0)
			{
				CDebug.CONSOLEMSG("GlError:VertexAttribPointer:Normal:" + l_Err);
			}
		}
		
		if( m_AttribsMask & ATTR_COLOR != 0 )
		{
			_Prim.BindColorBuffer();
			l_Gl.EnableVertexAttribArray( ATTR_COLOR_INDEX );
			l_Gl.VertexAttribPointer( ATTR_COLOR_INDEX, l_Prim.GetFloatPerColor(), CGL.FLOAT, CGL.FALSE, 0, 0);
			
			var l_Err = Glb.g_SystemJS.GetGL().GetError();
			if ( l_Err  != 0)
			{
				CDebug.CONSOLEMSG("GlError:VertexAttribPointer:Color:" + l_Err);
			}
		}
		
		if( m_AttribsMask & ATTR_TEXCOORD != 0 )
		{
			_Prim.BindTexCoordBuffer();
			l_Gl.EnableVertexAttribArray( ATTR_TEXCOORD_INDEX );
			l_Gl.VertexAttribPointer( ATTR_TEXCOORD_INDEX, l_Prim.GetFloatPerTexCoord(), CGL.FLOAT, CGL.FALSE, 0, 0);
			
			var l_Err = Glb.g_SystemJS.GetGL().GetError();
			if ( l_Err  != 0)
			{
				CDebug.CONSOLEMSG("GlError:VertexAttribPointer:TexCoord:" + l_Err);
			}
		}
	
		//CDebug.CONSOLEMSG("Unable to find Attrib channel");
		return SUCCESS;
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
			if ( l_Res == SUCCESS )
			{
				CDebug.CONSOLEMSG("Success linking shader :" + _Path);
			}
			else 
			{
				CDebug.CONSOLEMSG("Unable to link shader :" + _Path);
			}
		}
		else 
		{
			CDebug.CONSOLEMSG("Unable to compile shader :" + _Path);
		}
		return (l_Res == SUCCESS) ? SUCCESS : FAILURE;
	}
	
	public inline function DeclUniform(_Name : String) : Void
	{
		var l_Loc :  WebGLUniformLocation = Glb.g_SystemJS.GetGL().GetUniformLocation( m_Program, _Name );
		if (l_Loc == null )
		{
			CDebug.CONSOLEMSG("Unable to get uniform location: <" + _Name + ">");
			var l_Err = Glb.g_SystemJS.GetGL().GetError();
			if ( l_Err  != 0)
			{
				CDebug.CONSOLEMSG("GlError:GetUniformLocation:" + l_Err);
			}
		}
		m_Uniforms.set(_Name, l_Loc );
	}
	
	public override function SetUniform1f( _Name : String, _f0 : Float ) : Result
	{
		if ( !m_Uniforms.exists(_Name))
		{
			DeclUniform(_Name);
		}
		
		var l_Loc :  WebGLUniformLocation = m_Uniforms.get(_Name);
		if ( l_Loc != null )
		{
			Glb.g_SystemJS.GetGL().Uniform1f( l_Loc, _f0 );
			return FAILURE;
		}
		
		return SUCCESS;
	}
	
	public  override function  SetUniform1i( _Name : String, _Value : Int ) : Result 
	{
		if ( !m_Uniforms.exists(_Name))
		{
			DeclUniform(_Name);
			CDebug.CONSOLEMSG("DeclaredUniform1i " + _Name);
		}
		
		var l_Loc :  WebGLUniformLocation = m_Uniforms.get(_Name);
		if ( l_Loc != null )
		{
			Glb.g_SystemJS.GetGL().Uniform1i( l_Loc, _Value ); 
			
			var l_Err = Glb.g_SystemJS.GetGL().GetError();
			if ( l_Err  != 0)
			{
				CDebug.CONSOLEMSG("GlError:Uniform1i:" + l_Loc + "::" + l_Err);
				return FAILURE;
			}
			
		}
		
		return SUCCESS;
	}
	
	public override function SetUniformMatrix4f( _Name : String, _m0 : CMatrix44 ): Result
	{
		if ( !m_Uniforms.exists(_Name))
		{
			DeclUniform(_Name);
			CDebug.CONSOLEMSG("DeclaredUniformMatrix4fv " + _Name);
		}
		
		var l_Loc :  WebGLUniformLocation = m_Uniforms.get(_Name);
		if ( l_Loc != null )
		{
			Glb.g_SystemJS.GetGL().UniformMatrix4f( l_Loc, CGL.FALSE, _m0.m_Buffer );
			
		}
		else 
		{
			CDebug.CONSOLEMSG("UnableToSetUniformMatrix4fv");
			return FAILURE;
		}
		
		var l_Err = Glb.g_SystemJS.GetGL().GetError();
		if ( l_Err  != 0)
		{
			CDebug.CONSOLEMSG("GlError:postSetUniform4fv:" + l_Err);
			return FAILURE;
		}
		return SUCCESS;
	}
	
	public override function  Activate() : Result 
	{
		if( super.Activate() == SUCCESS )
		{
			var l_Gl : CGL = Glb.g_SystemJS.GetGL();
			
			if ( l_Gl.GetProgramParameter( m_Program, CGL.LINK_STATUS ) != true )
			{
				var l_Error = l_Gl.GetProgramInfoLog ( m_Program );
				if (l_Error != null)
				{
					CDebug.CONSOLEMSG("Error in post shader use program: " + l_Error);
				}
			}
			
			l_Gl.UseProgram( m_Program );
			
			if ( l_Gl.GetProgramParameter( m_Program, CGL.LINK_STATUS ) != true )
			{
				var l_Error = l_Gl.GetProgramInfoLog ( m_Program);
				if (l_Error != null)
				{
					CDebug.CONSOLEMSG("Error in post shader use program: " + l_Error);
				}
			}
			
			var l_GlError = l_Gl.GetError();
			if (l_GlError !=0)
			{
				CDebug.CONSOLEMSG("Error in shader program use: " + l_GlError);
			}
		}
		
		return SUCCESS;
	}
	
	public function PrintError() : Void
	{
		var l_Gl : CGL = Glb.g_SystemJS.GetGL();
		if( l_Gl.GetProgramParameter( m_Program, CGL.COMPILE_STATUS ) != true )
		{
			var l_Error = l_Gl.GetProgramInfoLog ( m_Program);
			if (l_Error != null)
			{
				CDebug.CONSOLEMSG("Error in shader program compiling: " + l_Error + " GL = " + l_Gl.GetError() );
			}
		}
		
		if( l_Gl.GetProgramParameter( m_Program, CGL.LINK_STATUS ) == 0 )
		{
			var l_Error = l_Gl.GetProgramInfoLog ( m_Program);
			if (l_Error != null)
			{
				CDebug.CONSOLEMSG("Error in shader program linking: " + l_Error);
			}
		}
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
		
		CDebug.ASSERT( l_Gl.GetAttribLocation( m_Program, ATTR_NAME_VERTEX ) == ATTR_VERTEX_INDEX );
		
		if( m_AttribsMask & ATTR_TEXCOORD != 0 )
		{
			CDebug.ASSERT( l_Gl.GetAttribLocation( m_Program, ATTR_NAME_TEXCOORD ) == ATTR_TEXCOORD_INDEX);
		}
		
		if( l_Gl.GetProgramParameter( m_Program, CGL.LINK_STATUS ) != true)
		{
			var l_Error = l_Gl.GetProgramInfoLog ( m_Program);
			CDebug.CONSOLEMSG("Error in program linking:"+l_Error);
			return FAILURE;
		}

		CDebug.CONSOLEMSG("Shader Linked");
		m_Status = CRscShader.SHADER_STATUS_LINKED;
		return SUCCESS;
	}
	
	public override function Compile() : Result
	{
		
		if ( m_VtxSh != null)
		{
			if(m_VtxSh.Compile()==FAILURE)
			{
				CDebug.CONSOLEMSG("Vertex shader compile failed.");
				PrintError();
				return FAILURE;
			}
		}
		else 
		{
			CDebug.CONSOLEMSG("Can't proceed : Vertex shader is null");
			return FAILURE;
		}
		
		if ( m_FragSh != null)
		{
			if ( m_FragSh.Compile() == FAILURE )
			{
				CDebug.CONSOLEMSG("Fragment shader compile failed.");
				PrintError();
				return FAILURE;
			}
		}
		else 
		{
			CDebug.CONSOLEMSG("Can't proceed : Fragment shader is null");
			return FAILURE;
		}
		
		m_Status = CRscShader.SHADER_STATUS_COMPILED;
		
		return SUCCESS;
	}
}