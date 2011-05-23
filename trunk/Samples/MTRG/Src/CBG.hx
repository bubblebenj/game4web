/****************************************************
 * MTRG : Motion-Twin recruitment game
 * A game by David Elahee
 * 
 * MTRG is a Space Invader RTS, the goal is to protect your mothership from
 * the random AI that shoots on it.
 * 
 * Powered by Game4Web a cross-platform engine by David Elahee & Benjamin Dubois.
 * 
	Copyright (C) 2011  David Elahee

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses
	
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
		return m_Img.IsReady();
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
