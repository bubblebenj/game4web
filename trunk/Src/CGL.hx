package ;//important to have anon namespace

#if js
import driver.js.kernel.CTypesJS;

typedef GLenum = Int;
typedef GLbitmask = Int;
typedef GLint = Int;
typedef GLuint = Int;
typedef GLsizei = Int;
typedef GLfloat = Float;
typedef GLboolean = Bool;
typedef GLsizeiptr = Int;



extern class ArrayBuffer
{
	public function new ( _ByteSize : Int ) : Void;
	
	public var byteLength : Int;
}

extern class ArrayBufferView
{
	public function new ( _Arr : ArrayBuffer  ) : Void;
	
	public var buffer : ArrayBuffer; 
	public var byteLength : Int; 
	public var byteOffset : Int;
	public var length : Int;
}


extern class Float32Array extends ArrayBufferView 
{
	public var 			BYTES_PER_ELEMENT : Int;
	public function 	Set( _Index : Int , _Value : Float) : Void;
	public function 	Get( _Index : Int ) : Float;
}

typedef FloatArray = Float32Array;

extern class Uint8Array extends ArrayBufferView 
{
	public var 			BYTES_PER_ELEMENT : Int;
	public function 	Set( _Index : Int , _Value : Int) : Void; 
	public function 	Get( _Index : Int ) : Int;
}

extern class WebGLObject { } 
extern class WebGLFramebuffer  { } 
extern class WebGLRenderbuffer { }
extern class WebGLBuffer  { } 
extern class WebGLShader { } 
extern class WebGLProgram { } 
extern class WebGLTexture { } 
extern class WebGLObjectArray { } 
extern class WebGLUniformLocation{}
extern class WebGLActiveInfo { }

extern class CGL
{
	public var 		m_GLContext : Dynamic;
	
	public function GetViewportWidth (): Float;
	public function GetViewportHeight (): Float;
	
	public function new( _RootElem : String) : Void;
	
	public function SetViewportWidth( _Width : Float ) : Void;
	public function SetViewportHeight( _Height : Float ) : Void;
	
	public function ClearColor( _f0 : Float, _f1: Float, _f2: Float, _f3 : Float) : Void;
	public function ClearDepth( _f : Float ) : Void;
	
	public function Clear( _bm : GLbitmask) : Void;
	
	public function Enable( _gle : GLenum ) : Void;
	public function Disable( _gle : GLenum ) : Void;
	public function DepthFunc( _gle : GLenum ) : Void;
	public function Viewport( _x : Float, _y: Float, _Width: Float, _Height : Float) : Void;
	public function Scissor( _x : Float, _y: Float, _Width: Float, _Height : Float) : Void; 
	
	public function DepthMask( _OnOff : GLboolean) : Void;
	public function BlendEquation( mode : GLenum) : Void;
    public function BlendEquationSeparate( modeRGB : GLenum, modeAlpha : GLenum) : Void;
    public function BlendFunc(sfactor : GLenum , dfactor : GLenum ) : Void;
    public function BlendFuncSeparate(srcRGB : GLenum , dstRGB : GLenum , srcAlpha : GLenum , dstAlpha : GLenum ) : Void;

	public function GetAttribLocation(  _prgm : WebGLProgram,  _Name : DOMString ) : GLint;
	
	public function CreateBuffer() : WebGLBuffer;
	public function DeleteBuffer( _Buf : WebGLBuffer) : Void;
	
    public function CreateFramebuffer() : WebGLFramebuffer;
    public function CreateRenderbuffer() : WebGLRenderbuffer;
	
    public function CreateTexture() : WebGLTexture;
	public function DeleteTexture( _Tex : WebGLTexture) : Void;
	
	public function BindTexture( _Target: GLenum, _Tex : WebGLTexture): Void;
	
	public function PixelStorei( _pname : GLenum, _param : GLint ): Void;
	public function TexImage2D( _Target: GLenum, _Level: GLint, _Internalformat: GLenum,
								_Format: GLenum, _Type : GLenum, _Pixels : Dynamic ): Void;
								
	public function TexParameteri( _Target : GLenum , _Pname : GLenum, _Param : GLint): Void;
	
	public function PolygonOffset(  factor : GLfloat, units : GLfloat ): Void;


	
	public function CreateProgram() : WebGLProgram;
	public function DeleteProgram(  _prgm : WebGLProgram) : Void;
	public function LinkProgram(  _prgm : WebGLProgram) : Void;
	public function UseProgram(  _prgm : WebGLProgram) : Void;
	public function ValidateProgram(  _prgm : WebGLProgram) : Void;
	
	public function AttachShader( _prgm 		: WebGLProgram, _Shdr 		: WebGLShader)	: Void;
	
	public function CreateShader( _Type : Int ) : WebGLShader;
	public function ShaderSource( _Shdr 		: WebGLShader, _Src : DOMString ) 			: Void;
	public function CompileShader( _Shdr 		: WebGLShader )								: Void;
	public function DeleteShader( _Shdr 		: WebGLShader ) 							: Void;
	
	public function GetShaderParameter( _Shdr : WebGLShader, _Type : Int)	: Dynamic;
	public function GetProgramParameter( _prgm : WebGLProgram, _enm: GLenum ): Dynamic;
	
	public function GetShaderInfoLog( _Shdr : WebGLShader): DOMString ;
	public function GetProgramInfoLog( _prgm : WebGLProgram): DOMString ;
	
	public function GetUniformLocation( _prgm : WebGLProgram,_Name : DOMString) : WebGLUniformLocation;
	public function Uniform3f( _Loc : WebGLUniformLocation , _x:Float, _y:Float, _z:Float) : Void;
	public function Uniform4f( _Loc : WebGLUniformLocation , _x:Float, _y:Float, _z:Float, _z:Float) : Void;
	public function Uniform1i( _Loc : WebGLUniformLocation , _x:GLint ) : Void;
	public function Uniform1f( _Loc : WebGLUniformLocation , _x:Float ) : Void;
	public function UniformMatrix4f( _Loc : WebGLUniformLocation, _Transpose : Bool, _Mat : Float32Array) : Void;
	
	public function EnableVertexAttribArray( _Index : GLuint ) : Void;
	public function DisableVertexAttribArray( _Index : GLuint  ) : Void;
	
	public function BindBuffer( _tgt : GLenum, _buf : WebGLBuffer ) : Void;
	public function Flush() : Void;
	
	public function BufferData( _tgt : GLenum, _Buffer : Dynamic, _usage : GLenum  ) : Void;
	public function BufferSubData( _tgt : GLenum,  _Offset : GLsizeiptr,  _Buffer : Dynamic  ) : Void;
	
	public function VertexAttribPointer	( 	_idx : GLuint, _sz : GLint, 
											_type : GLenum, _nrmlizd:GLboolean,
											_stride : GLsizei, _offset : GLsizeiptr ) : Void;
											
	public function BindAttribLocation	(  _Prgm : WebGLProgram, _Index : GLuint, _Name : DOMString ) : Void;
	
	public function DrawArrays( _md : GLenum , _frst : Int, _cnt :Int) : Void;
	
	public function DrawElements( _md : GLenum , _cnt : GLsizei, _type :GLenum, _offset : GLsizei) : Void;
	
	public function GetSupportedExtensions() : Array<DOMString>;
	public function GetExtension( _Name : DOMString ) : Dynamic;
	
	public function GetError() : GLenum;

	
	public function GetString( _Name: GLenum )	: DOMString;
	public function Hint( _Tgt : GLenum, _Mode:GLenum) : Void;
	
	static inline var TRUE                            		= 1;
	static inline var FALSE                             	= 0;
	
	/* ClearBufferMask */
    public static inline var DEPTH_BUFFER_BIT               = 0x00000100;
    public static inline var STENCIL_BUFFER_BIT             = 0x00000400;
    public static inline var COLOR_BUFFER_BIT               = 0x00004000;
    
    /* BeginMode */
    public static inline var POINTS                         = 0x0000;
    public static inline var LINES                          = 0x0001;
    public static inline var LINE_LOOP                      = 0x0002;
    public static inline var LINE_STRIP                     = 0x0003;
    public static inline var TRIANGLES                      = 0x0004;
    public static inline var TRIANGLE_STRIP                 = 0x0005;
    public static inline var TRIANGLE_FAN                   = 0x0006;
    
    /* AlphaFunction (not supported in ES20) */
    /*      NEVER */
    /*      LESS */
    /*      EQUAL */
    /*      LEQUAL */
    /*      GREATER */
    /*      NOTEQUAL */
    /*      GEQUAL */
    /*      ALWAYS */
    

    /* BlendingFactorDest */
    static inline var ZERO                           = 0;
    static inline var ONE                            = 1;
    static inline var SRC_COLOR                      = 0x0300;
    static inline var ONE_MINUS_SRC_COLOR            = 0x0301;
    static inline var SRC_ALPHA                      = 0x0302;
    static inline var ONE_MINUS_SRC_ALPHA            = 0x0303;
    static inline var DST_ALPHA                      = 0x0304;
    static inline var ONE_MINUS_DST_ALPHA            = 0x0305;
    
    /* BlendingFactorSrc */
    /*      ZERO */
    /*      ONE */
    static inline var DST_COLOR                      = 0x0306;
    static inline var ONE_MINUS_DST_COLOR            = 0x0307;
    static inline var SRC_ALPHA_SATURATE             = 0x0308;
    /*      SRC_ALPHA */
    /*      ONE_MINUS_SRC_ALPHA */
    /*      DST_ALPHA */
    /*      ONE_MINUS_DST_ALPHA */
    
    /* BlendEquationSeparate */
    static inline var FUNC_ADD                       = 0x8006;
    static inline var BLEND_EQUATION                 = 0x8009;
    static inline var BLEND_EQUATION_RGB             = 0x8009;   /* same as BLEND_EQUATION */
    static inline var BLEND_EQUATION_ALPHA           = 0x883D;
    
    /* BlendSubtract */
    static inline var FUNC_SUBTRACT                  = 0x800A;
    static inline var FUNC_REVERSE_SUBTRACT          = 0x800B;
    
    /* Separate Blend Functions */
    static inline var BLEND_DST_RGB                  = 0x80C8;
    static inline var BLEND_SRC_RGB                  = 0x80C9;
    static inline var BLEND_DST_ALPHA                = 0x80CA;
    static inline var BLEND_SRC_ALPHA                = 0x80CB;
    static inline var CONSTANT_COLOR                 = 0x8001;
    static inline var ONE_MINUS_CONSTANT_COLOR       = 0x8002;
    static inline var CONSTANT_ALPHA                 = 0x8003;
    static inline var ONE_MINUS_CONSTANT_ALPHA       = 0x8004;
    static inline var BLEND_COLOR                    = 0x8005;
    
    /* Buffer Objects */
    static inline var ARRAY_BUFFER                   = 0x8892;
    static inline var ELEMENT_ARRAY_BUFFER           = 0x8893;
    static inline var ARRAY_BUFFER_BINDING           = 0x8894;
    static inline var ELEMENT_ARRAY_BUFFER_BINDING   = 0x8895;
    
    static inline var STREAM_DRAW                    = 0x88E0;
    static inline var STATIC_DRAW                    = 0x88E4;
    static inline var DYNAMIC_DRAW                   = 0x88E8;
    
    static inline var BUFFER_SIZE                    = 0x8764;
    static inline var BUFFER_USAGE                   = 0x8765;
    
    static inline var CURRENT_VERTEX_ATTRIB          = 0x8626;
    
    /* CullFaceMode */
    static inline var FRONT                          = 0x0404;
    static inline var BACK                           = 0x0405;
    static inline var FRONT_AND_BACK                 = 0x0408;
    
    /* DepthFunction */
    /*      NEVER */
    /*      LESS */
    /*      EQUAL */
    /*      LEQUAL */
    /*      GREATER */
    /*      NOTEQUAL */
    /*      GEQUAL */
    /*      ALWAYS */
    
    /* EnableCap */
    /* TEXTURE_2D */
    static inline var CULL_FACE                      = 0x0B44;
    static inline var BLEND                          = 0x0BE2;
    static inline var DITHER                         = 0x0BD0;
    static inline var STENCIL_TEST                   = 0x0B90;
    static inline var DEPTH_TEST                     = 0x0B71;
    static inline var SCISSOR_TEST                   = 0x0C11;
    static inline var POLYGON_OFFSET_FILL            = 0x8037;
    static inline var SAMPLE_ALPHA_TO_COVERAGE       = 0x809E;
    static inline var SAMPLE_COVERAGE                = 0x80A0;
    
    /* ErrorCode */
    static inline var NO_ERROR                       = 0;
    static inline var INVALID_ENUM                   = 0x0500;
    static inline var INVALID_VALUE                  = 0x0501;
    static inline var INVALID_OPERATION              = 0x0502;
    static inline var OUT_OF_MEMORY                  = 0x0505;
    
    /* FrontFaceDirection */
    static inline var CW                             = 0x0900;
    static inline var CCW                            = 0x0901;
    
    /* GetPName */
    static inline var LINE_WIDTH                     = 0x0B21;
    static inline var ALIASED_POINT_SIZE_RANGE       = 0x846D;
    static inline var ALIASED_LINE_WIDTH_RANGE       = 0x846E;
    static inline var CULL_FACE_MODE                 = 0x0B45;
    static inline var FRONT_FACE                     = 0x0B46;
    static inline var DEPTH_RANGE                    = 0x0B70;
    static inline var DEPTH_WRITEMASK                = 0x0B72;
    static inline var DEPTH_CLEAR_VALUE              = 0x0B73;
    static inline var DEPTH_FUNC                     = 0x0B74;
    static inline var STENCIL_CLEAR_VALUE            = 0x0B91;
    static inline var STENCIL_FUNC                   = 0x0B92;
    static inline var STENCIL_FAIL                   = 0x0B94;
    static inline var STENCIL_PASS_DEPTH_FAIL        = 0x0B95;
    static inline var STENCIL_PASS_DEPTH_PASS        = 0x0B96;
    static inline var STENCIL_REF                    = 0x0B97;
    static inline var STENCIL_VALUE_MASK             = 0x0B93;
    static inline var STENCIL_WRITEMASK              = 0x0B98;
    static inline var STENCIL_BACK_FUNC              = 0x8800;
    static inline var STENCIL_BACK_FAIL              = 0x8801;
    static inline var STENCIL_BACK_PASS_DEPTH_FAIL   = 0x8802;
    static inline var STENCIL_BACK_PASS_DEPTH_PASS   = 0x8803;
    static inline var STENCIL_BACK_REF               = 0x8CA3;
    static inline var STENCIL_BACK_VALUE_MASK        = 0x8CA4;
    static inline var STENCIL_BACK_WRITEMASK         = 0x8CA5;
    static inline var VIEWPORT                       = 0x0BA2;
    static inline var SCISSOR_BOX                    = 0x0C10;
	
    /*      SCISSOR_TEST */
    static inline var COLOR_CLEAR_VALUE              = 0x0C22;
    static inline var COLOR_WRITEMASK                = 0x0C23;
    static inline var UNPACK_ALIGNMENT               = 0x0CF5;
    static inline var PACK_ALIGNMENT                 = 0x0D05;
    static inline var MAX_TEXTURE_SIZE               = 0x0D33;
    static inline var MAX_VIEWPORT_DIMS              = 0x0D3A;
    static inline var SUBPIXEL_BITS                  = 0x0D50;
    static inline var RED_BITS                       = 0x0D52;
    static inline var GREEN_BITS                     = 0x0D53;
    static inline var BLUE_BITS                      = 0x0D54;
    static inline var ALPHA_BITS                     = 0x0D55;
    static inline var DEPTH_BITS                     = 0x0D56;
    static inline var STENCIL_BITS                   = 0x0D57;
    static inline var POLYGON_OFFSET_UNITS           = 0x2A00;
	
    /*      POLYGON_OFFSET_FILL */
    static inline var POLYGON_OFFSET_FACTOR          = 0x8038;
    static inline var TEXTURE_BINDING_2D             = 0x8069;
    static inline var SAMPLE_BUFFERS                 = 0x80A8;
    static inline var SAMPLES                        = 0x80A9;
    static inline var SAMPLE_COVERAGE_VALUE          = 0x80AA;
    static inline var SAMPLE_COVERAGE_INVERT         = 0x80AB;
    
    /* GetTextureParameter */
    /*      TEXTURE_MAG_FILTER */
    /*      TEXTURE_MIN_FILTER */
    /*      TEXTURE_WRAP_S */
    /*      TEXTURE_WRAP_T */
    
    static inline var NUM_COMPRESSED_TEXTURE_FORMATS = 0x86A2;
    static inline var COMPRESSED_TEXTURE_FORMATS     = 0x86A3;
    
    /* HintMode */
    static inline var DONT_CARE                      = 0x1100;
    static inline var FASTEST                        = 0x1101;
    static inline var NICEST                         = 0x1102;
    
    /* HintTarget */
    static inline var GENERATE_MIPMAP_HINT            = 0x8192;
    
    /* DataType */
    static inline var BYTE                           = 0x1400;
    static inline var UNSIGNED_BYTE                  = 0x1401;
    static inline var SHORT                          = 0x1402;
    static inline var UNSIGNED_SHORT                 = 0x1403;
    static inline var INT                            = 0x1404;
    static inline var UNSIGNED_INT                   = 0x1405;
    static inline var FLOAT                          = 0x1406;
    
    /* PixelFormat */
    static inline var DEPTH_COMPONENT                = 0x1902;
    static inline var ALPHA                          = 0x1906;
    static inline var RGB                            = 0x1907;
    static inline var RGBA                           = 0x1908;
    static inline var LUMINANCE                      = 0x1909;
    static inline var LUMINANCE_ALPHA                = 0x190A;
    
    /* PixelType */
    /*      UNSIGNED_BYTE */
    static inline var UNSIGNED_SHORT_4_4_4_4         = 0x8033;
    static inline var UNSIGNED_SHORT_5_5_5_1         = 0x8034;
    static inline var UNSIGNED_SHORT_5_6_5           = 0x8363;
    
    /* Shaders */
    static inline var FRAGMENT_SHADER                  = 0x8B30;
    static inline var VERTEX_SHADER                    = 0x8B31;
    static inline var MAX_VERTEX_ATTRIBS               = 0x8869;
    static inline var MAX_VERTEX_UNIFORM_VECTORS       = 0x8DFB;
    static inline var MAX_VARYING_VECTORS              = 0x8DFC;
    static inline var MAX_COMBINED_TEXTURE_IMAGE_UNITS = 0x8B4D;
    static inline var MAX_VERTEX_TEXTURE_IMAGE_UNITS   = 0x8B4C;
    static inline var MAX_TEXTURE_IMAGE_UNITS          = 0x8872;
    static inline var MAX_FRAGMENT_UNIFORM_VECTORS     = 0x8DFD;
    static inline var SHADER_TYPE                      = 0x8B4F;
    static inline var DELETE_STATUS                    = 0x8B80;
    static inline var LINK_STATUS                      = 0x8B82;
    static inline var VALIDATE_STATUS                  = 0x8B83;
    static inline var ATTACHED_SHADERS                 = 0x8B85;
    static inline var ACTIVE_UNIFORMS                  = 0x8B86;
    static inline var ACTIVE_UNIFORM_MAX_LENGTH        = 0x8B87;
    static inline var ACTIVE_ATTRIBUTES                = 0x8B89;
    static inline var ACTIVE_ATTRIBUTE_MAX_LENGTH      = 0x8B8A;
    static inline var SHADING_LANGUAGE_VERSION         = 0x8B8C;
    static inline var CURRENT_PROGRAM                  = 0x8B8D;
    
    /* StencilFunction */
    static inline var NEVER                          = 0x0200;
    static inline var LESS                           = 0x0201;
    static inline var EQUAL                          = 0x0202;
    static inline var LEQUAL                         = 0x0203;
    static inline var GREATER                        = 0x0204;
    static inline var NOTEQUAL                       = 0x0205;
    static inline var GEQUAL                         = 0x0206;
    static inline var ALWAYS                         = 0x0207;
    
    /* StencilOp */
    /*      ZERO */
    static inline var KEEP                           = 0x1E00;
    static inline var REPLACE                        = 0x1E01;
    static inline var INCR                           = 0x1E02;
    static inline var DECR                           = 0x1E03;
    static inline var INVERT                         = 0x150A;
    static inline var INCR_WRAP                      = 0x8507;
    static inline var DECR_WRAP                      = 0x8508;
    
    /* StringName */
    static inline var VENDOR                         = 0x1F00;
    static inline var RENDERER                       = 0x1F01;
    static inline var VERSION                        = 0x1F02;
    static inline var EXTENSIONS                     = 0x1F03;
    
    /* TextureMagFilter */
    static inline var NEAREST                        = 0x2600;
    static inline var LINEAR                         = 0x2601;
    
    /* TextureMinFilter */
    /*      NEAREST */
    /*      LINEAR */
    static inline var NEAREST_MIPMAP_NEAREST         = 0x2700;
    static inline var LINEAR_MIPMAP_NEAREST          = 0x2701;
    static inline var NEAREST_MIPMAP_LINEAR          = 0x2702;
    static inline var LINEAR_MIPMAP_LINEAR           = 0x2703;
    
    /* TextureParameterName */
    static inline var TEXTURE_MAG_FILTER             = 0x2800;
    static inline var TEXTURE_MIN_FILTER             = 0x2801;
    static inline var TEXTURE_WRAP_S                 = 0x2802;
    static inline var TEXTURE_WRAP_T                 = 0x2803;
    
    /* TextureTarget */
    static inline var TEXTURE_2D                     = 0x0DE1;
    static inline var TEXTURE                        = 0x1702;
    
    static inline var TEXTURE_CUBE_MAP               = 0x8513;
    static inline var TEXTURE_BINDING_CUBE_MAP       = 0x8514;
    static inline var TEXTURE_CUBE_MAP_POSITIVE_X    = 0x8515;
    static inline var TEXTURE_CUBE_MAP_NEGATIVE_X    = 0x8516;
    static inline var TEXTURE_CUBE_MAP_POSITIVE_Y    = 0x8517;
    static inline var TEXTURE_CUBE_MAP_NEGATIVE_Y    = 0x8518;
    static inline var TEXTURE_CUBE_MAP_POSITIVE_Z    = 0x8519;
    static inline var TEXTURE_CUBE_MAP_NEGATIVE_Z    = 0x851A;
    static inline var MAX_CUBE_MAP_TEXTURE_SIZE      = 0x851C;
    
    /* TextureUnit */
    static inline var TEXTURE0                       = 0x84C0;
    static inline var TEXTURE1                       = 0x84C1;
    static inline var TEXTURE2                       = 0x84C2;
    static inline var TEXTURE3                       = 0x84C3;
    static inline var TEXTURE4                       = 0x84C4;
    static inline var TEXTURE5                       = 0x84C5;
    static inline var TEXTURE6                       = 0x84C6;
    static inline var TEXTURE7                       = 0x84C7;
    static inline var TEXTURE8                       = 0x84C8;
    static inline var TEXTURE9                       = 0x84C9;
    static inline var TEXTURE10                      = 0x84CA;
    static inline var TEXTURE11                      = 0x84CB;
    static inline var TEXTURE12                      = 0x84CC;
    static inline var TEXTURE13                      = 0x84CD;
    static inline var TEXTURE14                      = 0x84CE;
    static inline var TEXTURE15                      = 0x84CF;
    static inline var TEXTURE16                      = 0x84D0;
    static inline var TEXTURE17                      = 0x84D1;
    static inline var TEXTURE18                      = 0x84D2;
    static inline var TEXTURE19                      = 0x84D3;
    static inline var TEXTURE20                      = 0x84D4;
    static inline var TEXTURE21                      = 0x84D5;
    static inline var TEXTURE22                      = 0x84D6;
    static inline var TEXTURE23                      = 0x84D7;
    static inline var TEXTURE24                      = 0x84D8;
    static inline var TEXTURE25                      = 0x84D9;
    static inline var TEXTURE26                      = 0x84DA;
    static inline var TEXTURE27                      = 0x84DB;
    static inline var TEXTURE28                      = 0x84DC;
    static inline var TEXTURE29                      = 0x84DD;
    static inline var TEXTURE30                      = 0x84DE;
    static inline var TEXTURE31                      = 0x84DF;
    static inline var ACTIVE_TEXTURE                 = 0x84E0;
    
    /* TextureWrapMode */
    static inline var REPEAT                         = 0x2901;
    static inline var CLAMP_TO_EDGE                  = 0x812F;
    static inline var MIRRORED_REPEAT                = 0x8370;
    
    /* Uniform Types */
    static inline var FLOAT_VEC2                     = 0x8B50;
    static inline var FLOAT_VEC3                     = 0x8B51;
    static inline var FLOAT_VEC4                     = 0x8B52;
    static inline var INT_VEC2                       = 0x8B53;
    static inline var INT_VEC3                       = 0x8B54;
    static inline var INT_VEC4                       = 0x8B55;
    static inline var BOOL                           = 0x8B56;
    static inline var BOOL_VEC2                      = 0x8B57;
    static inline var BOOL_VEC3                      = 0x8B58;
    static inline var BOOL_VEC4                      = 0x8B59;
    static inline var FLOAT_MAT2                     = 0x8B5A;
    static inline var FLOAT_MAT3                     = 0x8B5B;
    static inline var FLOAT_MAT4                     = 0x8B5C;
    static inline var SAMPLER_2D                     = 0x8B5E;
    static inline var SAMPLER_CUBE                   = 0x8B60;
    
    /* Vertex Arrays */
    static inline var VERTEX_ATTRIB_ARRAY_ENABLED        = 0x8622;
    static inline var VERTEX_ATTRIB_ARRAY_SIZE           = 0x8623;
    static inline var VERTEX_ATTRIB_ARRAY_STRIDE         = 0x8624;
    static inline var VERTEX_ATTRIB_ARRAY_TYPE           = 0x8625;
    static inline var VERTEX_ATTRIB_ARRAY_NORMALIZED     = 0x886A;
    static inline var VERTEX_ATTRIB_ARRAY_POINTER        = 0x8645;
    static inline var VERTEX_ATTRIB_ARRAY_BUFFER_BINDING = 0x889F;
    
    /* Read Format */
    static inline var IMPLEMENTATION_COLOR_READ_TYPE   = 0x8B9A;
    static inline var IMPLEMENTATION_COLOR_READ_FORMAT = 0x8B9B;
    
    /* Shader Source */
    static inline var COMPILE_STATUS                 = 0x8B81;
    static inline var INFO_LOG_LENGTH                = 0x8B84;
    static inline var SHADER_SOURCE_LENGTH           = 0x8B88;
    static inline var SHADER_COMPILER                = 0x8DFA;
    
    /* Shader Precision-Specified Types */
    static inline var LOW_FLOAT                      = 0x8DF0;
    static inline var MEDIUM_FLOAT                   = 0x8DF1;
    static inline var HIGH_FLOAT                     = 0x8DF2;
    static inline var LOW_INT                        = 0x8DF3;
    static inline var MEDIUM_INT                     = 0x8DF4;
    static inline var HIGH_INT                       = 0x8DF5;
    
    /* Framebuffer Object. */
    static inline var FRAMEBUFFER                    = 0x8D40;
    static inline var RENDERBUFFER                   = 0x8D41;
    
    static inline var RGBA4                          = 0x8056;
    static inline var RGB5_A1                        = 0x8057;
    static inline var RGB565                         = 0x8D62;
    static inline var DEPTH_COMPONENT16              = 0x81A5;
    static inline var STENCIL_INDEX                  = 0x1901;
    static inline var STENCIL_INDEX8                 = 0x8D48;
    static inline var DEPTH_STENCIL                  = 0x84F9;
    
    static inline var RENDERBUFFER_WIDTH             = 0x8D42;
    static inline var RENDERBUFFER_HEIGHT            = 0x8D43;
    static inline var RENDERBUFFER_INTERNAL_FORMAT   = 0x8D44;
    static inline var RENDERBUFFER_RED_SIZE          = 0x8D50;
    static inline var RENDERBUFFER_GREEN_SIZE        = 0x8D51;
    static inline var RENDERBUFFER_BLUE_SIZE         = 0x8D52;
    static inline var RENDERBUFFER_ALPHA_SIZE        = 0x8D53;
    static inline var RENDERBUFFER_DEPTH_SIZE        = 0x8D54;
    static inline var RENDERBUFFER_STENCIL_SIZE      = 0x8D55;
    
    static inline var FRAMEBUFFER_ATTACHMENT_OBJECT_TYPE           = 0x8CD0;
    static inline var FRAMEBUFFER_ATTACHMENT_OBJECT_NAME           = 0x8CD1;
    static inline var FRAMEBUFFER_ATTACHMENT_TEXTURE_LEVEL         = 0x8CD2;
    static inline var FRAMEBUFFER_ATTACHMENT_TEXTURE_CUBE_MAP_FACE = 0x8CD3;
    
    static inline var COLOR_ATTACHMENT0              = 0x8CE0;
    static inline var DEPTH_ATTACHMENT               = 0x8D00;
    static inline var STENCIL_ATTACHMENT             = 0x8D20;
    static inline var DEPTH_STENCIL_ATTACHMENT       = 0x821A;
    
    static inline var NONE                           = 0;
    
	static inline var FRAMEBUFFER_COMPLETE                      = 0x8CD5;
    static inline var FRAMEBUFFER_INCOMPLETE_ATTACHMENT         = 0x8CD6;
    static inline var FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT = 0x8CD7;
    static inline var FRAMEBUFFER_INCOMPLETE_DIMENSIONS         = 0x8CD9;
    static inline var FRAMEBUFFER_UNSUPPORTED                   = 0x8CDD;
    
    static inline var FRAMEBUFFER_BINDING            = 0x8CA6;
    static inline var RENDERBUFFER_BINDING           = 0x8CA7;
    static inline var MAX_RENDERBUFFER_SIZE          = 0x84E8;
    
	static inline var INVALID_FRAMEBUFFER_OPERATION  = 0x0506;
	
	//WebGl spec
	static inline var  UNPACK_FLIP_Y_WEBGL            = 0x9240;
    static inline var  UNPACK_PREMULTIPLY_ALPHA_WEBGL = 0x9241;
    static inline var  CONTEXT_LOST_WEBGL             = 0x9242;

}







#end

