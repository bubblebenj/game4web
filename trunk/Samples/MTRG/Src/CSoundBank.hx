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
import flash.media.Sound;
import flash.media.SoundChannel;
import flash.net.URLRequest;

enum SNDS
{
	LASER;
	BOULETTE;
	ZAP;
	MS_ZAP;
	EXPLOSION;
	SHIP_ZAP;
	LOST;
	WON;
}

class CSoundBank 
{

	public function new() 
	{
		if (m_Snds == null )
		{
			m_Snds = new Array<Sound>();
			m_SndsChan = new Array<SoundChannel>();
			
			m_Snds[Type.enumIndex(LASER)] 		= new Sound(new URLRequest("Data/Laser.mp3"));
			m_Snds[Type.enumIndex(BOULETTE)] 	= new Sound(new URLRequest("Data/Boulette.mp3"));
			m_Snds[Type.enumIndex(ZAP)] 	= new Sound(new URLRequest("Data/Zap.mp3"));
			m_Snds[Type.enumIndex(LOST)] 	= new Sound(new URLRequest("Data/Lost.mp3"));
			m_Snds[Type.enumIndex(WON)] 	= new Sound(new URLRequest("Data/Won.mp3"));
			m_Snds[Type.enumIndex(MS_ZAP)] 	= new Sound(new URLRequest("Data/MS_Zap.mp3"));
			m_Snds[Type.enumIndex(SHIP_ZAP)] 	= new Sound(new URLRequest("Data/ShipZap.mp3"));
		}
	}
	
	public var m_Snds : Array<Sound>;
	public var m_SndsChan : Array<SoundChannel>;
	
	public function StopBank()
	{
		Lambda.iter( m_SndsChan, function(s) if(s!=null) s.stop() );
	}
	public function PlayLaserSound()
	{
		m_SndsChan[Type.enumIndex(LASER)] = m_Snds[Type.enumIndex(LASER)].play();
	}
	
	public function PlayBouletteSound()
	{
		m_SndsChan[Type.enumIndex(BOULETTE)] = m_Snds[Type.enumIndex(BOULETTE)].play();
	}
	
	public function PlayZapSound()
	{
		m_SndsChan[Type.enumIndex(ZAP)] = m_Snds[Type.enumIndex(ZAP)].play();
	}
	
	public function PlayMsZapSound()
	{
		m_SndsChan[Type.enumIndex(MS_ZAP)] = m_Snds[Type.enumIndex(MS_ZAP)].play();
	}
	
	public function PlayLostSound()
	{
		m_SndsChan[Type.enumIndex(LOST)] = m_Snds[Type.enumIndex(LOST)].play();
	}
	
	public function PlayWinSound()
	{
		m_SndsChan[Type.enumIndex(WON)] = m_Snds[Type.enumIndex(WON)].play();
	}
	
	public function PlayShipZapSound()
	{
		m_SndsChan[Type.enumIndex(SHIP_ZAP)] = m_Snds[Type.enumIndex(SHIP_ZAP)].play();
	}
}