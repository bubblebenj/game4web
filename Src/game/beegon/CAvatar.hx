package game.beegon;

/**
 * ...
 * @author bdubois
 */

import game.beegon.CEntity;
import math.CV2D;

class CAvatar extends CEntity
{
	private var m_MaxHealth	: Int;
	private var m_Health	: Int;
	private var m_Speed		: Float; // In screen height per second
	
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
	}
}