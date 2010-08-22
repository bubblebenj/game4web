package kernel.input.device;

/**
 * ...
 * @author bdubois
 */

import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.Lib;
import tools.CBitField;
import kernel.input.device.CKeyCode;
 
enum EDS_PAD
{
	EDS_PAD_BUTTON_L;		// L Button
	
	EDS_PAD_KEY_RIGHT;		//	+Control Pad Right key
	EDS_PAD_KEY_DOWN;		//	+Control Pad Down key
	EDS_PAD_KEY_UP;			//	+Control Pad Up	key
	EDS_PAD_KEY_LEFT;		//	+Control Pad Left key

	EDS_PAD_BUTTON_R;		//	R Button
	
	EDS_PAD_BUTTON_A;		//	A Button
	EDS_PAD_BUTTON_B;		//  B Button
	EDS_PAD_BUTTON_X;		//	X Button
	EDS_PAD_BUTTON_Y;		//	Y Button

	EDS_PAD_BUTTON_START;	//	START
	EDS_PAD_BUTTON_SELECT;	//	SELECT
}

class CRawPad 
{	
	
	public function new() 
	{
		//m_ButtonFlag = new CBitField( 12, false );
		BUTTON_L				= new CRawInputEvents();
		
		KEY_RIGHT				= new CRawInputEvents();
		KEY_DOWN				= new CRawInputEvents();
		KEY_UP					= new CRawInputEvents();
		KEY_LEFT				= new CRawInputEvents();

		BUTTON_R				= new CRawInputEvents();
		
		BUTTON_A				= new CRawInputEvents();
		BUTTON_B				= new CRawInputEvents();
		BUTTON_X				= new CRawInputEvents();
		BUTTON_Y				= new CRawInputEvents();

		BUTTON_START			= new CRawInputEvents();
		BUTTON_SELECT			= new CRawInputEvents();
	
		Lib.current.stage.addEventListener( KeyboardEvent.KEY_DOWN,	KeyDown );
		Lib.current.stage.addEventListener( KeyboardEvent.KEY_UP, 	KeyUp );
	}
	
	public function KeyCode2EDS_PAD( _KeyCode : Int ) : EDS_PAD
	{
		return switch( _KeyCode )
		{
			case CKeyCode.A			: EDS_PAD_BUTTON_L;
			                          
			case CKeyCode.D			: EDS_PAD_KEY_RIGHT;
			case CKeyCode.S			: EDS_PAD_KEY_DOWN;
			case CKeyCode.Z			: EDS_PAD_KEY_UP;
			case CKeyCode.Q			: EDS_PAD_KEY_LEFT;
			                          
			case CKeyCode.P			: EDS_PAD_BUTTON_R;
			                          
			case CKeyCode.M			: EDS_PAD_BUTTON_A;
			case CKeyCode.L			: EDS_PAD_BUTTON_B;
			case CKeyCode.O			: EDS_PAD_BUTTON_X;
			case CKeyCode.K			: EDS_PAD_BUTTON_Y;
			                          
			case CKeyCode.J			: EDS_PAD_BUTTON_START;
			case CKeyCode.N			: EDS_PAD_BUTTON_SELECT;
		}                             
	}
	
	public function EDS_PAD2FlagMask( _Button : EDS_PAD ) : TBinary
	{
		return switch( _Button )
		{
			case EDS_PAD_BUTTON_L		: CBitField.BitRank( 0 );
			
			case EDS_PAD_KEY_RIGHT		: CBitField.BitRank( 1 );
			case EDS_PAD_KEY_DOWN		: CBitField.BitRank( 2 );
			case EDS_PAD_KEY_UP			: CBitField.BitRank( 3 );
			case EDS_PAD_KEY_LEFT		: CBitField.BitRank( 4 );
			
			case EDS_PAD_BUTTON_R		: CBitField.BitRank( 5 );
			
			case EDS_PAD_BUTTON_A		: CBitField.BitRank( 6 );
			case EDS_PAD_BUTTON_B		: CBitField.BitRank( 7 );
			case EDS_PAD_BUTTON_X		: CBitField.BitRank( 8 );
			case EDS_PAD_BUTTON_Y		: CBitField.BitRank( 9 );
			
			case EDS_PAD_BUTTON_START	: CBitField.BitRank( 10 );
			case EDS_PAD_BUTTON_SELECT	: CBitField.BitRank( 11 );
		}
	}
	
	public function KeyCode2FlagMask( _KeyCode : Int ) : TBinary
	{
		return EDS_PAD2FlagMask( KeyCode2EDS_PAD( _KeyCode ) );
	}
	
	public function KeyDown( _Event : KeyboardEvent )	: Void
	{
		//m_ButtonFlag.SETFLAG( KeyCode2FlagMask ( _Event.keyCode ) );
		
		var l_Button	: EDS_PAD	= KeyCode2EDS_PAD( _Event.keyCode );                                
	}
	
	public function KeyUp( _Event : KeyboardEvent )		: Void
	{
		//m_ButtonFlag.CLEARFLAG( KeyCode2FlagMask ( _Event.keyCode ) );
		
		var l_Button	: EDS_PAD	= KeyCode2EDS_PAD( _Event.keyCode );                              
	}
}