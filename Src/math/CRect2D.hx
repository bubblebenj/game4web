/**
 * ...
 * @author de
 */

package math;

import math.CV2D;

class CRect2D 
{
	public function new() 
	{
		m_TL	= new CV2D(0,0);
		m_Size	= new CV2D(0,0);
	}

	public var m_TL		: CV2D;
	public var m_Size	: CV2D;	
}