package rsc;

/**
 * ...
 * @author bd
 */

import kernel.CTypes;
 
typedef TLoader =
{
	function Update() : Result;
}

typedef TStreamable =
{
	function IsStreamed() : Bool;
}

typedef RscAndLoader =
{
	var m_Rsc		: TStreamable;
	var m_Loader	: TLoader;
}

enum ESitterState
{
	SITTING;
	JUST_FREE;
	FREE;
}

class CRscSitter 
{
	private var	m_RscList	: List<RscAndLoader>;
	private	var m_State		: ESitterState;
	
	public function new() 
	{
		m_RscList	= new List<RscAndLoader>();
		m_State		= FREE;
	}
	
	public function Add( _Rsc : TStreamable, _Loader : TLoader ) : Void
	{
		m_RscList.add( { m_Rsc : _Rsc, m_Loader : _Loader } );
		m_State		= SITTING;
	}
	
	public function GetState() : ESitterState
	{
		switch ( m_State )
		{
			case SITTING :
			{
				for ( i_Rsc in m_RscList )
				{
					i_Rsc.m_Loader.Update();
					if ( i_Rsc.m_Rsc.IsStreamed() )
					{
						m_RscList.remove( i_Rsc );
					}
				}
				if ( m_RscList.isEmpty() )
				{
					m_State	= JUST_FREE;
				}
			}
			case JUST_FREE :
			{
				m_State	= FREE;
			}
			default :
			{
				
			}
		}
		return m_State;
	}
}