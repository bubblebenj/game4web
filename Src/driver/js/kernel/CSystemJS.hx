package driver.js.kernel;

import driver.js.renderer.CRendererJS;
import driver.js.rsc.CRscFragmentShader;
import driver.js.rsc.CRscShaderProgram;
import driver.js.rsc.CRscVertexShader;
import driver.js.rscbuilders.CRscBuilderDocElem;
import driver.js.kernel.CTypesJS;
import driver.js.rscbuilders.CRscJSFactory;


import kernel.CInputManager;

import input.CKeyboard;

import kernel.CSystem;
import kernel.CTypes;
import kernel.CDisplay;
import kernel.CDebug;
import kernel.Glb;
import kernel.CMouse;

import renderer.CMaterial;
import renderer.CRscTexture;
import renderer.CRenderStates;
import renderer.CViewport;
import renderer.CPrimitive;

import rsc.CRscImage;

import CGL;

class CSystemJS extends CSystem
{
	var m_GlObject : CGL;
	public function new()
	{
		super();
		m_GlObject = null;
		m_RscJSFactory = null;
		
		CDebug.CONSOLEMSG("JS system newed");
	}
	
	public inline function GetGL() : CGL
	{
		return m_GlObject;
	}

	public override function Initialize() : Result
	{
		super.Initialize();
		
		m_Renderer = new CRendererJS();
		m_Renderer.Initialize();
		
		InitializeGL();
		
		m_RscJSFactory = new CRscJSFactory();
		InitializeRscBuilders();
		
		m_InputManager	= new CInputManager();
		
		CDebug.CONSOLEMSG("JS system initialized");
		return SUCCESS;
	}
	
	public function InitializeGL() : Result
	{
		trace("CSystemJS::Getting GL context");	
		m_GlObject = new CGL("FinalRenderTarget");
		if ( m_GlObject != null )
		{
			trace("JS object created");
		}
		else 
		{
			trace("JS object creation failure");
		}
		
		trace("Hello World !");
		
		CDebug.ASSERT(m_Display != null );
		
		m_Display.m_Width  = Glb.g_SystemJS.GetGL().GetViewportWidth();
		m_Display.m_Height  = Glb.g_SystemJS.GetGL().GetViewportHeight();
		
		//TODO
		//Inspect();
		
		return SUCCESS;
	}

	public function Inspect() : Result
	{
		var l_Exts : Array<DOMString> = m_GlObject.GetSupportedExtensions();
		
		if( l_Exts != null)
		{
			for( l_Ext in l_Exts )
			{ 
				trace("Found Ext : " + l_Ext);
			}
			
			if( l_Exts.length == 0 )
			{
				trace("CSystemJS : found no exts! ");
			}
		}
		else 
		{
			trace("CSystemJS : no exts! ");
		}
		//object getExtension(DOMString name);

		return SUCCESS;
	}
	
	public override function InitializeRscBuilders() : Result
	{
		CDebug.CONSOLEMSG("Builders created");
		GetRscMan().AddBuilder( CRscVertexShader.RSC_ID, 	new CRscBuilderDocElem() );
		GetRscMan().AddBuilder( CRscShaderProgram.RSC_ID, 	new CRscBuilderDocElem() );
		GetRscMan().AddBuilder( CRscPixelShader.RSC_ID,	 	new CRscBuilderDocElem() );
		
		GetRscMan().AddBuilder( CMaterial.RSC_ID, 		m_RscJSFactory );
		GetRscMan().AddBuilder( CMouse.RSC_ID, 			m_RscJSFactory );
		GetRscMan().AddBuilder( CRscTexture.RSC_ID, 	m_RscJSFactory );
		GetRscMan().AddBuilder( CViewport.RSC_ID, 		m_RscJSFactory );
		GetRscMan().AddBuilder( CRenderStates.RSC_ID, 	m_RscJSFactory );
		GetRscMan().AddBuilder( CPrimitive.RSC_ID, 		m_RscJSFactory );
		GetRscMan().AddBuilder( CRscImage.RSC_ID, 		m_RscJSFactory );
		GetRscMan().AddBuilder( CKeyboard.RSC_ID, 		m_RscJSFactory );
		
		return SUCCESS;
	}
	
	public override function Update() : Void
	{
		m_Display.m_Width  = Glb.g_SystemJS.GetGL().GetViewportWidth();
		m_Display.m_Height  = Glb.g_SystemJS.GetGL().GetViewportHeight();
		
		super.Update();
	}
	
	var 		m_RscJSFactory 	: CRscJSFactory;
}