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
	
	public function new()
	{
		super();
		m_ImgContainer		= new Loader();							// 1 - Creation of the loader
		m_ImgContainer.contentLoaderInfo.addEventListener(Event.INIT, onImgLoaded);
	}

	public function onImgLoaded( _Event : Event )	: Void
	{
		var l_ImgSize	: CV2D	= new CV2D( 0, 0 );
		l_ImgSize.Set( m_ImgContainer.content.width, m_ImgContainer.content.height );
		
		#if CSprite
			trace ( "Sprite.m_Size [" + width + " | " + height + " ] should be [0|0]" );
		#end
		
		// Cheat to have a scalable sprite
		// 1 - The sprite (flash.display.Sprite) must be empty - no graphics inside so the width and height are "not defined"
		
		// 2 - get the larger side of the picture
		var	l_ImgLargerSide	: Float	= ( l_ImgSize.x > l_ImgSize.y ) ? l_ImgSize.x : l_ImgSize.y;
		
		// 3 - Draw a square with side = larger side of the picture
		// This will initialise the with and height of the sprite so it can be scalable
		// width	= l_ImgLargerSide;	height	= l_ImgLargerSide;
		m_Sprite.graphics.beginFill( 0x0000CC, 0 );				
		m_Sprite.graphics.lineStyle( 0, 0xCC0000, 0 );
		m_Sprite.graphics.drawRect(0 , 0, l_ImgLargerSide, l_ImgLargerSide); 
		m_Sprite.graphics.endFill();
		
		// 4 - before scaling, attach the image to the sprite
		// its must perfectly fit inside without scaling because of width = l_ImgLargerSide and height	= l_ImgLargerSide;
		m_Sprite.addChildAt( m_ImgContainer, 0 );
		
		#if CSprite
			trace ( "Sprite.m_Size [" + width + " | " + height + " ]  should be [img_larger_side|img_larger_side]" );
		#end
		
		// 5 - Then scale to the size you whant
		m_Sprite.width			= m_Size.x * CGame.m_WorldUnit;		
		m_Sprite.height			= m_Size.y * CGame.m_WorldUnit;
		
		#if CSprite
			trace ( "Sprite.m_Size [" + width + " | " + height + " ]  should be [m_Size.x|m_Size.y]" );
		#end
	}
}