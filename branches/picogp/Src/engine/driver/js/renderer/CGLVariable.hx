/**
 * ...
 * @author de
 */

package driver.js.renderer;

enum Binding
{
	B_UNIFORM;
	B_VARYING;
	B_ATTRIBUTE;
	
	B_INVALID;
}

enum Typing
{
	T_VEC2;
	T_VEC3;
	T_VEC4;
	
	T_MAT4;
	
	T_SAMPLER2D;
	
	T_INVALID;
}

class CGLVariable 
{
	var m_Bind : Binding;
	var m_Type : Typing;
	
	public function new() 
	{
		m_Bind = B_INVALID;
		m_Type = T_INVALID;
	}
}