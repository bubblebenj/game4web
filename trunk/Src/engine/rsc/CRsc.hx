package rsc;

import kernel.CSystem;
import kernel.Glb;
import remotedata.IRemoteData;

using Lambda;

typedef RSC_TYPES = Int;

class CRsc implements IRemoteData
{
	var m_Ref									: Int;
	var m_Path									: String;
	var m_SingleLoad							: Bool;
	
	public	var m_State( default, set_m_State )	: DATA_STATE;
	
			var cbk								: Map<DATA_STATE,List<Void->Dynamic>>; 
	
	public function set_m_State( s : DATA_STATE ) : DATA_STATE
	{
		m_State	= s;
		
		var lp = cbk.get(s);
		if ( lp != null )
		{
			CDebug.CONSOLEMSG("prc");
			lp.iter(function(p) p());
			cbk.set(s,null);
		}
			
		return m_State;
	}
	
	public function AddStateCbk(s:DATA_STATE,proc : Void->Dynamic)
	{
		if( s == m_State )
		{
			proc(); return;
		}
		
		if (cbk.get(s) == null)
		{
			var l = new List();
			l.add(proc);
			cbk.set(s, l);
		}
		else 
		{
			var l = cbk.get(s);
			l.add(proc);
			cbk.set(s, l);
		}
	}
	

	public function new()
	{
		m_Ref			= 0;
		m_Path 			= "";
		m_SingleLoad 	= false;
		cbk				= new Map<DATA_STATE,List<Void->Dynamic>>();
		m_State			= REMOTE;
	}
	
	public function Queue()
	{
		Glb.g_System.GetRscMan().AddToQueue( this );
	}

	public function Update()
	{
		
	}
	
	public inline function IsReady() : Bool
	{
		return m_State == READY;
	}
	
	public function Copy( _InRsc : CRsc ) : Void 
	{
		CDebug.ASSERT( GetType() == _InRsc.GetType() );
	}
	
	public function GetType() : Int
	{
		return -1;
	}
	
	public function SetPath( _Path : String ) : Void
	{
		m_Path = (_Path != null) ? _Path.toLowerCase() : null;
	}
	
	public function GetPath() : String
	{
		return m_Path;
	}
	
	public function AddRef() : Void 
	{
		CDebug.ASSERT( m_Ref >= 0 );
		m_Ref++;
	}
	
	public function SetSingleLoaded( _OnOff : Bool  ): Void 
	{
		m_SingleLoad = _OnOff;
	}
	
	public function IsSingleLoaded() : Bool
	{
		return m_SingleLoad!= false;
	}
	
	//one might override this to free system objects
	public function OnDeletion()
	{
		
	}
	
	public function Release() : Void 
	{
		CDebug.ASSERT( m_Ref >= 0 );
		m_Ref--;
		
		if(m_Ref==0)
		{
			OnDeletion();
			Glb.g_System.GetRscMan().ForceDelete(this);
		}
	}
}