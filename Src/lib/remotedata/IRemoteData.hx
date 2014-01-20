/**
 * ...
 * @author bd
 */
package remotedata;


enum DATA_STATE
{
	REMOTE;
	SYNCING;
	READY;
	INVALID;
}

interface IRemoteData 
{
	public	var m_state( default, set_m_State )	: DATA_STATE;
	
	public	function IsReady() : Bool;
	
	public	function set_m_State( _State : DATA_STATE ) : DATA_STATE;
}