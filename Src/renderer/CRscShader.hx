/**
 * ...
 * @author de
 */

package renderer;

import kernel.CTypes;

import rsc.CRsc;



class CRscShader extends CRsc
{
	public static inline var SHADER_STATUS_NONE : Int = 0;
	public static inline var SHADER_STATUS_COMPILED : Int = 1;
	public static inline var SHADER_STATUS_LINKED : Int = 2;
	public static inline var SHADER_STATUS_READY : Int = 3;

	public function new() 
	{
		super();
	}
	
	public function  Activate() : Result 
	{
		if( m_Status == SHADER_STATUS_NONE )
		{
			if ( Compile() == FAILURE)
			{
				return FAILURE;
			}
			
			if ( Link() == FAILURE)
			{
				return FAILURE;
			}
			
		}
		return SUCCESS;
	}
	
	
	public function Compile() : Result
	{
		return SUCCESS;
	}
	
	public function Link() : Result
	{
		return SUCCESS;
	}
	
	var m_Status : Int;
}