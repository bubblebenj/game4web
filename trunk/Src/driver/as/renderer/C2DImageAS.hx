/**
 * ...
 * @author Benjamin Dubois
 */

package driver.as.renderer;

import driver.as.renderer.C2DQuadAS;

import flash.display.Bitmap;
import flash.events.Event;
import flash.display.Loader;
import flash.net.URLRequest;

import kernel.CTypes;
import kernel.Glb;
import math.CV2D;
import renderer.C2DImage;

class C2DImageAS extends C2DImage
{
	private	var m_ImgContainer	: Loader;
	private var m_2DQuadAS		: C2DQuadAS;
	
	public function new()
	{
		super();
		m_2DQuadAS			= new C2DQuadAS();
		m_2DQuad			= m_2DQuadAS;
		
		// 1 - Creation of the loader
		m_ImgContainer		= new Loader();									
		m_ImgContainer.contentLoaderInfo.addEventListener(Event.INIT, onImgLoaded);
	}
	
	//Set the image of the Sprite
	public override function Load( _PathToImg : String )	: Void
	{
		//trace( "\t \t [ -- C2DImageAS.Loading( " + _PathToImg + " )...");
		super.Load( _PathToImg );
		// Loading
		// 2 - url of the image or swf to load
		var l_ImgURL	: URLRequest	= new URLRequest( m_PathToImg );
		// 3 - Loading of the image or swf inside the container
		m_ImgContainer.load( l_ImgURL );
	}
	
	public function onImgLoaded( _Event : Event )	: Void
	{
		m_SrcSize =	new CV2D( m_ImgContainer.content.width, m_ImgContainer.content.height);
		
		// Cheat to cast to a bitmap
		var l_Bitmap : Bitmap = cast ( m_ImgContainer.content );
		m_2DQuadAS.SetDisplayObject( l_Bitmap );
		
		// 5 - Then image can be scale to the size of the container (C2DQuad)
		SetSize( m_SrcSize );
		trace( "\t \t [ -- Image : " + m_PathToImg + " loaded. (x_Sz,y_Sz)=("+ m_2DQuadAS.GetDisplayObject().width +","+ m_2DQuadAS.GetDisplayObject().height+") (x_Rt,y_Rt)=("+ m_2DQuadAS.GetDisplayObject().scaleX +","+ m_2DQuadAS.GetDisplayObject().scaleY+")");
	}
	
	public override function SetVisible( _Vis : Bool ) : Void 
	{
		super.SetVisible( _Vis );
		m_2DQuadAS.SetVisible( _Vis );
	}
	
	public override function MoveTo( _Pos : CV2D ) : Void
	{
		m_2DQuadAS.MoveTo( _Pos );
	}
	
	// We suppose that the 2DQuad is already centered
	public override function SetSize( _Size : CV2D ) : Void
	{
		m_2DQuadAS.SetSize( _Size );
	}
}