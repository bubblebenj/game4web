/**
 * ...
 * @author Benjamin Dubois
 */

package kernel;

import kernel.CMouse;
import math.CV2D;
import math.Registers;
import renderer.camera.C2DCamera;
import renderer.CViewport;
import rsc.CRsc;
import rsc.CRscMan;

class CInputManager 
{
	private	var	m_Mouse			: CMouse;
	private var m_MouseCoordinate	( GetMousePosition, null ) : CV2D;
	
	public function new() 
	{
		var l_RscMan : CRscMan = Glb.g_System.GetRscMan();
		
		m_MouseCoordinate = new CV2D( 0, 0 );
		m_Mouse = cast( l_RscMan.Load( CMouse.RSC_ID , "mouse" ) );
	}
	
	public function GetMousePosition() : CV2D
	{
		m_MouseCoordinate.Copy( m_Mouse.m_Coordinate );
		m_MouseCoordinate.x /= Glb.GetSystem().m_Display.m_Height; // for ratio 1:1 Glb.GetSystem().m_Display.m_Width;
		m_MouseCoordinate.y /= Glb.GetSystem().m_Display.m_Height;
		return m_MouseCoordinate;
	}
	
	public function IsMouseDown() : Bool
	{
		return m_Mouse.m_Down;
	}
	
	public function IsMouseOut()	: Bool
	{
		return m_Mouse.m_Out;
	}
}