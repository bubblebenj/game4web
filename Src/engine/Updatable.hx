/**
 * ...
 * @author de
 * 26/03/2011 22:21
 */

package ;

interface Updatable 
{
	public function IsLoaded()		: Bool;
	public function Initialize()	: Void;
	public function Update()		: Void;
	public function Shut()			: Void;
}