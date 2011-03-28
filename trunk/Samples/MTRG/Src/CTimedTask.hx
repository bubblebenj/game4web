/**
 * ...
 * @author de
 */

package ;
import kernel.Glb;

class CTimedTask 
{
	//takes a 0 ... 1 float 
	var m_OnTick : Float -> Void;
	var m_Duration : Float;
	var m_Delay : Float;
	var m_QueuedDate : Float;
	
	public function new( _OnTick, _Duration : Float, _Delay : Float ) 
	{
		m_OnTick = _OnTick;
		m_Duration = _Duration;
		m_Delay = _Delay;
		m_QueuedDate = Glb.GetSystem().GetGameTime();
	}
	
	public function Dispose()
	{
		m_OnTick = null;
		m_Duration = 0;
		m_Delay = 0;
		m_QueuedDate = 0;
	}
	
	///returns true if op is finished
	public function Update() : Bool
	{
		var l_CurrentT = Glb.GetSystem().GetGameTime();
		if (l_CurrentT>m_Delay)
		{
			var l_Ratio = ((l_CurrentT) - (m_QueuedDate + m_Delay)) / m_Duration;
			if( l_Ratio < 1.0)
			{
				m_OnTick( l_Ratio );
			}
			else
			{
				m_OnTick( 1.0 );
				return true;
			}
		}
		return false;
	}
	
}