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
	private	var	m_Mouse			: CMouse;
	private var m_MouseCoordinate	( GetMousePosition, null ) : CV2D;
	
	private	var	m_Keyboard			: CKeyboard;
	
	public function new() 
	{
		var l_RscMan : CRscMan = Glb.g_System.GetRscMan();
		
		m_MouseCoordinate = new CV2D( 0, 0 );
		m_Mouse = cast( l_RscMan.Load( CMouse.RSC_ID , "mouse" ) );
		
		m_Keyboard = cast( l_RscMan.Create( CKeyboard.RSC_ID ) );

	}
	
	public inline function GetMouse()
	{
		return m_Mouse;
	}
	
	public inline function GetKeyboard()
	{
		return m_Keyboard;
	}
	
	public function GetMousePosition() : CV2D
	{
		if (null == m_Mouse)
		{
			return null;
		}
		m_MouseCoordinate.Copy( m_Mouse.m_Coordinate );
		m_MouseCoordinate.x /= Glb.GetSystem().m_Display.m_Height; // for ratio 1:1 Glb.GetSystem().m_Display.m_Width;
		m_MouseCoordinate.y /= Glb.GetSystem().m_Display.m_Height;
		return m_MouseCoordinate;
	}
	
	public inline function IsMouseDown() : Bool
	{
		return m_Mouse.m_Down;
	}
	
	public inline function IsMouseOut()	: Bool
	{
		return m_Mouse.m_Out;
	}
	
	public inline function Update()
	{
		if(null!=m_Keyboard)
		{
			m_Keyboard.Update();
		}
	}
}