﻿package game.beegon;

/**
 * ...
 * @author bdubois
 */

import kernel.CTypes;
import math.CV2D;
import renderer.C2DImage;
#if flash10
	import driver.as.renderer.C2DImageAS;
#end

enum EENTITY_STATE
{
	EES_FULLLIFE;
	EES_DEAD;
}

enum EENTITY_TYPE
{
	EENTITY_TYPE_AVATAR;
	EENTITY_TYPE_BUILDING;
	EENTITY_TYPE_ENEMY;
	
	EENTITY_TYPE_STAGE;	
	EENTITY_TYPE_HEXAGRID;
	EENTITY_TYPE_HEXAGRIDCELL;
	
	EENTITY_TYPE_ROOT;
	EENTITY_TYPE_CAMERA;
}

/*
 * 
 * La classe CEntity est destiné à contenir une ou plusieurs images
 * Elle peut s'apparenter au type movieClip mais dans un espace 3D
 * 
 */

class CEntity
{
	public	var m_Type				: EENTITY_TYPE;
	// Bounding box size
	public	var m_Size				: CV2D;
	
	public  var m_Coordinate		: CV2D;
	public	var m_Rotation			: Float;
	
	//private var m_State				: EENTITY_STATE;
	//private var m_StateAvailable	: CBitField;
	#if flash10
		public	var m_Sprite		: C2DImageAS;
	#else
		public	var m_Sprite		: C2DImage;
	#end
		
	public function new( _Type : EENTITY_TYPE )
	{
		//trace ( "\t \t [ -- new CEntity : " + _Type );
		
		m_Type			= _Type;
		m_Coordinate	= new CV2D( 0, 0 );
		m_Size			= new CV2D( 0, 0 );
		
		#if flash10
			m_Sprite	= new C2DImageAS();
		#else
			m_Sprite	= new C2DImage();;
		#end
		
		//trace ( "\t \t new CEntity -- ] ");
	}
	
	/* ENTITY STATE RELATIVE FUNCTIONS
	 */	/*		private function EES2Int( _State : EENTITY_STATE ) : Int
		{
			return switch( _State )
			{
				case 	EES_FULLLIFE	: 0;
				case 	EES_DEAD		: 1;
			}
		}*/

	/*
	 * SPRITE RELATIVE FUNCTIONS
	 */
		public	function SetSprite( _PathToImage : String ) : Result
		{
			m_Sprite.Load( _PathToImage );
			return SUCCESS;
		}
		
	/*
	 * POSITION (CV2D) RELATIVE FUNCTIONS
	 */
		// Return the value of the global coordonate
		public function GetCoordinate()	: CV2D
		{
			return m_Coordinate;
		}
		
		// Move the entity to a specified position
		public function SetPosition( _Pos : CV2D ) : Void
		{
			/* Entities are handled by the center whereas 
			 * "real images" are handled by the top left corner */
			
			m_Coordinate.Set( m_Size.x * 0.5, m_Size.y * 0.5 );	// Compute the half size
			CV2D.Sub( m_Coordinate, _Pos, m_Coordinate );		// Change coordinates centered
			m_Sprite.SetPosition( m_Coordinate );
			
			m_Coordinate.Copy( _Pos );
		}
		
		public function GetSize()	: CV2D
		{
			return m_Size;
		}
		
		public function SetSize( _Size : CV2D ) : Void
		{
			m_Size.Copy( _Size );
			/* Entities are handled by the center whereas 
			 * "real images" are handled by the top left corner
			 * Thus Coordinates need to be adjusted after resizing */
			m_Sprite.SetSize( _Size );
			SetPosition( m_Coordinate );
		}
}