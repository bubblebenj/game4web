/**
 * ...
 * @author de
 */

package driver.js.renderer;

import CDebug;
import kernel.CSystem;

import rsc.CRsc;
import rsc.CRscImage;
import js.Dom;

import remotedata.IRemoteData;

class CRscImageJS extends CRscImage
{
	var m_Img : Image;
	
	public function new() 
	{
		super();
		m_Img = null;
	}
	
	public override function SetPath( _Path : String ) : Void
	{
		super.SetPath(_Path);
		
		m_Img = untyped __js__("new Image()");
		m_Img.src = _Path;
		
		var me = this;
		var l_functor = 
			function(_)  
			{ 
				CDebug.CONSOLEMSG("Streamed image : " + _Path );
				me.m_state = READY;
				
			};
		
		m_state = SYNCING;
		m_Img.onload = l_functor;
		
	}
	
	public override function GetDriverImage() : Dynamic
	{
		return m_Img;
	}
	
}