/**
 * ...
 * @author de
 */

package driver.js.renderer;

import kernel.CDebug;
import kernel.CSystem;

import rsc.CRsc;
import rsc.CRscImage;
import js.Dom;

class CRscImageJS extends CRscImage
{
	var m_Img : Image;
	
	public function new() 
	{
		super();
		m_Img = null;
	}
	
	public override function SetPath( _Path : String )
	{
		super.SetPath(_Path);
		
		m_Img = untyped __js__("new Image()");
		m_Img.src = _Path;
		
		var l_functor = function( x ) 
		{ 
			return function(_) ( 
			{ 
				CDebug.CONSOLEMSG("Streamed image : " + _Path );
				x.m_State = E_STATE.STREAMED;  
			}
			);
		};
		
		m_State = E_STATE.STREAMING;
		m_Img.onload = l_functor(this);
	}
	
	public override function GetDriverImage() : Dynamic
	{
		return m_Img;
	}
	
}