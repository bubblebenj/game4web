/**
 * ...
 * @author de
 */

package renderer;

import CTypes;
import math.CMatrix44;

import rsc.CRscMan;
import rsc.CRsc;

enum Z_EQUATION
{
	Z_LESSER;
	Z_LESSER_EQ;
	Z_GREATER;
	Z_GREATER_EQ;
}

class CRenderStates extends CRsc
{
	public static var 	RSC_ID : Int = { CRscMan.RSC_COUNT++; };
	public override function GetType() : Int
	{
		return RSC_ID;
	}

	public function new()
	{
		super();
		m_ZRead = true;
		m_ZWrite = true;
		m_ZEq = Z_GREATER_EQ;
		m_VPMatrix = new CMatrix44();
		m_VPMatrix.Identity();
	}

	public override function Copy( _Rsc : CRsc ) : Void
	{
		super.Copy(_Rsc);

		var l_Rs = cast(_Rsc,CRenderStates);
		m_ZRead = l_Rs.m_ZRead;
		m_ZWrite = l_Rs.m_ZWrite;
		m_ZEq = l_Rs.m_ZEq;

		m_VPMatrix.Copy(l_Rs.m_VPMatrix);
	}

	public function Activate() : Result
	{
		return SUCCESS;
	}

	public function Reset()
	{
		m_ZRead = true;
		m_ZWrite = true;
		m_ZEq = Z_GREATER_EQ;
	}

	public function SetCurrentVPMatrix( _Mat : CMatrix44 )
	{
		m_VPMatrix = _Mat;
	}

	public var m_ZRead : Bool;
	public var m_ZWrite : Bool;
	public var m_ZEq : Z_EQUATION;
	public var m_VPMatrix : CMatrix44;
}