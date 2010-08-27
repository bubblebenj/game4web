﻿package game.beegon;

/**
 * ...
 * @author bdubois
 */

import game.beegon.CEntity;
import kernel.Glb;

import math.CV2D;
import math.CHexagone;
import math.Registers;

import rsc.CRsc;

/*
 * THIS REPRESENTATION IS NO MORE IN USE :
 * Please consider a -Pi/6 rotation to fit the actual implementation (x axis is horizontal).
 *                    ______
 *                   /      \
 *            ______/  2,-2  \______                   
 *           /      \        /      \                 * x axis
 *    ______/  1,-2  \______/  2,-1  \______  
 * * /      \        /      \        /      \ *
 *  /  0,-2  \______/  1,-1  \______/  2, 0  \
 *  \      * /      \        /      \*       /
 *   \______/  0,-1  \______/  1, 0  \______/
 *   /      \      * /      \*       /      \
 *  / -1,-1  \______/  0, 0  \______/  1, 1  \
 *  \        /      \*     * /      \        /
 *   \______/ -1, 0  \______/  0, 1  \______/
 *   /      \*       /      \      * /      \
 *  / -2, 0  \______/ -1, 1  \______/  0, 2  \
 *  \*       /      \        /      \      * /
 *   \______/ -2, 1  \______/ -1, 2  \______/
 *          \        /      \        /             * y axis
 *           \______/ -2, 2  \______/
 *                  \        /
 *                   \______/
 */
class CHexaGrid
{
	/*
	 * HEXA GRID AXIS UNITARY VECTOR
	 */
		static var v_x : CV2D	= new CV2D( 1, 0 );
		static var v_y : CV2D	= new CV2D( 0, 1 );
		static var v_z : CV2D	= new CV2D( 1,-1 );
		
	public var m_CellArray		: Array<Array<CHexaGridCell>>;
	/*
	 * The grid size is the number of cell around the center cell.
	 */
	public var m_GridRadius		: Int;
	/*
	 * The cell size is the size of the smaller diagonal,
	 * i.e the distance between the center of two opposite sides.
	 */
	public var m_CellSize		: Float;
	
	private var m_Coordinate	: CV2D;
	
	private var m_Ready			: Bool;
	
	public function new( _GridRadius : Int, _CellSize: Float )	: Void
	{
		#if CHexaGrid
			trace( "\t [ -- new CHexaGrid" );
		#end
		
		m_CellSize		= _CellSize;
		m_GridRadius	= ( _GridRadius > 1 ) ? _GridRadius 	: 1;
		m_Coordinate	= new CV2D( Glb.g_System.m_Display.m_Width, Glb.g_System.m_Display.m_Height );
		CV2D.Scale( m_Coordinate, 0.5, m_Coordinate );
		m_Ready			= false;
		#if CHexaGrid
			trace( "\t new CHexaGrid -- ]" );
		#end
	}
	
	public function LargerDiameter()				: Float
	{
		return ( m_CellSize * CHexagone.m_IsoceleHeightToSideCoef );
	}
	
	public function InitCellArray()					: Void
	{
		#if CHexaGrid
			trace( "\t [ -- InitCellArray()" );
		#end
		m_CellArray	= new Array();
		
		for (i in (-m_GridRadius) ... (m_GridRadius+1))
		{
			m_CellArray[i] = new Array();

			for (j in -(m_GridRadius) ... m_GridRadius +1)
			{	
				if ( DistCell( 0, 0, i, j) <= m_GridRadius )
				{
					#if CHexaGrid
						//trace ( "\t[" + i +"][" + j + "] Dist : " + DistCell( 0, 0, i, j) );
					#end
					AddCell( i, j );
				}
			}
		}
		#if CHexaGrid
			trace( "\t InitCellArray() -- ]" );
		#end
		Fill();
	}
	
	private function AddCell( _x : Int, _y : Int )	: Void
	{
		m_CellArray[_x][_y] = new CHexaGridCell( m_CellSize );
	}
	
	public function Fill()				: Void
	{
		var l_Cnt_Row	: Int = 0;
		var l_Cnt_Col	: Int;
		for ( i in ( -m_GridRadius) ... (m_GridRadius + 1) )
		{
			l_Cnt_Col	= l_Cnt_Row;
			for ( j in ( -m_GridRadius) ... (m_GridRadius + 1) )
			{
				if ( m_CellArray[i][j] != null )
				{
					switch( l_Cnt_Col + 1)
					{
						case 1 : m_CellArray[i][j].SetSprite( "./Data/vertical_hexcell1.png" );
						case 2 : m_CellArray[i][j].SetSprite( "./Data/vertical_hexcell2.png" );
						case 3 : m_CellArray[i][j].SetSprite( "./Data/vertical_hexcell3.png" );
					}
				}
				l_Cnt_Col = if ( l_Cnt_Col == 2 ) 0 else l_Cnt_Col + 1 ;
			}
			l_Cnt_Row = if ( l_Cnt_Row == 0 ) 2 else l_Cnt_Row - 1 ;
		}
	}
	
	private function IsReady()	: Bool
	{
		if ( m_Ready == true )
			return true;
		else
		{
			for ( i in ( -m_GridRadius) ... (m_GridRadius + 1) )
			{
				for ( j in ( -m_GridRadius) ... (m_GridRadius + 1) )
				{
					if ( m_CellArray[i][j] != null )
					{
						//if ( m_CellArray[i][j].m_Sprite.IsReady() )
						//{
							//return false;
						//}
					}
				}
			}
			m_Ready = true;
			return true;
		}
	}
	
	public function Update() : Void
	{
		//if ( IsReady() )
		//{
			for ( i in ( -m_GridRadius) ... (m_GridRadius + 1) )
			{	
				for ( j in ( -m_GridRadius) ... (m_GridRadius + 1) )
				{
					//trace( "if ( m_CellArray["+i+"]["+j+"] == "+m_CellArray[i][j]+" )");
					if ( m_CellArray[i][j] != null )
					{
						Registers.V2_8.Set( i, j );									// Coordinates in the hexa grid
						FromHexaToOrtho( Registers.V2_8, Registers.V2_8 );			// Getting orthonormal coordinates
						CV2D.Add( Registers.V2_8, m_Coordinate, Registers.V2_8 );	// Setting relative to grid coordinates
						m_CellArray[i][j].SetPosition( Registers.V2_8 );
					}
				}
			}
		//}
	}
	public function Draw()				: Void
	{
		
	}
	
	/*
	 *  Arguments:
	 *      xA, yB      coordinate pair for first hex : A
	 *      xA, yB      coordinate pair for second hex : B
	 *
	 *  Returns:
	 *      distance    the distance between hexacells in steps
	 */
	public function DistCell( _xA : Int, _yA: Int, _xB : Int , _yB : Int )	: Int	{
		/* apply a translation to A and B off value -A
		 * thus new value of A is (0,0) --> this origine of the grid
		 * and new value off B is ( _xB-_xA , _yB-yA )
		 * then the distance to calculate is from B to the origine
		 */
		
		var l_Distance	: Int	= 0;
		var l_xB		: Int	= _xB - _xA;
		var l_yB		: Int	= _yB - _yA;
		
		var l_xSign		: Int	= if ( l_xB < 0 ) -1 else 1;
		var l_ySign		: Int	= if ( l_yB < 0 ) -1 else 1;
		
		if(	( l_xSign ==  v_z.x	&&	l_ySign ==  v_z.y ) 
		 ||	( l_xSign == -v_z.x	&&	l_ySign == -v_z.y ) )
			l_Distance	= cast ( Math.max( Math.abs( l_xB), Math.abs( l_xB) ) );
		else
			l_Distance	= cast ( Math.abs( l_xB) + Math.abs( l_yB ) );
		
		return l_Distance;
	}
	
	/* 
	 * CONVERTING HEXA VECTOR TO ORTHONORMAL COORDONATE FUNCTIONS
	 */
		public function HexaToOrtho_v_x( _VOut : CV2D )	: Void
		{
			/*
			 * For an hexagrid with horizontal cells
			 * ( x axis going slightly up and y axis going slightly down )
			 * use this values intead :
			 * _VOut.Set( 0.75 * LargerDiameter(), -(m_CellSize/2) );
			 * 
			 * for an hexagrid with vertical cells
			 * (x axis going horizontaly and y axis going slightly (but a little faster) )down
			 * use it :
			 */
			_VOut.Set( m_CellSize, 0 );
		}
		
		public function HexaToOrtho_v_y( _VOut : CV2D )	: Void
		{
			/*
			 * For an hexagrid with horizontal cells (Cf. "public function Coord_v_x(): CV2D" comment)
			 * use this values intead :
			 * _VOut.Set( 0.75 * LargerDiameter(), -(m_CellSize/2) );
			 * 
			 * for an hexagrid with vertical cells, use it :
			 */
			_VOut.Set( m_CellSize/2, 0.75 * LargerDiameter() );
		}
		
		public function HexaToOrtho_v_z( _VOut : CV2D )	: Void
		{
			/*
			 * = v_x - v_y, but instead of compute it with
			 * 		v = v_x();
			 * 		v.decrementBy( v_y() );
			 * we'll put the solved fomula.
			 */
			
			/*
			 * For an hexagrid with horizontal cells (Cf. "public function Coord_v_x(): CV2D" comment)
			 * use this values intead :
			 * _VOut.Set( 0, -m_CellSize );
			 * 
			 * for an hexagrid with vertical cells, use it :
			 */
			_VOut.Set( -(m_CellSize/2) , 0.75 * LargerDiameter() );
		}
	
	/* 
	 * CONVERTING ORTHONORMAL COORDONATE TO HEXA VECTOR FUNCTIONS */ 
	/*
		public function OrthoToHexa_v_x( _VOut : CV2D )	: Void
		{
		
		}
		
		public function OrthoToHexa_v_y( _VOut : CV2D )	: Void
		{
		
		}
		
		public function OrthoToHexa_v_z( _VOut : CV2D )	: Void
		{
		
		}
	*/
		
	/*
	 * SWAP BETWEEN HEXA GRID TO ORTHONORMAL COORDONATE FUNCTIONS
	 */
		public function FromHexaToOrtho( _VOut : CV2D, _CellCoord : CV2D )	: Void
		{
			var a			: Float	= m_CellSize;
			var b			: Float	= 0.5 * m_CellSize;
			var c			: Float	= 0.0;
			var d			: Float	= 0.75 * LargerDiameter();
			
			var	x			: Float = a * _CellCoord.x + b * _CellCoord.y;
			var y			: Float = c * _CellCoord.x + d * _CellCoord.y;
			
			_VOut.Set( x, y );
		}
		
		public function FromOrthoToHexa( _VOut : CV2D, _Ortho : CV2D )	: Void
		{
			var a			: Float	= m_CellSize;
			var b			: Float	= 0.5 * m_CellSize;
			var c			: Float	= 0.0;
			var d			: Float	= 0.75 * LargerDiameter();
			
			var l_Factor	: Float = 1 / ( a * d + b * c );
			
			var	x			: Float = Math.round( l_Factor * ( d * _Ortho.x - b * _Ortho.y ) );
			var y			: Float = Math.round( l_Factor * ( a * _Ortho.y - c * _Ortho.x ) );
			
			_VOut.Set( x, y );
		}
}