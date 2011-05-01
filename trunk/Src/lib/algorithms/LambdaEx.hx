/**
 * ...
 * @author de
 */

package algorithms;

class LambdaEx 
{

	/**
	 *
	 **/
	public static function firstOrDefault<Elem>( it : Iterable<Elem>, predicate : Elem -> Bool, ? elt : Elem ) : Elem 
	{
		for ( x in it )
		{
			if(  predicate( x ) )
				return x;
		}
		return elt;
	}
	
	/**
	 * 
	 **/
	public static function nth<Elem>( it : Iterable<Elem>, _n : Int , ?dflt) : Elem
	{
		var i = 0;
		for ( x in it )
		{
			if( i == _n )
				return x;
			i++;
		}
		return dflt;
	}

	
}