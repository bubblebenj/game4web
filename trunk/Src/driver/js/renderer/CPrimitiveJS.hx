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
	
	public override function LockVertexArray() : Dynamic
	{
		return m_VtxNativeBuf;
	}
	
	public override function ReleaseVertexArray()
	{
		Glb.g_SystemJS.GetGL().BindBuffer( CGL.ARRAY_BUFFER, m_VtxObject);
		Glb.g_SystemJS.GetGL().BufferSubData( CGL.ARRAY_BUFFER, 0, m_VtxNativeBuf );
	}
	
	public override function LockTexCoordArray() : Dynamic
	{
		return m_TexNativeBuf;
	}
	
	public override function ReleaseTexCoordArray() : Void
	{
		Glb.g_SystemJS.GetGL().BindBuffer( CGL.ARRAY_BUFFER, m_TexObject);
		Glb.g_SystemJS.GetGL().BufferSubData( CGL.ARRAY_BUFFER, 0, m_TexNativeBuf );
	}
	
	public override function SetVertexArray(  _Vertices : Array< Float > , _Dyn : Bool) : Void
	{
		if ( m_VtxObject != null )
		{
			Glb.g_SystemJS.GetGL().DeleteBuffer(m_VtxObject);
			m_VtxObject = null;
			m_VtxNativeBuf = null;
			m_NbVertex = 0;
			m_NbTriangles = 0;
		}
		
		m_NbVertex = Std.int(_Vertices.length / 3);
		m_NbTriangles =  Std.int(_Vertices.length / 9);
		
		if ( m_VtxObject == null )
		{	
			m_VtxObject = Glb.g_SystemJS.GetGL().CreateBuffer();
			Glb.g_SystemJS.GetGL().BindBuffer( CGL.ARRAY_BUFFER, m_VtxObject);
			CDebug.CONSOLEMSG("Bound vertex buffer vtx:"+m_NbVertex);
			
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
		
		Glb.g_SystemJS.GetGL().BufferData( CGL.ARRAY_BUFFER, m_VtxNativeBuf, (_Dyn) ? CGL.DYNAMIC_DRAW : CGL.STATIC_DRAW );
		m_AreVtxArrayDynamic = _Dyn;
		CDebug.CONSOLEMSG("Set vertex buffer");
			
		var l_Err = Glb.g_SystemJS.GetGL().GetError();
		if ( l_Err  != 0)
		{
			CDebug.CONSOLEMSG("GlError:PostSetVertexArray:" + l_Err);
		}
	}
	
	public override function SetIndexArray(  _Indexes : Array< Int > , _Dyn : Bool) : Void
	{
		if ( m_IdxObject != null )
		{
			Glb.g_SystemJS.GetGL().DeleteBuffer(m_IdxObject);
			m_IdxObject = null;
			m_IdxNativeBuf = null;
			m_NbIndices = 0;
			m_NbTriangles = 0;
		}
		
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
		m_NbTriangles = Std.int(m_NbIndices / 3);
		
		if(m_IdxNativeBuf==null)
		{
			m_IdxNativeBuf =  new Uint8Array( new ArrayBuffer(m_NbIndices) );
		}
		
		for (i in 0...m_NbIndices)
		{
			m_IdxNativeBuf.Set(i, _Indexes[i]);
		}
		
		Glb.g_SystemJS.GetGL().BufferData( CGL.ELEMENT_ARRAY_BUFFER, m_IdxNativeBuf, (_Dyn) ? CGL.DYNAMIC_DRAW : CGL.STATIC_DRAW  );
		m_AreIdxArrayDynamic  = _Dyn;
		
		CDebug.CONSOLEMSG("Set index buffer (idx:"+m_NbIndices+", tri:"+m_NbTriangles+")" );
		
		var l_Err = Glb.g_SystemJS.GetGL().GetError();
		if ( l_Err  != 0)
		{
			CDebug.CONSOLEMSG("GlError:PostSetIndexArray:" + l_Err);
		}
	}
	 

	/**
	 * use this to do an "initial set, to update it use Lock and Release, these are forward compatible for double buffering
	 * @param	_TexCoords
	 * @param	_Dyn : Does not mean it is back buffered, just writeable, you have to double buffer it by hand if needed by now
	 */
	public override function SetTexCooArray(  _TexCoords : Array< Float > , _Dyn : Bool) : Void
	{
		if ( m_TexObject != null )
		{
			Glb.g_SystemJS.GetGL().DeleteBuffer( m_TexObject );
			m_TexObject = null;
			m_TexNativeBuf = null;
		}
		
		if ( m_TexObject == null )
		{
			m_TexObject = Glb.g_SystemJS.GetGL().CreateBuffer();
			Glb.g_SystemJS.GetGL().BindBuffer( CGL.ARRAY_BUFFER, m_TexObject);
		}
		
		if ( m_NbVertex == 0)
		{
			m_NbVertex = Std.int( _TexCoords.length / 4);
		}
		
		if ( null == m_TexNativeBuf )
		{
			m_TexNativeBuf =  new Float32Array( new ArrayBuffer( m_NbVertex * 4 * GetFloatPerTexCoord()) );
		}
		
		for (i in 0...m_NbVertex*GetFloatPerTexCoord())
		{
			m_TexNativeBuf.Set(i, _TexCoords[i]);
		}
		
		
		Glb.g_SystemJS.GetGL().BufferData( CGL.ARRAY_BUFFER, m_TexNativeBuf, (_Dyn) ? CGL.DYNAMIC_DRAW : CGL.STATIC_DRAW );
		m_AreTexCoordDynamic = _Dyn;
	}
	
	public override function HasIndexArray() : Bool
	{
		return m_NbIndices != 0;
	}
	
	public override function HasNormalArray() : Bool
	{
		return m_NrmlNativeBuf != null;
	}
	
	public override function HasTexCoordArray() : Bool
	{
		return m_TexNativeBuf != null;
	}
	
	
	public override function SetNormalArray(  _Normals : Array< Float > , _Dyn : Bool) : Void
	{
		CDebug.ASSERT(m_NbVertex != 0);
		if ( m_NrmlObject != null )
		{
			Glb.g_SystemJS.GetGL().DeleteBuffer( m_NrmlObject );
			m_NrmlObject = null;
			m_NrmlNativeBuf = null;
		}
		
		if ( m_NrmlObject == null )
		{
			m_NrmlObject = Glb.g_SystemJS.GetGL().CreateBuffer();
			Glb.g_SystemJS.GetGL().BindBuffer( CGL.ARRAY_BUFFER, m_NrmlObject);
		}
		
		if ( null == m_NrmlNativeBuf )
		{
			m_NrmlNativeBuf =  new Float32Array( new ArrayBuffer(m_NbVertex * 4 * GetFloatPerNormal()));
		}
		
		for (i in 0...m_NbVertex*GetFloatPerNormal())
		{
			m_NrmlNativeBuf.Set(i, _Normals[i]);
		}
				
		Glb.g_SystemJS.GetGL().BufferData( CGL.ARRAY_BUFFER, m_NrmlNativeBuf, (_Dyn) ? CGL.DYNAMIC_DRAW : CGL.STATIC_DRAW  );
		m_AreNrmlArrayDynamic = _Dyn;
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
	
	public var m_AreTexCoordDynamic(default, null) : Bool;
	public var m_AreVtxArrayDynamic(default, null) : Bool;
	public var m_AreIdxArrayDynamic(default, null) : Bool;
	public var m_AreNrmlArrayDynamic(default,null) : Bool;
}