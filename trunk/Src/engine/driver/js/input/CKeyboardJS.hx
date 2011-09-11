/**
 * ...
 * @author de
 */

package driver.js.input;

import js.Dom;

import CTypes;
import CDebug;
import input.CKeyboard;

class CKeyboardJS extends CKeyboard
{
	public function new() 
	{
		super();
		m_Context	= js.Lib.document.body;
		
		m_Context.onkeydown 	= OnDown;
		m_Context.onkeyup	 	= OnUp;
		
		if( null != m_Context)
		{
			CDebug.CONSOLEMSG("Created Keyboard JS" + m_Context);
		}
	}
	
	
	public function OnDown( _Evt : Event )
	{
		if ( IsKeyUp( _Evt.keyCode ) )
		{
			m_NbKeyDown++;
			m_UpArray.Set(_Evt.keyCode, false);
		}
		CDebug.CONSOLEMSG("OnDown :" +_Evt.keyCode);
	}
	
	
	public function OnUp(  _Evt : Event)
	{
		( m_NbKeyDown < 1 ) ? 0 : m_NbKeyDown--;
		m_UpArray.Set(_Evt.keyCode, true);
		CDebug.CONSOLEMSG("OnUp :" +_Evt.keyCode);
	}
	/*
	public function OnPress(  _Evt : Event)
	{
		CDebug.CONSOLEMSG("OnPress :" +_Evt.keyCode);
	}
	*/
	
	private var m_Context	: HtmlDom;
}