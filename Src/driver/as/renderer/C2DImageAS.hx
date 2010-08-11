/**
 * ...
 * @author Benjamin Dubois
 */

package driver.as.renderer;

import flash.events.Event;
import flash.display.Loader;
import flash.display.Sprite;
import flash.net.URLRequest;
import math.CV2D;
import renderer.C2DImage;

class C2DImageAS extends C2DImage
{
	private	var	m_Sprite		: Sprite;
	private	var m_ImgContainer	: Loader;
	private	var m_ImgURL		: URLRequest;
	
	public	var m_Size			: CV2D;
	
	public function new()
	{
		super();
		m_ImgContainer		= new Loader();							// 1 - Creation of the loader
		m_ImgContainer.contentLoaderInfo.addEventListener(Event.INIT, onImgLoaded);
	}

	public function onImgLoaded( _Event : Event )	: Void
	{
		var m_Size	: CV2D	= new CV2D( 0, 0 );
		m_Size.Set( m_ImgContainer.content.width, m_ImgContainer.content.height );
		
		#if CSprite
			trace ( "Sprite.m_Size [" + width + " | " + height + " ] should be [0|0]" );
		#end
		
		// Cheat to have a scalable sprite
		// 1 - The sprite (flash.display.Sprite) must be empty - no graphics inside so the width and height are "not defined"
		
		// 2 - get the larger side of the picture
		var	l_ImgLargerSide	: Float	= ( m_Size.x > m_Size.y ) ? m_Size.x : m_Size.y;
		
		// 3 - Draw a square with side = larger side of the picture
		// This will initialise the with and height of the sprite so it can be scalable
		// width	= l_ImgLargerSide;	height	= l_ImgLargerSide;
		m_Sprite.graphics.beginFill( 0x0000CC, 0 );				
		m_Sprite.graphics.lineStyle( 0, 0xCC0000, 0 );
		m_Sprite.graphics.drawRect( 0, 0, l_ImgLargerSide, l_ImgLargerSide);
		m_Sprite.graphics.endFill();
		
		// 4 - before scaling, attach the image to the sprite
		// its must perfectly fit inside without scaling because of width = l_ImgLargerSide and height	= l_ImgLargerSide;
		m_Sprite.addChildAt( m_ImgContainer, 0 );
		
		#if CSprite
			trace ( "Sprite.m_Size [" + m_Sprite.width + " | " + m_Sprite.height + " ]  should be [img_larger_side|img_larger_side]" );
		#end
		
		// 5 - Then image can be scale to the size of the container (C2DQuad)
		m_Sprite.width			= Math.abs( m_Rect.m_BR.x - m_Rect.m_TL.x );
		m_Sprite.height			= Math.abs( m_Rect.m_BR.y - m_Rect.m_TL.y );
	}
	
	//Set the image of the Sprite
	public function Load( _PathToImg : String )	: Void
	{
		#if CSprite
			//trace ("\t [ -- CSprite.SetSprite( PathToImg : " + _PathToImg + " )");
		#end
				
		// Loading
		m_ImgURL				= new URLRequest( _PathToImg );		// 2 - url of the image or swf to load
		m_ImgContainer.load( m_ImgURL );							// 3 - Loading of the image or swf inside the container
		
		#if CSprite
			//trace ( "Sprite.getChildAt( 0 ).size [" + getChildAt( 0 ).width + " | " + getChildAt( 0 ).height + " ]" );
			//trace ( "Sprite.getChildAt( 0 ).size [" + getChildAt( 0 ).scaleX + " | " + getChildAt( 0 ).scaleY + " ]" );
			//trace ( "Sprite.m_Size [" + width + " | " + height + " ]" );
		#end
	}
}