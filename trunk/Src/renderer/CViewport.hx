/**
 * ...
 * @author de
 */

package renderer;

import kernel.CTypes;

import rsc.CRsc;
import rsc.CRscMan;

class CViewport extends CRsc 
{
	public static var 	RSC_ID = CRscMan.RSC_COUNT++;
	
	public override function GetType() : Int
	{
		return RSC_ID;
	}
	
	public function new( ) 
	{
		m_x = 0;
		m_y = 0;
		m_h = 0;
		m_w = 0;
		
		m_VpRatio = 1;
		super();
	}
	
	public function Initialize( _x, _y , _h, _w) 
	{
		m_x = _x;
		m_y = _y;
		m_h = _h;
		m_w = _w;
	}
	
	public function Activate() : Result 
	{
		return SUCCESS;
	}
	
	public function ComputeRatio()
	{
		m_VpRatio = 1;
	}
	
	public inline function GetVpRatio() : Float
	{
		return m_VpRatio;
	}
	
	public var m_x: Float;
	public var m_y: Float;
	public var m_h: Float;
	public var m_w: Float;
	
	public var m_VpRatio : Float;
}