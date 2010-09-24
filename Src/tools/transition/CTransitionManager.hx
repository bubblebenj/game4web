/**
 * ...
 * @author Benjamin Dubois
 */

package tools.transition;

import kernel.Glb;

class CTransitionManager
{
	public var m_TweenList	: Hash<CTween>;
	
	public function new()
	{
		m_TweenList = new Hash<CTween>();
	}
	
	public function AddTween( 	_Name : String,	_Handler : Dynamic -> Void, _StartVal : Dynamic, _EndValue : Dynamic,
								_Duration : Float, _VariationFunction : Float -> Dynamic -> Dynamic -> Float -> Dynamic )
	{
		var TweenExists : Bool = false;
		var l_Tween : CTween;
				
		if ( m_TweenList.exists( _Name ) )
		{
			trace( _Name );
			l_Tween	= m_TweenList.get( _Name );
			l_Tween.m_StartVal			= _StartVal;
			l_Tween.m_EndValue			= _EndValue;
			l_Tween.m_Duration			= _Duration;
			l_Tween.m_VariationCallback	= _VariationFunction;
			
			l_Tween.InitCounter();
		}
		else
		{	
			l_Tween	= new CTween( _Handler, _StartVal, _EndValue, _Duration, _VariationFunction );
			m_TweenList.set( _Name, l_Tween );
		}
	}
	
	public function RemoveTween( _Name ) : Void
	{
		m_TweenList.remove( _Name );
	}
	
	public function GetTween( _Name ) : CTween
	{
		return m_TweenList.get( _Name );
	}
	
	public function Start( _Name ) : Void
	{
		GetTween( _Name ).Start();
	}
	
	public function Stop( _Name ) : Void
	{
		GetTween( _Name ).Stop();
	}
	
	public function Pause( _Name ) : Void
	{
		GetTween( _Name ).Pause();
	}
	
	public inline function IsFinished( _Name )		: Bool
	{
		return GetTween( _Name ).m_State == TW_FINISHED;
	}
	
	public function Update() : Void
	{
		for ( i_Tween in m_TweenList )
		{
			i_Tween.Update();
		}
	}
}

enum TWIN_STATE
{
	TW_STARTED;
	TW_PAUSED;
	TW_STOPPED;
	TW_FINISHED;
}

class CTween
{
	public	var m_State				: TWIN_STATE;
	
	public	var m_Handler			: Dynamic -> Void;
	public	var	m_StartVal			: Dynamic;
	public	var m_EndValue			: Dynamic;
	public	var	m_Duration			: Float;
	public	var m_VariationCallback	: Float -> Dynamic -> Dynamic -> Float -> Dynamic;
	
	public function new( _Handler : Dynamic -> Void, _StartVal : Dynamic, _EndValue : Dynamic,
						_Duration : Float, _VariationFunction : Float -> Dynamic -> Dynamic -> Float -> Dynamic ) 
	{
		m_Handler			= _Handler;
		m_StartVal			= _StartVal;
		m_EndValue			= _EndValue;
		m_Duration			= _Duration;
		m_VariationCallback	= _VariationFunction;
		
		Stop();
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
	
	public function Update()
	{
		switch ( m_State )
		{
			case TW_STARTED :
			{
				m_FrameCounter++;
				var l_CurrentTime	: Float	= m_FrameCounter * Glb.GetSystem().GetDeltaTime() * 1000;
				trace( l_CurrentTime + " = " + m_FrameCounter + " * " + Glb.GetSystem().GetDeltaTime() * 1000 );
				var l_CurrentValue : Dynamic;
				
				if ( l_CurrentTime < m_Duration )
				{
					l_CurrentValue = m_VariationCallback( l_CurrentTime, m_StartVal, m_EndValue, m_Duration );
					//trace ( m_StartVal.ToString() +" " + m_EndValue.ToString() );
					//trace ( m_FrameCounter +" Interpolated " + l_CurrentValue.ToString() +" " + l_CurrentTime + " / "+m_Duration + "ms" );
				}
				else	// Adjusting last value
				{
					trace ( " Last value " );
					m_State	= TW_FINISHED;
					l_CurrentValue = m_VariationCallback( m_Duration, m_StartVal, m_EndValue, m_Duration );
				}
				m_Handler( l_CurrentValue );
				//trace( "1_bliblop" + m_Obj+" "+m_Field+" "+ l_CurrentValue );
				//if ( Reflect.isObject( l_CurrentValue ) )
				//{
					//Reflect.field( m_Obj, m_Field ).Copy( l_CurrentValue );	//!\ The field object needs a Copy property
				//}
				//else
				//{
					//Reflect.setField( m_Obj, m_Field, l_CurrentValue );		// The field is a primitive
				//}
				//trace( "2_bliblop" );
			}
			default :
			{
				
			}
		}
	}
}