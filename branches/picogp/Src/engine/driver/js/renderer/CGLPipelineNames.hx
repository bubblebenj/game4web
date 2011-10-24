/**
 * ...
 * @author de
 */

package driver.js.renderer;

class CGLPipelineNames 
{
	public function GetModelMatrixName() :String
	{
		return "_MMatrix";
	}
	
	public function GetModelViewMatrixName() :String
	{
		return "_MVMatrix";
	}
	
	public function GetViewMatrixName() :String
	{
		return "_VMatrix";
	}
	
	public function GetProjectionMatrixName() :String
	{
		return "_PMatrix";
	}
	
	public function GetViewProjectionMatrixName(): String
	{
		return "_VPMatrix";
	}
	
	public function GetModelViewProjectionMatrixName() :String
	{
		return "_MVPMatrix";
	}
	
	public function GetPositionName( ?_Stage : Int ) : String
	{
		if (_Stage == null)
		{
			return "_Pos";
		}
		else 
		{
			return "_Pos_" + _Stage;
		}
	}
	
	public function GetTexCooName( ?_Stage : Int ) : String
	{
		if (_Stage == null)
		{
			return "_TexCoord";
		}
		else 
		{
			return "_TexCoord_" + _Stage;
		}
	}
	
	public function GetTexSamplerName( ?_Stage : Int ) : String
	{
		if (_Stage == null)
		{
			return "_TexSampler";
		}
		else 
		{
			return "_TexSampler_" + _Stage;
		}
	}
	
	public function GetNormalName( ?_Stage : Int ) : String
	{
		if (_Stage == null)
		{
			return "_Nrm";
		}
		else 
		{
			return "_Nrm_" + _Stage;
		}
	}
	
	public function GetColorName( ?_Stage : Int ) : String
	{
		if (_Stage == null)
		{
			return "_Clr";
		}
		else 
		{
			return "_Clr_" + _Stage;
		}
	}
	
	public function new() 
	{
		
	}
	
	private var m_Dico : Hash<CGLVariable>;
	
	public function ValidateShader( _Str : String )
	{
		_Str = ParseUniforms( _Str );
		_Str = ParseVarying( _Str );
		_Str = ParseAttributes( _Str );
		
		_Str = ParseMain( _Str );
	}
	
	private function ParseUniforms( _Str : String ) : String
	{
		var l_Uniform : String= "uniform";
		
		var l_Text : Int = _Str.indexOf(l_Uniform);

		return _Str;
	}
	
	private function ParseVarying( _Str : String ) : String
	{
		var l_Varying : String= "varying";
		
		var l_Text : Int = _Str.indexOf(l_Varying);

		return _Str;
	}
	
	private function ParseAttributes( _Str : String ) : String
	{
		var l_Attr : String= "attribute";
		
		var l_Text : Int = _Str.indexOf(l_Attr);

		return _Str;
	}
	
	private function ParseMain( _Str : String ) : String
	{
		var l_Func : String= "main";
		
		var l_Text : Int = _Str.indexOf(l_Func);

		return _Str;
	}
}