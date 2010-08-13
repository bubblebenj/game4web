package driver.as.kernel;

/**
 * ...
 * @author BDubois
 */

import kernel.CSystem;
import kernel.CTypes;
import driver.as.renderer.CRendererAS;

class CSystemAS extends CSystem
{
	public var m_Mouse		: CMouseAS; // <-- Normalement dans input manager lui même dans kernel.CSystem
	
	public function new()
	{
		super();
		m_Mouse = new CMouseAS();
	}
	
	public override function Initialize() : Result
	{
		super.Initialize();
		
		m_Renderer = new CRendererAS();
		
		m_Renderer.Initialize();
		
		trace("Init OK");
		return SUCCESS;
	}

}