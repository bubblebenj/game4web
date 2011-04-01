/**
 * ...
 * @author DE
 */

package ;

import algorithms.CPool;
import CProjectile;

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
		Lambda.iter(m_CBoulettePool.Free() , function(k) { k.Initialize(); } );
		m_Initialized = true;
	}
	
	public function Update()
	{
		Lambda.iter( Lambda.list( m_CBoulettePool.Used() ), function(k) k.Update()  );
	}
}