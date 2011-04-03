/****************************************************
 * MTRG : Motion-Twin recruitment game
 * A game by David Elahee
 * 
 * MTRG is a Space Invader RTS, the goal is to protect your mothership from
 * the random AI that shoots on it.
 * 
 * Powered by Game4Web a cross-platform engine by David Elahee & Benjamin Dubois.
 * 
 * @author de
 ****************************************************/

 /****************************************************
 * Background image management and creation class
 ****************************************************/

package ;

import driver.as.renderer.C2DImageAS;
import haxe.Public;
import kernel.Glb;
import math.CV2D;


class CBG  implements Public , implements Updatable
{
	public var m_Img : C2DImageAS;


	////////////////////////////////////////////////////////////
	function new()
	{
		m_Img = null;
	}
	
	////////////////////////////////////////////////////////////
	function Initialize()
	{
		m_Img = new C2DImageAS();
		m_Img.Load( "./Data/BG.png" );
		
		m_Img.SetCenterPosition( new CV2D( Glb.GetSystem().m_Display.GetAspectRatio() * 0.5, 0.5));
		
		m_Img.Activate();
		
	}
	
	////////////////////////////////////////////////////////////
	public function GetDisplayObject()
	{
		return m_Img.GetDisplayObject();
	}
	
	////////////////////////////////////////////////////////////
	function IsLoaded() : Bool
	{
		return m_Img.IsLoaded();
	}
	
	////////////////////////////////////////////////////////////
	function Update()
	{
		
	}
	
	////////////////////////////////////////////////////////////
	function Shut()
	{
		m_Img.Shut();
		m_Img = null;
	}
}
