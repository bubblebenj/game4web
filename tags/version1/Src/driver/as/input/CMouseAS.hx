package driver.as.input;

/**
 * ...
 * @author bdubois
 */

import flash.events.MouseEvent;
import flash.events.Event;
import flash.Lib;
import math.CV2D;
import input.CMouse;
import kernel.CDebug;

class CMouseAS extends CMouse
{
	public function new()
	{
		super();
		m_Out		= true;
		flash.Lib.current.stage.addEventListener( MouseEvent.MOUSE_DOWN,	Down );	//
		flash.Lib.current.stage.addEventListener( MouseEvent.MOUSE_UP, 		Up );	// To be change with one function handler onMouseEvent
		flash.Lib.current.stage.addEventListener( MouseEvent.MOUSE_MOVE, 	Move );	//
		// Oddly it's not a MouseEvent
		flash.Lib.current.stage.addEventListener( Event.MOUSE_LEAVE, 		Out );
		/* The following line doesn't work. Use MOUSE_MOVE instead
		 * flash.Lib.current.stage.addEventListener( MouseEvent.MOUSE_OVER, 	In );*/
		CDebug.CONSOLEMSG("Created Mouse");
	}

	private function Down( _Event : MouseEvent ) : Void
	{
		m_Down		= true;
		m_Coordinate.Set( Lib.current.stage.mouseX, Lib.current.stage.mouseY );
	}
	
	private function Up	( _Event : MouseEvent ) : Void
	{
		m_Down		= false;
		m_Coordinate.Set( Lib.current.stage.mouseX, Lib.current.stage.mouseY );
	}
	
	private function Move( _Event : MouseEvent ) : Void
	{
		m_Coordinate.Set( Lib.current.stage.mouseX, Lib.current.stage.mouseY );
		m_Out		= false;
	}
	
	private function Out( _Event : Event )	 : Void
	{
		m_Out		= true;
	}
}