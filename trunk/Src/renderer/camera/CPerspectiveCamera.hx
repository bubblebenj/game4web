/**
 * ...
 * @author de
 */

package renderer.camera;

import math.CMatrix44;
import math.CV3D;
import math.Registers;

import kernel.CTypes;

import renderer.camera.CCamera;

class CPerspectiveCamera extends CCamera
{
	public function new() 
	{
		
		m_Projection = new CMatrix44();
		m_View = new CMatrix44();
		
		super();
	}
	
	public override function  BuildMatrix( _Out : CMatrix44) : Result
	{
		CV3D.Add(Registers.V0, m_Pos, m_Dir);
		
		m_Projection.Identity();
		m_Projection.Perspective(m_Fov,m_AspectRatio,m_Near,m_Far);
		
		m_View.Identity();
		m_View.LookAt( 	m_Pos.x, m_Pos.y, m_Pos.z,
						Registers.V0.x, Registers.V0.y, Registers.V0.z,
						m_Up.x, m_Up.y, m_Up.z
					);
		
		CMatrix44.Mult(_Out, m_View, m_Projection);
		
		return SUCCESS;
	}
	
	public function SetDirection( _Dir : CV3D ) : Void
	{
		m_Dir.Copy( _Dir );
	}

	public function SetFov(_Fov : Float) : Void
	{
		m_Fov = _Fov;
	}
	
	
	
	var m_Projection : CMatrix44;
	var m_View : CMatrix44;
}