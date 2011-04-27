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
	var m_Ref				: Int;
	var m_Path				: String;
	var m_SingleLoad		: Bool;
	public var m_State		: E_STATE;
	
	public function new()
	{
		m_Ref			= 0;
		m_Path 			= "";
		m_SingleLoad 	= false;
		m_State			= INVALID;
	}
	
	public inline function IsStreamed() : Bool
	{
		return m_State == STREAMED;
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