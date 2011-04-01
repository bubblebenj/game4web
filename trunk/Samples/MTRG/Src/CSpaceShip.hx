/**
 * ...
 * @author de
 */

package ;

import flash.display.BlendMode;
import flash.display.GradientType;
import flash.display.SpreadMethod;
import flash.display.Shape;
import flash.display.Sprite;
import flash.geom.Matrix;
import flash.Vector;
import kernel.CDebug;
import math.Constants;
import math.Registers;
import math.Utils;

import kernel.Glb;

import math.CV2D;

enum AIBhv
{
	AI_Goto( _Pos : Float );
	AI_Idle;
}

enum ShapeIndex
{
	STD;
	SHOOT;
}

import CProjectile;
import algorithms.CPool;

class CSpaceShip implements Updatable
{
	public var m_AiTick : Float;
	public var m_Ship : Sprite; 
	
	private var m_Pos : Float ;
	
	public var  m_Shapes : Array<Shape>;
	public var  m_Bhv : AIBhv; 
	
	public var 	m_ShootSpin : Float;
	public var m_Hp(GetHp,SetHp) : Int;
	private var _Hp : Int;
	
	
	public static inline var MAX_LASERS = 16;
	public static inline var MAX_BOULETTE = 128;
	
	var m_LaserPool : CPool< CLaser >;
	var m_BoulettePool : CPool< CBoulette >;
	
	public function new() 
	{
		m_Ship = null;
		m_Pos = 0.5;
		m_Shapes = null;
		m_AiTick = 0.5;
		m_Bhv = AI_Idle;
		m_LaserPool = null;
		
		m_ShootSpin = 0;
	}

	public function IsLoaded() : Bool
	{
		return m_Ship != null;
	}
	
	//////////////////////////////////
	private function GetHp() : Int
	{
		return _Hp;
	}
	
	//////////////////////////////////
	private function SetHp(v : Int) : Int
	{
		_Hp = v;
		if( _Hp <= 0 )
		{
			OnDestroy();
		}
		return _Hp;
	}
	
	private function OnDestroy()
	{
		MTRG.s_Instance.m_Gameplay.GameOver(true);
	}
	
	public function Initialize() : Void 
	{
		m_ShootSpin = 0;
		m_Bhv = AI_Idle;
		m_AiTick = 0.5;
		m_Shapes = new Array<Shape>();
		m_Ship = new Sprite();
		
		var l_Vec : Vector<Float> = new Vector<Float>();
		var i = 0;
		l_Vec[i++] = 0; 	l_Vec[i++] = -16; 
		
		l_Vec[i++] = -24; 	l_Vec[i++] = 32;
		
		l_Vec[i++] = 0; 	l_Vec[i++] = 8;
		
		l_Vec[i++] = 0; 	l_Vec[i++] = 8;
		
		l_Vec[i++] = 24; 	l_Vec[i++] = 32;
		
		l_Vec[i++] = 0; 	l_Vec[i++] = -16; 
		
		//build standard shape
		{
			var l_PrimaryShape : Shape = new Shape();
			var l_GradientMatrix = new Matrix();
			
			l_PrimaryShape.graphics.lineStyle(3, 0xF2F807, 1.0);
			l_PrimaryShape.graphics.drawTriangles( l_Vec );
			l_PrimaryShape.graphics.beginFill( 0xD90E00 );
			
			l_PrimaryShape.graphics.drawTriangles( l_Vec );
			l_PrimaryShape.graphics.endFill();
			
			l_PrimaryShape.blendMode = BlendMode.ADD;
			l_PrimaryShape.cacheAsBitmap = true;
			l_PrimaryShape.visible = false;
			
			m_Shapes[m_Shapes.length] = l_PrimaryShape;
		}
		
		//build shooting shape
		{
			var l_PrimaryShape : Shape = new Shape();
			var l_GradientMatrix : Matrix = new Matrix();
			
			l_PrimaryShape.graphics.lineStyle(3, 0xF2F807, 1.0);
			l_PrimaryShape.graphics.drawTriangles( l_Vec );
			
			l_GradientMatrix.createGradientBox( 48,48, 0, -24,-36 );
			l_PrimaryShape.graphics.beginGradientFill( GradientType.RADIAL, [0xFFBB6E, 0xD90E00], [1, 1], [0, 255],l_GradientMatrix, SpreadMethod.PAD );
			
			l_PrimaryShape.graphics.drawTriangles( l_Vec );
			//l_PrimaryShape.graphics.drawRect( 200,200,100,100);
			l_PrimaryShape.graphics.endFill();
			
			l_PrimaryShape.blendMode = BlendMode.ADD;
			l_PrimaryShape.cacheAsBitmap = true;
			l_PrimaryShape.visible = false;
			
			m_Shapes[m_Shapes.length] = l_PrimaryShape;
		}
		
		var l_This = this ;
		Lambda.iter( 	m_Shapes,
						function(s)
						{
							l_This.m_Ship.addChild(s);
						}
					);
		
		Glb.GetRendererAS().AddToSceneAS( m_Ship );
		
		SetLinearPos( 0.5 );
		SetShapeIndex(SHOOT);
		

		m_LaserPool = new CPool<CLaser>( MAX_LASERS, new CLaser());
		Lambda.iter( m_LaserPool.Free(), function(ls) ls.Initialize() );
	}
	
	public function GetPosH( _Vec : CV2D )
	{ 
		_Vec.Set( m_Ship.x / MTRG.HEIGHT, m_Ship.y / MTRG.HEIGHT );
	}
	
	public static inline var BASE_LASER_SPEED = 0.4;
	
	public function DeleteLaser( _Ls : CLaser )
	{
		m_LaserPool.Destroy( _Ls );
	}
	
	public function Shoot()
	{
		//if (!m_LaserPool.isEmpty())
		{
			//var l_Len = m_LaserPool.length;
			
			var l_NewOne = m_LaserPool.Create();
			
			if ( l_NewOne == null ) return;
			
			l_NewOne.visible = true;
			
			var l_From : CV2D = Registers.V2DPool.Create();
			var l_To: CV2D = Registers.V2DPool.Create();
			
			GetPosH( l_From );
			l_To.Set( 0, -1 );
			
			CV2D.Add( l_To , l_From , l_To );
			
			l_NewOne.Fire(l_From, l_To, BASE_LASER_SPEED );
			
			Registers.V2DPool.Destroy( l_From );
			Registers.V2DPool.Destroy( l_To );
		
			SetShapeIndex(SHOOT);
		}
	}
	
	public function SetShapeIndex( _i : ShapeIndex )
	{
		var l_Index = Type.enumIndex( _i );
		for(i in 0...m_Shapes.length)
		{
			m_Shapes[i].visible = ( l_Index == i);
		}
	}
	
	public static inline var SHIP_BASELINE :Float =  MTRG.HEIGHT * 0.90;
	
	public static inline var SHIP_BASESPEED : Float = 0.1;
	public static inline var SHIP_AI_TICK_DURATION : Float = 0.5;
	
	public function SetLinearPos( _v : Float )
	{
		_v = Utils.Clamp(_v, 0, 1);
		var l_Base = Registers.V2_0;
		l_Base.x = MTRG.BOARD_X;
		l_Base.y = SHIP_BASELINE;
		
		l_Base.x += _v * MTRG.BOARD_WIDTH;
		
		m_Ship.x = l_Base.x;
		m_Ship.y = l_Base.y;
	}
	
	public function Update() : Void
	{
		switch( m_Bhv )
		{
			case AI_Goto(v):
				if( Math.abs(v - m_Pos) < Constants.EPSILON )
				{
					m_Bhv = AI_Idle;
					m_AiTick = SHIP_AI_TICK_DURATION;
				}
				else
				{
					var l_Len = Math.abs(v - m_Pos);
					var l_sign = (v > m_Pos ) ? 1 : -1;
					var l_Delta =  SHIP_BASESPEED * Glb.GetSystem().GetGameDeltaTime();
					if( l_Len <= Math.abs( l_Delta)  )
					{
						m_Pos = v;
						m_Bhv = AI_Idle;
						m_AiTick = SHIP_AI_TICK_DURATION;
					}
					else
					{
						m_Pos = m_Pos + l_sign * l_Delta;
					}
				}
			
			case AI_Idle:
				m_AiTick -= Glb.GetSystem().GetGameDeltaTime();
				if( m_AiTick <= 0 )
				{
					var l_sign = ( Math.random() > 0.5 ) ? 1 : -1;
					
					if ( m_Pos < 0.05 )
					{
						l_sign = 1;
					}
					
					if ( m_Pos > 0.95 )
					{
						l_sign = -1;
					}
					
					var l_Stabilized = l_sign * Math.random() * MTRG.BOARD_WIDTH * 0.25;
					l_Stabilized += l_Stabilized;
					l_Stabilized *= 0.5;
					
					var l_Goto = m_Pos + l_Stabilized / MTRG.BOARD_WIDTH;
					
					l_Goto = Utils.Clamp(l_Goto, 0, 1);
					m_Bhv = AI_Goto( l_Goto );
					m_AiTick = SHIP_AI_TICK_DURATION;
					//CDebug.CONSOLEMSG("Tick : pos = " + m_Pos +" => " + l_Goto);
				}
		}
		
		SetLinearPos(m_Pos);
		SetShapeIndex(STD);
		
		m_ShootSpin += Glb.GetSystem().GetGameDeltaTime();
		
		if (m_ShootSpin > 1.0 )
		{
			Shoot();
			m_ShootSpin = 0;
		}
		
		for(ls in Lambda.list(m_LaserPool.Used()) )
		{
			ls.Update();
		}
	}
	
	public function Shut() : Void 
	{
		m_Ship = null;
	}
	
}