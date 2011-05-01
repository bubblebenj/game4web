/**
 * ...
 * @author bdubois
 */
package rsc;

import CTypes;

import haxe.xml.Fast;
import tools.CXml;

import math.CSpline;
import math.CV3D;

import remoteData.IRemoteData;
import rsc.CRsc;

 
 

class	CRscSpline extends CRsc
{
	public static var 	RSC_ID = CRscMan.RSC_COUNT++;
	
	public override function GetType() : Int
	{
		return RSC_ID;
	}
	
	private	var 	m_xmlFile		: CXml;
	public	var		m_spline		: math.CSpline;
	
	public function new() 
	{
		super();
		m_xmlFile		= new CXml();
	}
	
	public function Load( _Path : String ) : Result
	{
		m_state = SYNCING;
		return m_xmlFile.Load( _Path );
	}
	
	public function Update() : Result
	{
		m_xmlFile.Update();
		if ( m_xmlFile.IsLoaded() && m_spline == null )
		{
			ReadFile();
			m_state = READY;
		}
		return SUCCESS;
	}
	
	public function	ReadFile() : Result
	{
		m_spline				= new CSpline();
		var l_Xml		: Xml	= Xml.parse( m_xmlFile.m_Text );
		var l_FSpline	: Fast	= new Fast( l_Xml.firstElement().firstElement() );
		
		var l_NbNodes : Int		= Std.parseInt(		l_FSpline.att.nb_nodes );
		
		//	***	Parse nodes
		var l_Nodes : Array<SplineNode> = new Array<SplineNode>();
		
		var i : Int = 0;
		for (i_Node in l_FSpline.nodes.node )
		{
			var l_Point : CV3D = new CV3D ( Std.parseFloat( i_Node.node.Point.att.x ),
			                                Std.parseFloat( i_Node.node.Point.att.y ),
			                                Std.parseFloat( i_Node.node.Point.att.z ) );
			var l_In	: CV3D = new CV3D ( Std.parseFloat( i_Node.node.In.att.x ),
			                                Std.parseFloat( i_Node.node.In.att.y ),
			                                Std.parseFloat( i_Node.node.In.att.z ) );
			var l_Out	: CV3D = new CV3D ( Std.parseFloat( i_Node.node.Out.att.x ),
			                                Std.parseFloat( i_Node.node.Out.att.y ),
			                                Std.parseFloat( i_Node.node.Out.att.z ) );
			
			l_Nodes[i]	= 
			{
				Point	: l_Point,
				In		: l_In,
				Out		: l_Out
			}
			
			//	310	Change from max
			var l_PointYTmp		: Float	= 0;
			l_PointYTmp			= l_Nodes[i].Point.y;
			l_Nodes[i].Point.y	= l_Nodes[i].Point.z;
			l_Nodes[i].Point.z	= -l_PointYTmp;
			l_PointYTmp			= l_Nodes[i].In.y;
			l_Nodes[i].In.y		= l_Nodes[i].In.z;
			l_Nodes[i].In.z		= -l_PointYTmp;
			l_PointYTmp			= l_Nodes[i].Out.y;
			l_Nodes[i].Out.y	= l_Nodes[i].Out.z;
			l_Nodes[i].Out.z	= -l_PointYTmp;
			i++;
		}
		
		//	***	Set the nodes
		m_spline.SetNodes( l_Nodes, l_NbNodes );
		return SUCCESS;
	}
}