/**
 * ...
 * @author de
 */

package math;

class CKeyContainer<KeyType>
{
	
	public function new() 
	{
		Dates = null;
		Values = null;
		ValuesIn = null;
		ValuesOut = null;
	}
	
	Array <KeyType> Dates;
	Array <KeyType> Values;
	Array <KeyType> ValuesIn;
	Array <KeyType> ValuesOut;
}