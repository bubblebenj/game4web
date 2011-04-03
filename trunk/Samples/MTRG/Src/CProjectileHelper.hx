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