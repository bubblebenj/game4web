/**
 * ...
 * @author Benjamin Dubois
 */
package renderer;

import CDriver;
import kernel.CTypes;
import math.CV2D;
import math.CV4D;
import math.Utils;
import rsc.CRscImage;

class CSliced2DImage extends C2DContainer, implements I2DImage
{
	private var m_RscImage	: CRscImage;
	public var m_NbWidthSlices( default, null )		: Int;
	public var m_NbHeightSlices( default, null )	: Int;
	private var m_SliceSize							: CV2D;
	
	public function new( _NbWidthSlices : Int, _NbHeightSlices : Int ) 
	{
		super();
		
		m_NbWidthSlices		= _NbWidthSlices;
		m_NbHeightSlices	= _NbHeightSlices;
		
		for ( i in 0 ... m_NbWidthSlices * m_NbHeightSlices - 1 )
		{
			m_2DObjects[i] = new C2DImage();
		}
	}
	
	public override function SetSize( _V2D : CV2D ): Void
	{
		
	}
	
	public function LoadImages( _ImgSrcs : Array<String> ) : Result
	{
		if ( _ImgSrcs.length == m_NbWidthSlices * m_NbHeightSlices )
		{
			for ( i in 0 ... _ImgSrcs.length - 1 )
			{
				cast( m_2DObjects[ i ], C2DImage ).Load( _ImgSrcs[ i ] );
			}
			return SUCCESS;
		}
		else
		{
			trace( "The number of given Slices doesn't fit the requirements : " +m_NbWidthSlices + " * " + m_NbHeightSlices );
			return FAILURE;
		}
	}
	
	/* Path to xml file (or to folder)? */
	public function Load( _Path : String )			: Result
	{
		return SUCCESS;
	}
	
	private function GetSlice( _Point : CV2D ) : C2DImage
	{
		// doesn't handle rotations
		var x = Math.floor( _Point.x * m_NbWidthSlices / GetSize().x );
		var y = Math.floor( _Point.y * m_NbHeightSlices / GetSize().y );
		
		return cast( m_2DObjects[ y * m_NbWidthSlices + x ], C2DImage );
	}
	
	/* Present only for implementation of I2DImage */
	public function SetRsc( _RscImg : CRscImage )	: Result
	{
		return SUCCESS;
	}
	
	public function SetUV( _u : CV2D , _v : CV2D )	: Void	{}
	
	public function GetARGB( _xy : CV2D )			: Int
	{
		return 0;
	}
	
	public inline function GetRGB( _Pixel : CV2D ) : Int
	{
		trace ( Utils.IntToStr( GetARGB(_Pixel), 16 ) );
		return GetARGB( _Pixel ) % 0x1000000;
	}
	
	private var m_UV : CV4D;
}