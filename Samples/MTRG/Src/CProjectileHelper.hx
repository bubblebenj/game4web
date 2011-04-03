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



 /*
 * manages the projectiles and the mass processing
 */ 
 
package ;

import algorithms.CPool;
import CProjectile;
import flash.media.Sound;
import flash.net.URLRequest;
using Lambda;


class CProjectileHelper 
{
	public var m_CBoulettePool : CPool<CBoulette>;
	public var m_Initialized : Bool;
	
	public function new()
	{
		m_CBoulettePool = new CPool<CBoulette>(64, new CBoulette() );
	}
	
	public function Initialize()
	{
		m_CBoulettePool.Free().iter( function(k) { k.Initialize(); } );
		m_Initialized = true;
		
	}
	
	public function Update()
	{
		Lambda.iter( Lambda.list( m_CBoulettePool.Used() ), function(k) k.Update()  );
	}
	
	public function Shut()
	{
		m_CBoulettePool.Free().iter( function(k) { k.Shut(); } );
		m_CBoulettePool.Used().iter( function(k) { k.Shut(); } );
		m_CBoulettePool.Reset();
		m_CBoulettePool = null;
	}
}