/**
 * ...
 * @author Benjamin Dubois
 */

package driver.as.rsc;

import flash.text.TextField;
import kernel.CTypes;

import rsc.CRsc;
import rsc.CRscText;


class CRscTextAS extends CRscText
{
	public function new() 
	{
		super();
		m_State	= INVALID;
	}
	
	public override function SetPath( _Path )
	{
		super.SetPath(_Path);
		Initialize();
	}
	
	public function Initialize() : Result
	{
		m_State			= STREAMING;
		SetText( m_Path );
		return SUCCESS;
	}
	
	public function SetText( _Text : String ) : Void
	{
		m_Text	= _Text;
		m_State	= STREAMED;
	}
	
	public function CreateText() : TextField
	{
		if ( m_State == STREAMED )
		{
			var l_TxtField	: TextField = new TextField();
			l_TxtField.text	= m_Text;
			#if DebugInfo
				l_TxtField.border	= true;
			#end
			l_TxtField.selectable	= false;
			return l_TxtField;
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
	
	private	var m_Text	: String;
}