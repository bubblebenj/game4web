package renderer;

import math.CMatrix44;
import renderer.camera.CPerspectiveCamera;

import kernel.CTypes;
import kernel.CDebug;

import renderer.CDrawObject;
import renderer.CViewport;

import renderer.camera.CCamera;
import renderer.camera.CPerspectiveCamera;
import renderer.camera.COrthoCamera;

import renderer.CRenderContext;


class CRenderer
{
	var	m_CurrentVPMatrix : CMatrix44;
	
	var m_Scene : List<CDrawObject>;
	var m_BackScene : List<CDrawObject>;
	
	public var m_Vps : Array<CViewport>;
	public var m_Cameras : Array<CCamera>;
	
	public static var CAM_PERSPECTIVE_0 : Int = 0;
	public static var CAM_ORTHO_0 : Int = 1;
	public static var CAM_COUNT : Int = 2;
	
	public static var VP_FULLSCREEN : Int = 0;
	public static var VP_MAX : Int = 2;
	
	public var m_RenderContext(default,null) : CRenderContext;
	
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
			m_Cameras[i] = null;
		}
		
		m_CurrentVPMatrix = null;
		
		m_RenderContext = new CRenderContext();
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
		
		m_Cameras[CAM_PERSPECTIVE_0] = new CPerspectiveCamera();
		m_Cameras[CAM_ORTHO_0] = new COrthoCamera();
		
		m_Scene = new List<CDrawObject>();
		m_BackScene  = new List<CDrawObject>();
		
		m_RenderContext.Reset();
		return SUCCESS;
	}
	
	public function BeginScene() : Result
	{
		//process skinning, texture activations
		for ( l_Cams in m_Cameras)
		{
			if( l_Cams != null )
			{
				l_Cams.Update();
			}
		}
		
		m_BackScene.clear();
		
		for ( l_do in m_Scene)
		{
			m_BackScene.push(l_do);
		}
		
		//CDebug.CONSOLEMSG(".");
		for ( l_do in m_BackScene )
		{
			l_do.Update();
		}
		
		m_Scene.clear();
		m_Scene = m_BackScene.filter( function( _ ) { return true; } );
		
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
		if (l_BegRes==FAILURE)
		{
			return FAILURE;
		}
		
		for (  l_VpId in 0...m_Vps.length )
		{
			if (m_Vps[l_VpId ]!=null)
			{
				m_Vps[l_VpId ].Activate();
				
				var l_RdrRes : Result = Render( l_VpId );
				if (l_RdrRes==FAILURE)
				{
					return FAILURE;
				}
			}
		}
		
		//trace("CRenderer:: end scn");
		var l_Endres : Result = EndScene();
		if (l_Endres==FAILURE)
		{
			return FAILURE;
		}

		return SUCCESS;
	}
	
	public function AddToScene( _Obj : CDrawObject )
	{
		var l_Exists : Bool = false;

		m_Scene.push( _Obj );			
	}
	
	public function RemoveFromScene(  _Obj : CDrawObject )
	{
		m_Scene.remove(_Obj );
	}
	
	
	
}


