package driver.as.kernel;

/**
 * ...
 * @author bdubois
 */

import flash.events.MouseEvent;
import flash.Lib;
import math.CV2D;
import kernel.CMouse;
 
/*
 * 
 * To mimic the behavior of the DS stylus that doesn't give 2D
 * vector information when stylus touch the screen :
 * Pointer information will only be taken will a valid trigger,
 * for instance mouse coordinate is taken only when left button triggered.
 * 
 */

class CMouseAS extends CMouse
{
	public function new()
	{
		super();
		flash.Lib.current.addEventListener( MouseEvent.MOUSE_DOWN,	Down );	//
		flash.Lib.current.addEventListener( MouseEvent.MOUSE_UP, 	Up );	// To be change with one function handler onMouseEvent
		flash.Lib.current.addEventListener( MouseEvent.MOUSE_MOVE, 	Move );	//
	}

	public function Down( _Event : MouseEvent ) : Void
	{
		m_Down				= true;
	}
	
	public function Up	( _Event : MouseEvent ) : Void
	{
		m_Down				= false;
	}
	
	public function Move( _Event : MouseEvent ) : Void
	{
		m_Coordinate.Set( Lib.current.stage.mouseX, Lib.current.stage.mouseY );
	}
}