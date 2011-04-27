/**
 * ...
 * @author de
 */

package algorithms;

import kernel.CDebug;

class CBitArray 
{

	public function new( _i : Int ) 
	{
		m_Array = new Array<Int>();
		m_Array[_i] = 0;
	}
	
	public function Length( ) 
	{
		return m_Array.length * 31;
	}
	
	public function Fill( _Val : Bool)
	{
		for( i in 0...m_Array.length)
		{
			m_Array[i] = _Val ? 0xFFffFFff : 0;
		}
	}
	
	public function GetRaw() : Array<Int>
	{
		return m_Array;
	}
	
	public function Copy( _Arr : CBitArray )
	{
		for( i in 0...m_Array.length)
		{
			m_Array[i] = _Arr.GetRaw()[i];
		}
	}
	
	public function toString()
	{
		return m_Array.toString();
	}
	
	public function Set( _Index : Int , _Val : Bool )
	{
		var l_Index = Std.int(_Index / 31);
		var l_Offset = _Index%31;
		
		if ( _Val)
		{
			m_Array[ Std.int(_Index / 31) ] |= (1 << (_Index%31));
		}
		else
		{
			m_Array[ Std.int(_Index / 31)] &= ~(1 << (_Index%31));
		}
	}
	
	public function Is( _Index : Int ) : Bool
	{
		
		return m_Array[Std.int(_Index / 31)] & (1<<(_Index%31)) != 0;
	}

	private var m_Array : Array<Int>;
}