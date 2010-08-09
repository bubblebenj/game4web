/**
 * ...
 * @author de
 */

package renderer;

import renderer.CMaterial;
import renderer.CPrimitive;

class CMesh extends CDrawObject;
{

	public function new() 
	{
		m_Primitives = new Array<CPrimitive>();
		m_Materials = new Array<CMaterial>();
	}
	
	var	m_Primitives : Array<CPrimitive>;
	var	m_Materials : Array<CMaterial>;
}