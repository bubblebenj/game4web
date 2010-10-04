/**
 * ...
 * @author Benjamin Dubois
 */

package logic;

typedef TransitionId = String;

class CMenuTransition
{
	private var m_Id	: TransitionId;
	
	public function new( _Id : String ) 
	{
		m_Id	= _Id;
	}
	
	public function GetId() : String
	{
		return	m_Id;
	}
}