/**
 * ...
 * @author de
 */

package renderer;

import math.CMatrix44;
import math.Constants;

import renderer.camera.CCamera;

import CTypes;
import kernel.Glb;


class DO<T> extends CDrawObject
{
	public function new( n : T , ?name)
	{
		super();
		m_Native = n;
		m_Name = name;
	}
	
	public var o(get_o,set_o) : T;
	
	public function get_o() : T
	{
		return cast m_Native;
	}
	
	public function set_o(v) : T
	{
		m_Native = v;
		return m_Native;
	}
}

class CDrawObject 
{
	public	var m_Priority	(get_m_Priority, set_m_Priority) : Int;
			var m_Visible	: Bool;
	private var	m_Alpha		: Float;
			var	m_Activated	: Bool;			/* We need it because, in AS, setting an object to a not visible is
			a lot faster than removing it from the scene. Thus object should be remove from the scene only on shut request.*/
	
			var m_Transfo	: CMatrix44;
	
	public 	var	m_VpMask	: Int;
			var	m_Cameras	: Array<CCamera>;
	public	var m_Native	: Dynamic;
	
	public var alpha	(get_alpha, set_alpha) : Float;
	public var visible	(get_visible, set_visible) : Bool;
	
	public	var	m_Name : String;
	
	public function toString()
	{
		return m_Name;
	}
	
	public function new()
	{
		m_Priority	= 0;
		m_VpMask	= Constants.INT_MAX;
		m_Visible	= false;
		m_Alpha		= 1;
		m_Transfo	= new CMatrix44();
		m_Transfo.Identity();
		m_Native	= null;
	
		m_Activated = false;
		m_Cameras = new Array<CCamera>();
		m_Name = "";
	}
	
	public function IsActivated()
	{
		return m_Activated;
	}
	
	public function get_m_Priority()
	{
		return m_Priority;
	}
	
	public function set_m_Priority(v) : Int
	{
		m_Priority = v;
		if ( m_Activated )
		{
			Glb.GetRenderer().RemoveFromScene( this );
			m_Activated = false;
			Glb.GetRenderer().AddToScene(this);
		}
		return m_Priority;
	}
	
	public function Initialize() : Result
	{
		return SUCCESS;
	}
	
	public function Activate() : Result
	{
		if ( !m_Activated && m_Native != null )
		{
			var r = Glb.GetRenderer().AddToScene( this );
			
			if ( r == SUCCESS) 
			{
				if( m_Name != null)
					CDebug.CONSOLEMSG("Activated :" + m_Name);
				m_Activated	= true;
			}
		}
		return SUCCESS;
	}
	
	public function Update() : Result
	{
		return SUCCESS;
	}
	
	public function Shut() : Result
	{
		if ( m_Activated )
		{
			Glb.GetRenderer().RemoveFromScene( this );
			m_Activated	= false;
		}
		return SUCCESS;
	}
	
	public function Draw( _Vp : Int ) : Result
	{
		/* bd : process draw requests in child objects
		 * on driver side ? */
		if ( Activate() == FAILURE )
		{
			return FAILURE;
		}
		return SUCCESS;
	}
	
	public function set_visible( v : Bool ) : Bool 
	{
		m_Visible = v;
		return v;
	}
	
	public function get_visible() : Bool 
	{
		return m_Visible;
	}
	
	public inline function set_alpha( _Value : Float )		: Float
	{
		return SetAlpha( _Value );
	}
	
	public function SetAlpha( _Value : Float )		: Float
	{
		m_Alpha = _Value;
		return m_Alpha;
	}
	
	public function get_alpha() : Float
	{
		return GetAlpha();
	}
	
	public function GetAlpha() : Float
	{
		return m_Alpha;
	}
	
	public function SetCamera( _VpIndex : Int, _Cam : CCamera ) : Result
	{
		if( _VpIndex < 0 || _VpIndex >= CRenderer.VP_MAX )
		{
			return FAILURE;
		}
		m_Cameras[_VpIndex] =  _Cam;
		return SUCCESS;
	}
	
	public function SetTransfo( _Transfo : CMatrix44 ) : Void
	{
		m_Transfo.Copy(_Transfo);
	}
}