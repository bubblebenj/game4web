/****************************************************
 * MTRG : Motion-Twin recruitment game
 * A game by David Elahee
 * 
 * MTRG is a Space Invader RTS, the goal is to protect your mothership from
 * the random AI that shoots on it.
 * 
 * Powered by Game4Web a cross-platform engine by David Elahee & Benjamin Dubois.
 * 
	Copyright (C) 2011  David Elahee

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses
	
 * @author de
 ****************************************************/



  
 /**
  * offers the dnd gameplay and manages mininon production
  * also manages the next medium term motives : discovering the next minion category
  */
 
package ;
import CMinion;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.text.TextFormat;
import kernel.CDebug;
import kernel.Glb;
import Game;
import math.CV2D;


enum TFS
{
	RED;
	NORMAL;
}

class CMinionPad extends Sprite , implements Updatable
{
	var m_Img : Shape;
	
	var m_MinionArray : Array<CMinion>;
	
	//smooth diff curve with unit stepping on availability
	var m_MinionAvail : Array < Int>;
	var m_MinionCounter :  Array <TextField>;
	var m_MinionCounterFormat : Array <TextFormat>;
	
	var m_AvailTimer : Float;
	public static inline var m_AvailTimerDuration : Float = 1.0;
	public static inline var AVAIL_INCR : Int = 4;
	
	public function new() 
	{
		super();
		m_Img = null;
		m_MinionArray = null;
		m_MinionCounterFormat = null;
	}
	
	static inline var MARGIN : Int= 16;
	public function Initialize()
	{
		m_MinionCounterFormat = new Array<TextFormat>();
		m_MinionCounter = new Array<TextField>();
		m_MinionAvail = new Array < Int>();
		
		m_MinionCounterFormat[Type.enumIndex(RED)] = new TextFormat();
		m_MinionCounterFormat[Type.enumIndex(RED)].size = 18;
		m_MinionCounterFormat[Type.enumIndex(RED)].font = "arial";
		m_MinionCounterFormat[Type.enumIndex(RED)].color = 0xFF0000;
		m_MinionCounterFormat[Type.enumIndex(RED)].bold = true;
		
		m_MinionCounterFormat[Type.enumIndex(NORMAL)] = new TextFormat();
		m_MinionCounterFormat[Type.enumIndex(NORMAL)].size = 16;
		m_MinionCounterFormat[Type.enumIndex(NORMAL)].font = "arial";
		m_MinionCounterFormat[Type.enumIndex(NORMAL)].color = 0xFFF5C7;
		
		m_MinionAvail[0] = 1;
		m_AvailTimer = 0;
	
		m_Img = new Shape(); 
		m_Img.graphics.beginFill( 0x777777 );
		m_Img.graphics.lineStyle(3, 0x000000);
		
		//draws the ui
		var l_Margin = MARGIN;
		m_Img.graphics.drawRoundRect(l_Margin, l_Margin, MTRG.BOARD_X - l_Margin, MTRG.HEIGHT * 0.5- l_Margin * 1, 24,24);
		m_Img.graphics.endFill();
		
		addChild(m_Img);
		Glb.GetRendererAS().AddToSceneAS(this);
		
		m_Img.alpha = 0.2;
		m_Img.cacheAsBitmap = true;
		visible = false;
		//visible = false;
		
		//initialize tempalte of dnd
		m_MinionArray = new Array<CMinion>();
		m_MinionArray[ Type.enumIndex( EMinions.SpaceInvaders ) ] = new CSpaceInvaderMinion();
		m_MinionArray[ Type.enumIndex( EMinions.Crossars ) ] = new CCrossMinion();
		m_MinionArray[ Type.enumIndex( EMinions.Shielders ) ] = new CSpaceCircleMinion();
		m_MinionArray[ Type.enumIndex( EMinions.Perforators ) ] = new CPerforatingMinion();
		
		m_MinionAvail[ m_MinionArray.length -1] = 0;
		m_MinionCounter[ m_MinionArray.length -1] = null;
		
		var l_Margin = MARGIN;
		var l_Top = 	l_Margin * 3;
		var l_Bottom =  MTRG.HEIGHT * 0.5 - l_Margin * 3;
		
		for (i in 0...m_MinionArray.length)
		{
			var l_Pos : Float = l_Top + i * ( l_Bottom - l_Top  ) / (m_MinionArray.length-1); 
			var l_NotHPosX = MTRG.BOARD_X * 0.5 + l_Margin * 0.5;
			var l_NotHPosY = l_Pos;
			
			m_MinionCounter[i] = new TextField();
			m_MinionCounter[i].x = l_NotHPosX + 16;
			m_MinionCounter[i].y = l_NotHPosY + 16;
			m_MinionCounter[i].visible = true;
			addChild(m_MinionCounter[i]);
		}
		UpdateCounters();
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
			
			var l_NotHPosX = MTRG.BOARD_X * 0.5 + l_Margin * 0.5;
			var l_NotHPosY = l_Pos;
			m.m_Center.Set( l_NotHPosX/ MTRG.HEIGHT,  l_NotHPosY/ MTRG.HEIGHT);
			m.Update();
			
			m_MinionCounter[i].visible = true;
			m.visible = true;
			addChild(m);
			i++;
		}
		UpdateCounters();
	}
	public function GetDisplayObject()
	{
		return cast this;
	}
	
	public function IsLoaded() : Bool
	{
		return m_Img != null;
	}
	
	public function UpdateCounters()
	{
		
		for(i in 0...m_MinionAvail.length)
		{
			if ( m_MinionCounter[i] == null) continue;
			
			var l_CurEnum = NORMAL;
			if (m_MinionAvail[i] == 0)
			{
				l_CurEnum = RED;
			}
			
			m_MinionCounter[i].text = Std.string(m_MinionAvail[i]);
			m_MinionCounter[i].setTextFormat( m_MinionCounterFormat[Type.enumIndex(l_CurEnum)] );
			m_MinionCounter[i].visible = true;
		}
	}
	
	public function UpdateAvailability()
	{
		m_AvailTimer += Glb.g_System.GetGameDeltaTime();
		if (m_AvailTimer>m_AvailTimerDuration )
		{
			m_AvailTimer = 0;
			m_MinionAvail[0]++;
			
			for(i in 0...m_MinionAvail.length-1)
			{
				if (m_MinionAvail[i]>=AVAIL_INCR)
				{
					m_MinionAvail[i] -= AVAIL_INCR;
					
					m_MinionAvail[i + 1]++;
				}
			}
			
			UpdateCounters();
		}
	}
	
	public function Update()
	{
		UpdateAvailability();
		
		if (MTRG.s_Instance.m_Gameplay.m_DND == DND_FREE)
		{
			if ( Glb.GetInputManager().GetMouse().IsDown()  )
			{
				//CDebug.CONSOLEMSG("Down");
				var l_MousePos :CV2D =  Glb.GetInputManager().GetMouse().GetPosition();
				
				var i = 0;
				for (m in m_MinionArray )
				{
					//CDebug.CONSOLEMSG("minion: " + m.m_Center + ":" + m.m_Radius);
					//CDebug.CONSOLEMSG("mouse: " + l_MousePos);
					if (( m_MinionAvail[i] > 0)
					&&	CCollManager.TestCircleCircle( m.m_Center, m.m_Radius, l_MousePos, 1.0 / MTRG.HEIGHT) )
					{
						//CDebug.CONSOLEMSG("Down");
						var l_New = MTRG.s_Instance.m_Gameplay.m_MinionHelper.Create(m);
						CDebug.ASSERT(l_New != null);
						
						l_New.m_Center.Copy( l_MousePos );
						l_New.visible = true;
						l_New.Update();
						MTRG.s_Instance.m_Gameplay.m_DND = DND_SOME( l_New );
						m_MinionAvail[i]--;//if dnd fails, minion instance is load
						
						UpdateCounters();
						return;
					}
					i++;
				}
			}
		}
		else
		{
			//do the dnd 
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
	
	//
	public function Shut()
	{
		m_MinionCounter = null;
		m_MinionCounterFormat = null;
		m_MinionAvail = null;
		Glb.GetRendererAS().RemoveFromSceneAS(this);
		m_Img = null;
	}
}