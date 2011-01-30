/**
 * ...
 * @author Benjamin Dubois
 */

package renderer.camera;

import math.CV2D;

import rsc.CRsc;
import rsc.CRscMan;
import kernel.Glb;

class C2DCamera
{	
	public var m_Coordinate : CV2D;
	public var m_Scale		: Float;
	public var m_Name		: String;
	
	public function new() 
	{
		m_Coordinate	= new CV2D( 0, 0 );
		m_Scale			= 1.0;
	}
	
	public function SetPosition( _Pos : CV2D ) : Void
	{
		m_Coordinate.Copy( _Pos );
	}
	
	public function SetScale( _Value : Float ) : Void
	{
		m_Scale = _Value;
	}
	
	public function GetProjectionPoint( _V2D : CV2D ) : CV2D
	{
		var l_V2D	= CV2D.NewCopy( _V2D );
		CV2D.Sub(	l_V2D, l_V2D, m_Coordinate );
		CV2D.Scale( l_V2D, m_Scale,	l_V2D );
		return l_V2D;
	}
	
	public function GetWorldPosition( _V2D : CV2D ) : CV2D
	{
		var l_V2D	= CV2D.NewCopy( _V2D );
		CV2D.Scale( l_V2D, 1 / m_Scale,	l_V2D );
		CV2D.Add(	l_V2D, l_V2D, m_Coordinate );
		return l_V2D;
	}
}