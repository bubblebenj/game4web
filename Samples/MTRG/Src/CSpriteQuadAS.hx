/**
 * ...
 * @author de
 */

package ;
import driver.as.renderer.C2DQuadAS;
import flash.display.Sprite;

class CSpriteQuadAS extends C2DQuadAS
{
	
	public function new() 
	{
		super();
		m_DisplayObject = new Sprite();
		m_Scale.Set(1,1);
	}
	
	public var m_Sprite(GetSprite, null) : Sprite;
	
	private function GetSprite() : Sprite
	{
		return cast m_DisplayObject;
	}
}