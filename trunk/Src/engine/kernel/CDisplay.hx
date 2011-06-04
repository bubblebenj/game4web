/**
 * ...
 * @author de
 */

package kernel;

class CDisplay
{
	public var m_Width	: Int;
	public var m_Height	: Int;

	public function new() 
	{
		m_Width		= 0;
		m_Height	= 0;
	}
	
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