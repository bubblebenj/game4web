/**
 * ...
 * @author de
 */

package memory;

import kernel.CTypes;
import kernel.CDebug;

class CFieldSaver 
{
	public function new() 
	{
		m_FieldsSource = new Array<Dynamic>();
		m_FieldsName = new Array<String>();
		
		m_FieldsView = new Array<String>();
	}

	//save the current reflection state
	public function SaveToXml( _Stream : Xml )
	{
		for( i in 0...m_FieldsSource.length )
		{
			var l_Out : Xml = Xml.createElement( m_FieldsName[i] );
			
			l_Out.nodeValue = m_FieldsView[i];
			
			_Stream.addChild(l_Out);
		}
	}
	
	public function ReadFromXml( _Stream : Xml )
	{
		for( i in 0...m_FieldsSource.length )
		{
			var l_Out : Iterator<Xml> = _Stream.elementsNamed( m_FieldsName[i] );
			
			m_FieldsView[i] = l_Out.next().nodeValue;
		}
	}
	
	public function SaveInstances() : Result
	{
		for( i in 0...m_FieldsView.length )
		{
			m_FieldsView[i] = haxe.Serializer.run(m_FieldsSource[i]);
		}
		
		return SUCCESS;
	}
	
	public function ReadInstances() : Result
	{
		for( i in 0...m_FieldsSource.length )
		{
			m_FieldsSource[i] = haxe.Unserializer.run(m_FieldsView[i]);
		}
		
		return SUCCESS;
	}
	
	public function BindField( _Name : String, _Member : Dynamic )
	{	
		CDebug.ASSERT(_Member);
		
		var i = m_FieldsView.length;
		
		m_FieldsName[i] = _Name ;
		m_FieldsSource[i] = _Member ;
	}
	
	public function Dump()
	{
		for( i in 0...m_FieldsSource.length )
		{
			CDebug.CONSOLEMSG( m_FieldsName[i] +" = "+ m_FieldsView[i]);
		}
	}
	
	private var m_FieldsName : Array<String>;
	private var m_FieldsSource : Array<Dynamic>;
	private var m_FieldsView : Array<String>;
}