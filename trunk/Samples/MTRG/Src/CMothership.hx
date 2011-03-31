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
	
	public var m_CollShape : COLL_SHAPE;
	
	private var m_ScanShape : Shape;
	
	////////////////////////////////////////////////////////////
	public function new() 
	{
		super();
		m_Center = new CV2D(0, 0);
		m_Radius = 64;
		m_CollShape = AARect(32);
		m_CollClass = Aliens;
		m_CollSameClass = false;
	}
	
	////////////////////////////////////////////////////////////
	public function OnCollision( _Collider : BSphered ) : Void
	{
		CDebug.CONSOLEMSG("Mothership hit");
	}
	
	public static inline var MS_SIZE_X = 256;
	public static inline var MS_SIZE_Y = 32;
	
	////////////////////////////////////////////////////////////
	public function Initialize()
	{
		var l_Shape  :Shape = new Shape(); 
		
		
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
		
		visible = true;
		Glb.GetRendererAS().AddToSceneAS( this );
	}
	
	////////////////////////////////////////////////////////////
	public function Update()
	{
		x = MTRG.BOARD_WIDTH / 2 + MTRG.BOARD_X;
		y = 64;
		
		m_ScanShape.x += Glb.GetSystem().GetGameDeltaTime() * 70;
		if (m_ScanShape.x> MS_SIZE_X * 0.5 - 32)
		{
			m_ScanShape.x  = - MS_SIZE_X * 0.5;
		}
	}
}