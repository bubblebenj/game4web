/****************************************************
 * MTRG : Motion-Twin recruitment game
 * A game by David Elahee
 * 
 * MTRG is a Space Invader RTS, the goal is to protect your mothership from
 * the random AI that shoots on it.
 * 
 * Powered by Game4Web a cross-platform engine by David Elahee & Benjamin Dubois.
 * 
 * @author de
 ****************************************************/
package ;
import flash.media.Sound;
import flash.net.URLRequest;

enum SNDS
{
	LASER;
	BOULETTE;
	ZAP;
	EXPLOSION;
}

class CSoundBank 
{

	public function new() 
	{
		if (m_Snds == null )
		{
			m_Snds = new Array<Sound>();
			
			m_Snds[Type.enumIndex(LASER)] 		= new Sound(new URLRequest("Data/Laser.mp3"));
			m_Snds[Type.enumIndex(BOULETTE)] 	= new Sound(new URLRequest("Data/Boulette.mp3"));
			m_Snds[Type.enumIndex(ZAP)] 		= new Sound(new URLRequest("Data/Lazer_Sword.mp3"));
			m_Snds[Type.enumIndex(EXPLOSION)] 	= new Sound(new URLRequest("Data/Lazer_Sword.mp3"));
		}
	}
	
	public var m_Snds : Array<Sound>;
	
	public function PlayLaserSound()
	{
		m_Snds[Type.enumIndex(LASER)].play();
	}
	
	public function PlayBouletteSound()
	{
		m_Snds[Type.enumIndex(BOULETTE)].play();
	}
	
	public function PlayZapSound()
	{
		
	}
}