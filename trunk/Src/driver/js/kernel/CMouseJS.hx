/**
 * ...
 * @author Benjamin Dubois
 */

package driver.js.kernel;
 
import js.Dom;

import math.CV2D;
import kernel.CMouse;
import kernel.Glb;
 
/*
 * 
 * To mimic the behavior of the DS stylus that doesn't give 2D
 * vector information when stylus touch the screen :
 * Pointer information will only be taken will a valid trigger,
 * for instance mouse coordinate is taken only when left button triggered.
 * 
 */

class CMouseJS extends CMouse
{
	public function new()
	{
		super();
		
		// You probably need to replace "js.Lib.document" like
		//	Glb.g_System.???????????.onmousedown = Down;
		m_Context	= js.Lib.document.getElementById( "FinalRenderTarget" );
		
		m_Context.onmousedown = Down;
		m_Context.onmousedown = Up;
		m_Context.onmousemove = Move;
	}

	private function Down( _Event : js.Event )
	{
		this.m_Down				= true;
	}
	
	private function Up	( _Event : js.Event )
	{
		m_Down				= false;
	}
	
	private function Move( _Event : js.Event )
	{
		/* I dont know if there's a way to get directly mouse coordinate in the
		 * relative object (the scene) */
		m_Coordinate.Set( (_Event.clientX - m_Context.offsetLeft) , (_Event.clientY - m_Context.offsetTop) );
	}
	
	// je sais c'est mal mais tellement moins chiant a minipuler
	private var m_Context	: HtmlDom;
}