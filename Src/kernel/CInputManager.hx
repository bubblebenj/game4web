/**
 * ...
 * @author Benjamin Dubois
 */

package kernel;

import math.CV2D;
import math.Registers;

import kernel.CMouse;
import input.CKeyboard;

import renderer.camera.C2DCamera;
import renderer.CViewport;

import rsc.CRsc;
import rsc.CRscMan;

class CInputManager 
{
	private	var	m_Mouse		: CMouse;
	private	var	m_Keyboard	: CKeyboard;
	
	public function new() 
	{
		var l_RscMan : CRscMan = Glb.g_System.GetRscMan();
		
		m_Mouse = cast( l_RscMan.Load( CMouse.RSC_ID , "mouse" ) );
		
		m_Keyboard = cast( l_RscMan.Create( CKeyboard.RSC_ID ) );

	}
	
	public inline function GetMouse() : CMouse
	{
		return m_Mouse;
	}
	
	public inline function GetKeyboard() : CKeyboard
	{
		return m_Keyboard;
	}
	
	public inline function Update()
	{
		if( m_Keyboard != null )
		{
			m_Keyboard.Update();
		}
	}
}