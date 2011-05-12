package tools;

/**
 * ...
 * @author bd
 */

class CCopy 
{
	// Copy all std field of a class
	public static function SuperficialClassCopy<T>( _src : T, _tgt : T ) : Void
	{ 
		for( i_field in Type.getInstanceFields( Type.getClass( _src ) ) ) 
		{
			var isStdType		=	Std.is( i_field, Int ) ||
									Std.is( i_field, Float ) ||
									Std.is( i_field, String );
			var isNotAFunction	= ! Reflect.isFunction( i_field  );
			
			if ( isStdType || isNotAFunction ) // simple type, not a fonction 
			{
				Reflect.setField( _tgt, i_field, Reflect.field( _src, i_field ) );
			}
		}
	} 
	
	
	
	/** 
    deep copy of anything 
   **/ 
	public static function deepCopy<T>( v:T ) : T 
	{ 
		if (!Reflect.isObject(v)) // simple type 
		{ 
			return v; 
		} 
		else if( Std.is( v, Array ) ) // array 
		{ 
			var r = Type.createInstance(Type.getClass(v), []); 
			untyped 
			{ 
				for( ii in 0...v.length ) 
					r.push(deepCopy(v[ii]));
			} 
			return r; 
		} 
		else if( Type.getClass(v) == null ) // anonymous object 
		{ 
			var obj : Dynamic = {}; 
			for( ff in Reflect.fields(v) ) 
				Reflect.setField(obj, ff, deepCopy(Reflect.field(v, ff))); 
			return obj; 
		} 
		else // class 
		{ 
			var obj = Type.createEmptyInstance(Type.getClass(v)); 
			for( ff in Reflect.fields(v) ) 
				Reflect.setField(obj, ff, deepCopy(Reflect.field(v, ff))); 
			return obj; 
		} 
		return null; 
	} 
	
}