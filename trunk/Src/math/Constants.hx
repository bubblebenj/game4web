/**
 * ...
 * @author de
 */

package math;

class Constants 
{
	public static inline var EPSILON : Float = 1e-6;
	public static inline var PI :Float =  3.1415926535897932384626433;
	
	public static inline var DEG_TO_RAD :Float = Constants.PI * 2.0 / 360.0;
	public static inline var RAD_TO_DEG :Float = 360.0 / Constants.PI * 2.0;
	
	public static inline var INT_MAX : Int = (1 << 31) - 1;
	public static inline var INT_MIN : Int = - ((1 << 31) - 1);
}