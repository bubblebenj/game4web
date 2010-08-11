/**
 * ...
 * @author BDubois
 */

package Src.driver.as.kernel;
import kernel.CMouse;
import kernel.CSystem;

class CSystemAS extends CSystem
{
	public var m_Mouse						: CMouse; // <-- Normalement dans input manager lui même dans kernel.CSystem
	
	public function new() 
	{
		super();
		m_Mouse = new CMouse();
	}
	
}