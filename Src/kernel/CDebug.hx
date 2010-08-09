package kernel;

class CDebug
{
	public static function ASSERT( _Obj : Bool, ?pos : haxe.PosInfos  )
	{
		if ( !_Obj )
		{
			haxe.Log.trace( "Assert in "+pos.className+"::"+pos.methodName,pos );
		}
	}
	
	public static function CONSOLEMSG( _Msg : String, ?pos : haxe.PosInfos  )
	{
		trace( _Msg );
	}
}