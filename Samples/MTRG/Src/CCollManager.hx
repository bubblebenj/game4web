/**
 * ...
 * @author de
 */

package ;
import algorithms.CBitArray;
import kernel.CDebug;

import math.CV2D;
import math.Registers;

enum COLL_CLASS
{
	Asteroids;
	Aliens;
	
	AlienShoots;
	SpaceShipShoots;
	Invalid;
}

enum COLL_SHAPE
{	
	Sphere;
	AARect( _Height : Float);//append to radius
}

//coord are expressed in AspectH
interface BSphered
{
	public var m_Center: CV2D;
	public var m_Radius : Float;
	
	public var m_CollClass : COLL_CLASS;
	public var m_CollSameClass : Bool;
	
	public var m_CollShape : COLL_SHAPE;
	
	public function OnCollision( _Collider : BSphered ) : Void;	
}

#if debug
class TestCollidable implements BSphered
{
	public function new()
	{
		m_Center = new CV2D(0,0);
		m_Radius = 0.5;
		
		m_CollClass = Invalid;
		m_CollSameClass = true;
		m_CollShape = Sphere;
	}
	
	public var m_Center : CV2D;
	public var m_Radius : Float;
	
	public var m_CollClass : COLL_CLASS;
	public var m_CollShape : COLL_SHAPE;
	public var m_CollSameClass : Bool;
	
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
	
	public static inline function TestCircleCircle( 	_V0 : CV2D, _R0 : Float,
														_V1 : CV2D, _R1 : Float
	) : Bool
	{
		var l_Radius2 :Float= _R0 + _R1;
		l_Radius2 *= l_Radius2;
		var l_DiffX :Float=  _V1.x - _V0.x;
		var l_DiffY :Float=  _V1.y - _V0.y;
		var l_Len2 :Float = l_DiffX * l_DiffX +  l_DiffY * l_DiffY;
		return( l_Radius2 >= l_Len2 );
	}
	
	public static inline function TestCircleVtx( 	_V0 : CV2D, _R0 : Float,
													_V1 : CV2D
	) : Bool
	{
		var l_Radius2 :Float= _R0*_R0;
		var l_DiffX :Float=  _V1.x - _V0.x;
		var l_DiffY :Float=  _V1.y - _V0.y;
		var l_Len2 :Float = l_DiffX * l_DiffX +  l_DiffY * l_DiffY;
		return( l_Radius2 >= l_Len2 );
	}
	
	//P0 = TL  P1 = BR
	public static function TestCircleRect( 	_V0 : CV2D, _R0 : Float,
											_P0 : CV2D, _P1 : CV2D
	) : Bool
	{
		var l_RectCenter : CV2D  = Registers.V2DPool.Create();
		
		CV2D.Add( l_RectCenter , _P0, _P1);
		CV2D.Scale( l_RectCenter, 0.5, l_RectCenter);

		var l_IsInBS : Bool = TestCircleCircle(l_RectCenter, CV2D.GetDistance( _P0, l_RectCenter) , _V0, _R0);
		
		Registers.V2DPool.Destroy(l_RectCenter);
		
		if (!l_IsInBS)
		{
			return false;
		}
		
		trace("v:" +_V0+ "r:"+_R0);
		trace("p0:" +_P0+ "p1:"+_P1);

		var l_Res=( 	_V0.x - _R0 < _P1.x 
		&& 				_V0.x + _R0 > _P0.x 
		&&				_V0.y + _R0 > _P0.y 
		&& 				_V0.y - _R0 < _P1.y );
	
		
		return l_Res;
	}
	
	public static function TestRectRect( 	_P00 : CV2D, _P01 : CV2D,
											_P10 : CV2D, _P11 : CV2D
	) : Bool
	{
		
		//easy dude
		if ( _P00.x > _P11.x)
		{
			return false;
		}
		
		if ( _P01.x < _P10.x)
		{
			return false;
		}
		
		if ( _P01.y < _P10.y)
		{
			return false;
		}
		
		if ( _P00.y > _P11.y)
		{
			return false;
		}
		
		return true;
	}
	
	
	public function Add( _o : BSphered )
	{
		CDebug.ASSERT(_o != null);
		var l_index = Type.enumIndex( _o.m_CollClass );
		
		for( i in 0...m_Objects.length)
		{
			if ( l_index < Type.enumIndex(m_Objects[i].m_CollClass))
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
	
	public static function IsColliding( _O0 : BSphered, _O1 : BSphered) : Bool
	{
		return switch(_O0.m_CollShape )
		{
			case Sphere:
				TestCircleCircle(_O0.m_Center, _O0.m_Radius, _O1.m_Center, _O1.m_Radius ) ;
			
			case AARect(r0):
				switch( _O1.m_CollShape)
				{
					case Sphere: 
						var l_Vec : CV2D = Registers.V2DPool.Create();
						l_Vec.Set(_O0.m_Radius, r0);
						CV2D.Add( l_Vec, _O0.m_Center, l_Vec);
						var l_Res = TestCircleRect(_O1.m_Center, _O1.m_Radius, _O0.m_Center, l_Vec ) ;
						Registers.V2DPool.Destroy(l_Vec);
						l_Res;
						
					case AARect(r1):
						var l_V0: CV2D = Registers.V2DPool.Create();
						var l_V1: CV2D = Registers.V2DPool.Create();
						l_V0.Set(_O0.m_Radius, r0);
						l_V1.Set(_O1.m_Radius, r1);
						CV2D.Add( l_V0, _O0.m_Center, l_V0);
						CV2D.Add( l_V1, _O1.m_Center, l_V1);
						var l_Res = TestRectRect(_O1.m_Center, l_V0, _O1.m_Center, l_V1 ) ;
						Registers.V2DPool.Destroy(l_V0);
						Registers.V2DPool.Destroy(l_V1);
						l_Res;
				}
		};
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
			CDebug.ASSERT( Type.enumIndex(m_Objects[i].m_CollClass) <=  Type.enumIndex(m_Objects[i + 1].m_CollClass) );
		}
		#end
		
		for( i in 0...m_Objects.length)
		{
			var c = m_Objects[i];
			var l_Next = i + 1;
			
			
			if(!c.m_CollSameClass)
			{
				while (	(m_Objects[l_Next] != null)
				&&		(c.m_CollClass == m_Objects[l_Next].m_CollClass))
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
					
					if ( 	!m_CollideMap.Is(i * m_Objects.length + j ) 
					&&		IsColliding(c,cprime))
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
			l_Str += "\n (" + c.m_Center.x + ","+c.m_Center.y+") : "+c.m_Radius;
		}
		
		return l_Str;
	}
	
	
}