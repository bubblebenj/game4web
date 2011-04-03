/**
 * ...
 * @author DE
 */

package ;

import algorithms.CPool;
import CProjectile;
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