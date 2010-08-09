/**
 * ...
 * @author de
 */

package driver.js.renderer;

import kernel.CSystem;
import kernel.Glb;
import renderer.CPrimitive;

import driver.js.kernel.CSystemJS;
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
	
	public function GetNbTriangles() : Int 
	{
		return m_NbTriangles;
	}
	
	public function GetNbVertices() : Int 
	{
		return m_NbVertex;
	}
	
	public function SetVertexArray(  _Vertices : Array< Float > ) : Void
	{
		m_NbTriangles =  cast( _Vertices.length / 12 ,Int);
		m_NbVertex = cast( _Vertices.length / 3, Int );
		
		if ( m_VtxObject == null )
		{
			m_VtxObject = Glb.g_SystemJS.GetGL().CreateBuffer();
			Glb.g_SystemJS.GetGL().BindBuffer( CGL.ARRAY_BUFFER, m_VtxObject);
		}
		
		
		m_VtxNativeBuf =  new WebGLFloatArray(_Vertices);
		
		Glb.g_SystemJS.GetGL().BufferData( CGL.ARRAY_BUFFER, m_VtxNativeBuf, CGL.STATIC_DRAW );
	}
	
	public function SetIndexArray(  _Indexes : Array< Int > ) : Void
	{
		
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