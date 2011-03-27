/**
 * ...
 * @author de
 */

package algorithms;

import kernel.CDebug;

class CBitArray 
{
	static inline var MAGNITUDE_BIT = 4;
	static inline var MAGNITUDE = 16;
	
	public function new( _Bits : Int ) 
	{
		m_Array = new Array<Int>();
		
		var l_Size = (_Bits >> MAGNITUDE_BIT) + 1;
		for ( i in 0...l_Size)
		{
			m_Array[i] = 0;
		}
	}
	
	public function Length( ) 
	{
		return m_Array.length * MAGNITUDE;
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
	
	public function Set( _Index : Int , _Val : Bool )
	{		
		if ( _Val)
		{
			m_Array[ _Index >>  MAGNITUDE_BIT] |= (1 << (_Index % MAGNITUDE));
		}
		else
		{
			m_Array[ _Index >>  MAGNITUDE_BIT ] &= ~(1 << (_Index%MAGNITUDE));
		}
	}
	
	public inline function Is( _Index : Int ) : Bool
	{
		return m_Array[_Index >> MAGNITUDE_BIT] & (1<<(_Index%MAGNITUDE)) != 0;
	}

	private var m_Array : Array<Int>;
}