package kernel;

/**
 * ...
 * @author bdubois
 */

import math.CV2D;
import rsc.CRsc;
import rsc.CRscMan;
 
/*
 * 
 * To mimic the behavior of the DS stylus that doesn't give 2D
 * vector information when stylus touch the screen :
 * Pointer information will only be taken will a valid trigger,
 * for instance mouse coordinate is taken only when left button triggered.
 * 
 */

class CMouse extends CRsc
{
	public static var 	RSC_ID = CRscMan.RSC_COUNT++;
	public override function GetType() : Int
	{
		return RSC_ID;
	}
		
	public var m_Coordinate		: CV2D;
	public var m_Down			: Bool;
	public var m_Out			: Bool; // True if the mouse in outside the game context
	
	public function new() 
	{
		super();
		m_Coordinate	= new CV2D( 0, 0 );
		Init();
	}
	
	private function Init() : Void	
	{
		m_Coordinate.Set( -1.0, -1.0 );
	}
}