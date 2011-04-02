/**
 * ...
 * @author DE
 */

package ;
import flash.display.BlendMode;
import flash.display.GradientType;
import flash.display.Shape;
import flash.display.Sprite;
import flash.geom.Matrix;
import kernel.Glb;
import kernel.CDebug;
import math.CV2D;

import CCollManager;

class CMothership extends Sprite , implements CCollManager.BSphered
{
	public var m_Center: CV2D;
	public var m_Radius : Float;
	
	public var m_CollClass : COLL_CLASS;
	public var m_CollSameClass : Bool;
	public var m_CollMask : Int;
	
	public var m_CollShape : COLL_SHAPE;
	
	private var m_ScanShape : Shape;
	public var m_Hp(GetHp,SetHp) : Int;
	private var _Hp : Int;
	
	////////////////////////////////////////////////////////////
	public function new() 
	{
		super();
		m_Center = new CV2D(0, 0);
		m_Radius = 64;
		m_CollShape = AARect(16.0/MTRG.HEIGHT);
		m_CollClass = Aliens;
		
		m_CollMask = (1 << Type.enumIndex(SpaceShipShoots));

		#if debug
		m_Hp = 1;
		#else
		m_Hp = 100;
		#end
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
	
	public function OnHit() : Void
	{
		var l_This = this;
		//trace("onhit");
		MTRG.s_Instance.m_Gameplay.m_Tasks.push( new CTimedTask(function(ratio)
																{
																	l_This.blendMode = SUBTRACT;
																	
																	if (ratio >= 1.0)
																	{
																		l_This.blendMode = NORMAL;
																	}
																}
																,0.1,0) );
	}
	public function OnDestroy() : Void
	{
		MTRG.s_Instance.m_Gameplay.GameOver(false);
		var l_This = this;
		MTRG.s_Instance.m_Gameplay.m_Tasks.push( new CTimedTask(function(ratio)
																{
																	l_This.blendMode = ADD;
																	l_This.alpha = 1.0 - ratio;
																	if (l_This.alpha == 0)
																	{
																		l_This.visible = false;
																	}
																}
																,0.2,0) );
	}
	
	////////////////////////////////////////////////////////////
	public function OnCollision( _Collider : BSphered ) : Void
	{
		CDebug.CONSOLEMSG("Mothership hit");
		//CDebug.CONSOLEMSG("Mothership hit");
	}
	
	public var MS_SIZE_X : Int;
	public var MS_SIZE_Y : Int;
	
	////////////////////////////////////////////////////////////
	public function Initialize()
	{
		MS_SIZE_X = 256;
		MS_SIZE_Y = 32;
	
		var l_Shape  :Shape = new Shape(); 
		
		m_Radius = 128.0 / MTRG.HEIGHT;
		
		l_Shape.graphics.beginFill(0x787878); 
		l_Shape.graphics.drawEllipse( - MS_SIZE_X * 0.5, MS_SIZE_Y*0.25, MS_SIZE_X, MS_SIZE_Y*0.5);
		l_Shape.graphics.endFill();
		
		
		l_Shape.graphics.beginFill(0x787878); 
		l_Shape.graphics.drawEllipse( - MS_SIZE_X * 0.5, -MS_SIZE_Y*0.75, MS_SIZE_X, MS_SIZE_Y*0.5 );
		l_Shape.graphics.endFill();
		
		l_Shape.graphics.beginFill(0x787878); 
		l_Shape.graphics.drawRect( - MS_SIZE_X * 0.5, -MS_SIZE_Y*0.5, MS_SIZE_X, MS_SIZE_Y );
		l_Shape.graphics.endFill();
		
		l_Shape.graphics.lineStyle(4,0xFE0000,  0.9) ;
		l_Shape.graphics.moveTo( - MS_SIZE_X * 0.5, 0);
		l_Shape.graphics.lineTo( MS_SIZE_X * 0.5, 0 );
		
		var l_GrdMatrix : Matrix = new Matrix();
		
		l_GrdMatrix.createGradientBox( 24, 24, 0, 0, 0 );
		
		m_ScanShape = new Shape(); 
		m_ScanShape.graphics.beginGradientFill( GradientType.RADIAL, [0xFF5588, 0xFF5588], [1, 0], [0, 255], l_GrdMatrix);
		m_ScanShape.graphics.drawCircle(0, 0, 32);
		m_ScanShape.graphics.endFill();
		m_ScanShape.y -= 12;
		
		m_ScanShape.alpha = 1.0;
		m_ScanShape.blendMode = BlendMode.ADD;
		
		
		addChild(l_Shape);
		addChild(m_ScanShape);
		
		visible = false;
		Glb.GetRendererAS().AddToSceneAS( this );
		
		m_Center.Set( 	(MTRG.BOARD_WIDTH / 2 + MTRG.BOARD_X) / MTRG.HEIGHT,
						64 / MTRG.HEIGHT);
						
		MTRG.s_Instance.m_Gameplay.m_CollMan.Add(this);
	}
	
	////////////////////////////////////////////////////////////
	public function Update()
	{
		x = m_Center.x * MTRG.HEIGHT;
		y = m_Center.y * MTRG.HEIGHT;
		
		m_ScanShape.x += Glb.GetSystem().GetGameDeltaTime() * 70;
		if (m_ScanShape.x> MS_SIZE_X * 0.5 - 32)
		{
			m_ScanShape.x  = - MS_SIZE_X * 0.5;
		}
	}
}