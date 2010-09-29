
//JS binding

function Assign( _Array, _Index ,_V)
{
	_Array[_Index] = _V;
}

function GetBack( _Array, _Index )
{
	return _Array[_Index];
}


Float32Array.prototype.Set  = function( _i,_f)
{
	Assign( this,_i,_f);
}

Uint8Array.prototype.Set  = function( _i,_f)
{
	Assign( this,_i,_f);
}

Float32Array.prototype.Get  = function( _i,_f)
{
	return GetBack( this,_i);
}

Uint8Array.prototype.Get  = function( _i,_f)
{
	return GetBack( this,_i);
}

function CGL( _Name ) 
{
	m_Element = null;
	m_GLContext = null;
	
	m_Element = document.getElementById(_Name);
	if( m_Element != null)
	{
		//m_GLContext = m_Element.getContext('webgl');
		//document.write('GLContext Fetched');
	}
	else
	{
		//document.write('out of element : cannot get root node');
	}
	
	if( !m_GLContext && m_Element )
	{
		m_GLContext = m_Element.getContext('experimental-webgl');
		if( m_GLContext )
		{
			//document.write('GLContext experimental Fetched');
		}
	}
	
	if( !m_GLContext && m_Element  )
	{
		document.write('out of context : please use a webgl compliant navigator');
	}
	
	return this;
}

CGL.prototype.GetViewportWidth = function() 
{
	//document.write('getw : ' + m_Element + ' ' + m_GLContext);
	if(!m_GLContext)
	{
		return 0;
	}
	return m_GLContext.canvas.clientWidth;
}

CGL.prototype.GetViewportHeight = function() 
{
	if(!m_GLContext)
	{
		return 0;
	}
	return m_GLContext.canvas.clientHeight;
}

CGL.prototype.Flush = function() 
{
	m_GLContext.flush();
}

CGL.prototype.Clear = function( _Mask ) 
{
	m_GLContext.clear( _Mask);
}

CGL.prototype.SetViewportWidth = function( _f ) 
{
	m_GLContext.viewportWidth = ( _f );
}

CGL.prototype.SetViewportHeight = function( _f ) 
{
	m_GLContext.viewportHeight = ( _f );
}

CGL.prototype.ClearColor = function( _f0, _f1, _f2, _f3 ) 
{
	m_GLContext.clearColor( _f0, _f1, _f2, _f3 );
	//.document.write('getw : ' + m_Element + ' ' + m_GLContext);
}

CGL.prototype.ClearDepth = function( _f ) 
{
	m_GLContext.clearDepth( _f );
}

CGL.prototype.Enable = function( _gle  ) 
{
	m_GLContext.enable( _gle );
}

CGL.prototype.DepthFunc = function( _gle  ) 
{
	m_GLContext.depthFunc( _gle );
}

CGL.prototype.DepthMask = function( _OnOff  ) 
{
	m_GLContext.depthMask( _OnOff );
}

CGL.prototype.Disable = function( _gle  ) 
{
	m_GLContext.disable( _gle );
}

CGL.prototype.Viewport = function( _f0, _f1, _f2, _f3 ) 
{
	m_GLContext.viewport( _f0, _f1, _f2, _f3 );
}

CGL.prototype.CreateShader = function( _t0 ) 
{
	return m_GLContext.createShader( _t0 );
}

CGL.prototype.CreateBuffer = function( )  
{
	return m_GLContext.createBuffer();
}

CGL.prototype.DeleteBuffer = function( _Buf )  
{
	return m_GLContext.deleteBuffer(_Buf);
}

CGL.prototype.CreateFramebuffer= function( )   
{
	return m_GLContext.createFramebuffer();
}

CGL.prototype.CreateRenderbuffer = function( )  
{
	return m_GLContext.createRenderbuffer();
}

CGL.prototype.CreateTexture = function()   
{
	return m_GLContext.createTexture();
}
	
CGL.prototype.CompileShader = function( _t0 ) 
{
	m_GLContext.compileShader( _t0 );
}

CGL.prototype.CreateProgram = function() 
{
	return m_GLContext.createProgram();
}

CGL.prototype.LinkProgram = function( _prgm ) 
{
	m_GLContext.linkProgram( _prgm );
}

CGL.prototype.DeleteProgram = function( _prgm ) 
{
	m_GLContext.deleteProgram( _prgm );
}

CGL.prototype.DeleteShader = function( _shdr ) 
{
	m_GLContext.deleteShader( _shdr );
}

CGL.prototype.GetShaderInfoLog = function( _shdr ) 
{
	m_GLContext.getShaderInfoLog( _shdr );
}

CGL.prototype.GetShaderParameter = function( _shdr , _sts) 
{
	return m_GLContext.getShaderParameter(_shdr,_sts);
}

CGL.prototype.GetProgramParameter = function( _prgm , _enm) 
{
	return m_GLContext.getProgramParameter(_prgm,_enm);
}

CGL.prototype.GetProgramInfoLog = function( _prgm ) 
{
	return m_GLContext.getProgramInfoLog(_prgm);
}


CGL.prototype.ShaderSource = function(_shdr, _src )
{
	m_GLContext.shaderSource( _shdr , _src);
}

CGL.prototype.UseProgram = function(_prgm)
{
	m_GLContext.useProgram( _prgm );
}

CGL.prototype.ValidateProgram = function(_prgm)
{
	m_GLContext.validateProgram( _prgm );
}

CGL.prototype.AttachShader  = function ( _prgm , _Shdr )	
{
	m_GLContext.attachShader( _prgm , _Shdr);
}

CGL.prototype.GetUniformLocation = function( _prgm,_Name )
{
	return m_GLContext.getUniformLocation( _prgm,_Name )
}

CGL.prototype.GetAttribLocation = function (  _prgm,_Name ) 
{
	return m_GLContext.getAttribLocation(_prgm,_Name);
}

CGL.prototype.Uniform3f = function( _Loc, _f0, _f1, _f2 ) 
{
	m_GLContext.uniform3f( _Loc, _f0, _f1, _f2 );
}

CGL.prototype.Uniform4f = function( _Loc, _f0, _f1, _f2, _f3 ) 
{
	m_GLContext.uniform4f( _Loc, _f0, _f1, _f2, _f3 );
}

CGL.prototype.UniformMatrix4f = function ( _Loc , _Trans, _Mat )
{
	m_GLContext.uniformMatrix4fv( _Loc, _Trans,_Mat );
}

CGL.prototype.Uniform1i = function( _Loc, _i0 ) 
{
	m_GLContext.uniform1i( _Loc, _i0);
}

CGL.prototype.Uniform1f = function( _Loc, _f0 ) 
{
	m_GLContext.uniform1f( _Loc, _f0);
}

CGL.prototype.EnableVertexAttribArray = function( _Index ) 
{
	m_GLContext.enableVertexAttribArray( _Index );
}

CGL.prototype.DisableVertexAttribArray = function( _Index ) 
{
	m_GLContext.disableVertexAttribArray( _Index );
}


CGL.prototype.BindBuffer = function( _tgt,_buf ) 
{
	m_GLContext.bindBuffer( _tgt,_buf );
}

CGL.prototype.VertexAttribPointer = function( _idx,_sz,_type,_nrmlizd,_stride,_offset )
{
	m_GLContext.vertexAttribPointer(  _idx,_sz,_type,_nrmlizd,_stride,_offset );
}

CGL.prototype.BindAttribLocation  = function (  _Prgm , _Index , _Name  )
{
	m_GLContext.bindAttribLocation(_Prgm,_Index,_Name);
}

CGL.prototype.DrawArrays = function( _md, _frst, _cnt)
{
	m_GLContext.drawArrays( _md, _frst, _cnt);
}

CGL.prototype.GetError = function()
{
	return m_GLContext.getError();
}

CGL.prototype.Flush = function( ) 
{
	m_GLContext.flush();
}

CGL.prototype.DrawElements = function( _md , _cnt , _type , _offset ) 
{
	m_GLContext.drawElements( _md, _cnt, _type,_offset);
}

CGL.prototype.GetSupportedExtensions = function()  
{
	if( m_GLContext && m_GLContext.getSupportedExtensions ) 
	{
		return m_GLContext.getSupportedExtensions();
	}
	return null;
}

CGL.prototype.GetExtensions= function( _Name ) 
{
	return m_GLContext.getExtensions();
}

CGL.prototype.GetString= function(_Name)	
{
	return m_GLContext.getString(_Name);
}

CGL.prototype.Hint= function( _Tgt, _Mode)
{
	m_GLContext.hint( _Tgt, _Mode);
}

CGL.prototype.ShaderSource = function( _Shdr, _Src )
{
	m_GLContext.shaderSource( _Shdr, _Src);
}


CGL.prototype.BufferSubData = function( _Tgt,  _Offset,  _Buffer )
{
	m_GLContext.bufferSubData( _Tgt,_Offset,_Buffer);
}

/*
 public function CreateTexture() : WebGLTexture;
	public function DeleteTexture( _Tex : WebGLTexture);
	
	public function BindTexture( _Target: GLenum, _Tex : WebGLTexture);
	
	public function PixelStorei( _pname : GLenum, _param : GLint );
	public function TexImage2D( _Target: GLenum, _Level: GLint, _Internalformat: GLenum,
								_Format: GLenum, _Type : GLenum, _Pixels : Dynamic );
								
	public function TexParameteri( _Target : GLenum , _Pname : GLenum, _Param : GLint);
	
	public function PolygonOffset(  factor : GLfloat, units : GLfloat );
*/

CGL.prototype.DeleteTexture = function( _Tgt )
{
	m_GLContext.deleteTexture( _Tgt);
}

CGL.prototype.ActiveTexture = function( _Tgt )
{
	m_GLContext.activeTexture( _Tgt);
}

CGL.prototype.BindTexture = function( _Tgt,_Tex )
{
	m_GLContext.bindTexture( _Tgt,_Tex);
}

CGL.prototype.PixelStorei = function( _pname,_param )
{
	m_GLContext.pixelStorei( _pname,_param);
}

CGL.prototype.CullFace = function( _Mode   )
{
	m_GLContext.cullFace(_Mode);
}

CGL.prototype.TexParameteri = function( _Target,_Pname,_Param )
{
	m_GLContext.texParameteri( _Target,_Pname,_Param);
}

CGL.prototype.TexImage2D = function( _Target,_Level,_Internalformat,_Format,_Type,_Pixels )
{
	m_GLContext.texImage2D( _Target,_Level,_Internalformat,_Format,_Type,_Pixels );
}

CGL.prototype.PolygonOffset = function( _factor,_units )
{
	m_GLContext.polygonOffset( _factor,_units);
}

CGL.prototype.BufferData= function( _Tgt , _Buffer , _Usage )
{
	if( !m_GLContext && !_Tgt )
	{
	//	document.write("erf");
	}
	m_GLContext.bufferData( _Tgt,_Buffer,_Usage );
}






