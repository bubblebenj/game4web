/**
 * ...
 * @author de
 */

package ;

import flash.display.Bitmap;
import flash.display.DisplayObject;
import flash.display.Sprite;
import CCollManager;
import flash.geom.ColorTransform;
import math.Utils;
import kernel.CDebug;
import kernel.Glb;

class CMinion extends Sprite , implements Updatable, implements BSphered
{
	public var CenterX : Float;
	public var CenterY : Float;
	public var Radius : Float;
	
	public var CollClass : COLL_CLASSES;
	public var CollSameClass : Bool;
	
	public var m_Hp(GetHp,SetHp) : Int;
	private var _Hp : Int;
	
	private var m_ImgNormal : DisplayObject;
	private var m_ImgHit : DisplayObject;
	
	private var m_ShootDelay : Float;
	private var m_ShootTimer : Float ;
	
	private var m_Level: Int;
	
	private function GetHp() : Int
	{
		return _Hp;
	}
	
	private function SetHp(v : Int) : Int
	{
		_Hp = v;
		if( _Hp <= 0 )
		{
			OnDestroy();
		}
		return _Hp;
	}
	
	
	public function new() 
	{
		super();
		m_ShootTimer = 0;
		m_ShootDelay = 0;
		m_ImgNormal = null;
		m_ImgHit = null;
		CollSameClass = false;
		CollClass = Aliens;
		CenterX = 0;
		CenterY = 0;
		Radius = 8 / MTRG.HEIGHT;
		m_Level = 0;
	}
	
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
	
	public function OnCollision( _Collider : BSphered  )
	{
		switch( _Collider.CollClass )
		{
			case SpaceShipShoots: CDebug.CONSOLEMSG("Minion collided shoot");
			default: CDebug.CONSOLEMSG("Minion collided something");
		}
	}
	
	public function Initialize()
	{
		CDebug.BREAK("Override me");
	}
	
	public function ProcessNextPosition()
	{
		CDebug.BREAK("Override me");
	}
	
	public function IsLoaded()
	{
		return m_ImgNormal != null && m_ImgHit != null;
	}
	
	public function Update()
	{
		ProcessNextPosition();
		
		//x = CenterX * MTRG.HEIGHT; // aka (m_Img.x /  MTRG.WIDTH) *  (MTRG.WIDTH / MTRG.HEIGHT);
		//y = CenterY * MTRG.HEIGHT ;
		
		m_ShootTimer += Glb.GetSystem().GetGameDeltaTime();
		if ( m_ShootTimer >= m_ShootDelay )
		{
			Shoot();
			m_ShootTimer  = 0;
		}
	}
	
	
	public function Shut()
	{
		Glb.GetRendererAS().RemoveFromSceneAS(this);
		m_ImgNormal = null;
		m_ImgHit = null;
	}
	
	public function Shoot()
	{
		CDebug.BREAK("Override me");
	}
}

class CSpaceInvaderMinion extends CMinion
{
	
	public function new()
	{
		super();
	}
	
	public override function Initialize()
	{
		CDebug.ASSERT( null != MTRG.s_Instance.m_Gameplay.m_RscSpaceInvader.GetDriverImage() );
		var l_Bmp = new Bitmap(  cast MTRG.s_Instance.m_Gameplay.m_RscSpaceInvader.GetDriverImage() );
		CDebug.ASSERT( l_Bmp != null );
		m_ImgNormal = l_Bmp;
		
		
		l_Bmp.transform.colorTransform = new ColorTransform();
		l_Bmp.transform.colorTransform.redMultiplier = 1;
		l_Bmp.transform.colorTransform.greenMultiplier = 0;
		l_Bmp.transform.colorTransform.blueMultiplier = 0;
		l_Bmp.visible = true;
		
		var l_BmpHit = new Bitmap( cast MTRG.s_Instance.m_Gameplay.m_RscSpaceInvader.GetDriverImage() );
		m_ImgHit = l_BmpHit;
		
		l_BmpHit.visible = false;
		
		addChild( m_ImgHit );
		addChild( m_ImgNormal);
		visible = true;
		Glb.GetRendererAS().AddToSceneAS(this);
	}
	
	public override function Shoot()
	{
		
	}
	
	public override function ProcessNextPosition()
	{
		//CDebug.BREAK("Override me");
		x = MTRG.WIDTH / 2;
		y = 100;
	}
	
}

class CSpaceCircleMinion extends CMinion
{
	
}

class CPerforatingMinion extends CMinion
{
	
}

class CCrossMinion extends CMinion
{
	
}