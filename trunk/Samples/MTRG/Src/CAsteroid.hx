/**
 * ...
 * @author de
 */

package ;

 import flash.display.Shape;
 import flash.display.Sprite;
 import kernel.CDebug;
 import math.CV2D;
 import math.RandomEx;
 import renderer.CColor;

 import CCollManager;
 import kernel.Glb;
 
 class CAsteroid extends Sprite , implements Updatable, implements BSphered
{
	public static inline var MAX_WIDTH = 48;
	
	var m_Img : Shape;
	public var m_Rot : Float;
	var m_RotAngle : Float;
	
	public var CenterX : Float;
	public var CenterY : Float;
	public var Radius : Float;
	
	public var CollClass : COLL_CLASSES;
	public var CollSameClass : Bool;
	
	public var m_Hp(default,SetHp) : Int ;
	
	
	private function SetHp(v) : Int
	{
		if (m_Hp <= 0)
		{
			return 0;
		}
		m_Hp = v;
		if( m_Hp <= 0)
		{
			OnDestroy();
		}
		return m_Hp;
	}
	
	private function OnDestroy()
	{
		MTRG.s_Instance.m_Gameplay.m_CollMan.Remove(this);
		m_Img.visible = false;
		CDebug.CONSOLEMSG("Asteroid destroyed");
	}
	
	public function OnCollision( _Collider : BSphered  )
	{
		switch( _Collider.CollClass )
		{
			default:
		}
		CDebug.CONSOLEMSG("Asteroid collided something");
	}
	
	
	public function new() 
	{
		super();
		m_Img = null;
		m_RotAngle = RandomEx.DiceF( - Math.PI * 8.0, Math.PI * 8);
		Radius = MAX_WIDTH;
		CenterX = 0;
		CenterY = 0;
		CollClass = Asteroids;
		CollSameClass = false;
		m_Hp = 10;
	}
	
	public function Initialize()
	{
		m_Img = new Shape(); 
		
		var l_Arr : Array<CV2D> = new Array<CV2D>();
		
		var l_AsterMag = MAX_WIDTH;
		
		var l_Nb = Std.int( Math.random() * 16.0) + 4;
		
		
		for ( i in 0...l_Nb )
		{
			var l_CacheDiv = i / (l_Nb - 1);
			var l_CacheAngle = l_CacheDiv * 2.0 * Math.PI;
			var l_Cos = Math.cos( l_CacheAngle);
			var l_Sin = Math.sin( l_CacheAngle);
			
			if( Math.random()<0.5)
			{
				var l_randMag = 0.6 + Math.random() * 0.2;
				l_Cos *= l_randMag;
				l_Sin *= l_randMag;
			}
			l_Arr.push( new CV2D( 0.5 * l_AsterMag * l_Cos * Glb.GetSystem().m_Display.GetAspectRatio(),  l_Sin  * 0.5 * l_AsterMag * 1.0) );
		}
		
		
		//m_Img.graphics.beginFill(0xFF);
		m_Img.graphics.lineStyle(3, 0xF2F807, 1.0);
		m_Img.graphics.moveTo(l_Arr[0].x, l_Arr[0].y);
		
		var l_Last : CV2D = new CV2D(0,0);
		l_Last.Set(l_Arr[0].x, l_Arr[0].y);
		for ( i in 1...l_Nb)
		{
			if ( Math.random() < 0.6 )
			{
				m_Img.graphics.lineTo(l_Arr[i].x, l_Arr[i].y);
			}
			else
			{
				if (Math.random() < 0.5)
				{
					m_Img.graphics.curveTo( (l_Last.x +  l_Arr[i].x) * 0.6, (l_Last.y +  l_Arr[i].y) * 0.6,
											l_Arr[i].x, l_Arr[i].y );	
				}
				else
				{
					m_Img.graphics.curveTo( (l_Last.x +  l_Arr[i].x) * 0.4, (l_Last.y +  l_Arr[i].y) * 0.4,
											l_Arr[i].x, l_Arr[i].y );	
				}
			}
			l_Last.Set(l_Arr[i].x, l_Arr[i].y);
		}
		m_Img.graphics.lineTo(l_Arr[0].x, l_Arr[0].y);
		
		
		m_Img.alpha = 1.0;
		m_Img.blendMode = flash.display.BlendMode.ADD;
		//m_Img.graphics.endFill();
		
		addChild(m_Img);
		Glb.GetRendererAS().AddToSceneAS(this);
		//visible = false;	
		cacheAsBitmap = true;
	}
	
	public function IsLoaded()
	{
		return m_Img != null;
	}
	
	public function Update()
	{
		rotationZ += m_RotAngle * Glb.GetSystem().GetGameDeltaTime();
		
		CenterX = m_Img.x / MTRG.HEIGHT; // aka (m_Img.x /  MTRG.WIDTH) *  (MTRG.WIDTH / MTRG.HEIGHT);
		CenterY = m_Img.y / MTRG.HEIGHT;
	}
	
	public function Shut()
	{
		Glb.GetRendererAS().RemoveFromSceneAS(m_Img);
		m_Img = null;
	}
}