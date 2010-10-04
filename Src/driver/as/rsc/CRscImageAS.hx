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
		m_ImgLoader	= new Loader();
		m_State			= INVALID;
	}
	
	public function Initialize() : Result
	{
		m_ImgLoader.contentLoaderInfo.addEventListener(Event.INIT, onLoaded);
		m_ImgLoader.load( new URLRequest( m_Path ) );
		m_State			= STREAMING;
		return SUCCESS;
	}
		
	public override function SetPath( _Path )
	{
		super.SetPath(_Path);
		Initialize();
	}
	
	public function onLoaded( _Event : Event )	: Void
	{
		m_State			= STREAMED;
		//CDebug.CONSOLEMSG("Img loaded " + m_Path);
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
	
	private	var m_ImgLoader	: Loader;
}