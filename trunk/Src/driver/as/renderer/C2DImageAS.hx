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
		trace( "new ImageAS" );
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
		trace( "\t \t [ -- C2DImage.Load( " + _PathToImg );
		super.Load( _PathToImg );
		// Loading
		// 2 - url of the image or swf to load
		var l_ImgURL	: URLRequest	= new URLRequest( m_PathToImg );
		// 3 - Loading of the image or swf inside the container
		m_ImgContainer.load( l_ImgURL );
		trace ( "\t \t CEntity.Load -- ] ");
	}
	
	public function onImgLoaded( _Event : Event )	: Void
	{
		trace ( "\t \t [ -- C2DImage.onImgLoaded( " + _Event );
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
		var l_Bitmap : Bitmap = cast ( m_ImgContainer.content );
		m_2DQuadAS.SetDisplayObject( l_Bitmap );
		
		trace ( "Scale X : " + m_2DQuadAS.GetDisplayObject().scaleX +" Scale Y : " 	+ m_2DQuadAS.GetDisplayObject().scaleY );
		trace ( "Width : " + m_2DQuadAS.GetDisplayObject().width +" Height : " 	+ m_2DQuadAS.GetDisplayObject().height );

		// 5 - Then image can be scale to the size of the container (C2DQuad)
		SetSize( m_SrcSize );
		trace ( "\t \t CEntity.onImgLoaded -- ] ");
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
			trace ( "\t \t [ -- C2DImageAS.SetSize ( " + _Size.x + " " + _Size.y );
		m_2DQuadAS.SetSize( _Size );
			trace ( "\t \t C2DImageAS.SetSize -- ] ");
	}
}