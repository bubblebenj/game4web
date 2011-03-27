/**
 * ...
 * @author de
 */

package ;
import algorithms.CBitArray;

import math.CV2D;
import math.Registers;

enum COLL_CLASSES
{
	Asteroids;
	Aliens;
	Mothership;
	
	AlienShoots;
	SpaceShipShoots;
}

//coord are expressed in AspectH
interface BSphered
{
	public var CenterX : Float;
	public var CenterY : Float;
	public var Radius : Float;
	
	public var CollClass : COLL_CLASSES;
	public var CollSameClass : Bool;
	
	public function OnCollision( _Collider : BSphered ) : Void;	
}



class CCollManager 
{
	var m_Objects : Array<BSphered>;
	var m_CollideMap : CBitArray;
	var m_IsProcessing : Bool;
	var m_DeleteQueue : List<BSphered>;
	
	public function new() 
	{
		m_Objects = new Array();
		m_CollideMap = new CBitArray(128);
		m_DeleteQueue = new List<BSphered>();
	}
	
	public static function TestCircleCircle( _Bs0 : BSphered, _Bs1 : BSphered) : Bool
	{
		var l_Radius2 = _Bs0.Radius + _Bs1.Radius;
		l_Radius2 *= l_Radius2;
		
		Registers.V2_1.Set(_Bs0.CenterX, _Bs0.CenterY );
		Registers.V2_2.Set(_Bs1.CenterX, _Bs1.CenterY );
		
		var l_Diff :CV2D = CV2D.Sub( Registers.V2_0, Registers.V2_2 , Registers.V2_1 );
		var l_Len2 = l_Diff.Norm2();
		
		return( l_Radius2 >= l_Len2 );
	}
	
	public function Add( _o : BSphered )
	{
		var l_index = Type.enumIndex( _o.CollClass );
		
		for( i in 0...m_Objects.length)
		{
			if ( Type.enumIndex(m_Objects[i].CollClass) > l_index )
			{
				m_Objects.insert( i ,_o);
				break;
			}
		}
	}
	
	public function Remove(_o : BSphered )
	{
		if( m_IsProcessing )
		{
			m_DeleteQueue.add(_o);
			return;
		}
		
		for( i in 0...m_Objects.length)
		{
			if ( m_Objects[i] == _o )
			{
				m_Objects.splice( i , 1);
				break;
			}
		}
	}
	
	public function Update()
	{
		m_IsProcessing = true;
		m_CollideMap.Fill(false);
		
		for( i in 0...m_Objects.length)
		{
			var c = m_Objects[i];
			var l_Next = i + 1;
			
			if(!c.CollSameClass)
			{
				while(c.CollClass == m_Objects[l_Next].CollClass)
				{
					l_Next++;
				}
			}
			for( j in l_Next...m_Objects.length )
			{
				var cprime = m_Objects[i];
				if( c != cprime )
				{
					if ( 	
							!m_CollideMap.Is(i * m_Objects.length + j ) 
					&& 		TestCircleCircle(c,cprime ) )
					{
						c.OnCollision(cprime);
						cprime.OnCollision(c);
						m_CollideMap.Set( i * m_Objects.length + j, true);
					}
				}
			}
		}
		m_IsProcessing = false;
		
		if (m_DeleteQueue.length != 0)
		{
			for( b in m_DeleteQueue )
			{
				Remove( b );
			}
			m_DeleteQueue.clear();
		}
	}
}