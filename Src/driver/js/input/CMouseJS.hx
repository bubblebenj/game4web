/**
 * ...
 * @author Benjamin Dubois
 */

package driver.js.input;
 
import js.Dom;

import math.CV2D;
import kernel.CMouse;
import kernel.Glb;
 
class CMouseJS extends CMouse
{
	public function new()
	{
		super();
		
		// You probably need to replace "js.Lib.document" like
		//	Glb.g_System.???????????.onmousedown = Down;
		m_Context	= js.Lib.document.getElementById( "FinalRenderTarget" );
		m_Out		= true;
		m_Context.onmousedown	= Down;
		m_Context.onmousedown	= Up;
		m_Context.onmousemove	= Move;
		m_Context.onmouseout	= Out;
		m_Context.onmouseover	= In;
	}

	private function Down( _Event : js.Event )
	{
		m_Down		= true;
	}
	
	private function Up	( _Event : js.Event )
	{
		m_Down		= false;
	}
	
	private function Move( _Event : js.Event )
	{
		m_Coordinate.Set( _Event.clientX - m_Context.offsetLeft, _Event.clientY - m_Context.offsetTop );
	}
	
	private function Out( _Event : js.Event )	 : Void
	{
		m_Out		= true;
	}
	
	private function In( _Event : js.Event )	 : Void
	{
		m_Out		= false;
	}
	
	// je sais c'est mal mais tellement moins chiant a minipuler
	private var m_Context	: HtmlDom;
}