package logic.collision;
import math.CV2D;

/**
 * ...
 * @author bd
 */

class CSegmentCollision
{

	// Collision segment / segment
	// ! \ Not tested !!!!
	public static  inline function Segment( _A : CV2D, _B : CV2D, _C : CV2D, _D : CV2D ) : Bool
	{
		var r_Collides	: Bool	= false;
		
		// [AB] collides (CD) ?
		var l_Directeur	: CV2D	= CV2D.OperatorMinus( _D, _C );
		var l_Normale		: CV2D	= new CV2D( -l_Directeur.y , l_Directeur.x );
		 
		var	l_Distance1	: Float	= CV2D.DotProduct( CV2D.OperatorMinus( _A, _C ) , l_Normale ); // distance orientée point/droite
		var	l_Distance2	: Float	= CV2D.DotProduct( CV2D.OperatorMinus(  B, _C ) , l_Normale );
		 
		if ( 	( (l_Distance1 > 0) && (l_Distance2 < 0) ) ||
				( (l_Distance1 < 0) && (l_Distance2 > 0) ) || 
				l_Distance1 == 0 ||
				l_Distance2 == 0 )
		{
			// [CD] collides (AB) ?
			l_Directeur	= CV2D.OperatorMinus( _B, _A );
			l_Normale.Set( -l_Directeur.y , l_Directeur.x );
			 
			l_Distance1	= CV2D.DotProduct( CV2D.OperatorMinus( _C, _A ) , l_Normale ); // distance orientée point/droite
			l_Distance2	= CV2D.DotProduct( CV2D.OperatorMinus( _D, _A ) , l_Normale );
			 
			if ( 	( (l_Distance1 > 0) && (l_Distance2 < 0) ) ||
					( (l_Distance1 < 0) && (l_Distance2 > 0) ) || 
					l_Distance1 == 0 ||
					l_Distance2 == 0 )
			{
				r_Collides	= true;
			}
		}
		return r_Collides;
	}
}