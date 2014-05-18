package kernel;

import haxe.ds.GenericStack;
import tools.transition.CTween;
#if		js
	import driver.js.kernel.CSystemJS;
	import driver.js.renderer.CRendererJS;

#elseif	flash
	import driver.as.kernel.CSystemAS;
	import driver.as.renderer.CRendererAS;
#end

import renderer.CRenderer;

class Glb
{
	#if		js
		public static var g_SystemJS : CSystemJS = new CSystemJS();
		public static var g_System 	= g_SystemJS;
	#elseif flash
		public static var g_SystemAS : CSystemAS = new CSystemAS();
		public static var g_System 	= g_SystemAS;
	#else
		public static var g_System : CSystem = new CSystem();
	#end

	public static inline function GetRenderer() 	: CRenderer		{
		return g_System.GetRenderer();
	}

	public static inline function GetInputManager() : CInputManager	{
		return g_System.GetInputManager();
	}

	#if flash10
		public static inline function GetRendererAS() : CRendererAS		{
			return cast g_SystemAS.GetRenderer();
		}
	#elseif js
		public static inline function GetRendererJS() : CRendererJS		{
			return cast g_SystemJS.GetRenderer();
		}
	#end

	public static inline function GetSystem() 		: CSystem
	{
		return g_System;
	}

	public static function StaticUpdate()	: Void
	{
		g_System.Update();
	}
}