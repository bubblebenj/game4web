/**
 * ...
 * @author bd
 */

package remotedata;

import CTypes;
import remotedata.IRemoteData;

/*
 * Remote data manager
 */
typedef TLoader =
{
	function Update() : Result;
}

typedef RemoteDataAndLoader =
{
	var m_RemoteData	: IRemoteData;
	var m_Loader		: TLoader;
}

enum ESitterState
{
	SITTING;
	JUST_FREE;
	FREE;
}

class CRemoteDataMan 
{
	private var	m_RemoteDataList	: List<RemoteDataAndLoader>;
	public	var m_State				: ESitterState;
	//private	var m_State				: ESitterState;
	
	public function new() 
	{
		m_RemoteDataList	= new List<RemoteDataAndLoader>();
		m_State				= FREE;
	}
	
	// Typically if pure remoteData loader is not needed
	public function Add( _RemoteData : IRemoteData, ?_Loader : TLoader ) : Void
	{
		m_RemoteDataList.add( { m_RemoteData : _RemoteData, m_Loader : _Loader } );
		m_State		= SITTING;
	}
	
	public function GetState() : ESitterState
	{
		switch ( m_State )
		{
			case SITTING :
			{
				for ( i_RemoteDataAndLoader in m_RemoteDataList )
				{
					if ( i_RemoteDataAndLoader.m_Loader != null )
					{
						i_RemoteDataAndLoader.m_Loader.Update();
					}
					if ( i_RemoteDataAndLoader.m_RemoteData.IsReady() )
					{
						m_RemoteDataList.remove( i_RemoteDataAndLoader );
					}
				}
				if ( m_RemoteDataList.isEmpty() )
				{
					m_State	= JUST_FREE;
				}
			}
			case JUST_FREE :
			{
				m_State	= FREE;
			}
			case FREE :
			{
				
			}
		}
		return m_State;
	}
}