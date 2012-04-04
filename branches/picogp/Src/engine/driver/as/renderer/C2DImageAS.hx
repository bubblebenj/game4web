/**
 * ...
 * @author Benjamin Dubois
 */

package driver.as.renderer;

import CTypes;
import CDebug;
import driver.as.rsc.CRscImageAS;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.DisplayObject;
import kernel.Glb;
import math.CV2D;
import math.CV4D;
import math.Registers;
import remotedata.IRemoteData;
import renderer.I2DImage;
import rsc.CRscImage;
import rsc.CRscMan;
import rsc.CRsc;


class C2DImageAS extends C2DQuadAS, implements I2DImage, implements IRemoteData
{
	private var m_RscImage	: CRscImageAS;	// content
	private var m_UV : CV4D;
	public	var m_state( default, SetState )	: DATA_STATE;
	
	public function new()
	{
		super();
		m_state			= REMOTE;
		//m_Native		= new Bitmap( new BitmapData( 8, 8, false, 0x00000000 ) );
		//GetBitmap().alpha = 0;
		m_RscImage		= null;
		m_Visible		= false;
		m_UV			= new CV4D( 0, 0, 1, 1 );
	}
	
	public	function SetState( _State : DATA_STATE ) : DATA_STATE
	{
		m_state	= _State;
		return m_state;
	}
	
	public function SetUV( _u : CV2D , _v : CV2D ) : Void
	{
		m_UV.CopyV2D( _u, _v );
	}
	
	public function Load( _Path )	: Result
	{
		//m_state	= SYNCING;
		var l_RscMan : CRscMan = Glb.g_System.GetRscMan();
		
		var l_Res = SetRsc( cast( l_RscMan.Load( CRscImage.RSC_ID , _Path ), CRscImageAS ) );
		
		CDebug.ASSERT(l_Res == SUCCESS );
		return l_Res;
	}
	
	public	function SetRsc( _Rsc : CRscImage )	: Result
	{
		m_state = SYNCING;
		m_RscImage = cast ( _Rsc, CRscImageAS );
		var l_Res = (m_RscImage != null) ? SUCCESS : FAILURE;
		
		return l_Res;
	}
	
	//public	function GetRsc() : CRscImage
	//{
		//return m_RscImage;
	//}

	public override function IsReady()	: Bool
	{
		return m_state == READY;
	}
	
	private function CreateBitmap() : Void
	{
		var l_BitmapData = m_RscImage.GetBitmapData();
		CDebug.ASSERT( l_BitmapData != null, l_BitmapData + "" );
		if ( l_BitmapData != null )
		{
			var l_Bmp = new Bitmap( l_BitmapData );
			m_Native = l_Bmp;
			l_Bmp.smoothing	= true;
		}
	}
	
	private function InitLoadedRsc() : Void
	{
		CreateBitmap();
			
		var l_Size : CV2D	= CV2D.NewCopy( GetSize() );
		
		// initializing Scale value
		SetSize( new CV2D(	m_DisplayObject.width	/ Glb.GetSystem().m_Display.m_Height, 
							m_DisplayObject.height	/ Glb.GetSystem().m_Display.m_Height) );
		m_Scale.Set( 1, 1 );
		
		if ( !CV2D.AreAbsEqual( l_Size, CV2D.ZERO ) )
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
		m_state	= READY;
		//CDebug.CONSOLEMSG( "READY" );
			
	}
	
	public override function Update() : Result
	{
		if ( 	m_RscImage	!= null
		&& 		m_RscImage.IsReady()
		&&		m_state == SYNCING )
		{
			CDebug.CONSOLEMSG( "loading rsc" );
			InitLoadedRsc();
		}
		return SUCCESS;
	}
	
	public function GetBitmap() : Bitmap
	{
		return cast( m_DisplayObject, Bitmap );
	}
	
	public function GetDisplayObject() : DisplayObject
	{
		return m_DisplayObject;
	}
	
	public function GetBitmapData() : BitmapData
	{
		return cast( m_DisplayObject, Bitmap ).bitmapData;
	}
	
	public inline function GetRGB( _Point : CV2D ) : Int
	{
		return GetARGB( _Point ) % 0x1000000;
	}

	public function GetARGB( _Point : CV2D ) : Int
	{
		var l_BitmapData	= cast( m_DisplayObject, Bitmap ).bitmapData;
		var l_V2D	= Registers.V2_8;
		GetNonTransformedPoint( _Point, l_V2D );
		CV2D.Scale( l_V2D, Glb.GetSystem().m_Display.m_Height, l_V2D );
		var l_Color	= l_BitmapData.getPixel32( Std.int( l_V2D.x ), Std.int( l_V2D.y ) );
		
		return l_Color;
	}
	
	// Debug functions
	public override function DebugInfo( ?_Prefix : String ) : Void
	{
		super.DebugInfo( _Prefix );
		var l_Url		= ( m_RscImage	!= null)? m_RscImage.GetPath() : null;
		CDebug.CONSOLEMSG( _Prefix +"path : " + l_Url );
	}	
}