/**
 * ...
 * @author Benjamin Dubois
 */

package renderer.camera;

import math.CV2D;

import CDebug;

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
	
	public function GetProjectionPoint( _WorldV2D : CV2D, _PointOut : CV2D ) : Void
	{
		CDebug.ASSERT( true );
	}
	
	public function GetWorldPosition( _CameraV2D : CV2D, _PointOut : CV2D ) : Void
	{
		CDebug.ASSERT( true );
	}
}