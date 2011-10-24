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
	
	public var o(get,set) : T;
	
	public function get() : T
	{
		return cast m_Native;
	}
	
	public function set(v) : T
	{
		m_Native = v;
		return m_Native;
	}
}

class CDrawObject 
{
	public	var m_Priority(getPrio,setPrio)	: Int;
			var m_Visible	: Bool;
	private var	m_Alpha		: Float;
			var	m_Activated	: Bool;			/* We need it because, in AS, setting an object to a not visible is
			a lot faster than removing it from the scene. Thus object should be remove from the scene only on shut request.*/
	
			var m_Transfo	: CMatrix44;
	
	public 	var	m_VpMask	: Int;
			var	m_Cameras	: Array<CCamera>;
	public	var m_Native	: Dynamic;
	
	public var alpha(GetAlpha, SetAlpha) : Float;
	public var visible(IsVisible, SetVisible) : Bool;
	
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
	
	public function getPrio()
	{
		return m_Priority;
	}
	
	public function setPrio(v) : Int
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
	
	public function SetVisible( v : Bool ) : Bool 
	{
		m_Visible = v;
		return v;
	}
	
	public function IsVisible() : Bool 
	{
		return m_Visible;
	}
	
	public function SetAlpha( _Value : Float )		: Float
	{
		m_Alpha 	= _Value;
		return m_Alpha;
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