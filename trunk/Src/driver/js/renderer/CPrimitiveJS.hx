/**
 * ...
 * @author de
 */

package driver.js.renderer;

import driver.js.kernel.CSystemJS;

import kernel.CSystem;
import kernel.Glb;
import kernel.CDebug;

import renderer.CPrimitive;



import CGL;

class CPrimitiveJS extends CPrimitive
{

	public function new() 
	{
		super();
		
		m_NbIndices = 0;
		m_NbVertex = 0;
		
		m_NrmlObject = null;
		m_TexObject = null;
		m_VtxObject = null;
		m_IdxObject = null;
		
		m_NrmlNativeBuf = null;
		m_TexNativeBuf = null;
		m_VtxNativeBuf = null;
		m_IdxNativeBuf = null;
	}
	
	public function GetFloatPerVtx() : Int
	{
		return 3;
	}
	
	public function GetFloatPerNormal() : Int
	{
		return 3;
	}
	
	public function GetFloatPerColor() : Int
	{
		return 4;
	}
	
	public function GetFloatPerTexCoord() : Int
	{
		return 4;
	}
	
	public function GetNbTriangles() : Int 
	{
		return m_NbTriangles;
	}
	
	public function GetNbVertices() : Int 
	{
		return m_NbVertex;
	}
	
	public function GetNbIndices() : Int 
	{
		return m_NbIndices;
	}
	
	public override function SetVertexArray(  _Vertices : Array< Float > ) : Void
	{
		m_NbTriangles =  Std.int(_Vertices.length / 9);
		m_NbVertex = Std.int(_Vertices.length / 3);
		
		if ( m_VtxObject == null )
		{	
			m_VtxObject = Glb.g_SystemJS.GetGL().CreateBuffer();
			Glb.g_SystemJS.GetGL().BindBuffer( CGL.ARRAY_BUFFER, m_VtxObject);
			CDebug.CONSOLEMSG("Bound vertex buffer");
			
			var l_Err = Glb.g_SystemJS.GetGL().GetError();
			if ( l_Err  != 0)
			{
				CDebug.CONSOLEMSG("GlError:PostBindVertexArray:" + l_Err);
			}
		}
		

		{
			m_VtxNativeBuf =  new WebGLFloatArray(_Vertices);
			Glb.g_SystemJS.GetGL().BufferData( CGL.ARRAY_BUFFER, m_VtxNativeBuf, CGL.STATIC_DRAW );
			CDebug.CONSOLEMSG("Set vertex buffer");
			
			var l_Err = Glb.g_SystemJS.GetGL().GetError();
			if ( l_Err  != 0)
			{
				CDebug.CONSOLEMSG("GlError:PostSetVertexArray:" + l_Err);
			}
		}
	}
	
	public function SetIndexArray(  _Indexes : Array< Int > ) : Void
	{
		if ( m_IdxObject == null )
		{
			m_IdxObject = Glb.g_SystemJS.GetGL().CreateBuffer();
			Glb.g_SystemJS.GetGL().BindBuffer( CGL.ELEMENT_ARRAY_BUFFER, m_IdxObject);
			CDebug.CONSOLEMSG("bind index buffer");
			
			var l_Err = Glb.g_SystemJS.GetGL().GetError();
			if ( l_Err  != 0)
			{
				CDebug.CONSOLEMSG("GlError:PostBindIndexArray:" + l_Err);
			}
		}
		
		m_NbIndices = _Indexes.length;
		m_IdxNativeBuf =  new WebGLUnsignedByteArray( _Indexes );
		
		Glb.g_SystemJS.GetGL().BufferData( CGL.ELEMENT_ARRAY_BUFFER, m_IdxNativeBuf, CGL.STATIC_DRAW );
		
		CDebug.CONSOLEMSG("Set index buffer");
		
		var l_Err = Glb.g_SystemJS.GetGL().GetError();
		if ( l_Err  != 0)
		{
			CDebug.CONSOLEMSG("GlError:PostSetIndexArray:" + l_Err);
		}
	}
	
	public function SetTexCooArray(  _Coord : Array< Float > ) : Void
	{
		if ( m_TexObject == null )
		{
			m_TexObject = Glb.g_SystemJS.GetGL().CreateBuffer();
			Glb.g_SystemJS.GetGL().BindBuffer( CGL.ARRAY_BUFFER, m_TexObject);
		}
		
		m_TexNativeBuf =  new WebGLFloatArray(_Coord);
		
		Glb.g_SystemJS.GetGL().BufferData( CGL.ARRAY_BUFFER, m_TexNativeBuf, CGL.STATIC_DRAW );
	}
	
	public function SetNormalArray(  _Normals : Array< Float > ) : Void
	{
		if ( m_NrmlObject == null )
		{
			m_NrmlObject = Glb.g_SystemJS.GetGL().CreateBuffer();
			Glb.g_SystemJS.GetGL().BindBuffer( CGL.ARRAY_BUFFER, m_NrmlObject);
		}
		
		m_NrmlNativeBuf =  new WebGLFloatArray(_Normals);
		
		Glb.g_SystemJS.GetGL().BufferData( CGL.ARRAY_BUFFER, m_NrmlNativeBuf, CGL.STATIC_DRAW );
	}
	
	var m_NrmlObject:WebGLBuffer;
	var m_TexObject:WebGLBuffer;
	var m_VtxObject:WebGLBuffer;
	var m_IdxObject:WebGLBuffer;
	
	var m_NrmlNativeBuf:WebGLFloatArray;
	var m_TexNativeBuf:WebGLFloatArray;
	var m_VtxNativeBuf:WebGLFloatArray;
	var m_IdxNativeBuf:WebGLUnsignedByteArray;
	
	var m_NbIndices:Int;
	
	var m_NbTriangles:Int;
	var m_NbVertex:Int;
}