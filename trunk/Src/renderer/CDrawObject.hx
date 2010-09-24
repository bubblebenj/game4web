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
		m_VpMask	= Constants.INT_MAX;
		m_Visible	= false;
		m_Alpha		= 1;
		m_Transfo	= new CMatrix44();
		m_Transfo.Identity();
		
		m_Cameras = new Array<CCamera>();
	}
	
	public function Initialize() : Result
	{
		return SUCCESS;
	}
	
	public function Activate() : Result
	{
		m_Activated	= true;
		return SUCCESS;
	}
	
	public function Update() : Result
	{
		return SUCCESS;
	}
	
	public function Shut() : Result
	{
		m_Activated	= false;
		return SUCCESS;
	}
	
	public function Draw( _Vp : Int ) : Result
	{
		/* bd : process draw requests in child objects
		 * on driver side ? */
		return SUCCESS;
	}
	
	public function SetVisible( _Vis : Bool ) : Void 
	{
		m_Visible = _Vis;
		
		if( m_Visible )
		{
			trace( "add" );
			Glb.g_System.GetRenderer().AddToScene( this );
		}
		else
		{
			trace( "remove" );
			Glb.g_System.GetRenderer().RemoveFromScene( this );
		}
	}
	
	public function IsVisible() : Bool 
	{
		return m_Visible;
	}
	
	public function SetAlpha( _Value : Float )		: Void
	{
		trace( m_Alpha );
		m_Alpha 	= _Value;
	}
	
	public function GetAlpha() : Float
	{
		return m_Alpha;
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
	
			var 	m_Visible	: Bool;
	private var		m_Alpha		: Float;
			var		m_Activated	: Bool;			/* We need it because, in AS, setting an object to a not visible is
			a lot faster than removing it from the scene. Thus object should be remove from the scene only on shut request.*/
	
			var 	m_Transfo	: CMatrix44;
	
	public 	var		m_VpMask	: Int;
			var		m_Cameras	: Array<CCamera>;
}