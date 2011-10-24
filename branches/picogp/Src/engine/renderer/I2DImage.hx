/**
 * ...
 * @author Benjamin Dubois
 */

package renderer;

import math.CV2D;
import math.CV4D;

import CTypes;

import rsc.CRscImage;

interface I2DImage
{
	public function Load( _Path : String, _autoActivate :Bool = true )			: Result;
	
	public function SetRsc( _RscImg : CRscImage )	: Result;
	
	//public function GetRsc()						: CRscImage;
	
	public function SetUV( _u : CV2D , _v : CV2D )	: Void;
	
	public function SetAlpha( v : Float )		: Float;
	
	public function GetARGB( _xy : CV2D )			: Int;
	
	public function GetRGB( _xy : CV2D )			: Int;
	
	private var m_UV		: CV4D;
	private var m_Pivot		: CV2D;
}
