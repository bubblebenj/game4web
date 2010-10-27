/**
 * ...
 * @author Benjamin Dubois
 */

package logic;
import math.CV2D;
import renderer.camera.C2DCamera;

class CView 
{
	var m_Camera		: C2DCamera;

	public function new() 
	{
		m_Camera	= new C2DCamera();
	}
	
	public function GetMousePosition() : CV2D
	{
		if ( m_Camera != null )
		{
			return Glb.GetInputManager().m_Mouse.m_Coordinate;
		}
		else
		{
			var l_ReturnValue : CV2D = new CV2D( 0, 0 );
			CV2D.Add( l_ReturnValue, Glb.GetInputManager().m_Mouse.m_Coordinate, m_Camera.m_Coordinate );
			return l_ReturnValue;
		}
	}
}