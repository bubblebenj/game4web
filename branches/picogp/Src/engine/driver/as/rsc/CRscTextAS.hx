/**
 * ...
 * @author Benjamin Dubois
 */

package driver.as.rsc;

import flash.events.Event;
import flash.net.URLLoader;
import flash.text.TextField;
import flash.net.URLRequest;

import CTypes;
import remotedata.IRemoteData;
import rsc.CRsc;
import rsc.CRscText;


class CRscTextAS extends CRscText
{
	public function new() 
	{
		super();
		m_TextLoader	= new URLLoader();
		m_state			= REMOTE;
	}
	
	public function Initialize() : Result
	{
		m_TextLoader.addEventListener(Event.COMPLETE, onLoaded);
		m_TextLoader.load( new URLRequest( m_Path ) );
		m_state			= SYNCING;
		return SUCCESS;
	}
	
	public override function SetPath( _Path )
	{
		super.SetPath(_Path);
		Initialize();
	}
	
	public function onLoaded( _Event : Event )	: Void
	{
		m_state			= READY;
		//CDebug.CONSOLEMSG("Img loaded " + m_Path);
	}
	
	public override function GetTextData() : String
	{
		if  ( m_state == READY )
		{
			return cast( m_TextLoader.data, String );
		}
		else
		{
			return null;
		}
	}
	
	private var  m_TextLoader	: URLLoader;
}