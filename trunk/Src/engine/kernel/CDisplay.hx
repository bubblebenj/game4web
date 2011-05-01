/**
 * ...
 * @author de
 */

package kernel;

class CDisplay
{

	public function new() 
	{
		m_Width = 0;
		m_Height = 0;
	}
	
	public var m_Width : Float;
	public var m_Height  : Float;
	
	public function GetAspectRatio() : Float
	{
		if ( m_Height != 0 )
		{
			return m_Width / m_Height;
		}
		else
		{
			return Math.NaN;
		}
	}
}