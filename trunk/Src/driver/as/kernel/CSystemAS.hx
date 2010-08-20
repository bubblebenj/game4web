package driver.as.kernel;

/**
 * ...
 * @author BDubois
 */

import kernel.CDebug;
import kernel.CInputManager;
import kernel.CSystem;
import kernel.CTypes;
import kernel.CMouse;

import rsc.CRscImage;

import driver.as.renderer.CRendererAS;
import driver.as.rscbuilders.CRscASFactory;

class CSystemAS extends CSystem
{
	private	var m_RscASFactory	: CRscASFactory;
	private var m_InputManager	: CInputManager;
	
	public function new()
	{
		super();
		//m_Mouse = new CMouseAS();
	}
	
	public override function Initialize() : Result
	{
		super.Initialize();
		
		m_Renderer	= new CRendererAS();
		m_Renderer.Initialize();
		
		m_RscASFactory = new CRscASFactory();
		InitializeRscBuilders();
		
		m_InputManager	= new CInputManager();
		
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
		GetRscMan().AddBuilder( CRscImage.RSC_ID, 	m_RscASFactory );//new CRscASFactory() );
		GetRscMan().AddBuilder( CMouse.RSC_ID, 		m_RscASFactory );//new CRscASFactory() );
		
		return SUCCESS;
	}
	
	public function GetMouse()	: CMouse
	{
		return m_InputManager.m_Mouse;
	}
}