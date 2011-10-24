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



package ;


////////////////////game sequencing
import flash.display.BitmapData;
import driver.as.renderer.C2DImageAS;
import flash.display.DisplayObject;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.geom.Matrix;
import flash.Lib;
import flash.media.Sound;
import flash.media.SoundChannel;
import flash.media.SoundMixer;
import flash.media.SoundTransform;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.text.TextField;
import flash.text.TextFormat;
import haxe.TimerQueue;

import kernel.Glb;
import kernel.CSystem;
import CTypes;
import CDebug;

enum GAME_STAGE
{
	GS_INIT;
	GS_STARTING;
	GS_BEGIN_SCREEN;
	GS_RUNNING;
	GS_END_SCREEN(_Won : Bool);
}

//does not work :-(
//typedef BeginScreen = { > Sprite, Body:TextField } ;

class MTRG implements SystemProcess
{
	public static var s_Instance	: MTRG; 
	public var m_State				: GAME_STAGE;
	public var m_Gameplay 			: Game;
	public var m_LoadTimer			: TimerQueue;
	
	//public var m_BeginScreen :  BeginScreen;
	public var m_BeginScreen :  Sprite;
	public var m_BeginScreenBody :  TextField;
	public var m_BeginScreenBodyFormat :  TextFormat;
	public var m_EndScreen :  Sprite;
	
	public var m_Tasks : List<CTimedTask>;
	
	public static var WIDTH : Float = 600;
	public static var HEIGHT : Float = 800;
	public static var ASTEROIDS_HEIGHT : Float = 275;
	public static var BOARD_X : Float = 100;
	public static var BOARD_WIDTH : Float = WIDTH - BOARD_X;
	
	public var m_Music : Sound;
	public var m_MusicChannel : SoundChannel;
	public var m_MusicStarted : Bool;
	public var m_SoundBank : CSoundBank;
	
	////////////////////////////////////////////////////////////
	public function new() 
	{
		s_Instance = this;
		m_State = GS_INIT;
		m_EndScreen =  null;
		m_BeginScreen = null;
		m_Tasks = new List<CTimedTask>();
		m_Music = null;
		m_SoundBank = null;
		m_MusicStarted = false;
	}
	
	public function PlayMusic()
	{
		if (m_Music ==null)
		{
			m_Music = new Sound(new URLRequest("Data/Lazer_Sword.mp3"));
			
			m_Music.addEventListener( Event.COMPLETE, OnLoadDone); 
			m_Music.addEventListener(Event.SOUND_COMPLETE, OnSoundEnd);

			m_MusicChannel = m_Music.play();
			m_SoundBank = new CSoundBank();
		}
		else
		{
			m_SoundBank.StopBank();
			m_MusicChannel = m_Music.play();
		}
	}
	
	function OnLoadDone(_):Void
	{
		
	}
	 
	function OnSoundEnd(_):Void
	{
		m_MusicChannel = m_Music.play();
	}
	
	////////////////////////////////////////////////////////////
	//gentlemen... startup your engines !
	public function Startup()
	{
		m_State = GS_STARTING;
		m_Gameplay = new Game();
		m_Gameplay.Initialize();
	}
	
	////////////////////////////////////////////////////////////
	public function Shut()
	{
		m_Gameplay.Shut();
		m_Gameplay = null;
	}

	////////////////////////////////////////////////////////////
	function UpdateGame()
	{
		//trace ("blop");
		m_Gameplay.Update();
	}
	
	////////////////////////////////////////////////////////////
	public function AfterUpdate() : Result
	{
		m_Tasks =  Lambda.filter( 
									Lambda.map(m_Tasks, function( t) { return ( t.Update() == false ) ? t : null;} ),
									function(x) { return x != null; }
									);
		return SUCCESS;
	}
	
	////////////////////////////////////////////////////////////
	public function BeforeUpdate() : Result
	{
		
		switch( s_Instance.m_State )
		{
			case GS_INIT:
				
				Startup();
				
			case GS_STARTING:
				PlayMusic();
				//m_State = GS_RUNNING;
				//m_Gameplay.SetVisible(true);
				m_State  = GS_BEGIN_SCREEN;
			case GS_BEGIN_SCREEN:
				
				BuildBeginScreen();
				
			case GS_RUNNING:
				UpdateGame();
				
			case GS_END_SCREEN(w):
				BuildEndScreen(w);
		}

		return SUCCESS;
	}
	
	////////////////////////////////////////////////////////////
	public function GetBeginText():String
	{
		return 	"Slv. : ...Chief Chief we got a problem....\n"
		+		"Bss. : C'mon on ya prick, 'm basy playin tha fracking spaceinvader sh*t...\n"
		+		"Slv. : It is really important our glorious mother ship is under assault!\n"
		+		"Bss. : What the hell are you talking about..\n"	
		+		"Bss. : Why not blue horses with fracking trumps doing dirt with cats...\n"
		+		"Slv. : No no chief, it is true they are coming...\n"
		+		"Slv. : THE HUMANS ARE HERE!!!!\n"
		+		"Bss. : ...\n"
		+		"Bss. : ...\n"
		+		"Bss. : ...\n"
		+		"Bss. : okay DRAG and DROP near our ship our troops and eliminate them!\n"
		+		"Slv. : But... the repetitors are still bugged\n"
		+		"Bss. : It's not a bug it's a feature maggot...!\n"
		+		"Bss. : Our race can only survive if it proves it has a brain...\n"
		+		"Bss. : And exploit minions carefully!\n"
		+		"Slv. : Yes MASTTTTTAAAA!!!!\n"
		+		"Bss. : GO GO GO!!!\n"
		+		"\n\n\nClick to continue";
	}
	
	////////////////////////////////////////////////////////////
	public function BuildBeginScreen()
	{
		if ( m_BeginScreen == null )
		{
			//CDebug.CONSOLEMSG("printing begin");
			m_BeginScreen = new Sprite();
			var l_Shape : Shape = new Shape();
			l_Shape.graphics.beginFill(0xB2A568, 0.8);
			l_Shape.graphics.drawRoundRect( 32, 32, MTRG.WIDTH - 48, MTRG.HEIGHT - 48, 8, 8);
			l_Shape.graphics.endFill();
			
			l_Shape.graphics.beginFill(0xFFF5C7, 0.8);
			l_Shape.graphics.drawRoundRect( 24, 24, MTRG.WIDTH - 32, MTRG.HEIGHT - 32, 8, 8);
			l_Shape.graphics.endFill();
			
			l_Shape.visible = true;
			
			
			var l_Title = new TextField();
			
			l_Title.x = 48;
			l_Title.y = 48;
			l_Title.text = "In a Galaxy far far away...";
			l_Title.width = MTRG.HEIGHT - 48 - 32;
			l_Title.visible = true;
			l_Title.textColor = 0x7B69CC;
			{
				var l_Title0Format = new flash.text.TextFormat();
				l_Title0Format.font = "Arial";
				l_Title0Format.italic = true;
				l_Title0Format.size = 42;
				l_Title0Format.bold = true;
				
				l_Title.setTextFormat( l_Title0Format );
			}
			
			m_BeginScreenBody= new TextField();
			
			m_BeginScreenBody.x = 48;
			m_BeginScreenBody.y = l_Title.y + 16 + l_Title.height;
			
			m_BeginScreenBody.height = 400;
			m_BeginScreenBody.width = MTRG.HEIGHT - 48 - 32;
			m_BeginScreenBody.visible = true;
			
			m_BeginScreenBody.textColor = 0x7B69CC;
			
			{
				m_BeginScreenBodyFormat = new flash.text.TextFormat();
				m_BeginScreenBodyFormat.font = "Arial";
				m_BeginScreenBodyFormat.size = 16;
				
				m_BeginScreenBody.setTextFormat( m_BeginScreenBodyFormat );
			}
			
			m_BeginScreen.addChild(l_Shape);
			m_BeginScreen.addChild(l_Title);
			m_BeginScreen.addChild(m_BeginScreenBody);
			m_BeginScreen.alpha = 0;
			m_BeginScreen.visible = true;
			Glb.GetRendererAS().AddToSceneAS(m_BeginScreen);
			//Glb.GetRendererAS().SendToBack( m_BeginScreen );
		}
		else
		{
			//CDebug.CONSOLEMSG	("other " + m_BeginScreen);
			if (m_BeginScreen.alpha <1)
			{
				m_BeginScreen.alpha += 1 * Glb.GetSystem().GetGameDeltaTime();
			}
			else
			{
				m_BeginScreen.alpha = 1;
			}
			
			if (m_BeginScreen.alpha >= 1)
			{
				
				if (Glb.GetInputManager().GetMouse().IsDown())
				{
					m_BeginScreen.visible = false;
					Glb.GetRendererAS().RemoveFromSceneAS(m_BeginScreen);
					m_BeginScreen = null;
					m_BeginScreenBody = null;
					m_BeginScreenBodyFormat = null;
					
					
					m_Gameplay.Start();
					m_Gameplay.SetVisible(true);
					m_State = GS_RUNNING;
				}
				
			}
			
			if(m_BeginScreenBody!= null)
			{
				var l_CurText =  GetBeginText();
				m_BeginScreenBody.text = l_CurText.substr(0, Std.int(l_CurText.length * m_BeginScreen.alpha));
				m_BeginScreenBody.setTextFormat( m_BeginScreenBodyFormat );//so weird...crap...
			}
		}
	}
	
	////////////////////////////////////////////////////////////
	public function BuildEndScreen(_w)
	{
		if ( m_EndScreen == null )
		{
			Shut();
			
			m_EndScreen = new Sprite();
			var l_Shape :Shape = new Shape();
			l_Shape.graphics.beginFill(0xFFFFFF, 0.8);
			l_Shape.graphics.drawRoundRect( 32, 32, MTRG.WIDTH- 48, MTRG.HEIGHT - 48,8,8);
			l_Shape.visible = true;
			m_EndScreen.addChild(l_Shape);
			
			var l_Title = new TextField();
			
			l_Title.x = 48;
			l_Title.y = 48;
			l_Title.text =  ((_w) ? "YOU WON" : "YOU LOST..." ) +"!\n\nYou liked it ?";
			l_Title.width = MTRG.WIDTH - 48 - 32;
			l_Title.height = 256;
			l_Title.visible = true;
			l_Title.textColor = 0x000000;
			var l_Title0Format = new flash.text.TextFormat();
			l_Title0Format.font = "Arial";
			l_Title0Format.italic = true;
			l_Title0Format.size = 45;
			l_Title0Format.bold = true;
			
			l_Title.setTextFormat( l_Title0Format );
			
			
			var l_ClickHere = new TextField();
			l_ClickHere.x = 48;
			l_ClickHere.y = l_Title.y + 16 + l_Title.height;
			var l_FontBegin = "<font FACE=\"Arial\" SIZE=\"36\" COLOR=\"#FF0000\">";
			var l_FontEnd = "</font>";
			l_ClickHere.htmlText = 	l_FontBegin 
					+  "<a href=\"mailto:david.elahee@gmail.com?subject=Recruitment&body=Hi David,\nSince your game really kicks ass a lot, we will recruit you!\nsign with your blood here ;-)\" >david.elahee@gmail.com</A>" 
					+ l_FontEnd;

			l_ClickHere.width = MTRG.WIDTH- 48 - 32;
			l_ClickHere.visible = true;
			l_ClickHere.textColor = 0xFF1111;
			
			m_EndScreen.addChild(l_ClickHere);
			
			
			var l_ClickSomewhereElse = new TextField();
			l_ClickSomewhereElse.x = 48;
			l_ClickSomewhereElse.y = l_ClickHere.y + 16 + l_ClickHere.height;
			l_ClickSomewhereElse.text = "Click somewhere else to try again!";
			l_ClickSomewhereElse.width = MTRG.WIDTH - 48 - 32;
			l_ClickSomewhereElse.visible = true;
			l_ClickSomewhereElse.textColor = 0x000000;
			var l_ClickSomewhereElseFormat = new flash.text.TextFormat();
			l_ClickSomewhereElseFormat.font = "Arial";
			l_ClickSomewhereElseFormat.size = 24;
			l_ClickSomewhereElse.setTextFormat( l_ClickSomewhereElseFormat );
			
			m_EndScreen.addChild(l_ClickSomewhereElse);
			
			m_EndScreen.alpha = 0;
			m_EndScreen.addChild(l_Title);
			m_EndScreen.visible = true;
			Glb.GetRendererAS().AddToSceneAS(m_EndScreen);
		}
		else
		{
			if (m_EndScreen.alpha <1)
			{
				m_EndScreen.alpha += 1 * Glb.GetSystem().GetGameDeltaTime();
			}
			else
			{
				m_EndScreen.alpha = 1;
			}
			
			if (m_EndScreen.alpha >= 1)
			{
				if( Glb.GetInputManager().GetMouse().IsDown() )
				{
					Glb.GetRendererAS().RemoveFromSceneAS(m_EndScreen);
					m_EndScreen = null;
					m_SoundBank.StopBank();
					m_State = GS_INIT;
				}
			}
			
			
		}
	}

	////////////////////////////////////////////////////////////
	public function Reset()
	{
		
	}
	
	////////////////////////////////////////////////////////////
	public function AfterDraw() : Result
	{
		return SUCCESS;
	}
	
	public function BeforeDraw() : Result
	{
		return SUCCESS;
	}
	
	////////////////////////////////////////////////////////////
	public static function main()
	{
		var l_MTRG = new MTRG();

		Lib.fscommand( "allowscale", "true");
		Lib.fscommand( "showmenu", "false");

		var WIDTH = Lib.current.stage.stageWidth;
		var HEIGHT = Lib.current.stage.stageHeight;
		
		CDebug.CONSOLEMSG("w=" +WIDTH+ " h=" +HEIGHT);
		if( Glb.g_System == null )
		{
			CDebug.CONSOLEMSG("no g_system");
		}
		else 
		{
			CDebug.CONSOLEMSG("system init");
			Glb.g_System.Initialize();
			CDebug.CONSOLEMSG("main loop");
			
			Glb.g_System.m_Process = l_MTRG;
			
			Glb.g_System.MainLoop();
		}
	}
	

	
}