package kernel;

/**
 * ...
 * @author de
 */

class EnumHash<E,T>
{
	var data : IntHash<T>;
	var e : Enum<E>;
	
	public inline function new( e : Enum<E> ) : Void
	{
		data = new IntHash();
		this.e = e;
	}
	
	public inline function clear()
	{
		data = new IntHash();
	}
	
	public inline function exists( key : E ) : Bool
	{
		return data.exists( Type.enumIndex(key) );
	}
	
	public inline function get( key : E ) : Null<T>
	{
		return data.get( Type.enumIndex( key ));
	}
	
	public inline function remove( key : E ) : Bool
	{
		return data.remove( Type.enumIndex(key));
	}
		
	public inline function set( key : E, value : T ) : Void
	{
		data.set( Type.enumIndex(key), value );
	}
	
	public inline  function toString() : String
	{
		var s = "";
		for( e in keys() )
		{
			s += e +" = " + Std.string(get(e)) +" ; ";
		}
		return s;
	}
	
	public inline function iterator() : Iterator<T>
	{
		CDebug.ASSERT( data != null );
		return data.iterator();
	}
	
	public function keys() : Iterator<E>
	{
		var iter = data.keys(); 
		return 
		{
			next : function() return Type.createEnumIndex( e, iter.next() ),
			hasNext : iter.hasNext
		};
	}
	
	function hxSerialize( s : haxe.Serializer ) 
	{
		s.serialize( Std.string( Type.getEnumName(e) ));
		s.serialize( data );
    }
	
    function hxUnserialize( s : haxe.Unserializer ) 
	{
        var p :String = s.unserialize();
		e = cast Type.resolveEnum( p );
		data = s.unserialize();
		
    }
	
}