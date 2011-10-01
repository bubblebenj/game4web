package rsc;
import haxe.xml.Fast;
import kernel.Glb;
import renderer.CMesh;
import remotedata.IRemoteData;
/**
 * ...
 * @author 
 */

class CRscDAE extends CRsc
{
	public static var 	RSC_ID = CRscMan.RSC_COUNT++;
	public override function GetType() : Int return RSC_ID
	public var m_Meshes : Hash<CMesh>;
	
	public function new() super()
	var m_Buffer : CRscText;
	
	public var m_Xml : Fast;
	
	public override function SetPath(p)
	{
		super.SetPath(p);
		m_Buffer = cast Glb.g_System.GetRscMan().Load( CRscText.RSC_ID, p );
		m_state = SYNCING;
		m_Meshes = new Hash();
		Queue();
	}
	 
	public override function Update()
	{
		if ( m_Buffer.IsReady())
		{
			var txt = m_Buffer.GetTextData();
			m_Xml = new Fast(Xml.parse( txt ));
			
			
			BuildMeshes();
			m_state = READY;
		}
	}
	
	public function BuildMeshes()
	{
		CDebug.CONSOLEMSG("dae loaded");
		var imgList =  m_Xml.node.library_images.nodes.image;
		CDebug.CONSOLEMSG("img list : " + imgList.length);
		//var matlist
	}
}