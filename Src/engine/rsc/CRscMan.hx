package rsc;

import rsc.CRsc;
import rsc.CRscBuilder;

import CTypes;
import CDebug;


class CRscMan
{
	public function Initialize() : Result
	{
		m_Repository = new Map<String, CRsc>();
		m_Builders = new Map<Int, CRscBuilder>();
		return SUCCESS;
	}
	
	public function Shut() : Result
	{
		m_Repository = null;
		m_Builders = null;
		return SUCCESS;
	}
	
	public function AddBuilder( _Type : RSC_TYPES , _Builder : CRscBuilder ) : Result
	{
		CDebug.ASSERT(_Builder != null );
		
		if (_Builder == null)
		{
			CDebug.CONSOLEMSG("Rsc Type num " +_Type + " is null");
		}
		
		m_Builders.set( _Type, _Builder);
		return SUCCESS;
	}
	
	public function Create( _Type : RSC_TYPES ) : CRsc
	{
		var l_Builder = m_Builders.get(_Type);
		if (l_Builder == null )
		{
			CDebug.CONSOLEMSG("No builder for rsc type : " + _Type );
			return null;
		}
		else
		{
			var l_Rsc : CRsc = l_Builder.Build( _Type, null );
			if( l_Rsc != null )
			{
				l_Rsc.AddRef();
				l_Rsc.SetPath( null );
				l_Rsc.SetSingleLoaded( true );
				return l_Rsc;
			}
		}
		
		return null;
	}
	
	public function Copy( _Rsc : CRsc ) : CRsc
	{
		CDebug.ASSERT( m_Builders.get( _Rsc.GetType() ) != null );
		var l_Rsc : CRsc = m_Builders.get( _Rsc.GetType() ).Build( _Rsc.GetType(), null );
		if( l_Rsc != null )
		{
			l_Rsc.AddRef();
			l_Rsc.SetPath( null );
			l_Rsc.SetSingleLoaded( true );
		}
		
		l_Rsc.Copy( _Rsc );
		
		return l_Rsc;
	}
	
	public function Update()
	{ 
		m_SyncQueue = m_SyncQueue.filter( function(r) { r.Update(); return !r.IsReady(); } );
	}
	
	public function AddToQueue(r)
	{
		m_SyncQueue.add(r);
	}
	
	public function Load( _Type : RSC_TYPES, _Path : String, ?_SingleLoad : Bool ) : CRsc
	{
		CDebug.ASSERT(_Path != null );
		
		
		if (	_SingleLoad != true 
			&& 	_Path != null )
		{
			//CDebug.CONSOLEMSG("searching resource : >" + _Path+"<");

			var l_CandRsc : CRsc = m_Repository.get( _Type + "_" + _Path);
			if (l_CandRsc != null
			&&	!l_CandRsc.IsSingleLoaded()
			&& _Type == l_CandRsc.GetType())
			{
				l_CandRsc.AddRef();
				return l_CandRsc;
			}
		}

		var l_Builder = m_Builders.get(_Type);
		if (l_Builder == null )
		{
			trace("No builder for rsc: " + _Type +"(" + _Path + ")");
			return null;
		}
		else
		{
			var l_Rsc : CRsc = l_Builder.Build( _Type, _Path );
			if( l_Rsc != null )
			{
				l_Rsc.AddRef();
				l_Rsc.SetPath( _Path );
				l_Rsc.SetSingleLoaded( (_SingleLoad != true) ? false : _SingleLoad );
				
				m_Repository.set(_Type+"_"+_Path, l_Rsc);
				//CDebug.CONSOLEMSG("Adding resource : " + _Path);
			}
			
			return l_Rsc;
		}
	}
	
	public function ForceDelete( _R : CRsc  ) : Void
	{
		m_Repository.set( _R.GetType() +"_"+_R.GetPath() , null );
	}
	
	public function new()
	{
		m_Repository = null;
		m_Builders = null;
		m_SyncQueue  = new List();
	}
	
	var m_Repository 	: Map<String,CRsc>;
	var m_Builders 		: Map<Int,CRscBuilder>;
	
	var m_SyncQueue 		: List<CRsc>;
	
	public static var RSC_COUNT	= 0;
}


