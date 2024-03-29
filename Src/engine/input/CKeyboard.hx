/**
 * ...
 * @author de
 */

package input;

import algorithms.CBitArray;
import CTypes;
import CDebug;

import rsc.CRsc;
import rsc.CRscMan;


class CKeyboard extends CRsc
{
	public static var 	RSC_ID = CRscMan.RSC_COUNT++;
	public override function GetType() : Int
	{
		return RSC_ID;
	}
	
	public	var m_NbKeyDown	: Int;
	
	public function new() 
	{
		super();
		m_NbKeyDown			= 0;
		m_UpArray			= new CBitArray( CKeyCodes.KEY_MAX );
		m_UpArray.Fill(true);
		
		m_PreviousUpArray	= new CBitArray(CKeyCodes.KEY_MAX);
		m_PreviousUpArray.Fill( true );
	}
	
	public override function Update() : Result
	{
		m_PreviousUpArray.Copy( m_UpArray );
		return SUCCESS;
	}
	
	public function IsKeyDown( _Kc : Int ) : Bool
	{
		return !m_UpArray.Is( _Kc );
	}
	
	public function WasKeyDown( _Kc : Int ) : Bool
	{
		return !m_PreviousUpArray.Is( _Kc );
	}
	
	public function IsKeyUp( _Kc : Int ) : Bool
	{
		return m_UpArray.Is( _Kc );
	}
	
	private var m_UpArray			: CBitArray;
	private var m_PreviousUpArray	: CBitArray;
}