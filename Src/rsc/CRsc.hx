package rsc;

import kernel.CTypes;
import kernel.CDebug;
import kernel.CSystem;
import kernel.Glb;

typedef RSC_TYPES = Int;

enum E_STATE
{
	INVALID;
	STREAMING;
	STREAMED;
}

class CRsc
{
	var m_Ref			: Int;
	var m_Path			: String;
	var m_SingleLoad	: Bool;
	var m_State			: E_STATE;
	
	
	public function new()
	{
		m_Ref			= 0;
		m_Path 			= "";
		m_SingleLoad 	= false;
		m_State			= STREAMED;
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
	
	public function SetState( _State : E_STATE ) : Void
	{
		m_State = _State;
	}
	
	public function GetState() : E_STATE
	{
		return m_State;
	}
	
	public function SetSingleLoaded( _OnOff : Bool  ): Void 
	{
		m_SingleLoad = _OnOff;
	}
	
	public function IsSingleLoaded() : Bool
	{
		return m_SingleLoad!= false;
	}
	
	public function Release() : Void 
	{
		CDebug.ASSERT( m_Ref >= 0 );
		m_Ref--;
		
		if(m_Ref==0)
		{
			Glb.g_System.GetRscMan().ForceDelete(this);
		}
	}
}