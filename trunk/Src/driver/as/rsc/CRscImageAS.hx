/**
 * ...
 * @author BDubois
 */

package driver.as.rsc;

import flash.display.Bitmap;
import flash.display.Loader;
import flash.events.Event;
import math.CV2D;

import kernel.CTypes;
import rsc.CRscImage;

class CRscImageAS extends CRscImage
{
	public	var	m_FlashImage		: Bitmap;
	
	public function new() 
	{
		super();
		m_ImgContainer		= new Loader();
		m_State				= INVALID;
	}
	
	public function Initialize() : Result
	{
		// 1 - Creation of the loader
		m_ImgContainer.contentLoaderInfo.addEventListener(Event.INIT, onImgLoaded);
		// Loading
		// 2 - url of the image or swf to load
		var l_ImgURL	: URLRequest	= new URLRequest( m_Path );
		// 3 - Loading of the image or swf inside the container
		m_ImgContainer.load( l_ImgURL );
		m_State			= STREAMING;
	}
	
	public function onImgLoaded( _Event : Event )	: Void
	{
		// The chocolate in the paper.
		m_FlashImage	= cast ( m_ImgContainer.content );
		m_State			= STREAMED;
	}
	
	public function GetSize()	: CV2D
	{
		
		return new CV2D( m_FlashImage.content.width, m_FlashImage.content.width );
	}
	
	private	var m_ImgContainer	: Loader;
}