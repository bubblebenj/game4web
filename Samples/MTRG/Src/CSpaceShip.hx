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
using Lambda;
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
import CCollManager;

class CSpaceShip implements Updatable, implements BSphered
{
	public var m_AiTick : Float;
	public var m_Ship : Sprite; 
	
	private var m_Pos : Float ;
	
	public var  m_Shape : Shape;
	public var  m_Bhv : AIBhv; 
	
	public var 	m_ShootSpin : Float;
	
	public var m_Hp(GetHp,SetHp) : Int;
	private var _Hp : Int;
	
	public var m_Center: CV2D;
	public var m_Radius : Float;
	
	public var m_CollClass : COLL_CLASS;
	public var m_CollMask : Int;
	
	public var m_CollShape : COLL_SHAPE;
	
	public static inline var MAX_LASERS = 16;
	public static inline var MAX_BOULETTE = 128;
	
	//imporvement, gather code and refactor with motherships
	private var m_LifeBar : Shape;
	private var m_LifeBarContainer : Shape;
	
	var m_LaserPool : CPool< CLaser >;
	
	private var m_MaxHp : Int;
	
	public function new() 
	{
		m_Ship = null;
		m_Pos = 0.5;
		m_AiTick = 0.5;
		m_Bhv = AI_Idle;
		m_LaserPool = null;
		
		m_ShootSpin = 0;
		m_CollClass = SpaceShip;
		m_Radius = 8 / MTRG.HEIGHT;
		m_CollShape = Sphere;
		m_Center = new CV2D(0, 0);
		
		m_CollMask = (	(1 << Type.enumIndex(Asteroids))
		|				(1 << Type.enumIndex(Aliens))
		|				(1 << Type.enumIndex(AlienShoots)) );
		
		m_MaxHp = 100;
		m_Hp = m_MaxHp;
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
		var l_OldHp = _Hp;
		_Hp = v;
		
		if( _Hp <= 0 )
		{
			OnDestroy();
		}
		else if( v <= l_OldHp )
		{
			OnHit();
		}
		return _Hp;
	}
	
	private function OnHit()
	{
		UpdateLifeBar();
		//CDebug.CONSOLEMSG("Ship hit!");
		var l_This = this;
		MTRG.s_Instance.m_Gameplay.m_Tasks.push( new CTimedTask(function(ratio)
																{
																	l_This.m_Ship.blendMode = SUBTRACT;
																	
																	if (ratio >= 1.0)
																	{
																		l_This.m_Ship.blendMode = NORMAL;
																	}
																}
																,0.1,0) );
	}
	
	//ship doesn handle anything
	public function OnCollision( _Collider : BSphered ) : Void
	{
		
	}
	
	private function OnDestroy()
	{
		UpdateLifeBar();
		
		MTRG.s_Instance.m_Gameplay.GameOver(true);
	}
	
	public function Initialize() : Void 
	{
		m_ShootSpin = 0;
		m_Bhv = AI_Idle;
		m_AiTick = 0.5;
		m_Ship = new Sprite();
		
		var l_Vec : Vector<Float> = new Vector<Float>();
		var i = 0;
		l_Vec[i++] = 0; 	l_Vec[i++] = -16; 
		
		l_Vec[i++] = -24; 	l_Vec[i++] = 32;
		
		l_Vec[i++] = 0; 	l_Vec[i++] = 8;
		
		l_Vec[i++] = 0; 	l_Vec[i++] = 8;
		
		l_Vec[i++] = 24; 	l_Vec[i++] = 32;
		
		l_Vec[i++] = 0; 	l_Vec[i++] = -16; 
		
		var l_PrimaryShape : Shape = new Shape();
		{
		
			var l_GradientMatrix = new Matrix();
			
			l_PrimaryShape.graphics.lineStyle(3, 0xF2F807, 1.0);
			l_PrimaryShape.graphics.drawTriangles( l_Vec );
			l_PrimaryShape.graphics.beginFill( 0xD90E00 );
			
			l_PrimaryShape.graphics.drawTriangles( l_Vec );
			l_PrimaryShape.graphics.endFill();
			
			l_PrimaryShape.blendMode = BlendMode.ADD;
			l_PrimaryShape.cacheAsBitmap = true;
			l_PrimaryShape.visible = true;
		}
		
		m_Ship.addChild(l_PrimaryShape);
	
		
		Glb.GetRendererAS().AddToSceneAS( m_Ship );
		
		SetLinearPos( 0.5 );
		m_Ship.visible = false;

		m_LaserPool = new CPool<CLaser>( MAX_LASERS, new CLaser());
		Lambda.iter( m_LaserPool.Free(), function(ls) ls.Initialize() );
		MTRG.s_Instance.m_Gameplay.m_CollMan.Add(this);
		
		{
			m_LifeBarContainer = new Shape();
			m_LifeBarContainer.graphics.clear();
			
			m_LifeBarContainer.graphics.lineStyle(8, 0xFF0000);
			m_LifeBarContainer.graphics.moveTo(MTRG.BOARD_X,MTRG.HEIGHT - 16);
			m_LifeBarContainer.graphics.lineTo(MTRG.BOARD_X + MTRG.BOARD_WIDTH - 32, MTRG.HEIGHT - 16);
			m_LifeBarContainer.visible = false;
			Glb.GetRendererAS().AddToSceneAS(m_LifeBarContainer);
			
			m_LifeBar = new Shape();
			m_LifeBar.visible = false;
			Glb.GetRendererAS().AddToSceneAS(m_LifeBar);
			UpdateLifeBar();
		}
	}
	
	public function UpdateLifeBar()
	{
		if ( m_LifeBar != null)
		{
			m_LifeBar.graphics.clear();
			m_LifeBar.graphics.moveTo(MTRG.BOARD_X,MTRG.HEIGHT - 16);
			m_LifeBar.graphics.lineStyle(8, 0x00FF00);
			var l_width = MTRG.BOARD_WIDTH - 32;
			m_LifeBar.graphics.lineTo( MTRG.BOARD_X + (l_width * (m_Hp / m_MaxHp)) ,MTRG.HEIGHT - 16);
			m_LifeBar.cacheAsBitmap = true;
		}
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
	
	public function SetVisible( _OnOff )
	{
		m_LifeBar.visible = _OnOff;
		m_LifeBarContainer.visible = _OnOff;
		m_Ship.visible = _OnOff;
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
		
		m_Center.x = l_Base.x / MTRG.HEIGHT;
		m_Center.y = l_Base.y / MTRG.HEIGHT;
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
		m_LaserPool.Free().iter( function(l) l.Shut() );
		m_LaserPool.Used().iter( function(l) l.Shut() );
		
		m_LaserPool.Reset();
		m_LaserPool = null;
		MTRG.s_Instance.m_Gameplay.m_CollMan.Remove(this);
		Glb.GetRendererAS().RemoveFromSceneAS( m_Ship );
		m_Ship = null;
	}
	
}