/**
 * ...
 * @author de
 */

package algorithms;
import kernel.CDebug;


class CPool<T> 
{
	private var m_FreeList : List < T >;
	private var m_UsedList : List < T >;
	
	public function Create() : T
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
	
	public function Destroy( _Old : T ) : Void
	{
		var l_IsOk = m_UsedList.remove( _Old );
		CDebug.ASSERT(l_IsOk);
		
		m_FreeList.add(_Old);
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
	
}