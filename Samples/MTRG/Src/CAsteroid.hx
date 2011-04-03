/****************************************************
 * MTRG : Motion-Twin recruitment game
 * A game by David Elahee
 * 
 * MTRG is a Space Invader RTS, the goal is to protect your mothership from
 * the random AI that shoots on it.
 * 
 * Powered by Game4Web a cross-platform engine by David Elahee & Benjamin Dubois.
 * 
 * @author de
 ****************************************************/

 /****************************************************
 * Asteroid management and creation class
 ****************************************************/

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
	////////////////////////////////////////////////
	public static inline var MAX_WIDTH : Int= 48;
	
	var m_ImgNormal : Shape;
	var m_ImgHit : Shape;
	
	public var m_Rot : Float;
	var m_RotAngle : Float;
	
	public var m_Center:CV2D;
	public var m_Radius : Float;
	
	public var m_CollClass : COLL_CLASS;
	public var m_CollShape : COLL_SHAPE;
	public var m_CollMask : Int;
	
	public var m_Hp(GetHp,SetHp) : Int;
	private var _Hp : Int;
	
	////////////////////////////////////////////////
	public function new() 
	{
		super();
		m_ImgNormal = null;
		m_ImgHit = null;
		m_RotAngle = RandomEx.DiceF( - Math.PI * 8.0, Math.PI * 8);
		m_Radius = MAX_WIDTH / MTRG.HEIGHT * 0.5;
		m_Center = new CV2D(0, 0);
		m_CollClass = Asteroids;
		
		m_CollShape = Sphere;
		m_Hp = 10;
		
		
		
		m_CollMask = 
		(
			( 1 << Type.enumIndex(Aliens) )
		|	( 1 << Type.enumIndex(AlienShoots))
		|	( 1 << Type.enumIndex(SpaceShip ))
		|	( 1 << Type.enumIndex(SpaceShipShoots) ));
	}
	
	////////////////////////////////////////////////
	private function GetHp() : Int
	{
		return _Hp;
	}
	
	////////////////////////////////////////////////
	private function SetHp(v : Int) : Int
	{
		_Hp = v;
		if( _Hp <= 0 )
		{
			OnDestroy();
		}
		return _Hp;
	}
	
	
	
	////////////////////////////////////////////////
	private function OnDestroy()
	{
		MTRG.s_Instance.m_Gameplay.m_CollMan.Remove(this);
		//visible = false;
		//CDebug.CONSOLEMSG("Asteroid destroyed");
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
	
	////////////////////////////////////////////////
	public function OnCollision( _Collider : BSphered  )
	{
		switch( _Collider.m_CollClass )
		{
			case SpaceShipShoots: CDebug.CONSOLEMSG("Asteroid collided shoot");
			default: CDebug.CONSOLEMSG("Asteroid collided something");
		}
	}
	
	////////////////////////////////////////////////
	public static function BatchCreateShape( _Path : Array<CV2D> , _Sp : Shape )
	{
		_Sp.graphics.moveTo(_Path[0].x, _Path[0].y);
		
		var l_Last : CV2D = new CV2D(0,0);
		l_Last.Set(_Path[0].x, _Path[0].y);
		for ( i in 1..._Path.length)
		{
			if ( Math.random() < 0.6 )
			{
				_Sp.graphics.lineTo(_Path[i].x, _Path[i].y);
			}
			else
			{
				if (Math.random() < 0.5)
				{
					_Sp.graphics.curveTo( (l_Last.x +  _Path[i].x) * 0.6, (l_Last.y +  _Path[i].y) * 0.6,
											_Path[i].x, _Path[i].y );	
				}
				else
				{
					_Sp.graphics.curveTo( (l_Last.x +  _Path[i].x) * 0.4, (l_Last.y +  _Path[i].y) * 0.4,
											_Path[i].x, _Path[i].y );	
				}
			}
			l_Last.Set(_Path[i].x, _Path[i].y);
		}
		_Sp.graphics.lineTo(_Path[0].x, _Path[0].y);
	}
	
	////////////////////////////////////////////////
	public function Initialize()
	{
		m_ImgNormal = new Shape(); 
		m_ImgHit = new Shape(); 
		
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
				var l_randMag = 0.8 + Math.random() * 0.2;
				l_Cos *= l_randMag;
				l_Sin *= l_randMag;
			}
			l_Arr.push( new CV2D( 0.5 * l_AsterMag * l_Cos * Glb.GetSystem().m_Display.GetAspectRatio(),  l_Sin  * 0.5 * l_AsterMag * 1.0) );
		}
		
		{
			m_ImgNormal.graphics.lineStyle(3, 0xF2F807, 1.0);
			BatchCreateShape(l_Arr, m_ImgNormal);
			m_ImgNormal.alpha = 1.0;
			m_ImgNormal.blendMode = flash.display.BlendMode.ADD;
		}
		
		{
			m_ImgHit.graphics.beginFill( 0xEEEEEE );
			BatchCreateShape(l_Arr, m_ImgHit);
			m_ImgHit.alpha = 1.0;
			m_ImgHit.blendMode = flash.display.BlendMode.ADD;
			m_ImgHit.visible = false;
		}
		
		//m_Img.graphics.endFill();
		
		addChild(m_ImgNormal);
		addChild(m_ImgHit);
		Glb.GetRendererAS().AddToSceneAS(this);
		//visible = false;	
		cacheAsBitmap = true;
		visible = false;
	}
	
	////////////////////////////////////////////////
	public function IsLoaded()
	{
		return m_ImgNormal != null;
	}
	
	
	////////////////////////////////////////////////
	public function Update()
	{
		rotationZ += m_RotAngle * Glb.GetSystem().GetGameDeltaTime();
		
		//Go to Aspect / Homogene base
		m_Center.Set( x / MTRG.HEIGHT, y / MTRG.HEIGHT); // aka (m_Img.x /  MTRG.WIDTH) *  (MTRG.WIDTH / MTRG.HEIGHT);
	}
	
	////////////////////////////////////////////////
	public function Shut()
	{
		Glb.GetRendererAS().RemoveFromSceneAS(this);
		m_ImgNormal = null;
		m_ImgHit = null;
	}
}