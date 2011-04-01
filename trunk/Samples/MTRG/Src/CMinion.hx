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

class CMinion extends Sprite , implements Updatable, implements BSphered
{
	public var m_Center : CV2D;
	public var m_Radius : Float;
	
	public var m_CollClass : COLL_CLASS;
	public var m_CollShape : COLL_SHAPE;
	public var m_CollSameClass : Bool;
	
	public var m_Hp(GetHp,SetHp) : Int;
	private var _Hp : Int;
	
	private var m_ImgNormal : DisplayObject;
	private var m_ImgHit : DisplayObject;
	
	private var m_ShootDelay : Float;
	private var m_ShootTimer : Float ;
	
	private var m_Level: Int;
	public var m_HasAI : Bool;
	
	public function new() 
	{
		super();
		m_ShootTimer = 0;
		m_ShootDelay = 0;
		m_ImgNormal = null;
		m_ImgHit = null;
		m_CollSameClass = false;
		m_CollClass = Aliens;
		m_Center = new CV2D(0,0);
		m_Radius = 8 / MTRG.HEIGHT;
		m_Level = 0;
		m_HasAI = false;
		
		m_Hp = 20;
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

	//////////////////////////////////
	private function OnDestroy()
	{
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
																,0.1,0) );
	}
	
	//////////////////////////////////
	public function OnCollision( _Collider : BSphered  )
	{
		switch( _Collider.m_CollClass )
		{
			case SpaceShipShoots: CDebug.CONSOLEMSG("Minion collided shoot");
			default: CDebug.CONSOLEMSG("Minion collided something");
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
		
		m_ShootTimer += Glb.GetSystem().GetGameDeltaTime();
		if ( m_ShootTimer >= m_ShootDelay )
		{
			Shoot();
			m_ShootTimer  = 0;
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
	
	
}

class CSpaceInvaderMinion extends CMinion
{
	//////////////////////////////////
	public function new()
	{
		super();
	}

	//putting inline causes compiler issue when bulding pools...oh my gosh
	public var SI_SIZE : Int;
	public var BASE_SV_BOULETTE_SPEED : Float;
	
	//////////////////////////////////
	public override function Initialize()
	{
		BASE_SV_BOULETTE_SPEED = 0.2;
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
		
		
		//addChild( m_ImgHit );
		addChild( m_ImgNormal);
		visible = false;
		Glb.GetRendererAS().AddToSceneAS(this);
		
		m_ShootDelay = 1;
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
		
		l_NewOne.Fire(m_Center, l_To, BASE_SV_BOULETTE_SPEED );
		
		Registers.V2DPool.Destroy( l_To );
	}
	
	//////////////////////////////////
	public override function ProcessNextPosition()
	{
	}
	
}

class CSpaceCircleMinion extends CMinion
{
	public function new()
	{
		super();
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
	public override function Shoot()
	{
		
	}
	
	//////////////////////////////////
	public override function ProcessNextPosition()
	{
	
	}
}

import algorithms.CPool;

class CPerforatingMinion extends CMinion
{
	public function new()
	{
		super();
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
	}
}

class CCrossMinion extends CMinion
{
	//////////////////////////////////
	public function new()
	{
		super();
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
		
	}
	
	//////////////////////////////////
	public override function ProcessNextPosition()
	{
	}
}
