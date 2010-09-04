/**
 * ...
 * @author de
 */

package renderer;

class CRenderContext 
{
	public var m_CurrentMaterial(default,SetActiveMaterial) : CMaterial;
	public var m_CurrentShader (default,SetActiveShader): CRscShader;
	
	public function new() 
	{
		m_CurrentMaterial = null;
		m_CurrentShader = null;
	}
	
	public function Reset()
	{
		SetActiveMaterial( null );
		SetActiveShader( null );
	}
	
	public function SetActiveShader( _sh : CRscShader ) : CRscShader
	{
		if( _sh != m_CurrentShader)
		{
			if(m_CurrentShader!= null)
			{
				m_CurrentShader.Release(); 
			}
			
			m_CurrentShader = _sh;
			
			if (m_CurrentShader != null)
			{
				m_CurrentShader.AddRef();
				m_CurrentShader.Activate();
			}
		}
		
		return m_CurrentShader;
	}
	
	public function SetActiveMaterial( _Mat : CMaterial ) : CMaterial
	{
		if( _Mat != m_CurrentMaterial)
		{
			if (m_CurrentMaterial != null)
			{
				m_CurrentMaterial.Release();
			}
			
			m_CurrentMaterial = _Mat;
			
			if (m_CurrentMaterial != null)
			{
				m_CurrentMaterial.AddRef();
				m_CurrentMaterial.Activate();
			}
		}
		
		return m_CurrentMaterial;
	}
}