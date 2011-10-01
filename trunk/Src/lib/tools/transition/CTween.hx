/**
 * ...
 * @author Benjamin Dubois
 */

package tools.transition;

import haxe.FastList;
import kernel.Glb;
//import feffects.Tween;

enum TWIN_STATE
{
	TW_STARTED;
	TW_PAUSED;
	TW_STOPPED;
	TW_FINISHED;
}

class CTween
{	
	public static var m_TweenList	: FastList<CTween> = new FastList<CTween>();
	
	public	var m_State				: TWIN_STATE;
	
	public	var m_Handler			: Dynamic -> Void;
	public	var	m_StartVal			: Dynamic;
	public	var m_EndValue			: Dynamic;
	public	var	m_Duration			: Int;
	public	var m_VariationCallback	: Int -> Dynamic -> Dynamic -> Int -> Dynamic;
	public	var m_EndFunction		: Void -> Dynamic;
	
	public function new( _Handler : Dynamic -> Void, _StartVal : Dynamic, _EndValue : Dynamic,
						_Duration : Int, _VariationFunction : Int -> Dynamic -> Dynamic -> Int -> Dynamic, ? _EndFunction : Void -> Dynamic ) 
	{
		m_Handler			= _Handler;
		m_StartVal			= _StartVal;
		m_EndValue			= _EndValue;
		m_Duration			= _Duration;
		m_VariationCallback	= _VariationFunction;
		m_EndFunction		= _EndFunction;
		InitCounter();
		
		Stop();
		m_TweenList.add( this );
	}
	
	//private var m_Obj				: Dynamic;
	//private var	m_Field				: String;

	
	private var m_FrameCounter		: Int;
	
	public inline function Start()
	{
		m_State	= TW_STARTED;
	}
	
	public inline function Stop()
	{
		m_State	= TW_STOPPED;
		InitCounter();
	}
	
	public inline function Pause()
	{
		m_State	= TW_PAUSED;
	}
	
	public inline function InitCounter()	: Void
	{
		m_FrameCounter	= 0;
	}
	
	public inline function GetValue( _Time : Int )	: Dynamic
	{
		return m_VariationCallback( _Time, m_StartVal, m_EndValue, m_Duration );
	}	
	
	public inline function GetCurrentTime()	: Int
	{
		return Math.floor( m_FrameCounter * Glb.GetSystem().GetDeltaTime() * 1000 );
	}
	
	public inline function GetCurrentValue()	: Dynamic
	{
		return GetValue( GetCurrentTime() );
	}
	
	public inline function IsFinished()		: Bool
	{
		return m_State == TW_FINISHED;
	}
	
	public inline function IsPlaying()		: Bool
	{
		return m_State == TW_STARTED;
	}
	
	public inline function SetEndFunction( _EndFunction : Void -> Dynamic )
	{
		m_EndFunction		= _EndFunction;
	}
	
	public inline function ContinueTo( _EndValue : Dynamic, _Duration : Int )
	{
		m_StartVal	= GetCurrentValue();
		InitCounter();
		m_Duration	= _Duration;
		m_EndValue	= _EndValue;
	}
	
	/* Go to the specified position [ms] (in ms) */
	public inline function Seek( _ms : Int ) : Void
	{
		m_FrameCounter = cast( _ms * Glb.GetSystem().GetFrameRate() * 0.001, Int );
	}
	
	public function Remove() : Void
	{
		m_TweenList.remove( this );
	}
	
	public function Update()
	{
		switch ( m_State )
		{
			case TW_STARTED :
			{
				m_FrameCounter++;
				//trace( GetCurrentTime() + " = " + m_FrameCounter + " * " + Glb.GetSystem().GetDeltaTime() * 1000 );
				var l_Value : Dynamic;
				
				if ( GetCurrentTime() < m_Duration )
				{
					l_Value = GetCurrentValue();
				}
				else	// Adjusting last value
				{
					m_State	= TW_FINISHED;
					l_Value = GetValue( m_Duration );
				}
				m_Handler( l_Value );
			}
			case TW_FINISHED :
			{
				if ( m_EndFunction != null )
				{
					m_EndFunction();
				}
				m_State = TW_STOPPED;
			}
			case TW_STOPPED :
			{
				Remove();
			}
			default :
			{
				
			}
		}
	}
}