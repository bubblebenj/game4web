/**
 * ...
 * @author de
 */

package ;
import flash.display.Shape;
import flash.display.Sprite;

import kernel.Glb;

class CMinionPad extends Sprite , implements Updatable
{
	var m_Img : Shape;
	public function new() 
	{
		super();
		m_Img = null;
	}
	
	public function Initialize()
	{
		m_Img = new Shape(); 
		m_Img.graphics.beginFill( 0x777777 );
		m_Img.graphics.lineStyle(3, 0x000000);
		
		var l_Margin = 16;
		m_Img.graphics.drawRoundRect(l_Margin, l_Margin, MTRG.BOARD_X - l_Margin, MTRG.HEIGHT - l_Margin * 2, 24,24);
		
		m_Img.graphics.endFill();
		
		addChild(m_Img);
		Glb.GetRendererAS().AddToSceneAS(this);
		
		m_Img.alpha = 0.2;
		m_Img.cacheAsBitmap = true;
		visible = true;
		//visible = false;
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