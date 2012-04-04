package tools;
import math.Utils;

/**
 * ...
 * @author dubois benjamin
 */

class CTime 
{
	public static function PrintFormattedTime(	_Time		: Float )	: String
	{										var	_OutputStr				: String;
		var l_TempStr	: String	= "";
		var l_Time		: Float 	= _Time;
		_OutputStr					= "";
		
		var l_NbMinutes	: Int	= Utils.RoundNearest( Math.floor( l_Time / 60 ) );
		l_TempStr	= "" + l_NbMinutes;
		l_TempStr	= Utils.FillWithZero( l_TempStr, 2 );
		_OutputStr	+= l_TempStr;
		
		l_Time		-= l_NbMinutes * 60;
		var l_NbTSec	: Int	= Utils.RoundNearest( Math.floor( l_Time ) );
		l_TempStr	= "" + l_NbTSec;
		l_TempStr	= Utils.FillWithZero( l_TempStr, 2 );
		_OutputStr	+= ":" + l_TempStr;
		
		l_Time	-= l_NbTSec;
		var l_Ms		: Int	= Utils.RoundNearest( Math.floor( l_Time * 1000 ) );
		l_TempStr	= "" + l_Ms;
		l_TempStr	= Utils.FillWithZero( l_TempStr, 3 );
		_OutputStr	+= ":" + l_TempStr;
		
		//_OutputStr	=
		//_OutputStr	= Utils.FillWithZero ( l_NbMinutes + ":" + l_NbTSec + ":" + l_Ms;
		return _OutputStr;
	}
}