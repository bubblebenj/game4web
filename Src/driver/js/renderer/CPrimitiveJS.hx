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
		
		if(m_VtxNativeBuf==null)
		{
			m_VtxNativeBuf =  new Float32Array( new ArrayBuffer(m_NbVertex * 4 * GetFloatPerVtx()));
		}
		
		for (i in 0...m_NbVertex * GetFloatPerVtx())
		{
			m_VtxNativeBuf.Set(i, _Vertices[i]);
		}
		
		Glb.g_SystemJS.GetGL().BufferData( CGL.ARRAY_BUFFER, m_VtxNativeBuf, CGL.STATIC_DRAW );
		CDebug.CONSOLEMSG("Set vertex buffer");
			
		var l_Err = Glb.g_SystemJS.GetGL().GetError();
		if ( l_Err  != 0)
		{
			CDebug.CONSOLEMSG("GlError:PostSetVertexArray:" + l_Err);
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
		
		if(m_IdxNativeBuf==null)
		{
			m_IdxNativeBuf =  new Uint8Array( new ArrayBuffer(m_NbIndices) );
		}
		
		for (i in 0...m_NbVertex)
		{
			m_IdxNativeBuf.Set(i, _Indexes[i]);
		}
		
		Glb.g_SystemJS.GetGL().BufferData( CGL.ELEMENT_ARRAY_BUFFER, m_IdxNativeBuf, CGL.STATIC_DRAW );
		
		CDebug.CONSOLEMSG("Set index buffer");
		
		var l_Err = Glb.g_SystemJS.GetGL().GetError();
		if ( l_Err  != 0)
		{
			CDebug.CONSOLEMSG("GlError:PostSetIndexArray:" + l_Err);
		}
	}
	
	public function SetTexCooArray(  _TexCoords : Array< Float > ) : Void
	{
		if ( m_TexObject == null )
		{
			m_TexObject = Glb.g_SystemJS.GetGL().CreateBuffer();
			Glb.g_SystemJS.GetGL().BindBuffer( CGL.ARRAY_BUFFER, m_TexObject);
		}
		
		if ( null != m_TexNativeBuf )
		{
			m_TexNativeBuf =  new Float32Array( new ArrayBuffer( m_NbVertex * 4 * GetFloatPerTexCoord()) );
		}
		
		for (i in 0...m_NbVertex*GetFloatPerTexCoord())
		{
			m_TexNativeBuf.Set(i, _TexCoords[i]);
		}
		
		Glb.g_SystemJS.GetGL().BufferData( CGL.ARRAY_BUFFER, m_TexNativeBuf, CGL.STATIC_DRAW );
	}
	
	public function SetNormalArray(  _Normals : Array< Float > ) : Void
	{
		if ( m_NrmlObject == null )
		{
			m_NrmlObject = Glb.g_SystemJS.GetGL().CreateBuffer();
			Glb.g_SystemJS.GetGL().BindBuffer( CGL.ARRAY_BUFFER, m_NrmlObject);
		}
		
		if ( null != m_NrmlNativeBuf )
		{
			m_NrmlNativeBuf =  new Float32Array( new ArrayBuffer(m_NbVertex * 4 * GetFloatPerNormal()));
		}
		
		for (i in 0...m_NbVertex*GetFloatPerNormal())
		{
			m_NrmlNativeBuf.Set(i, _Normals[i]);
		}
				
		Glb.g_SystemJS.GetGL().BufferData( CGL.ARRAY_BUFFER, m_NrmlNativeBuf, CGL.STATIC_DRAW );
	}
	
	var m_NrmlObject:WebGLBuffer;
	var m_TexObject:WebGLBuffer;
	var m_VtxObject:WebGLBuffer;
	var m_IdxObject:WebGLBuffer;
	
	var m_NrmlNativeBuf:Float32Array;
	var m_TexNativeBuf:Float32Array;
	var m_VtxNativeBuf:Float32Array;
	var m_IdxNativeBuf:Uint8Array;
	
	var m_NbIndices:Int;
	
	var m_NbTriangles:Int;
	var m_NbVertex:Int;
}