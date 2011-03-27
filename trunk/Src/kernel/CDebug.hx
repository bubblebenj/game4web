package kernel;

class CDebug
{
	public static function ASSERT( _Obj : Bool, ?pos : haxe.PosInfos  )
	{
		if ( _Obj == false )//|| _Obj == null )
		{
			#if debug
			haxe.Log.trace( "Assert in " + pos.className + "::" + pos.methodName, pos );
			#end
		}
	}
	
	public static function BREAK( _Str : String, ?pos : haxe.PosInfos  )
	{
		if ( true )
		{
			#if debug
			haxe.Log.trace( "Break in " + pos.className + "::" + pos.methodName + ":" +  _Str, pos );
			#end
		}
	}
	
	public static function CONSOLEMSG( _Msg : String, ?pos : haxe.PosInfos  )
	{
		#if debug
		haxe.Log.trace( _Msg , pos);
		#end
	}
}