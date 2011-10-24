/**
 * ...
 * @author de
 */

package algorithms;

class CPool<T> 
{
	private var m_FreeList : List < T >;
	private var m_UsedList : List < T >;
	
	public inline function Create() : T
	{
		var l_New = m_FreeList.pop();
		CDebug.ASSERT(l_New != null);//not enough instances in pool
		m_UsedList.add(l_New);
		return l_New;
	}
	
	public function Used() : Iterable<T>
	{
		return m_UsedList;
	}
	
	public function Free() : Iterable<T>
	{
		return m_FreeList;
	}
	
	public inline function Destroy( _Old : T ) : Void
	{
		CDebug.ASSERT(_Old!=null);
		var l_IsOk = m_UsedList.remove( _Old );
		
		#if debug
		//already out it seems, ensure it is already freed before throwing away
		if( !Lambda.has( m_FreeList , _Old ))
		{
			CDebug.ASSERT(l_IsOk);
		}
		#end
		
		if (l_IsOk)
		{
			m_FreeList.add(_Old);
		}
	}
	
	public function new(_Len : Int, _OriginalCopy : T ) 
	{
		m_FreeList = new List<T>();
		m_UsedList = new List<T>();
		
		m_FreeList.clear();
		for (i in 0..._Len)
		{
			m_FreeList.add( Type.createInstance(Type.getClass(_OriginalCopy),[]) );
		}
		
		m_UsedList.clear();
	}
	
	public function Reset() 
	{
		for (o in m_UsedList)
		{
			m_FreeList.add( o );
		}
		m_UsedList.clear();
	}
	
}