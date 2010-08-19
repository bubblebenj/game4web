/**
 * ...
 * @author BDubois
 */

package driver.as.rsc;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.events.Event;
import flash.display.Loader;
import flash.net.URLRequest;
import math.CV2D;

import kernel.CTypes;
import kernel.CDebug;
import rsc.CRscImage;
import rsc.CRsc;

class CRscImageAS extends CRscImage
{
	public function new() 
	{
		super();
		m_ImgContainer	= new Loader();
		m_State			= INVALID;
	}
	
	public function Initialize() : Result
	{
		// 1 - Creation of the loader
		m_ImgContainer.contentLoaderInfo.addEventListener(Event.INIT, onImgLoaded);
		// Loading
		// 2 - url of the image or swf to load
		var l_ImgURL	: URLRequest	= new URLRequest( m_Path );
		// 3 - Loading of the image or swf inside the container
		//CDebug.CONSOLEMSG("Initializing img" + m_Path);
		m_ImgContainer.load( l_ImgURL );
		m_State			= STREAMING;
		return SUCCESS;
	}
		
	public override function SetPath( _Path )
	{
		super.SetPath(_Path);
		Initialize();
	}
	
	public function onImgLoaded( _Event : Event )	: Void
	{
		m_State			= STREAMED;
		//CDebug.CONSOLEMSG("Img loaded " + m_Path);
	}
	
	public function CreateBitmap() : Bitmap
	{
		if ( m_State == STREAMED )
		{
			return new Bitmap( cast( m_ImgContainer.content , Bitmap ).bitmapData );
		}
		else
		{
			return null;
		}
	}
	
	private	var m_ImgContainer	: Loader;
}