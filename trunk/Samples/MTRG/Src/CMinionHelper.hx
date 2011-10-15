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



 
 /**
  * does the minion polling and mass processing
  */

  
package ;

import algorithms.CPool;
import CMinion;
import CDebug;
using Lambda;

class CMinionHelper
{
	//////////////////////////////////
	public function Create( _Orig : CMinion ) : CMinion
	{
		var l_Res : CMinion = null;
		switch( Type.typeof(_Orig ))
		{
			case TClass(c):
			switch(c)
			{
				case CPerforatingMinion: l_Res= m_CPerforatingMinionPool.Create();
				case CCrossMinion: l_Res= m_CCrossMinionPool.Create();
				case CSpaceCircleMinion: l_Res= m_CSpaceCircleMinionPool.Create();
				case CSpaceInvaderMinion: l_Res= m_CSpaceInvaderMinionPool.Create();
				default: CDebug.BREAK("Should not occur");  return null;
			}
			
			default: return null;
		}
		
		//l_Res.visible = true;
		return l_Res;
	}
	
	//////////////////////////////////
	public function Delete( _Inst : CMinion ) : Void
	{
		if ( _Inst == null ) return;
		
		//disable the beast
		_Inst.m_HasAI = false;
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
					default : throw "err";
				}
			}
			default : throw "err";
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
		m_CCrossMinionPool.Free().iter( function(k) { k.Initialize(); } );
		m_CPerforatingMinionPool.Free().iter( function(k) { k.Initialize(); } );
		m_CSpaceCircleMinionPool.Free().iter( function(k) { k.Initialize(); } );
		m_CSpaceInvaderMinionPool.Free().iter( function(k) { k.Initialize(); } );
		m_Initialized = true;
	}
	
	//////////////////////////////////
	public function Update()
	{
		m_CCrossMinionPool.Used().iter( function(k) { k.Update(); } );
		m_CPerforatingMinionPool.Used().iter( function(k) { k.Update(); } );
		m_CSpaceCircleMinionPool.Used().iter( function(k) { k.Update(); } );
		m_CSpaceInvaderMinionPool.Used().iter( function(k) { k.Update(); } );
		Constants.Update();
	}
	
	//////////////////////////////////
	public function Shut()
	{
		m_CCrossMinionPool.Free().iter( function(k) { k.Shut(); } );
		m_CPerforatingMinionPool.Free().iter( function(k) { k.Shut(); } );
		m_CSpaceCircleMinionPool.Free().iter( function(k) { k.Shut(); } );
		m_CSpaceInvaderMinionPool.Free().iter( function(k) { k.Shut(); } );
		
		m_CCrossMinionPool.Used().iter( function(k) { k.Shut(); } );
		m_CPerforatingMinionPool.Used().iter( function(k) { k.Shut(); } );
		m_CSpaceCircleMinionPool.Used().iter( function(k) { k.Shut(); } );
		m_CSpaceInvaderMinionPool.Used().iter( function(k) { k.Shut(); } );
		
		m_CCrossMinionPool.Reset();
		m_CPerforatingMinionPool.Reset();
		m_CSpaceCircleMinionPool.Reset();
		m_CSpaceInvaderMinionPool.Reset();
		
		m_CCrossMinionPool = null;
		m_CPerforatingMinionPool = null;
		m_CSpaceCircleMinionPool = null;
        m_CSpaceInvaderMinionPool = null;
	}
}