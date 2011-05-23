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
	public	var m_state( default, SetState )	: DATA_STATE;
	
	public	function IsReady() : Bool;
	
	public	function SetState( _State : DATA_STATE ) : DATA_STATE;
}