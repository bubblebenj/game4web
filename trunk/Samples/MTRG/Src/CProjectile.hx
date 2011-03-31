/**
 * ...
 * @author de
 */

package ;
import flash.accessibility.Accessibility;
import flash.display.DisplayObject;
import flash.display.BlendMode;
import flash.display.Shape;
import flash.display.Sprite;
import flash.display.GradientType;
import flash.display.SpreadMethod;
import flash.geom.Matrix;
import kernel.CDebug;
import math.Constants;
import math.CV2D;
import kernel.Glb;
import math.Registers;
import math.Utils;

import CCollManager;

class CProjectile implements BSphered
{
	///////////////////
	var m_Pos : CV2D;
	var m_NextPos : CV2D;
	
	var m_Dir : CV2D;
	var m_Speed : Float;
	
	var m_DisplayObject : DisplayObject;
	
	public var visible(default, SetVisible) : Bool;
	
	public var m_Center : CV2D;
	public var m_Radius : Float;
	
	public var m_CollClass : COLL_CLASS;
	public var m_CollShape : COLL_SHAPE;
	public var m_CollSameClass : Bool;
	
	public var m_Damage : Int;
	
	///////////////////
	public function new() 
	{
		m_Pos = new CV2D(0,0);
		m_NextPos = new CV2D(0, 0);
		m_Dir = new CV2D(0, 0);
		m_Speed = 0;
		m_DisplayObject = null;
		
		m_Center = new CV2D(0, 0);
		m_CollSameClass = false;
		m_CollClass = Invalid;
		m_CollShape = Sphere;
		m_Damage = 0;
	}
	
	public function SetVisible( v ) : Bool
	{
		visible = v;
		m_DisplayObject.visible = v;
		return visible;
	}
	
	public function Initialize()
	{
		
	}
	
	public function Shut()
	{
		Glb.GetRendererAS().RemoveFromSceneAS( m_DisplayObject );
	}
	
	public function Update()
	{
		CV2D.Add( m_Pos, m_Pos , CV2D.Scale( Registers.V2_0 , Glb.GetSystem().GetGameDeltaTime() * m_Speed , m_Dir ));
		
		m_Center.Copy(  m_Pos );
		
		m_Radius = 8.0 / MTRG.HEIGHT;
		
		if ( 	(m_Pos.y <= 0) 
		||		(m_Pos.y >= 1) )
		{
			OnLost();
		}
		
		m_DisplayObject.x = m_Pos.x * MTRG.HEIGHT;
		m_DisplayObject.y = m_Pos.y * MTRG.HEIGHT;
		//CDebug.CONSOLEMSG("upd lsr" + m_Pos.x +":"+ m_Pos.y);
	}
	
	public function OnDestroy()
	{
		CDebug.BREAK("should not happen");
	}
	
	public function OnLost()
	{
		CDebug.BREAK("should not happen");
	}
	
	public function OnCollision( _Collider : BSphered ) : Void
	{
		CDebug.CONSOLEMSG("Proj coll");
	}
	
	public function Reset() : Void 
	{
		
	}
	
	public function Fire( _From : CV2D , _To : CV2D, _Speed : Float )
	{
		m_Dir.Copy( CV2D.Sub( Registers.V2_9, _To, _From) );
		var l_Len2 = m_Dir.Norm2();
		
		if ( l_Len2 > Constants.EPSILON )
		{
			CV2D.Normalize( m_Dir );
			m_Speed = _Speed;
		}
		else 
		{
			kernel.CDebug.BREAK("Projectile targeting wrong");
		}
		
		m_Pos.Copy(_From);
		m_DisplayObject.visible = true;
		MTRG.s_Instance.m_Gameplay.m_CollMan.Add( this );
	}
}

class CLaser extends  CProjectile
{
	///////////////////
	public function new()
	{
		super();
		
		m_Center = new CV2D(0, 0);
		m_CollClass = SpaceShipShoots;
		m_CollSameClass = false;
		m_Radius = 2.0 / MTRG.HEIGHT;
		m_Damage =  10;
	}
	
	public override function OnCollision( _Collider : BSphered ) : Void
	{
		switch( _Collider.m_CollClass )
		{
			case Asteroids:
				var l_Aster : CAsteroid = cast _Collider;
				l_Aster.m_Hp -= 10;
				
			case Aliens:
				switch( Type.typeof( _Collider ) )
				{
					case TClass(a):
					switch(a)
					{
						case CMothership: 
						var l_Ms : CMothership = cast _Collider;
						l_Ms.m_Hp -= 10;
						
						case CMinion: 
						var l_Mn : CMinion = cast _Collider;
						l_Mn.m_Hp -= 10;

						default: 
						CDebug.CONSOLEMSG("Typing err...");
						
					}
					default:
				}
			default:
				//CDebug.CONSOLEMSG("COLL");
		}
		OnDestroy();
	}
	
	public override function OnLost()
	{
		OnDestroy();
		//kernel.CDebug.CONSOLEMSG("Laser Lost ");
	}
	
	public override function OnDestroy()
	{
		m_DisplayObject.visible = false;
		
		MTRG.s_Instance.m_Gameplay.m_Ship.DeleteLaser(this);
		MTRG.s_Instance.m_Gameplay.m_CollMan.Remove(this);
		
		//kernel.CDebug.CONSOLEMSG("Laser destroyed ");
	}
	
	public override function Initialize()
	{
		super.Initialize();
		var l_PrimaryShape : Shape = new Shape();
		var l_GradientMatrix : Matrix = new Matrix();
		
		l_GradientMatrix.createGradientBox( 8, 32 );
		
		l_PrimaryShape.graphics.beginGradientFill( GradientType.RADIAL, [0xFFBB6E, 0xD90E00], [1, 1], [0, 255], l_GradientMatrix, SpreadMethod.PAD );
		l_PrimaryShape.graphics.drawEllipse( 0, 0, 8, 32);
		
		l_PrimaryShape.blendMode = BlendMode.ADD;
		l_PrimaryShape.cacheAsBitmap = true;
		l_PrimaryShape.visible = true;
		
		m_DisplayObject = new Sprite();
		(cast m_DisplayObject).addChild(l_PrimaryShape);
		Glb.GetRendererAS().AddToSceneAS(m_DisplayObject);
		Glb.GetRendererAS().SendToFront(m_DisplayObject);
		
		m_DisplayObject.visible = false;
	}
}


class CBoulette extends  CProjectile
{
	///////////////////
	public function new()
	{
		super();
		m_CollClass = AlienShoots;
		m_CollSameClass = false;
		m_Radius = 2.0 / MTRG.HEIGHT;
		
		m_Damage = 10;
	}
	
	public override function OnCollision( _Collider : BSphered ) : Void
	{
		switch( _Collider.m_CollClass )
		{
			case Asteroids:
				var l_Aster : CAsteroid = cast _Collider;
				l_Aster.m_Hp -= 10;
				OnDestroy();
			default:
				CDebug.CONSOLEMSG("COLL");
		}
	}
	
	public override function OnLost()
	{
		OnDestroy();
		//kernel.CDebug.CONSOLEMSG("Laser Lost ");
	}
	
	public override function OnDestroy()
	{
		m_DisplayObject.visible = false;
		
		MTRG.s_Instance.m_Gameplay.m_Ship.DeleteBoulette(this);
		MTRG.s_Instance.m_Gameplay.m_CollMan.Remove(this);
		
		//kernel.CDebug.CONSOLEMSG("Laser destroyed ");
	}
	
	public override function Initialize()
	{
		super.Initialize();
		var l_PrimaryShape : Shape = new Shape();
		var l_GradientMatrix : Matrix = new Matrix();
		
		l_GradientMatrix.createGradientBox( 8, 32 );
		
		l_PrimaryShape.graphics.beginGradientFill( GradientType.RADIAL, [0xFFBB6E, 0xD90E00], [1, 1], [0, 255], l_GradientMatrix, SpreadMethod.PAD );
		l_PrimaryShape.graphics.drawEllipse( 0, 0, 8, 32);
		
		l_PrimaryShape.blendMode = BlendMode.ADD;
		l_PrimaryShape.cacheAsBitmap = true;
		l_PrimaryShape.visible = true;
		
		m_DisplayObject = new Sprite();
		(cast m_DisplayObject).addChild(l_PrimaryShape);
		Glb.GetRendererAS().AddToSceneAS(m_DisplayObject);
		Glb.GetRendererAS().SendToFront(m_DisplayObject);
		
		m_DisplayObject.visible = false;
	}
}