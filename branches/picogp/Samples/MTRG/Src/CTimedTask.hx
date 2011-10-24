/****************************************************
 * MTRG : Motion-Twin recruitment game
 * A game by David Elahee
 * 
 * MTRG is a Space Invader RTS, the goal is to protect your mothership from
 * the random AI that shoots on it.
 * 
 * Powered by Game4Web a cross-platform engine by David Elahee & Benjamin Dubois.
 * 
	Copyright (C) 2011  David Elahee

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses
	
 * @author de
 ****************************************************/



 /* I don't know tweens well enough... it takes less time to do nearly the same by now and i hear it s*cks
  * */
package ;
import kernel.Glb;

////////////////////////////////////////////////////////////
class CTimedTask 
{
	//takes a 0 ... 1 float 
	var m_OnTick : Float -> Void;
	var m_Duration : Float;
	var m_Delay : Float;
	var m_QueuedDate : Float;
	
	
	////////////////////////////////////////////////////////////
	public function new( _OnTick, _Duration : Float, _Delay : Float ) 
	{
		m_OnTick = _OnTick;
		m_Duration = _Duration;
		m_Delay = _Delay;
		m_QueuedDate = Glb.GetSystem().GetGameTime();
	}
	
	////////////////////////////////////////////////////////////
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
		if (l_CurrentT> (m_Delay+ m_QueuedDate))
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