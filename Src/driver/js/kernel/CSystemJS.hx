package driver.js.kernel;

import driver.js.renderer.CRendererJS;
import driver.js.rsc.CRscFragmentShader;
import driver.js.rsc.CRscShaderProgram;
import driver.js.rsc.CRscVertexShader;
import driver.js.rscbuilders.CRscBuilderDocElem;
import driver.js.kernel.CTypesJS;
import driver.js.rscbuilders.CRscJSFactory;

import kernel.CSystem;
import kernel.CTypes;
import kernel.CDisplay;
import kernel.CDebug;
import kernel.Glb;

import renderer.CMaterial;
import renderer.CTexture;
import renderer.CRenderStates;
import renderer.CViewport;

import CGL;

class CSystemJS extends CSystem
{
	var m_GlObject : CGL;
	public function new()
	{
		super();
		m_GlObject = null;
		m_RscJSFactory = null;
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
	
	public function InitializeRscBuilders() : Result
	{
		CDebug.CONSOLEMSG("Builders created");
		GetRscMan().AddBuilder( CRscVertexShader.RSC_ID, 	new CRscBuilderDocElem() );
		GetRscMan().AddBuilder( CRscShaderProgram.RSC_ID, 	new CRscBuilderDocElem() );
		GetRscMan().AddBuilder( CRscPixelShader.RSC_ID,	 	new CRscBuilderDocElem() );
		
		GetRscMan().AddBuilder( CMaterial.RSC_ID, 	m_RscJSFactory );
		GetRscMan().AddBuilder( CTexture.RSC_ID, 	m_RscJSFactory );
		GetRscMan().AddBuilder( CViewport.RSC_ID, 	m_RscJSFactory );
		GetRscMan().AddBuilder( CRenderStates.RSC_ID, 	m_RscJSFactory );
		
		return SUCCESS;
	}
	
	var m_RscJSFactory : CRscJSFactory;
}