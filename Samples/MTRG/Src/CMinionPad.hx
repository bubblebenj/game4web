/**
 * ...
 * @author de
 */

package ;
import flash.display.Shape;
import flash.display.Sprite;

import kernel.Glb;
import CMinion;

class CMinionPad extends Sprite , implements Updatable
{
	var m_Img : Shape;
	var m_MinionArray : Array<CMinion>;
	
	public function new() 
	{
		super();
		m_Img = null;
		m_MinionArray = null;
	}
	
	static inline var MARGIN : Int= 16;
	public function Initialize()
	{
		m_Img = new Shape(); 
		m_Img.graphics.beginFill( 0x777777 );
		m_Img.graphics.lineStyle(3, 0x000000);
		
		var l_Margin = MARGIN;
		m_Img.graphics.drawRoundRect(l_Margin, l_Margin, MTRG.BOARD_X - l_Margin, MTRG.HEIGHT - l_Margin * 2, 24,24);
		
		m_Img.graphics.endFill();
		
		addChild(m_Img);
		Glb.GetRendererAS().AddToSceneAS(this);
		
		m_Img.alpha = 0.2;
		m_Img.cacheAsBitmap = true;
		visible = true;
		//visible = false;
		
		m_MinionArray = new Array<CMinion>();
		m_MinionArray[ Type.enumIndex( EMinions.SpaceInvaders ) ] = new CSpaceInvaderMinion();
		m_MinionArray[ Type.enumIndex( EMinions.Crossars ) ] = new CCrossMinion();
		m_MinionArray[ Type.enumIndex( EMinions.Shielders ) ] = new CSpaceCircleMinion();
		m_MinionArray[ Type.enumIndex( EMinions.Perforators ) ] = new CPerforatingMinion();
		
		
	}
	
	public function Populate()
	{
		var l_Margin = MARGIN;
		var l_Top = 	l_Margin * 3;
		var l_Bottom =  MTRG.HEIGHT - l_Margin * 3;
		
		var i = 0;
		
		for (m in m_MinionArray )
		{
			var l_Pos : Float = l_Top + i * ( l_Bottom - l_Top  ) / (m_MinionArray.length-1); 
			//var l_Pos : Float = l_Top + i * ( 64 ) ;
			m.Initialize();
			m.x = MTRG.BOARD_X * 0.5 + l_Margin * 0.5;
			m.y = l_Pos;
			m.visible = true;
			i++;
		}
	}
	public function GetDisplayObject()
	{
		return cast this;
	}
	
	public function IsLoaded() : Bool
	{
		return m_Img != null;
	}
	
	public function Update()
	{
		
	}
	
	public function Shut()
	{
		Glb.GetRendererAS().RemoveFromSceneAS(m_Img);
		m_Img = null;
	}
}