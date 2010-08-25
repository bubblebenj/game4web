/**
 * ...
 * @author de
 */

package renderer.camera;

import math.CMatrix44;
import math.CV3D;

import kernel.CTypes;

import renderer.camera.CCamera;


class COrthoCamera extends CCamera
{
	
	public function new() 
	{
		super();
		
		m_Height = 0;
		m_Width = 0;
	}
	
	public function SetHeight(  _H : Float  ) : Void
	{
		m_Height = _H;
	}
	
	public function SetWidth( _W : Float ) : Void
	{
		m_Width = _W;
	}
	
	public override function BuildMatrix( _Out : CMatrix44 ) : Result
	{
		var l_Left : Float = m_Pos.x;
		var l_Right : Float  = m_Pos.x + m_Width;
		
		var l_Bottom  : Float = m_Pos.y + m_Height;
		var l_Top : Float  = m_Pos.y;

		
		CMatrix44.Ortho(_Out, l_Left, l_Right, l_Bottom, l_Top, m_Pos.z + m_Near, m_Pos.z + m_Far );
		//CMatrix44.Ortho(_Out, 0, 1, 1, 0, m_Near,  m_Far );
		
		return SUCCESS;
	}
	
	var m_Height : Float;
	var m_Width : Float;
}