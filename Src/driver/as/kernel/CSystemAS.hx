package driver.as.kernel;

/**
 * ...
 * @author BDubois
 */

import kernel.CDebug;
import kernel.CSystem;
import kernel.CTypes;

import rsc.CRscImage;

import driver.as.renderer.CRendererAS;
import driver.as.rscbuilders.CRscASFactory;

class CSystemAS extends CSystem
{
	public	var m_Mouse			: CMouseAS; // <-- Normalement dans input manager lui même dans kernel.CSystem
	private	var m_RscASFactory	: CRscASFactory;
	
	public function new()
	{
		super();
		m_Mouse = new CMouseAS();
	}
	
	public override function Initialize() : Result
	{
		super.Initialize();
		
		m_Renderer	= new CRendererAS();
		
		m_Renderer.Initialize();
		
		m_RscASFactory = new CRscASFactory();
		InitializeRscBuilders();
		
		CDebug.ASSERT(m_Display != null );
		
		/* /!\ in the flash API the stage is the viewport,
		 * not the whole area size */
		m_Display.m_Width	= flash.Lib.current.stage.stageWidth;
		m_Display.m_Height  = flash.Lib.current.stage.stageHeight;
		
		trace("Init OK");
		return SUCCESS;
	}
	
	// Binding type with its factory
	public function InitializeRscBuilders() : Result
	{
		CDebug.CONSOLEMSG("Builders created");
		GetRscMan().AddBuilder( CRscImage.RSC_ID, 	new CRscASFactory() );
		
		return SUCCESS;
	}
}