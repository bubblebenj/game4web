package game.beegon;

/**
 * ...
 * @author bdubois
 */

import game.beegon.CEntity;
import math.CV2D;
import kernel.Glb;

class CAvatar extends CEntity
{
	private var m_MaxHealth	: Int;
	private var m_Health	: Int;
	private var m_Speed		: Float; // In world units per second
	private var m_Follow		: Bool;
	
	public function new() 
	{
		trace ( "\t new Avatar" );
		
		super( EENTITY_TYPE_AVATAR );
				
		Init();
	}
	
	public function Init()
	{
		m_MaxHealth	= 100;
		m_Health	= 100;
		m_Speed		= 1.0;
		m_Follow	= false;
		m_Follow	= false;
	}
	
	public function TeleportTo( _Coordinates : CV2D )	: Void
	{
		// animation au point de depart et d'arrivee
		// TBD
		SetPosition( _Coordinates );
	}
	
	public function MoveTo( _Coordinate : CV2D )	: Void
	{
		// Un while risque de tout peter
		// du coup je vais faire ca par pas
		var l_NextPos	: CV2D	= new CV2D( 0, 0 );
		CV2D.Sub( l_NextPos, _Coordinate, m_Coordinate );
		var l_Distance	: Float	= Math.sqrt( Math.pow( l_NextPos.x , 2 ) + Math.pow( l_NextPos.y , 2 ));
		var l_StepSize	: Float	= m_Speed / l_Distance;

		CV2D.Scale( l_NextPos, l_StepSize, l_NextPos );
		CV2D.Add( l_NextPos, m_Coordinate, l_NextPos );
		SetPosition( l_NextPos );
	}
	
	public function SetFollowCursor( _Follow : Bool )	: Void
	{
		m_Follow = _Follow;
	}
	
	public function Update()	: Void
	{
		if ( m_Follow )
		{
			MoveTo( Glb.GetInputManager().m_Mouse.m_Coordinate );
		}
	}
	
	public function SetSpeed( _Speed	: Float ) : Void
	{
		m_Speed	=	_Speed;
	}
}