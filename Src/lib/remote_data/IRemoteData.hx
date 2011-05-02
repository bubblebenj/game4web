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
	private var m_state	: DATA_STATE;
	
	public function IsReady() : Bool;
}