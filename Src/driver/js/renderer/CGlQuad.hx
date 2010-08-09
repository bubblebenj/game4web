/**
 * ...
 * @author de
 */

package driver.js.renderer;

import driver.js.rsc.CRscShaderProgram;
import renderer.CViewport;

import renderer.C2DQuad;
import renderer.CRscShader;
import renderer.CMaterial;

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
			CDebug.CONSOLEMSG("unable gl quad shader");
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
		
		return l_Res;
	}

	public override function Draw( _VpId : Int ) : Result
	{
		super.Draw( _VpId );
		
		var l_Vp : CViewport = Glb.GetRenderer().m_Vps[ _VpId ];
		CDebug.ASSERT( l_Vp != null );
		
		var l_Top : Float = math.Utils.RoundNearest( m_Rect.m_TL.y * l_Vp.m_h + l_Vp.m_y);
		var l_Left : Float = math.Utils.RoundNearest( m_Rect.m_TL.x * l_Vp.GetVpRatio() * l_Vp.m_w + l_Vp.m_x);
		var l_Bottom : Float = math.Utils.RoundNearest( m_Rect.m_BR.y * l_Vp.m_h + l_Vp.m_y);
		var l_Right : Float = math.Utils.RoundNearest( m_Rect.m_BR.x * l_Vp.GetVpRatio() * l_Vp.m_w + l_Vp.m_x);	
		
		var l_Array : Array<Float> = new Array<Float>();
		
		l_Array[0] = l_Left; 	l_Array[1] = l_Top; 	l_Array[2] = 1.0;
		l_Array[3] = l_Right; 	l_Array[4] = l_Top; 	l_Array[5] = 1.0;
		l_Array[6] = l_Left; 	l_Array[7] = l_Bottom; 	l_Array[8] = 1.0;
		l_Array[9] = l_Right; 	l_Array[10] = l_Top; 	l_Array[11] = 1.0;
		l_Array[12] = l_Left; 	l_Array[13] = l_Bottom; l_Array[14] = 1.0;
		l_Array[15] = l_Right; 	l_Array[16] = l_Bottom;	l_Array[17] = 1.0;
				
		m_Primitive.SetVertexArray( l_Array );
		
		if ( Activate() == FAILURE)
		{
			return FAILURE;
		}
		
		Registers.M0.Identity();
		
		m_ShdrPrgm.UniformMatrix4fv( "uModelMatrix", Registers.M0);
		m_ShdrPrgm.UniformMatrix4fv( "uViewProjMatrix", m_Cameras[_VpId].GetMatrix() );
		
		Glb.g_SystemJS.GetGL().DrawArrays( CGL.TRIANGLES, 0, m_Primitive.GetNbVertices() );
		
		return SUCCESS;
	}
	
	public override function Activate() : Result
	{
		m_Material.Activate();
		m_ShdrPrgm.Activate();
		
		m_ShdrPrgm.LinkPrimitive( m_Primitive );
		
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
}