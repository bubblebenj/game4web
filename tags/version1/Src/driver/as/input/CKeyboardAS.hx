/**
 * ...
 * @author bdubois
 */
package driver.as.input;

import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.Lib;

import kernel.CTypes;
import kernel.CDebug;
import input.CKeyboard;
 
class  CKeyboardAS extends CKeyboard
{	
	
	public function new() 
	{
		super();
		
		Lib.current.stage.addEventListener( KeyboardEvent.KEY_DOWN,	KeyDown );
	}
	
	public function KeyDown( _Event : KeyboardEvent )	: Void
	{
		m_UpArray.Set( _Event.keyCode, false);
		//CDebug.ASSERT( m_UpArray.Is(_Event.keyCode) == false);
		//CDebug.CONSOLEMSG("KeyboardEvent.KEY_DOWN :" + _Event.keyCode);   
		//CDebug.CONSOLEMSG(  m_UpArray.toString() );
	}
	
	/*
	public function KeyUp( _Event : KeyboardEvent )		: Void
	{                          
	}*/
}