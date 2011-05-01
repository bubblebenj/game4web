package;

class CDebug
{
	//please oh mighty god of compilers do yar job
	#if debug
	public static function ASSERT( _Obj : Bool, ?pos : haxe.PosInfos  )
	{
		if ( _Obj == false )//|| _Obj == null )
		{
			
			haxe.Log.trace( "Assert in " + pos.className + "::" + pos.methodName, pos );
			throw _Obj;
		}
	}
	#else
	public static inline function ASSERT( _Obj : Bool, ?pos : haxe.PosInfos  )
	{
		
	}
	#end
	
	#if debug
	public static function BREAK( _Str : String, ?pos : haxe.PosInfos  )
	{
		if ( true )
		{
			#if debug
			haxe.Log.trace( "Break in " + pos.className + "::" + pos.methodName + ":" +  _Str, pos );
			throw _Str;
			#end
		}
	}
	#else
	public static inline function BREAK( _Str : String, ?pos : haxe.PosInfos  )
	{
	}
	#end
	
	#if debug
	public static function CONSOLEMSG( _Msg : String, ?pos : haxe.PosInfos  )
	{
		#if debug
		haxe.Log.trace( _Msg , pos);
		#end
	}
	#else
	public static inline function CONSOLEMSG( _Msg : String, ?pos : haxe.PosInfos  )
	{
	}
	#end
}