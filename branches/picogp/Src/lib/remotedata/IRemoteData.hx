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
	public	var m_state( default, set )	: DATA_STATE;
	
	public	function set_m_state( _State : DATA_STATE ) : DATA_STATE;
	
	public	function IsReady() : Bool;
}