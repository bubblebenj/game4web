package rsc;

import rsc.CRsc;
import rsc.CRscBuilder;

import kernel.CTypes;
import kernel.CDebug;


class CRscMan
{
	public function Initialize() : Result
	{
		m_Repository = new Hash<CRsc>();
		m_Builders = new IntHash <CRscBuilder>();
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
		m_Builders.set( _Type, _Builder);
		return SUCCESS;
	}
	
	public function Create( _Type : RSC_TYPES ) : CRsc
	{
		var l_Builder = m_Builders.get(_Type);
		if (l_Builder == null )
		{
			trace("No builder for rsc type : " + _Type );
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
	
	public function Load( _Type : RSC_TYPES, _Path : String, ?_SingleLoad : Bool ) : CRsc
	{
		CDebug.ASSERT(_Path != null );
		if ( _SingleLoad != null && _SingleLoad != true && _Path != null )
		{
			var l_CandRsc : CRsc = m_Repository.get(_Path);
			if (l_CandRsc != null
			&&	!l_CandRsc.IsSingleLoaded())
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
				l_Rsc.SetSingleLoaded( (_SingleLoad==null) ? false : _SingleLoad );
			}
			
			return l_Rsc;
		}
	}
	
	public function ForceDelete( _R : CRsc  ) : Void
	{
		m_Repository.set( _R.GetPath() , null );
	}
	
	public function new()
	{
		m_Repository = null;
		m_Builders = null;
	}
	
	var m_Repository 	: Hash<CRsc>;
	var m_Builders 		: IntHash < CRscBuilder >;
	
	public static var RSC_COUNT	= 0;
}






