/**
 * ...
 * @author de
 */

package driver.js.renderer;

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

import kernel.CDebug;
import kernel.CSystem;
import kernel.Glb;
import kernel.CTypes;

import math.CMatrix44;
import math.Registers;

import rsc.CRsc;
import rsc.CRscMan;

class CGlQuad extends C2DQuad
{

	public function new() 
	{
		super();
		
		m_Material = null;
		m_ShdrPrgm = null;
	}
	
	public function Shut() : Result
	{
		m_ShdrPrgm.Release();
		m_ShdrPrgm = null;
		
		m_Material.Release();
		m_Material = null;
		
		return SUCCESS;
	}
	
	public override function Initialize() : Result
	{
		var l_RscMan : CRscMan = Glb.g_System.GetRscMan();
		
		m_ShdrPrgm = cast(l_RscMan.Load( CRscShaderProgram.RSC_ID , "white"), CRscShaderProgram );
		if( m_ShdrPrgm  != null)
		{
			CDebug.CONSOLEMSG("create gl quad shader");
		}
		else 
		{
			CDebug.CONSOLEMSG("unable to create gl quad shader");
		}
		var l_Res = m_ShdrPrgm != null ? SUCCESS : FAILURE;
		
		if ( l_Res == SUCCESS  )
		{
			m_ShdrPrgm.Compile();
		}
		
		m_Material = cast(l_RscMan.Create( CMaterial.RSC_ID ), CMaterial );
		
		if (m_Material != null)
		{
			m_Material.SetShader(m_ShdrPrgm);
		}
		else 
		{
			CDebug.CONSOLEMSG("Unable to create material");
		}
		
		m_Primitive = cast( l_RscMan.Create( CPrimitive.RSC_ID ), CPrimitiveJS );
		if( m_Primitive == null )
		{
			CDebug.CONSOLEMSG("Unable to create primitive");
		}
		
		m_RenderStates = cast( l_RscMan.Create( CRenderStates.RSC_ID ), CRenderStatesJS );
		if( m_RenderStates == null )
		{
			CDebug.CONSOLEMSG("Unable to create primitive");
		}
		
		CreateData();
		return l_Res;
	}
	
	public function CreateData()
	{
		var l_Array : Array<Float> = new Array<Float>();

		var l_Z : Float = -5.0;
		var l_Scale : Float = 1.0;
		
		l_Array[0] = 0;
		l_Array[1] = 0;
		l_Array[2] = l_Z;
		
		l_Array[3] = 1 * l_Scale;
		l_Array[4] = 0.0;
		l_Array[5] = l_Z;
		
		l_Array[6] = 0;
		l_Array[7] = 1 * l_Scale;
		l_Array[8] = l_Z;
		
		l_Array[9] = 1 * l_Scale;
		l_Array[10] = 1 * l_Scale;
		l_Array[11] = l_Z;
		
		m_Primitive.SetVertexArray( l_Array , false );
		
		var l_IndexArray : Array<Int> = new Array<Int>();
		
		l_IndexArray[0] = 0;
		l_IndexArray[1] = 1;
		l_IndexArray[2] = 2;
		
		l_IndexArray[3] = 3;
		l_IndexArray[4] = 2;
		l_IndexArray[5] = 1;
		
		m_Primitive.SetIndexArray(l_IndexArray);
	}

	public function UpdateQuad(_VpId : Int )
	{	
		var l_Vp : CViewport = Glb.GetRenderer().m_Vps[ _VpId ];
		CDebug.ASSERT( l_Vp != null );
		
		var l_Top : Float = math.Utils.RoundNearest( m_Rect.m_TL.y * l_Vp.m_h + l_Vp.m_y);
		var l_Left : Float = math.Utils.RoundNearest( m_Rect.m_TL.x * l_Vp.GetVpRatio() * l_Vp.m_w + l_Vp.m_x);
		var l_Bottom : Float = math.Utils.RoundNearest( m_Rect.m_BR.y * l_Vp.m_h + l_Vp.m_y);
		var l_Right : Float = math.Utils.RoundNearest( m_Rect.m_BR.x * l_Vp.GetVpRatio() * l_Vp.m_w + l_Vp.m_x);
		
		var l_Array = cast( m_Primitive.LockVertexArray(), Float32Array );
		var l_Z = -1;
	
		l_Array.Set(0,l_Left);
		l_Array.Set(1,l_Top);
		l_Array.Set(2,l_Z);
		
		l_Array.Set(3,l_Right);
		l_Array.Set(4,l_Top);
		l_Array.Set(5,l_Z);
		
		l_Array.Set(6,l_Left);
		l_Array.Set(7, l_Bottom);
		l_Array.Set(8, l_Z);
		
		l_Array.Set(9, l_Right);
		l_Array.Set(10, l_Bottom);
		l_Array.Set(11, l_Z);
		
		m_Primitive.ReleaseVertexArray();
	}
	
	public override function Draw( _VpId : Int ) : Result
	{
		super.Draw( _VpId );
	
		//UpdateQuad(_VpId);
		//CreateData();
		if ( Activate() == FAILURE)
		{
			CDebug.CONSOLEMSG("Shader activation failure");
			return FAILURE;
		}
		
		if (m_MatrixCache == null)
		{
			m_MatrixCache = m_Cameras[_VpId].GetMatrix().m_Buffer;
			
			m_Cameras[_VpId].GetMatrix().Trace();
		}
		
		var l_Err = Glb.g_SystemJS.GetGL().GetError();
		if ( l_Err  != 0)
		{
			CDebug.CONSOLEMSG("GlError:PreSetUniform:" + l_Err);
		}
		
		m_ShdrPrgm.UniformMatrix4fv( "u_MVPMatrix", false, m_MatrixCache );
		
		//Glb.g_SystemJS.GetGL().DrawArrays( CGL.TRIANGLES, 0, m_Primitive.GetNbVertices() );
		
		{
			var l_Err = Glb.g_SystemJS.GetGL().GetError();
			if ( l_Err  != 0)
			{
				CDebug.CONSOLEMSG("GlError:PreDrawElements:" + l_Err);
			}
		}
		
		Glb.g_SystemJS.GetGL().DrawElements( CGL.TRIANGLES, m_Primitive.GetNbIndices(), CGL.UNSIGNED_BYTE, 0 );
		
		var l_Err = Glb.g_SystemJS.GetGL().GetError();
		if ( l_Err  != 0)
		{
			CDebug.CONSOLEMSG("GlError:PostDrawElements:" + l_Err);
		}
		
		return SUCCESS;
	}
	
	public override function Activate() : Result
	{
		var l_MatActivation : Result= m_Material.Activate();
		if(l_MatActivation==FAILURE)
		{
			CDebug.CONSOLEMSG("CGLQuad:unable to activate mat");
			return FAILURE;
		}
		
		var  l_ShdrActivation : Result= m_ShdrPrgm.Activate();
		if(l_ShdrActivation==FAILURE)
		{
			CDebug.CONSOLEMSG("CGLQuad:unable to activate shdr");
			return FAILURE;
		}
		
		var  l_PrgmLink : Result = m_ShdrPrgm.LinkPrimitive( m_Primitive );
		if(l_PrgmLink==FAILURE)
		{
			CDebug.CONSOLEMSG("CGLQuad:unable to link prim");
			return FAILURE;
		}
		
		var  l_RsActivate : Result = m_RenderStates.Activate();
		if(l_RsActivate==FAILURE)
		{
			CDebug.CONSOLEMSG("CGLQuad:unable to activate rs");
			return FAILURE;
		}
		
		return SUCCESS;
	}
	
	public override function Update() : Result
	{
		super.Update();
		
		return SUCCESS;
	}

	var m_Primitive : CPrimitiveJS;
	var m_Material : CMaterial;
	var m_ShdrPrgm : CRscShaderProgram;
	var m_RenderStates : CRenderStatesJS;
	
	var m_MatrixCache : Float32Array;
}