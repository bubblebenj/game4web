/**
 * ...
 * @author Benjamin Dubois
 */

package driver.as.renderer;

import flash.display.Bitmap;
import driver.as.rsc.CRscImageAS;
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.geom.Point;
import flash.sampler.NewObjectSample;
import math.CV4D;
import math.Registers;
import math.Utils;

import math.CV2D;

import kernel.CTypes;
import kernel.CDebug;
import kernel.Glb;

import renderer.I2DImage;

import rsc.CRscMan;
import rsc.CRsc;
import rsc.CRscImage;

class C2DImageAS extends C2DQuadAS, implements I2DImage 
{
	private var m_RscImage	: CRscImageAS;	// content
	
	private	var m_Loading	: Bool;
	
	public function new()
	{
		super();
		m_Loading		= false;
		m_DisplayObject	= new Bitmap( new BitmapData( 8, 8, false, 0x00FF00 ) );
		m_RscImage		= null;
		m_Visible		= false;
		m_UV			= new CV4D( 0, 0, 1, 1 );
	}

	private var m_UV : CV4D;
	
	public function SetUV( _u : CV2D , _v : CV2D ) : Void
	{
		m_UV.CopyV2D(_u, _v );
	}
	
	public function Load( _Path )	: Result
	{
		m_Loading	= true;
		var l_RscMan : CRscMan = Glb.g_System.GetRscMan();
		
		var l_Res = SetRsc( cast( l_RscMan.Load( CRscImage.RSC_ID , _Path ), CRscImageAS ) );
		
		return l_Res;
	}
	
	public function SetRsc( _Rsc : CRscImage )	: Result
	{
		m_RscImage = cast ( _Rsc, CRscImageAS );
		var l_Res = (m_RscImage != null) ? SUCCESS : FAILURE;
		
		return l_Res;
	}
	
	public function CreateBitmap() : Void
	{
		var l_BitmapData = m_RscImage.GetBitmapData();
		if ( l_BitmapData != null )
		{
			m_DisplayObject	= new Bitmap( l_BitmapData );
		}
	}
	
	public override function Update() : Result
	{
		if ( 	m_RscImage			!= null
		&& 		m_RscImage.m_State	== E_STATE.STREAMED
		&&		m_Loading )
		{
			m_Loading	= false;
			CreateBitmap();
			
			var l_Size : CV2D	= CV2D.NewCopy( GetSize() );
			
			// initializing Scale value
			SetSize( new CV2D(	m_DisplayObject.width	/ Glb.GetSystem().m_Display.m_Height,
								m_DisplayObject.height	/ Glb.GetSystem().m_Display.m_Height) );
			m_Scale.Set( 1, 1 );
			
			if ( CV2D.AreNotEqual( l_Size, CV2D.ZERO ) )
			{
				// Update size if a size was already set
				var l_x : Float = 0;
				var l_y : Float = 0;
				l_x	= ( l_Size.x == 0 ) ? l_Size.y * m_DisplayObject.width / m_DisplayObject.height : l_Size.x;
				l_y	= ( l_Size.y == 0 ) ? l_Size.x * m_DisplayObject.height / m_DisplayObject.width : l_Size.y;
				SetSize( new CV2D( l_x, l_y ) );
			}
			
			SetPosition( GetPosition() );
			
			SetVisible( m_Visible );
			if ( m_Activated )
			{
				if ( m_DisplayObject.parent == null )
				{
					Glb.GetRendererAS().AddToSceneAS( m_DisplayObject );
				}
			}
		}
		return SUCCESS;
	}
	
	private function GetBitmapData() : BitmapData
	{
		return cast( m_DisplayObject, Bitmap ).bitmapData;
	}
	
	public inline function GetRGB( _Pixel : CV2D ) : UInt
	{
		trace ( Utils.IntToStr( GetARGB(_Pixel), 16 ) );
		return GetARGB( _Pixel ) % 0x1000000;
	}
	
	public function GetARGB( _Pixel : CV2D ) : UInt
	{
		var l_LocalCoord : CV2D = new CV2D( 0, 0 );
		CV2D.Sub( l_LocalCoord, _Pixel, GetTL() );
		
		/* a try to make it through rotation... FAILURE */
		//var l_x : Int = Utils.RoundNearest( Math.cos( -m_Rotation ) * l_LocalCoord.x 	+ 	Math.sin( -m_Rotation ) * l_LocalCoord.y	+	GetSize().x * 0.5 );
		//var l_y : Int = Utils.RoundNearest( Math.cos( -m_Rotation ) * l_LocalCoord.y 	- 	Math.sin( -m_Rotation ) * l_LocalCoord.x	+	GetSize().y * 0.5 );
		
		l_LocalCoord.x *= GetBitmapData().width / GetSize().x;
		l_LocalCoord.y *= GetBitmapData().height / GetSize().y;
		
		var l_x = Utils.RoundNearest( l_LocalCoord.x );
		var l_y = Utils.RoundNearest( l_LocalCoord.y );
		
		return cast( m_DisplayObject, Bitmap ).bitmapData.getPixel32( l_x, l_y ) ;
	}
	
	// Debug functions
	public override function DebugInfo( ?_Prefix : String ) : Void
	{
		super.DebugInfo( _Prefix );
		var l_Url		= ( m_RscImage	!= null)? m_RscImage.GetPath() : null;
		trace( _Prefix +"path : " + l_Url );
	}	
}