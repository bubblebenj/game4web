/**
 * ...
 * @author DE
 */

package ;

import algorithms.CPool;
import CMinion;
import kernel.CDebug;

class CMinionHelper
{
	//////////////////////////////////
	public function Create( _Orig : CMinion ) : CMinion
	{
		switch( Type.typeof(_Orig ))
		{
			case TClass(c):
			switch(c)
			{
				case CPerforatingMinion: return m_CPerforatingMinionPool.Create();
				case CCrossMinion: return m_CCrossMinionPool.Create();
				case CSpaceCircleMinion: return m_CSpaceCircleMinionPool.Create();
				case CSpaceInvaderMinion: return m_CSpaceInvaderMinionPool.Create();
				default: CDebug.BREAK("Should not occur");  return null;
			}
			
			default: return null;
		}
	}
	
	//////////////////////////////////
	public function Delete( _Inst : CMinion ) : Void
	{
		switch( Type.typeof(_Inst ))
		{
			case TClass(a):
			{
				switch(a)
				{
					case CPerforatingMinion:m_CPerforatingMinionPool.Destroy(cast _Inst);
					case CCrossMinion:m_CCrossMinionPool.Destroy(cast _Inst);
					case CSpaceCircleMinion:m_CSpaceCircleMinionPool.Destroy(cast _Inst);
					case CSpaceInvaderMinion: m_CSpaceInvaderMinionPool.Destroy( cast _Inst );
					default : 
				}
			}
			default : 
		}
	}
	
	//////////////////////////////////
	public var m_CCrossMinionPool :CPool<CCrossMinion>;
	public var m_CPerforatingMinionPool : CPool<CPerforatingMinion>;
	public var m_CSpaceCircleMinionPool : CPool<CSpaceCircleMinion>;
	public var m_CSpaceInvaderMinionPool : CPool<CSpaceInvaderMinion>;

	public var m_Initialized : Bool;
	public function new()
	{
		m_CCrossMinionPool  = new CPool<CCrossMinion>( 32,new CCrossMinion() );
		m_CPerforatingMinionPool  = new CPool<CPerforatingMinion>( 32,new CPerforatingMinion() );
		m_CSpaceCircleMinionPool  = new CPool<CSpaceCircleMinion>( 32,new CSpaceCircleMinion() );
        m_CSpaceInvaderMinionPool = new CPool<CSpaceInvaderMinion>( 32, new CSpaceInvaderMinion() );
	}
	
	//////////////////////////////////
	public function IsLoaded() : Bool 
	{
		return m_Initialized;
	}
	
	//////////////////////////////////
	public function Initialize()
	{
		Lambda.iter(m_CCrossMinionPool.Free() , function(k) { k.Initialize(); } );
		Lambda.iter(m_CPerforatingMinionPool.Free() , function(k) { k.Initialize(); } );
		Lambda.iter(m_CSpaceCircleMinionPool.Free() , function(k) { k.Initialize(); } );
		Lambda.iter(m_CSpaceInvaderMinionPool.Free() , function(k) { k.Initialize(); } );
		m_Initialized = true;
	}
	
	public function Update()
	{
		
	}
}