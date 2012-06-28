package;
import haxe.BaseCode;
import haxe.Stack;
import math.Utils;

class CDebug
{
	//please oh mighty god of compilers do yar job
	#if debug
	public static function ASSERT( _Obj : Bool, ?_Msg : String, ?pos : haxe.PosInfos  )
	{
		if ( _Obj == false )//|| _Obj == null )
		{
			
			CDebug.CONSOLEMSG( "Assert in " + pos.className + "::" + pos.methodName, pos );
			if ( _Msg != null )
			{
				CDebug.CONSOLEMSG( _Msg );
			}
			throw _Obj;
		}
	}
	#else
	public static inline function ASSERT( _Obj : Bool, ?_Msg : String, ?pos : haxe.PosInfos  )
	{
		
	}
	#end
	
	#if debug
	public static function BREAK( _Str : String, ?pos : haxe.PosInfos  )
	{
		if ( true )
		{
			CDebug.CONSOLEMSG( "Break in " + pos.className + "::" + pos.methodName + ":" +  _Str, pos );
			throw _Str;
		}
	}
	#else
	public static inline function BREAK( _Str : String, ?pos : haxe.PosInfos  )
	{
	}
	#end
	
	#if debug
	public static function ERRORMSG( _Error : Dynamic, ?pos : haxe.PosInfos  )
	{
		CDebug.CONSOLEMSG( "ERROR\n \"" + _Error + "\" " + haxe.Stack.toString( haxe.Stack.exceptionStack() ), pos );
	}
	#else
	public static inline function ERRORMSG( _Msg : String, ?pos : haxe.PosInfos  )
	{
	}
	#end
	
	
	#if debug
	public static function CONSOLEMSG( _Msg : String, ?pos : haxe.PosInfos  )
	{
		
		#if neko
			neko.Web.logMessage( pos.fileName +":"+pos.lineNumber+" : "+ _Msg );
		#else
			haxe.Log.trace( _Msg , pos);
		#end
	}
	#else
	public static inline function CONSOLEMSG( _Msg : String, ?pos : haxe.PosInfos  )
	{
	}
	#end
}