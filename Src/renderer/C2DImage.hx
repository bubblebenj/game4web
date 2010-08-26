/**
 * ...
 * @author Benjamin Dubois
 */

package renderer;

import math.CV2D;
import math.CV4D;

import kernel.CTypes;

import rsc.CRscImage;


class C2DImage extends C2DQuad
{
	public function new()
	{
		super();
		m_UV = new CV4D(0,0,1,1);
	}
	
	public function SetRsc( _RscImg : CRscImage ) : Void
	{
		
	}
	
	public function SetUV( _u : CV2D , _v : CV2D) : Void
	{
		m_UV.CopyV2D(_u, _v);
	}
	
	
	private var m_UV : CV4D;
}