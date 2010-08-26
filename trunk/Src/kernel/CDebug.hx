package kernel;

class CDebug
{
	public static function ASSERT( _Obj : Bool, ?pos : haxe.PosInfos  )
	{
		if ( _Obj == false ||  _Obj == null)
		{
			haxe.Log.trace( "Assert in "+pos.className+"::"+pos.methodName,pos );
		}
	}
	
	public static function BREAK( _Str : String, ?pos : haxe.PosInfos  )
	{
		if ( true )
		{
			haxe.Log.trace( "Break in "+pos.className+"::"+pos.methodName+":"+  _Str, pos );
		}
	}
	
	public static function CONSOLEMSG( _Msg : String, ?pos : haxe.PosInfos  )
	{
		trace( _Msg );
	}
}