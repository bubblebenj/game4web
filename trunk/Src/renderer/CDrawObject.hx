/**
 * ...
 * @author de
 */

package renderer;

import math.CMatrix44;
import math.Constants;

import renderer.camera.CCamera;

import kernel.CTypes;
import kernel.Glb;

class CDrawObject 
{
	public function new()
	{
		m_VpMask = Constants.INT_MAX;
		m_Visible = false;
		m_Transfo = new CMatrix44();
		m_Transfo.Identity();
		
		m_Cameras = new Array<CCamera>();
	}
	
	public function Initialize() : Result
	{
		return SUCCESS;
	}
	
	public function Activate() : Result
	{
		return SUCCESS;
	}
	
	public function Update() : Result
	{
		return SUCCESS;
	}
	
	public function Draw( _Vp : Int ) : Result
	{
		return SUCCESS;
	}
	
	public function SetVisible( _Vis : Bool ) : Void 
	{
		m_Visible = _Vis;
		
		if( m_Visible )
		{
			Glb.g_System.GetRenderer().AddToScene( this );
		}
		else
		{
			Glb.g_System.GetRenderer().RemoveFromScene( this );
		}
	}
	
	public function IsVisible() : Bool 
	{
		return m_Visible;
	}
	
	public function SetCamera( _VpIndex : Int, _Cam : CCamera) : Result
	{
		if( _VpIndex<0 || _VpIndex>= CRenderer.VP_MAX )
		{
			return FAILURE;
		}
		m_Cameras[_VpIndex] =  _Cam;
		return SUCCESS;
	}
	
	public function SetTransfo( _Transfo : CMatrix44) : Void
	{
		m_Transfo.Copy(_Transfo);
	}
	
			var 	m_Visible : Bool;
	
			var 	m_Transfo : CMatrix44;
	
	public 	var		m_VpMask : Int;
			var		m_Cameras : Array<CCamera>;
}