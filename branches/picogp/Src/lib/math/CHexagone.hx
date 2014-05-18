package math;

/**
 * ...
 * @author bdubois
 */

class CHexagone
{
	/*
	 * la hauteur d'un triangle isocele = x * ( sqrt(3)/2 ) où x est la longueur d'un côté.
	 */
	public static var m_IsoceleSideToHeightCoef( default, never ) : Float	= { (Math.sqrt(3) / 2); }
	 /*
	  * donc la longueur d'un côté vaut x * ( 2*sqrt(3)/3 ) où x est la hauteur du triangle (i.e. x == m_CellSize ).
	  */
	public static var m_IsoceleHeightToSideCoef( default, never ) : Float	= { (2 * Math.sqrt(3) / 3); }

	public function new()
	{
	}

}