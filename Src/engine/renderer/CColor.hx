/**
 * ...
 * @author de
 */

package renderer;

class CColor 
{
	public var r : Float;
	public var g : Float;
	public var b : Float;
	public var a : Float;
	
	public function new( 	?_r : Float,
							?_g : Float,
							?_b : Float,
							?_a : Float )
	{
		r = (_r==null)?1.0:_r;
		g = (_g==null)?1.0:_g;
		b = (_b==null)?1.0:_b;
		a = (_a==null)?1.0:_a;
	}
	
	public function ToRGBA32()
	{
		return 	(Std.int(r * 255.0) << 24	)
		|		(Std.int(g * 255.0) << 16	) 
		|		(Std.int(b * 255.0) << 8 	)
		|		(Std.int(a * 255.0)		); 
	}
	
	public function ToARGB32()
	{
		return 	(Std.int(r * 255.0) << 16	)
		|		(Std.int(g * 255.0) << 8	) 
		|		(Std.int(b * 255.0) 		)
		|		(Std.int(a * 255.0) <<	24	); 
	}

}