/**
 * ...
 * @author BDubois
 */

package driver.as.rsc;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.events.Event;
import flash.events.IOErrorEvent;
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
		m_ImgLoader	= new Loader();
		m_State			= INVALID;
	}
	
	public function Initialize() : Result
	{
		//init is fired earlier
		m_ImgLoader.contentLoaderInfo.addEventListener(Event.INIT, onLoaded);
		m_ImgLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOError );
		m_ImgLoader.load( new URLRequest( m_Path ) );
		m_State			= STREAMING;
		return SUCCESS;
	}
		
	public override function SetPath( _Path )
	{
		super.SetPath(_Path);
		Initialize();
	}
	
	public function onIOError( _Event : Event )	: Void
	{
		m_ImgLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
		
		m_State			= INVALID;
		CDebug.CONSOLEMSG("Img failed to load " + m_Path);
	}
	
	public function onLoaded( _Event : Event )	: Void
	{
		m_ImgLoader.contentLoaderInfo.removeEventListener(Event.INIT, onLoaded);

		m_State			= STREAMED;
		CDebug.CONSOLEMSG("Img loaded " + m_Path);
	}
	
	public function GetBitmapData() : BitmapData
	{
		if  ( m_State == STREAMED )
		{
			return cast( m_ImgLoader.content, Bitmap ).bitmapData;
		}
		else
		{
			return null;
		}
	}
	
	
	public override function GetDriverImage() : Dynamic
	{
		return GetBitmapData();
	}
	
	private	var m_ImgLoader	: Loader;
}