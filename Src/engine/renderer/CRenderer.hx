package renderer;

import haxe.FastList;
import kernel.CDisplay;
import math.CMatrix44;

import tools.transition.CTween;

import CTypes;
import CDebug;

import renderer.CDrawObject;
import renderer.CRenderContext;
import renderer.CViewport;

import renderer.camera.CCamera;
import renderer.camera.CPerspectiveCamera;
import renderer.camera.COrthoCamera;

using Lambda;

class CRenderer
{
	var	m_CurrentVPMatrix	: CMatrix44;
	
	public var m_Scene 			: Array<CDrawObject>;

	public var m_Vps		: Array<CViewport>;
	public var m_Cameras	: Array<CCamera>;
	
	public static var CAM_PERSPECTIVE_0 : Int = 0;
	public static var CAM_ORTHO_0		: Int = 1;
	public static var CAM_COUNT			: Int = 2;
	
	public static var VP_FULLSCREEN		: Int = 0;
	public static var VP_MAX			: Int = 8;
	public static var VP_EDITOR			: Int = VP_MAX;
	public static var VP_SDK_MAX		: Int = VP_EDITOR + 1;
	
	public var m_RenderContext(default, null) : CRenderContext;
	
	public function new()
	{
		m_Vps = new Array<>();
		
		for( i in 0...VP_MAX)
		{
			m_Vps[i] = null;
		}
		
		m_Cameras = new Array<CCamera>();
		for( i in 0...VP_MAX)
		{
			m_Cameras[i]	= null;
		}
		
		m_CurrentVPMatrix	= null;
		
		m_RenderContext		= new CRenderContext();
	}
	
	public inline function GetViewProjection() : CMatrix44
	{
		return m_CurrentVPMatrix;
	}
	
	public function BuildViewport() : CViewport
	{
		CDebug.BREAK("Implement me");
		return null;
	}
	
	public inline function GetCamera( _CamIndex : Int )
	{
		return m_Cameras[_CamIndex];
	}
	
	public function Initialize() : Result
	{
		m_Vps[VP_FULLSCREEN] = BuildViewport();
		m_Vps[VP_FULLSCREEN].Initialize(0, 0, 1, 1);
		
		m_Vps[VP_EDITOR] = BuildViewport();
		m_Vps[VP_EDITOR].Initialize(0.75, 0.75, 1, 1);
		
		m_Cameras[CAM_PERSPECTIVE_0]	= new CPerspectiveCamera();
		m_Cameras[CAM_ORTHO_0]			= new COrthoCamera();
		
		m_Scene			= [];
		
		m_RenderContext.Reset();
		
		return SUCCESS;
	}
	
	public function BeginScene() : Result
	{
		
		m_RenderContext.Reset();
		
		//process skinning, texture activations
		for ( l_Cams in m_Cameras)
		{
			if( l_Cams != null )
			{
				l_Cams.Update();
			}
		}
		
		//CDebug.CONSOLEMSG(".");
		for ( l_do in m_Scene )
		{
			l_do.Update();
		}
		
		return SUCCESS;
	}
	
	public function Render( _VpId : Int) : Result
	{
		//process draw requests on driver side
		return SUCCESS;
	}
	
	public function EndScene() : Result
	{
		return SUCCESS;
	}
		
	public function Update() : Result 
	{
		var l_BegRes : Result = BeginScene();
		if ( l_BegRes == FAILURE )
		{
			return FAILURE;
		}
		
		for ( l_VpId in 0...m_Vps.length )
		{
			if (m_Vps[ l_VpId ]!= null)
			{
				m_Vps[ l_VpId ].Activate();
				
				var l_RdrRes : Result = Render( l_VpId );
				if ( l_RdrRes == FAILURE )
				{
					return FAILURE;
				}
			}
		}
		
		for ( i_Tween in CTween.m_TweenList )
		{
			i_Tween.Update();
		}
		
		//trace("CRenderer:: end scn");
		var l_Endres : Result = EndScene();
		if ( l_Endres == FAILURE )
		{
			return FAILURE;
		}

		return SUCCESS;
	}
	
	public function AddToScene( _Obj : CDrawObject ) : Result
	{
		if (_Obj.IsActivated()) return FAILURE;
		m_Scene.push( _Obj );
		m_Scene.sort( function(o1,o2)
		{
			if (o2.m_Priority < o1.m_Priority)
			{
				return -1;
			}
			else if (o2.m_Priority > o1.m_Priority)
			{
				return 1;
			}
			return 0;
		}
		);
		
		return SUCCESS;
	}
	
	/*/
	public function Subset( _l, _n )
	{
		var l_NewList = new List();
		for ( x in _l )
		{
			l_NewList.push( _l );
			n--;
		}
	}//*/
	
	
	public function RemoveFromScene(  _Obj : CDrawObject ) : Void
	{
		m_Scene.remove(_Obj );
	}
	
	public function toString()
	{
		return m_Scene
		.filter( function(d) return d.m_Name != null )
		.map(
		function( d )
		{
			return  d.m_Priority + " * " + d.toString();
		}).join(" , ");
	}
}
