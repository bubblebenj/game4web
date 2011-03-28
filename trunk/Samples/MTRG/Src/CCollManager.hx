/**
 * ...
 * @author de
 */

package ;
import algorithms.CBitArray;
import kernel.CDebug;

import math.CV2D;
import math.Registers;

enum COLL_CLASSES
{
	Asteroids;
	Aliens;
	Mothership;
	
	AlienShoots;
	SpaceShipShoots;
	Invalid;
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

#if debug
class TestCollidable implements BSphered
{
	public function new()
	{
		CenterX = 0;
		CenterY = 0;
		Radius = 0.5;
		
		CollClass = Invalid;
		CollSameClass = true;
	}
	
	public var CenterX : Float;
	public var CenterY : Float;
	public var Radius : Float;
	
	public var CollClass : COLL_CLASSES;
	public var CollSameClass : Bool;
	
	public function OnCollision( _Collider : BSphered ) : Void
	{
		
	}
}
#end

class CCollManager 
{
	var m_Objects : Array<BSphered>;
	var m_CollideMap : CBitArray;
	var m_IsProcessing : Bool;
	var m_DeleteQueue : List<BSphered>;
	
	public var m_LastFrameTestCount : Int;
	public var m_LastFrameHitCount : Int;
	
	public function new() 
	{
		m_Objects = new Array();
		m_CollideMap = new CBitArray(128);
		m_DeleteQueue = new List<BSphered>();
		m_LastFrameTestCount = 0;
		m_LastFrameHitCount = 0;
	}
	
	public static inline function TestCircleCircle( _Bs0 : BSphered, _Bs1 : BSphered) : Bool
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
		CDebug.ASSERT(_o != null);
		var l_index = Type.enumIndex( _o.CollClass );
		
		for( i in 0...m_Objects.length)
		{
			if ( l_index < Type.enumIndex(m_Objects[i].CollClass))
			{
				m_Objects.insert( i , _o);
				return;
			}
		}
		
		m_Objects.push( _o );
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
		
		#if debug
		m_LastFrameTestCount = 0;
		m_LastFrameHitCount = 0;
		#end
		
		#if debug
		for( i in 0...m_Objects.length-1)
		{
			CDebug.ASSERT( Type.enumIndex(m_Objects[i].CollClass) <=  Type.enumIndex(m_Objects[i + 1].CollClass) );
		}
		#end
		
		for( i in 0...m_Objects.length)
		{
			var c = m_Objects[i];
			var l_Next = i + 1;
			
			
			if(!c.CollSameClass)
			{
				while (	(m_Objects[l_Next] != null)
				&&		(c.CollClass == m_Objects[l_Next].CollClass))
				{
					l_Next++;
				}
			}
			
			for( j in l_Next...m_Objects.length )
			{
				var cprime = m_Objects[j];
				if( c != cprime )
				{
					#if debug
					m_LastFrameTestCount++;
					#end
					
					if ( 	
							!m_CollideMap.Is(i * m_Objects.length + j ) 
					&& 		TestCircleCircle(c,cprime ) )
					{
						//CDebug.CONSOLEMSG(">> (" + c.CenterX+"," + c.CenterY+") : "+c.Radius);
						//CDebug.CONSOLEMSG("<< (" + cprime.CenterX+"," + cprime.CenterY+") : "+cprime.Radius);
						c.OnCollision(cprime);
						cprime.OnCollision(c);
						
						m_CollideMap.Set( i * m_Objects.length + j, true);
						
						#if debug
						m_LastFrameHitCount++;
						#end
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
		
		#if debug
		if (	(m_LastFrameTestCount != 0)
		||		(m_LastFrameHitCount != 0 )
		)
		{
			//CDebug.CONSOLEMSG("Phy : Tests:" + m_LastFrameTestCount + " Hits :" +m_LastFrameHitCount);
		}
		#end
	}
	
	public function toString() : String
	{
		var l_Str = "CollMan";
		l_Str += "Len:" + m_Objects.length;
		
		for (i in 0...m_Objects.length)
		{
			var c = m_Objects[i];
			l_Str += "\n (" + c.CenterX + ","+c.CenterY+") : "+c.Radius;
		}
		
		return l_Str;
	}
	
	
	public static function UnitTest()
	{
		#if debug
		var l_C0 :TestCollidable= new TestCollidable();
		var l_C1 :TestCollidable= new TestCollidable();
		CDebug.ASSERT( TestCircleCircle( l_C0, l_C1) == true );
		
		l_C0.CenterX = 1;
		CDebug.ASSERT( TestCircleCircle( l_C0, l_C1) == true );
		
		l_C0.CenterX = 2;
		CDebug.ASSERT( TestCircleCircle( l_C0, l_C1) == false );
		#end
	}
	
}