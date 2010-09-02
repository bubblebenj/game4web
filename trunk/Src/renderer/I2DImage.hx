/**
 * ...
 * @author Benjamin Dubois
 */

package renderer;

import math.CV2D;
import math.CV4D;

import kernel.CTypes;

import rsc.CRscImage;

interface I2DImage
{

	public function Load( _Path : String ) : Result	{}
	
	public function SetRsc( _RscImg : CRscImage ) : Result	{}
	
	public function SetUV( _u : CV2D , _v : CV2D ) : Void	{}
		
	private var m_UV : CV4D;
}
