package kernel;

#if js
import driver.js.kernel.CSystemJS;
#end

import renderer.CRenderer;

class Glb
{
	#if js
		public static var g_SystemJS : CSystemJS = new CSystemJS();
		public static var g_System = g_SystemJS;
	#else
		public static var g_System : CSystem = new CSystem();
	#end
	
	public static inline function GetRenderer() : CRenderer
	{
		return g_System.GetRenderer();
	}
	
	public static inline function GetSystem() : CSystem
	{
		return g_System;
	}
		
	public static function StaticUpdate()
	{
		g_System.Update();
	}
}