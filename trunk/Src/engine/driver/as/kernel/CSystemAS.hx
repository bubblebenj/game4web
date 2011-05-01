package driver.as.kernel;

/**
 * ...
 * @author BDubois
 */

import flash.utils.Timer;
import CDebug;
import kernel.CInputManager;
import kernel.CSystem;
import CTypes;
import input.CMouse;

import input.CKeyboard;
import renderer.camera.C2DCamera;

import rsc.CRscImage;
import rsc.CRscText;

import driver.as.renderer.CRendererAS;
import driver.as.rscbuilders.CRscASFactory;

class CSystemAS extends CSystem
{
	private	var m_RscASFactory	: CRscASFactory;
	
	public var m_FlashTimer : Timer;
	public var m_PreviousTimer : Int;
	
	public function new()
	{
		super();
		m_PreviousTimer = flash.Lib.getTimer();
	}
	
	public override function GetDriverDt() : Float
	{
		var l_NewTimeMillis = flash.Lib.getTimer();
		var l_Dt = ((cast(l_NewTimeMillis,Float)) - (cast(m_PreviousTimer,Float)))  / 1000.0;
		m_PreviousTimer = l_NewTimeMillis;
		return l_Dt;
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
		
		//trace("Init OK");
		return SUCCESS;
	}
	
	// Binding type with its factory
	public override function InitializeRscBuilders() : Result
	{
		//CDebug.CONSOLEMSG("Builders created");
		GetRscMan().AddBuilder( CRscImage.RSC_ID, 	m_RscASFactory );//new CRscASFactory() );
		GetRscMan().AddBuilder( CRscText.RSC_ID, 	m_RscASFactory );//new CRscASFactory() );
		GetRscMan().AddBuilder( CMouse.RSC_ID, 		m_RscASFactory );//new CRscASFactory() );
		GetRscMan().AddBuilder( CKeyboard.RSC_ID, 	m_RscASFactory );//new CRscASFactory() );

		return SUCCESS;
	}
	
	
}