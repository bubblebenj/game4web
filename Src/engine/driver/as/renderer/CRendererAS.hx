
package driver.as.renderer;

/**
 * ...
 * @author Benjamin Dubois
 */

import flash.display.MovieClip;
import flash.display.DisplayObject;
import CTypes;
import CDebug;
import renderer.CDrawObject;
import renderer.CRenderer;
import renderer.CViewport;

class CRendererAS extends CRenderer
{
	private var m_SceneAS	: MovieClip;
	
	public function new()
	{
		super();
		m_SceneAS	=	flash.Lib.current;
	}
	
	public override function  Initialize()	: Result
	{
		super.Initialize();
		
		//trace("CRendererAS::init");
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
	
	public function SendToFront(  _DisplayObj : DisplayObject )
	{
		m_SceneAS.setChildIndex( _DisplayObj,m_SceneAS.numChildren-1 );
	}
	
	public function SendToBack(  _DisplayObj : DisplayObject )
	{
		m_SceneAS.setChildIndex( _DisplayObj, 0 );
	}
	
	public override function AddToScene( _Obj : CDrawObject ) : Void
	{
		CDebug.ASSERT( _Obj != null);
		CDebug.ASSERT( _Obj.m_Native != null);

		super.AddToScene( _Obj );
				
		for ( i_Child in 0 ... m_SceneAS.numChildren )
		{
			m_SceneAS.removeChildAt( 0 );
		}
		
		for ( i_Child in m_Scene )
		{
			m_SceneAS.addChild( cast ( i_Child.m_Native, DisplayObject ) );
		}
	}
	
	private function AddToSceneAS( _DisplayObj : DisplayObject )
	{
		m_SceneAS.addChild( _DisplayObj );
	}
	
	private function RemoveFromSceneAS( _DisplayObj : DisplayObject )
	{
		if (m_SceneAS.contains( _DisplayObj ) )
		{
			m_SceneAS.removeChild( _DisplayObj );
		}
	}
}