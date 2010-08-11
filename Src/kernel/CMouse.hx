package kernel;

/**
 * ...
 * @author bdubois
 */

import flash.events.MouseEvent;
import flash.Lib;
import math.CV2D;
 
/*
 * 
 * To mimic the behavior of the DS stylus that doesn't give 2D
 * vector information when stylus touch the screen :
 * Pointer information will only be taken will a valid trigger,
 * for instance mouse coordinate is taken only when left button triggered.
 * 
 */

class CMouse
{
	public var m_Coordinate		: CV2D;
	public var m_Down			: Bool;
	
	public function new()
	{
		m_Coordinate	= new CV2D( 0, 0 );
		Init();
	}
	
	private function Init() : Void	
	{
		m_Coordinate.Set( -1.0, -1.0 );
	}
}