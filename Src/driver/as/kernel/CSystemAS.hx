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
		
		m_Renderer	= new CRendererAS();
		trace ( Type.typeof( m_Renderer ) );
		m_Renderer.Initialize();
		
		GetRendererAS();
		
		trace("Init OK");
		return SUCCESS;
	}
	
	/* /!\  /!\  /!\  /!\  /!\  /!\  /!\  /!\  /!\  /!\  /!\  /!\  /!\ 
	 * 
	 * J'aurai bien surcharge la function de CSystem qui retourne un
	 * CRenderer mais elle est inline et de toute facon n'a pas les meme
	 * parametres en sortie.
	 * Je ne dois pas m'y prendre correctement.
	 * En attendant :
	 * 
	 * /!\  /!\  /!\  /!\  /!\  /!\  /!\  /!\  /!\  /!\  /!\  /!\  /!\ 
	 */
	public inline function GetRendererAS() : CRendererAS
	{
		trace ( Type.typeof( m_Renderer ) );
		return m_Renderer;
	}
}