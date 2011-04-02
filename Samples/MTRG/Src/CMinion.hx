/**
 * ...
 * @author de
 */

package ;

import algorithms.CPool;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.BlendMode;
import flash.display.DisplayObject;
import flash.display.GradientType;
import flash.display.Shape;
import flash.display.Sprite;
import CCollManager;
import flash.geom.ColorTransform;
import flash.geom.Matrix;
import flash.Vector;
import math.Interp;
import math.RandomEx;
import math.Registers;
import math.Utils;
import kernel.CDebug;
import kernel.Glb;
import math.CV2D;
import CProjectile;

enum EMinions
{
	SpaceInvaders;
	Shielders;
	Perforators;
	Crossars;
	
	Count;
}


//since i cannot store my constants in pooled object let's do different
//this is the root of dance 
class Constants
{
	public static var CUR_SV_DANCE : CV2D = new CV2D(0, 0);
	public static inline var CIRCLE_SPEED : Float = 0.005;
	public static inline var PERFORATOR_SPEED : Float = 0.1;
	public static inline var CROSS_SPEED : Float =  0.3;
	public static inline var BASE_SV_BOULETTE_SPEED : Float = 0.15; 
	
	
	public static function Update()
	{
		
	}
}

class CMinion extends Sprite , implements Updatable, implements BSphered
{
	public var m_Center : CV2D;
	public var m_Radius : Float;
	
	public var m_CollClass : COLL_CLASS;
	public var m_CollShape : COLL_SHAPE;
	public var m_CollMask : Int;
	
	public var m_Hp(GetHp,SetHp) : Int;
	private var _Hp : Int;
	
	private var m_ImgNormal : DisplayObject;
	private var m_ImgHit : DisplayObject;
	
	private var m_ShootDelay : Float;
	private var m_ShootTimer : Float ;
	
	private var m_Level: Int;
	public var m_HasAI(default, SetHasAi) : Bool;
	public var m_CollDmg : Int;
	public var m_BaseHp : Int;
	
	public function new() 
	{
		super();
		m_ShootTimer = 0;
		m_ShootDelay = 0;
		m_ImgNormal = null;
		m_ImgHit = null;
		m_CollClass = Aliens;
		m_CollShape =  Sphere;
		m_Center = new CV2D(0,0);
		m_Radius = 8 / MTRG.HEIGHT;
		m_Level = 0;
		m_HasAI = false;
		m_CollDmg = 50;
		m_Hp = 10;
		m_BaseHp = 10;
		
		m_CollMask = ( 	(1 << Type.enumIndex(Asteroids))
		|				(1 << Type.enumIndex(SpaceShip))
		|				(1 << Type.enumIndex(SpaceShipShoots)));
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

	public function OnHit()
	{
		var l_This = this;
		//trace("onhit");
		MTRG.s_Instance.m_Gameplay.m_Tasks.push( new CTimedTask(function(ratio)
																{
																	l_This.m_ImgNormal.blendMode = ADD;
																	
																	if (ratio >= 1.0)
																	{
																		l_This.m_ImgNormal.blendMode = NORMAL;
																	}
																}
																,0.1,0) );
	}
	
	
	private function SetHasAi( _OnOff ) 
	{
		if (!m_HasAI&&_OnOff)
		{
			OnEnable();
			Think();
		}
		m_HasAI = _OnOff;
		
		return m_HasAI;
	}
	
	//////////////////////////////////
	private function OnDestroy()
	{
		MTRG.s_Instance.m_Gameplay.m_MinionHelper.Delete(this);
		MTRG.s_Instance.m_Gameplay.m_CollMan.Remove(this);

		var l_This = this;
		MTRG.s_Instance.m_Gameplay.m_Tasks.push( new CTimedTask(function(ratio)
																{
																	l_This.m_ImgNormal.visible = false;
																	l_This.m_ImgHit.visible = true;
																	l_This.alpha = 1.0 - ratio;
																	if (l_This.alpha == 0)
																	{
																		l_This.visible = false;
																	}
																}
																,0.15,0) );
	}
	
	//////////////////////////////////
	public function OnCollision( _Collider : BSphered  )
	{
		switch( _Collider.m_CollClass )
		{
			case SpaceShip: 
			var l_Ship :  CSpaceShip = cast _Collider;
			l_Ship.m_Hp -= m_CollDmg;
			
			case Asteroids: 
			m_Hp -= 100;
			
			default: CDebug.CONSOLEMSG("Minion collided something ");
		}
	}
	
	//////////////////////////////////
	public function Initialize()
	{
		CDebug.BREAK("Override me");
	}
	
	//////////////////////////////////
	public function ProcessNextPosition()
	{
		CDebug.BREAK("Override me");
	}
	
	//////////////////////////////////
	public function IsLoaded()
	{
		return m_ImgNormal != null && m_ImgHit != null;
	}
	
	//////////////////////////////////
	public function Update()
	{
		if ( m_HasAI )
		{
			ProcessNextPosition();
		}
		
		x = m_Center.x * MTRG.HEIGHT; // aka (m_Img.x /  MTRG.WIDTH) *  (MTRG.WIDTH / MTRG.HEIGHT);
		y = m_Center.y * MTRG.HEIGHT;
		
		if ( m_HasAI )
		{
			m_ShootTimer += Glb.GetSystem().GetGameDeltaTime();
			if ( m_ShootTimer >= m_ShootDelay )
			{
				Shoot();
				m_ShootTimer  = 0;
			}
		}
	}
	
	//////////////////////////////////
	public function Shut()
	{
		Glb.GetRendererAS().RemoveFromSceneAS(this);
		m_ImgNormal = null;
		m_ImgHit = null;
	}
	
	//////////////////////////////////
	public function Shoot()
	{
		CDebug.BREAK("Override me");
	}
	
	public function Think()
	{
		
	}
	
	
	//good idea is to turn on hp, colls
	public function OnEnable()
	{
		MTRG.s_Instance.m_Gameplay.m_CollMan.Add(this);
		m_Hp = m_BaseHp;
	}
}


class CSpaceInvaderMinion extends CMinion
{
	//////////////////////////////////
	public function new()
	{
		super();
		m_BaseHp = 10;
	}

	//putting inline causes compiler issue when bulding pools...oh my gosh
	public var SI_SIZE : Int;
	
	
	
	public override function OnEnable()
	{
		super.OnEnable();
		
	}
	
	//////////////////////////////////
	public override function Initialize()
	{
		SI_SIZE = 32;
		var l_BmpData : BitmapData = cast MTRG.s_Instance.m_Gameplay.m_RscSpaceInvader.GetDriverImage();
		CDebug.ASSERT( null != MTRG.s_Instance.m_Gameplay.m_RscSpaceInvader.GetDriverImage() );
		var l_Bmp = new Sprite();
		CDebug.ASSERT( l_Bmp != null );
		m_ImgNormal = l_Bmp;
		
		l_Bmp.graphics.beginBitmapFill( cast MTRG.s_Instance.m_Gameplay.m_RscSpaceInvader.GetDriverImage());
		l_Bmp.graphics.drawRect(0, 0, 64, 64);
		l_Bmp.graphics.endFill();
		l_Bmp.x = - SI_SIZE / 2;
		l_Bmp.y = - SI_SIZE / 2 ;
		l_Bmp.scaleX = SI_SIZE / 64;
		l_Bmp.scaleY = SI_SIZE / 64;
		
		l_Bmp.transform.colorTransform = new ColorTransform(1,0,0);
		
		var l_BmpHit = new Sprite( );
		m_ImgHit = l_BmpHit;
		
		l_BmpHit.visible = false;
		
		l_BmpHit.graphics.beginBitmapFill( cast MTRG.s_Instance.m_Gameplay.m_RscSpaceInvader.GetDriverImage());
		l_BmpHit.graphics.drawRect(0, 0, 64, 64);
		l_BmpHit.graphics.endFill();
		
		l_BmpHit.x = - SI_SIZE / 2;
		l_BmpHit.y = - SI_SIZE / 2 ;
		l_BmpHit.scaleX = SI_SIZE / 64;
		l_BmpHit.scaleY = SI_SIZE / 64;
		
		
		addChild( m_ImgHit );
		addChild( m_ImgNormal);
		visible = false;
		Glb.GetRendererAS().AddToSceneAS(this);
		
		m_ShootDelay = 3;
		
	}
	
	//////////////////////////////////
	public override function Update()
	{
		super.Update();
	}
	
	
	//////////////////////////////////
	public override function Shoot()
	{
		var l_NewOne = MTRG.s_Instance.m_Gameplay.m_ProjectileHelper.m_CBoulettePool.Create();
			
		if ( l_NewOne == null ) return;
		
		l_NewOne.visible = true;
		
		var l_To: CV2D = Registers.V2DPool.Create();
		
		l_To.Set( 0, 1 );
		
		CV2D.Add( l_To , m_Center , l_To );
		
		l_NewOne.Fire(m_Center, l_To, Constants.BASE_SV_BOULETTE_SPEED );
		
		Registers.V2DPool.Destroy( l_To );
	}
	
	//////////////////////////////////
	public override function ProcessNextPosition()
	{
	}
	
}

enum CircleBHV
{
	WanderMother;
	Oscillate( _PosX : Float,_PosY : Float);
}

class CSpaceCircleMinion extends CMinion
{
	public function new()
	{
		super();
		m_BaseHp = 30;
	}

	
	
	public override function OnEnable()
	{
		super.OnEnable();
	}
	
	var m_ThinkTimer : Float ;
	var m_BHV : CircleBHV;
	var m_Dir : CV2D;
	
	//////////////////////////////////
	public override function Initialize()
	{
		var l_BmpData : BitmapData = cast MTRG.s_Instance.m_Gameplay.m_RscSpaceInvader.GetDriverImage();
		CDebug.ASSERT( null != MTRG.s_Instance.m_Gameplay.m_RscSpaceInvader.GetDriverImage() );

		//build standard shape
		{
			var l_PrimaryShape : Shape = new Shape();
			var l_GradientMatrix : Matrix = new Matrix();
			
			l_GradientMatrix.createGradientBox( 12,12, 0, -12,-12 );
			l_PrimaryShape.graphics.beginGradientFill( GradientType.RADIAL, [0xCCC5BE , 0x302B1D], [1, 1], [0, 255],l_GradientMatrix, flash.display.SpreadMethod.PAD );
			l_PrimaryShape.graphics.drawCircle( 0, 0,12);
			l_PrimaryShape.graphics.endFill();
			
			l_PrimaryShape.graphics.lineStyle(2, 0xCCC5BE);
			l_PrimaryShape.graphics.drawCircle( 0, 0, 12);
			
			l_PrimaryShape.blendMode = BlendMode.NORMAL;
			l_PrimaryShape.cacheAsBitmap = true;
			l_PrimaryShape.visible = true;
			
			m_ImgNormal = l_PrimaryShape;
		}
		
		{
			var l_PrimaryShape : Shape = new Shape();
			
			l_PrimaryShape.graphics.beginFill( 0xEEEEEE );
			l_PrimaryShape.graphics.drawCircle( 0, 0, 21);
			l_PrimaryShape.graphics.endFill();
			
			l_PrimaryShape.blendMode = BlendMode.ADD;
			l_PrimaryShape.cacheAsBitmap = true;
			l_PrimaryShape.visible = false;
			
			m_ImgHit = l_PrimaryShape;
		}
		
		addChild( m_ImgHit );
		addChild( m_ImgNormal);
		visible = false;
		Glb.GetRendererAS().AddToSceneAS(this);
		m_Dir = new CV2D(0, 0);
		m_BHV = WanderMother;
		m_ThinkTimer = 0.5;
	}
	

	//////////////////////////////////
	public override function Update()
	{
		super.Update();
		
		if ( IsLoaded() )
		{
			m_ImgNormal.rotationZ += 30 * Glb.g_System.GetGameDeltaTime();	
		}
	}
	
	//////////////////////////////////
	//does not shoot but rather turn aroun the mothership of go down oscilating
	public override function Shoot()
	{
		
	}
	
	public override function Think()
	{
		var l_Wander = RandomEx.DiceF(0,0.5) > 0.05;
		
		//get a shot if far
		if ( CV2D.GetDistance( m_Center, MTRG.s_Instance.m_Gameplay.m_Mothership.m_Center ) > 0.5 )
		{
			l_Wander = false;  
		}
		
		//when starts tracking always pursue
		if ( WanderMother != m_BHV )
		{
			l_Wander = false;  
		}

		if ( l_Wander )
		{
			var l_R0 = Registers.V2DPool.Create();
			var l_Ms = MTRG.s_Instance.m_Gameplay.m_Mothership;
			
			RandomEx.RandBox( 	l_R0,
								l_Ms.m_Center.x - l_Ms.MS_SIZE_X / MTRG.HEIGHT * 0.6, 
								l_Ms.m_Center.y - l_Ms.MS_SIZE_Y / MTRG.HEIGHT * 0.6,
								l_Ms.m_Center.x + l_Ms.MS_SIZE_X / MTRG.HEIGHT * 0.6, 
								l_Ms.m_Center.y + l_Ms.MS_SIZE_Y / MTRG.HEIGHT * 0.6);
								
			CV2D.Sub( m_Dir, l_R0, m_Center);
			CV2D.SafeNormalize( m_Dir , CV2D.ZERO );
			m_BHV = WanderMother;
			m_ThinkTimer = 3.0; 
			Registers.V2DPool.Destroy(l_R0);
		}
		else 
		{
			m_BHV = Oscillate(  MTRG.s_Instance.m_Gameplay.m_Ship.m_Center.x, MTRG.s_Instance.m_Gameplay.m_Ship.m_Center.y );
			
			trace(  MTRG.s_Instance.m_Gameplay.m_Ship.m_Center);
			m_ThinkTimer = 0.75;
		}
	}
	
	//////////////////////////////////
	public override function ProcessNextPosition()
	{
		m_ThinkTimer -= Glb.g_System.GetGameDeltaTime();
		
		if (m_ThinkTimer<0)
		{
			Think();
		}
		
		
		switch(m_BHV)
		{
			case WanderMother:
			{
				//wander freely always same winding
				
				var l_Temp = Registers.V2DPool.Create();
				l_Temp.Set(0, 0);
				var l_Dir = RandomEx.DiceF( 0, 0.5);
				
				l_Temp.Set(l_Dir, Math.sqrt(1 - Math.sqrt(l_Dir * l_Dir)));
				CV2D.Incr(m_Dir, CV2D.Scale( l_Temp, RandomEx.DiceF(0, 0.5) * Glb.g_System.GetGameDeltaTime() , l_Temp));
				
				CV2D.SafeNormalize( m_Dir, CV2D.ZERO );
				
				Registers.V2DPool.Destroy(l_Temp);
				
			}
			
			//oscillate with target, it i particuliarly effficient to protect MS
			case Oscillate(px, py):
			{
				var l_Temp = Registers.V2DPool.Create();
				
				l_Temp.Set( px, py);
				m_Dir.Copy( CV2D.Sub(l_Temp, l_Temp , m_Center ) ) ;
				
				CV2D.Incr(m_Dir, CV2D.Scale( l_Temp, RandomEx.DiceF(-0.1, 0.1) * Glb.g_System.GetGameDeltaTime() , l_Temp));
				Registers.V2DPool.Destroy(l_Temp);
			}
		}
		
		CV2D.SafeNormalize( m_Dir , CV2D.ZERO );
		
		var l_R0 = Registers.V2DPool.Create();
		CV2D.Incr(m_Center, CV2D.Scale( l_R0, Glb.g_System.GetGameDeltaTime() * Constants.CIRCLE_SPEED, m_Dir ));
		Registers.V2DPool.Destroy(l_R0);
		
		
	}
}

import algorithms.CPool;

class CPerforatingMinion extends CMinion
{
	public var m_Dir : CV2D;
	public var m_MatchingAngle : Float; 
	public var m_Speed : Float;
	public function new()
	{
		super();
		
		m_Radius = 4 / MTRG.HEIGHT;
		m_Dir = new CV2D(0, 0);
		m_MatchingAngle = 0;
		m_Speed = 0;
		m_CollDmg = 80;
		m_BaseHp = 10;
	}
	
	
	//////////////////////////////////
	public override function OnEnable()
	{
		super.OnEnable();
		m_MatchingAngle = 0;
		m_Speed = 0;
	}
	
	//////////////////////////////////
	public override function Initialize()
	{
		var l_BmpData : BitmapData = cast MTRG.s_Instance.m_Gameplay.m_RscSpaceInvader.GetDriverImage();
		CDebug.ASSERT( null != MTRG.s_Instance.m_Gameplay.m_RscSpaceInvader.GetDriverImage() );
		
		var l_Vec : Vector<Float> = new Vector<Float>();
		var i = 0;
		l_Vec[i++] = 4; 	l_Vec[i++] = 0; 
		l_Vec[i++] = 0; 	l_Vec[i++] = 32;
		l_Vec[i++] = -4; 	l_Vec[i++] = 0;
		
		//build standard shape
		{
			var l_PrimaryShape : Shape = new Shape();
			
			l_PrimaryShape.graphics.lineStyle(3, 0x888888, 1.0);
			
			l_PrimaryShape.graphics.beginFill( 0x3F522B );
			l_PrimaryShape.graphics.drawTriangles( l_Vec );
			l_PrimaryShape.graphics.endFill();
			
			l_PrimaryShape.blendMode = BlendMode.NORMAL;
			l_PrimaryShape.cacheAsBitmap = true;
			l_PrimaryShape.visible = true;
			
			m_ImgNormal = l_PrimaryShape;
		}
		
		{
			var l_PrimaryShape : Shape = new Shape();
			
			l_PrimaryShape.graphics.beginFill( 0xFFFFFF );
			l_PrimaryShape.graphics.drawTriangles( l_Vec );
			l_PrimaryShape.graphics.endFill();
			
			l_PrimaryShape.blendMode = BlendMode.NORMAL;
			l_PrimaryShape.cacheAsBitmap = true;
			l_PrimaryShape.visible = false;
			
			m_ImgHit = l_PrimaryShape;
		}
		
		addChild( m_ImgHit );
		addChild( m_ImgNormal);
		visible = false;
		Glb.GetRendererAS().AddToSceneAS(this);
	}
	
	//////////////////////////////////
	public override function Update()
	{
		super.Update();
	}
	
	//////////////////////////////////
	public override function Shoot()
	{
		
	}
	
	//////////////////////////////////
	public override function ProcessNextPosition()
	{
		var l_R0 = Registers.V2DPool.Create();
		CV2D.Sub( m_Dir, MTRG.s_Instance.m_Gameplay.m_Ship.m_Center , m_Center );
		
		var l_Dist = m_Dir.Norm();
		
		CV2D.SafeNormalize( m_Dir, CV2D.ZERO);
		
		if( l_Dist > 0.35 )
		{
			m_Speed = Interp.SInterp( Math.pow( m_MatchingAngle, 0.5), 0, Constants.PERFORATOR_SPEED);
		}
		else
		{
			//go for the throat !
			m_Speed += Constants.PERFORATOR_SPEED *  3 * Glb.g_System.GetGameDeltaTime();
		}
		
		var l_Delta = m_Speed *  Glb.g_System.GetGameDeltaTime();
		if (l_Delta > l_Dist )
		{
			trace("warp d:" + l_Delta + " dis" + l_Dist);
			m_Center = MTRG.s_Instance.m_Gameplay.m_Ship.m_Center;
		}
		else
		{
			//we inject lerping to give this lagy sensation for AI
			CV2D.Incr( m_Center, CV2D.Scale( l_R0,  l_Delta , m_Dir ));
		}
		
		var l_Angle = Math.atan2(m_Dir.x, m_Dir.y);
		m_ImgNormal.rotationZ =  Interp.Lerp( m_MatchingAngle, m_ImgNormal.rotationZ , (- l_Angle * math.Constants.RAD_TO_DEG) );
		//trace(l_Angle);
		Registers.V2DPool.Destroy(l_R0);
		m_MatchingAngle += Glb.g_System.GetGameDeltaTime() * 0.85;
		m_MatchingAngle = Utils.Clamp( m_MatchingAngle, 0, 1);
	}
}

enum CrossState
{
	CS_IDLE;

	CS_SALVA(n:Int, dly : Float);
}

class CCrossMinion extends CMinion
{
	public var m_State: CrossState;
	
	public var m_Target : CV2D;
	
	//////////////////////////////////
	public function new()
	{
		super();
		m_ShootDelay = 5;
		m_Target = new CV2D(0, 0);
		m_BaseHp = 20;
	}
	
	public override function OnEnable()
	{
		super.OnEnable();
		
		RandomEx.RandBox(	m_Target,
									0, 0,
									Glb.g_System.m_Display.GetAspectRatio(), 0.8
									);
		m_State = CS_IDLE;
	}
	
	//////////////////////////////////
	public override function Initialize()
	{
		var l_BmpData : BitmapData = cast MTRG.s_Instance.m_Gameplay.m_RscSpaceInvader.GetDriverImage();
		CDebug.ASSERT( null != MTRG.s_Instance.m_Gameplay.m_RscSpaceInvader.GetDriverImage() );

		//build standard shape
		{
			var l_PrimaryShape : Shape = new Shape();
			var l_GradientMatrix : Matrix = new Matrix();
			
			l_PrimaryShape.graphics.lineStyle(3, 0xAAAAAA);
			l_PrimaryShape.graphics.moveTo( -8, -8);
			l_PrimaryShape.graphics.lineTo(  8, 8);
			l_PrimaryShape.graphics.lineStyle(5, 0xBBBBBB);
			l_PrimaryShape.graphics.moveTo( -8, 8);
			l_PrimaryShape.graphics.lineTo(  8, -8);
			
			l_PrimaryShape.blendMode = BlendMode.NORMAL;
			l_PrimaryShape.cacheAsBitmap = true;
			l_PrimaryShape.visible = true;
			
			m_ImgNormal = l_PrimaryShape;
		}
		
		{
			var l_PrimaryShape : Shape = new Shape();
			
			l_PrimaryShape.graphics.lineStyle(3, 0xFFFFFF);
			l_PrimaryShape.graphics.moveTo( -8, -8);
			l_PrimaryShape.graphics.lineTo(  8, 8);
			l_PrimaryShape.graphics.lineStyle(5, 0xFFFFFF);
			l_PrimaryShape.graphics.moveTo( -8, 8);
			l_PrimaryShape.graphics.lineTo(  8, -8);
			
			l_PrimaryShape.blendMode = BlendMode.ADD;
			l_PrimaryShape.cacheAsBitmap = true;
			l_PrimaryShape.visible = false;
			
			m_ImgHit = l_PrimaryShape;
		}
		
		addChild( m_ImgHit );
		addChild( m_ImgNormal);
		visible = false;
		Glb.GetRendererAS().AddToSceneAS(this);
	}
	
	//////////////////////////////////
	public override function Update()
	{
		super.Update();
		
		if ( IsLoaded() )
		{
			m_ImgNormal.rotationZ += 20 * Glb.g_System.GetGameDeltaTime();
		}
	}
	
	//////////////////////////////////
	public override function Shoot()
	{
		m_State = CS_SALVA(5,0);
	}
	
	//////////////////////////////////
	public override function ProcessNextPosition()
	{
		switch(m_State)
		{
			case CS_IDLE: 
			
			case CS_SALVA(n, dly):
			if(dly - Glb.g_System.GetGameDeltaTime() >= 0)
			{
				m_State = CS_SALVA(n, dly - Glb.g_System.GetGameDeltaTime());
			}
			else
			{
				if (n==0)
				{
					RandomEx.RandBox(	m_Target,
										0, 0,
										Glb.g_System.m_Display.GetAspectRatio(), 0.8
										);
					trace("heading to " + m_Target);
					m_State = CS_IDLE;
				}
				else
				{
					var l_NewOne = MTRG.s_Instance.m_Gameplay.m_ProjectileHelper.m_CBoulettePool.Create();
					if (l_NewOne != null)
					{
						l_NewOne.visible = true;
						l_NewOne.Fire(m_Center, MTRG.s_Instance.m_Gameplay.m_Ship.m_Center, Constants.BASE_SV_BOULETTE_SPEED );
					}
					m_State = CS_SALVA(n - 1, 0.1 );
				}
			}
		}
		
		CV2D.Sub( Registers.V2_1, m_Target, m_Center );		
		var l_Dist2 = Registers.V2_1.Norm2();
		var l_Delta = Glb.g_System.GetGameDeltaTime() * Constants.CROSS_SPEED;
		
		if (l_Delta*l_Delta > l_Dist2)
		{
			m_Center.Copy(m_Target);
			m_Target.Copy(m_Center);
		}
		else
		{
			CV2D.SafeNormalize(Registers.V2_1, CV2D.ZERO);
			CV2D.Incr( m_Center, CV2D.Scale( Registers.V2_0, l_Delta,Registers.V2_1));
		}
	}
}
