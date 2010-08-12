
package driver.as.renderer;

/**
 * ...
 * @author Benjamin Dubois
 */

import flash.display.MovieClip;
import flash.display.Sprite;
import kernel.CTypes;
import renderer.CDrawObject;
import renderer.CRenderer;
import renderer.CViewport;

class CRendererAS extends CRenderer
{
	private var m_SwfRoot	: MovieClip;
	
	public function new() 
	{
		super();
		m_SwfRoot	=	flash.Lib.current;
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
	
	
	public override function AddToScene( _Obj : CDrawObject )
	{
		super.AddToScene( _Obj );
	}
	
	public override function RemoveFromScene(  _Obj : CDrawObject )
	{
		super.RemoveFromScene( _Obj );
	}
	
	public function AddToSwfRoot( _Obj : Sprite )
	{
		m_SwfRoot.AddChild( _Obj );
	}
	
	public function RemoveFromSwfRoot( _Obj : Sprite )
	{
		m_SwfRoot.AddChild( _Obj );
	}
}