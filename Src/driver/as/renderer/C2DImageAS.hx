/**
 * ...
 * @author Benjamin Dubois
 */

package driver.as.renderer;

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
	private	var m_ImgURL		: URLRequest;
	private var m_Bitmap		: Bitmap;
	
	public function new()
	{
		super();
		m_DisplayObject;// Sprite();
		m_ImgContainer		= new Loader();							// 1 - Creation of the loader
		m_ImgContainer.contentLoaderInfo.addEventListener(Event.INIT, onImgLoaded);
	}
	
	//Set the image of the Sprite
	public function Load( _PathToImg : String )	: Void
	{
		#if DebugInfo
			trace ("\t [ -- Load( PathToImg : " + _PathToImg + " )");
		#end	
		// Loading
		m_ImgURL				= new URLRequest( _PathToImg );		// 2 - url of the image or swf to load
		m_ImgContainer.load( m_ImgURL );							// 3 - Loading of the image or swf inside the container
	}
	
	public function onImgLoaded( _Event : Event )	: Void
	{
		m_SrcSize =	new CV2D( m_ImgContainer.content.width, m_ImgContainer.content.height);
		
		// Seems that only point 1 4 and 5 are necessary to get a correctly scalable image
		
		// Cheat to have a scalable sprite
		// 1 - The sprite (flash.display.Sprite) must be empty - no graphics inside so the width and height are "not defined"
		/*					
			// 2 - get the larger side of the picture
			var	l_ImgLargerSide	: Float	= ( m_Size.x > m_Size.y ) ? m_Size.x : m_Size.y;
					//
			// 3 - Draw a square with side = larger side of the picture
			// This will initialise the with and height of the sprite so it can be scalable
			// width	= l_ImgLargerSide;	height	= l_ImgLargerSide;
			m_Sprite.graphics.beginFill( 0x0000CC, 0.1 ); // 0x0000CC, 0 );	
			m_Sprite.graphics.lineStyle( 0, 0xCC0000, 0 );			
			m_Sprite.graphics.drawRect( 0, 0, l_ImgLargerSide, l_ImgLargerSide);		
			m_Sprite.graphics.endFill();
		*/
					
		// 4 - before scaling, attach the image to the sprite
		// its must perfectly fit inside without scaling because of width = l_ImgLargerSide and height	= l_ImgLargerSide;
		
		// Cheat to cast to a bitmap
		m_Bitmap = cast ( m_ImgContainer.content );
		m_DisplayObject	= m_Bitmap;
		
		//Glb.GetRendererAS().AddToSceneAS( m_DisplayObject );
		//m_DisplayObject.addChildAt( m_ImgContainer, 0 );
		
		trace ( "Scale X : " + m_DisplayObject.scaleX +" Scale Y : " 	+ m_DisplayObject.scaleY );
		trace ( "Width : " + m_DisplayObject.width +" Height : " 	+ m_DisplayObject.height );

		// 5 - Then image can be scale to the size of the container (C2DQuad)
		FillQuad();
	}
	
	private override function FillQuad() : Result
	{
		super.FillQuad();
		m_DisplayObject.width	= m_Rect.m_BR.x - m_Rect.m_TL.x;
		m_DisplayObject.height	= m_Rect.m_BR.y - m_Rect.m_TL.y;
		return SUCCESS;
	}
}