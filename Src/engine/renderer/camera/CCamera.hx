/**
 * ...
 * @author de
 */

package renderer.camera;

import math.CV3D;
import math.CV2D;
import math.CMatrix44;
import math.Constants;
import math.Registers;

import CTypes;

class CCamera 
{
	public function new() 
	{
		m_Near	= 0.0001;
		m_Far	= 1000.0;
		m_Fov	= Constants.DEG_TO_RAD * 54.4;
		m_AspectRatio = 4.0 / 3.0;
		
		m_Up	= new CV3D(0, 1, 0);
		m_Pos	= new CV3D(0, 0, 5);
		m_Dir	= new CV3D(0, 0, -1);
		
		m_VPMatrix = new CMatrix44();
	}
	
	public function GetMatrix() : CMatrix44 
	{
		return m_VPMatrix;
	}
	
	public function BuildMatrix( _Out : CMatrix44 ) : Result 
	{
		return SUCCESS;
	}
	
	public function Update() : Result 
	{
		return BuildMatrix(m_VPMatrix);
	}
	
	public inline function GetFar() : Float
	{
		return m_Near;
	}
	
	public inline function GetNear() : Float
	{
		return m_Far;
	}
	
	public inline function GetPosition() : CV3D
	{
		return m_Pos;
	}
	
	public inline function SetNear( _Near ) : Void
	{
		m_Near = _Near;
	}
	
	public inline function SetFar( _Far ) : Void
	{
		m_Far = _Far;
	}
	
	public function SetPosition( _Pos : CV3D ) : Void
	{
		m_Pos.Copy(_Pos);
	}
	
	public function SetUp( _Up : CV3D ) : Void
	{
		m_Up.Copy( _Up );
	}
	
	//
	var m_Near	: Float;
	var m_Far	: Float;
	var m_Fov	: Float;
	var m_AspectRatio : Float;
	
	var m_Pos	: CV3D;
	var m_Dir	: CV3D;
	var m_Up	: CV3D;
	
	var m_VPMatrix : CMatrix44;

}
