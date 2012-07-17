package kernel;

/**
 * ...
 * @author bd
 */

class StdEx 
{
	public static function time() : Float 
    { 
		#if neko 
			return neko.Sys.time(); 
		#elseif flash 
			return flash.Lib.getTimer() * 0.001; 
		#elseif js 
			return  Date.now().getTime()  * 0.001; 
		#end 
    }
}