/**
 * ...
 * @author de
 */

package driver.js.renderer;

import driver.js.renderer.CPrimitiveJS;
import driver.js.rsc.CRscShaderProgram;
import driver.js.renderer.CPrimitiveJS;
import driver.js.renderer.CRenderStatesJS;

import CGL;

import renderer.CViewport;
import renderer.CRenderStates;
import renderer.C2DQuad;
import renderer.CRscShader;
import renderer.CMaterial;
import renderer.CPrimitive;
import renderer.CDrawObject;

import kernel.CDebug;
import kernel.CSystem;
import kernel.Glb;
import kernel.CTypes;

import math.CMatrix44;
import math.Registers;

import rsc.CRsc;
import rsc.CRscMan;

class CGLCube extends CDrawObject
{

	public function new() 
	{
		super();
		m_MatrixCache =  null;
	}
	
	public override function Initialize() : Result
	{
		var l_RscMan : CRscMan = Glb.g_System.GetRscMan();
		m_RS = cast( l_RscMan.Create( CRenderStates.RSC_ID ), CRenderStatesJS );
		if( m_RS == null )
		{
			CDebug.CONSOLEMSG("Unable to createrender states");
		}
		
		m_Primitive = cast( l_RscMan.Create( CPrimitive.RSC_ID ), CPrimitiveJS );
		if( m_Primitive == null )
		{
			CDebug.CONSOLEMSG("Unable to create primitive");
		}
		
		m_ShdrPrgm = cast(l_RscMan.Load( CRscShaderProgram.RSC_ID , "white"), CRscShaderProgram );
		m_ShdrPrgm.Compile();
		
		return SUCCESS;
	}
	
	public override function Draw( _Vp : Int ) : Result
	{
		m_Matrix = new CMatrix44();
		m_Matrix.Identity();
		//m_Matrix.Perspective( 45, 800.0 / 600.0, 0.1, 100.0 );
		CMatrix44.Ortho( m_Matrix, 0,1,0,1,0.01,100 );
		
		var l_Trans = new CMatrix44();
		l_Trans.Identity();
		//l_Trans.Translation(0.0, 0.0, -1.0);
		
		
		var l_MVP = new CMatrix44();
		l_MVP.Identity();
		CMatrix44.Mult( l_MVP, m_Matrix,l_Trans);
		
		var l_Err = Glb.g_SystemJS.GetGL().GetError();
		if ( l_Err  != 0)
		{
			CDebug.CONSOLEMSG("GlError:PreActivate:" + l_Err);
		}
		
		m_RS.Activate();
		
		Glb.g_SystemJS.GetGL().Disable( CGL.CULL_FACE );
		m_ShdrPrgm.Activate();
		
		
		var l_vertices : Array<Float>= [
			1.0,  1.0,  5.5,
			0.0,  1.0,  5.5,
			1.0, 0.0,  5.5,
			0.0, 0.0,  5.5
		];
		
		m_Primitive.SetVertexArray(l_vertices);
		m_ShdrPrgm.LinkPrimitive( m_Primitive );

		m_MatrixCache = new Float32Array( l_MVP.m_Buffer );
		
		var l_Err = Glb.g_SystemJS.GetGL().GetError();
		if ( l_Err  != 0)
		{
			CDebug.CONSOLEMSG("GlError:PreSetUniform:" + l_Err);
		}
		m_ShdrPrgm.UniformMatrix4fv( "u_MVPMatrix", false, m_MatrixCache );
		
		m_Matrix.Trace();
		Glb.g_SystemJS.GetGL().DrawArrays( CGL.TRIANGLE_STRIP, 0, 4);

		var l_Err = Glb.g_SystemJS.GetGL().GetError();
		if ( l_Err  != 0)
		{
			CDebug.CONSOLEMSG("GlError:PostDraw:" + l_Err);
		}
		//CDebug.CONSOLEMSG(".");
		return SUCCESS;
	}

	var m_Matrix : CMatrix44;
	var m_MatrixCache : Float32Array;
	var m_RS : CRenderStatesJS;
	var m_Primitive : CPrimitiveJS;
	var m_ShdrPrgm: CRscShaderProgram;
}