
package driver.as.renderer;

/**
 * ...
 * @author Benjamin Dubois
 */

import flash.display.MovieClip;
import flash.display.DisplayObject;
import kernel.CTypes;
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
		
		trace("CRendererAS::init");
		return SUCCESS;
	}
	
	public override function BuildViewport() : CViewport
	{
		// Needed. inherited function return null
		return new CViewportAS();
	}
	
	public function AddToSceneAS( _Obj : DisplayObject )
	{
		trace( Type.typeof( _Obj ));
		m_SceneAS.addChild( _Obj );
	}
	
	public function RemoveFromSceneAS( _Obj : DisplayObject )
	{
		m_SceneAS.removeChild( _Obj );
	}
}