/**
 * ...
 * @author de
 */

package ;
import CMinion;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.MouseEvent;
import kernel.CDebug;
import kernel.Glb;
import Game;
import math.CV2D;


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
		m_Img.graphics.drawRoundRect(l_Margin, l_Margin, MTRG.BOARD_X - l_Margin, MTRG.HEIGHT * 0.5- l_Margin * 2, 24,24);
		
		m_Img.graphics.endFill();
		
		addChild(m_Img);
		Glb.GetRendererAS().AddToSceneAS(this);
		
		m_Img.alpha = 0.2;
		m_Img.cacheAsBitmap = true;
		visible = false;
		//visible = false;
		
		m_MinionArray = new Array<CMinion>();
		m_MinionArray[ Type.enumIndex( EMinions.SpaceInvaders ) ] = new CSpaceInvaderMinion();
		m_MinionArray[ Type.enumIndex( EMinions.Crossars ) ] = new CCrossMinion();
		m_MinionArray[ Type.enumIndex( EMinions.Shielders ) ] = new CSpaceCircleMinion();
		m_MinionArray[ Type.enumIndex( EMinions.Perforators ) ] = new CPerforatingMinion();
		
		Lambda.iter( m_MinionArray, function(m) m.visible = true  );
	}
	
	public function Populate()
	{
		var l_Margin = MARGIN;
		var l_Top = 	l_Margin * 3;
		var l_Bottom =  MTRG.HEIGHT * 0.5 - l_Margin * 3;
		
		var i = 0;
		
		CDebug.CONSOLEMSG("Minion Pad populated");
		for (m in m_MinionArray )
		{
			var l_Pos : Float = l_Top + i * ( l_Bottom - l_Top  ) / (m_MinionArray.length-1); 
			//var l_Pos : Float = l_Top + i * ( 64 ) ;
			m.Initialize();
			
			m.m_Center.Set( (MTRG.BOARD_X * 0.5 + l_Margin * 0.5) / MTRG.HEIGHT, (l_Pos) / MTRG.HEIGHT);
			
			m.Update();
			
			m.visible = true;
			addChild(m);
			//Glb.GetRendererAS().AddToSceneAS( m );
			//Glb.GetRendererAS().SendToFront( m );
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
		if (MTRG.s_Instance.m_Gameplay.m_DND == DND_FREE)
		{
			if ( Glb.GetInputManager().GetMouse().IsDown()  )
			{
				//CDebug.CONSOLEMSG("Down");
				var l_MousePos :CV2D =  Glb.GetInputManager().GetMouse().GetPosition();
				
				for (m in m_MinionArray )
				{
					//CDebug.CONSOLEMSG("minion: " + m.m_Center + ":" + m.m_Radius);
					//CDebug.CONSOLEMSG("mouse: " + l_MousePos);
					if( CCollManager.TestCircleCircle( m.m_Center, m.m_Radius, l_MousePos, 1.0 / MTRG.HEIGHT) )
					{
						//CDebug.CONSOLEMSG("Down");
						var l_New = MTRG.s_Instance.m_Gameplay.m_MinionHelper.Create(m);
						CDebug.ASSERT(l_New != null);
						
						l_New.m_Center.Copy( l_MousePos );
						l_New.visible = true;
						l_New.Update();
						MTRG.s_Instance.m_Gameplay.m_DND = DND_SOME( l_New );
						return;
					}
				}
			}
		}
		else
		{
			switch(MTRG.s_Instance.m_Gameplay.m_DND )
			{
				case DND_SOME( _Mob ):
				{
					var l_MousePos =  Glb.GetInputManager().GetMouse().GetPosition();
					_Mob.m_Center.Copy(l_MousePos);
					_Mob.Update();
					MTRG.s_Instance.m_Gameplay.m_DND = DND_SOME( _Mob ); 
				}
				default://don t care
			}
		}
		
		if ( !Glb.GetInputManager().GetMouse().IsDown() 
		&& MTRG.s_Instance.m_Gameplay.m_DND != DND_FREE)
		{
			MTRG.s_Instance.m_Gameplay.PlaceCurrentDND();
			MTRG.s_Instance.m_Gameplay.m_DND = DND_FREE;
		}
	}
	
	public function Shut()
	{
		Glb.GetRendererAS().RemoveFromSceneAS(m_Img);
		m_Img = null;
	}
}