/**
 * ...
 * @author Benjamin Dubois
 */

package driver.as.rsc;

import kernel.CTypes;

import rsc.CRsc;
import rsc.CRscText;


class CRscTextAS extends CRscText
{
	var m_Text	: String;	// <-- ca va peut-etre etre un peu ridicule de faire une classe pour ca...
	
	public function new() 
	{
		super();
		m_State	= INVALID;
	}
	
	public function Initialize() : Result
	{
		// bidon
		SetText( m_Path );
		return SUCCESS;
	}
	
	public override function SetPath( _Path )
	{
		super.SetPath(_Path);
		Initialize();
	}
	
	public function SetText( _Text : String ) : Void
	{
		m_Text	= _Text;
		m_State	= STREAMED;
	}
	
	public function GetText() : String
	{
		if ( m_State == STREAMED )
		{
			return m_Text;
		}
		else
		{
			return null;
		}
	}
	
	public function Load( _Path : String )
	{
		m_State	= STREAMING;
		// loading stuff
		SetText( "function Load not implemented yet" );
	}
	
}