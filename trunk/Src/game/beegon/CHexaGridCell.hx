package game.beegon;

/**
 * ...
 * @author bdubois
 */

import math.CHexagone;
import game.beegon.CEntity;
import math.CV2D;

/*  ___
 * /   \
 * \___/
 */
class CHexaGridCell extends CEntity
{
	//public var m_Building	: CBuilding;
	
	public function new( _Width : Float )	: Void
	{
		#if CHexaGridCell
			trace ( "\t new CHexagridCell" );
		#end
		super( EENTITY_TYPE_HEXAGRIDCELL );
		
		//var l_Size : CV2D = new CV2D( _Width, _Width );
		//SetSize( l_Size );
	}
	
	public function CreateBuilding()	: Void
	{
		//var l_TestSize	: CVector2D	= new CVector2D( 1, 1 );
		//m_Building	= new CBuilding( this, l_TestSize );
		//m_Building.SetParent( this );
		//
		//m_Building.InitSprite();
		//m_Building.ActiveSprite().SetSprite( "./images/Spring/Spring_32^2/Spring_Base.png" );
		//m_Building.ActiveSprite().ShiftSprite( ESHIFT_CENTER );
		//m_Building.ActiveSprite().SetSize( l_TestSize );
	}
}