/**
 * ...
 * @author de
 */

package ;

import kernel.CTypes;

interface SystemProcess 
{
	public function BeforeUpdate() : Result;
	public function AfterUpdate() : Result;
	
	public function BeforeDraw() : Result;
	public function AfterDraw() : Result;
}