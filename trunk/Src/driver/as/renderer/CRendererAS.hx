
package driver.as.renderer;

/**
 * ...
 * @author Benjamin Dubois
 */

import flash.display.MovieClip;
import flash.display.DisplayObject;
import kernel.CTypes;
import kernel.CDebug;
import renderer.CDrawObject;
import renderer.CRenderer;
import renderer.CViewport;

class CRendererAS extends CRenderer
{
	private var m_SceneAS	: MovieClip;
	public var 	m_CameraAS	: C2DCameraAS;
	
	public function new()
	{
		super();
		m_SceneAS	=	flash.Lib.current;
		m_CameraAS	= new C2DCameraAS();
	}
	
	public override function  Initialize()	: Result
	{
		super.Initialize();
		
		trace("CRendererAS::init");
		return SUCCESS;
	}
	
	public override function BuildViewport() : CViewport
	{
		// Needed. inherited function returns null
		return new CViewportAS();
	}
	
	public var m_NbDrawn : Int;
	// Just copy paste from CRendererJS
	public override function Render( _VpId : Int) : Result
	{
		super.Render(_VpId);
		
		var l_InvMatrix = m_CameraAS.m_Matrix.clone();
		l_InvMatrix.invert();
		m_SceneAS.transform.matrix = l_InvMatrix;
		
		m_NbDrawn = 0;
		
		for( _DOs in m_Scene )
		{
			if ( 	_DOs != null 
			&&		_DOs.Draw( _VpId ) == SUCCESS )
			{
				m_NbDrawn++;
			}
		}
		
		return SUCCESS;
	}
	
	public function AddToSceneAS(  _DisplayObj : DisplayObject )
	{
		m_SceneAS.addChild( _DisplayObj );
	}
	
	public function RemoveFromSceneAS( _DisplayObj : DisplayObject )
	{
		m_SceneAS.removeChild( _DisplayObj );
	}
}