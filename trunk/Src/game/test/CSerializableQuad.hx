/**
 * ...
 * @author de
 */

package test;

import CDriver;

import CTypes;
import memory.CFieldSaver;

class CSerializableQuad extends C2DImage
{
	override public function Initialize():Result 
	{
		
		return super.Initialize();
	}
	
	public function new() 
	{
		super();
		
		m_Save = new CFieldSaver();
		m_Save.BindField("Rect", m_Rect);
	}
	
	public function Dump()
	{
		m_Save.SaveInstances();
		m_Save.Dump();
	}
	
	private var m_Save : CFieldSaver;
}