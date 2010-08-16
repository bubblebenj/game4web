/**
 * ...
 * @author Benjamin Dubois
 */

package renderer;

import kernel.CTypes;
import math.CV2D;

class C2DImage extends CDrawObject
{
	private	var m_PathToImg		: String;
	private	var m_SrcSize		: CV2D;
	private var m_2DQuad		: C2DQuad;
	
	public function new()
	{
		trace( "\t new Image" );
		super();
	}
	
	//Set the image of the Sprite
	public function Load( _PathToImg : String )	: Void
	{
		#if DebugInfo
			trace ("\t [ -- Load( PathToImg : " + _PathToImg + " )");
		#end
		m_PathToImg		= _PathToImg;
	}
	
	public function MoveTo( _Pos : CV2D ) : Void
	{
		m_2DQuad.MoveTo( _Pos );
	}
	
	// We suppose that the 2DQuad is already centered
	public function SetSize( _Size : CV2D ) : Void
	{
		m_2DQuad.SetSize( _Size );
	}
	
	private function FillQuad() : Result
	{
		//dunno exactly what to do out of the driver
		return SUCCESS;
	}
}