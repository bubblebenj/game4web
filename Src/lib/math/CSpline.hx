package math;

/**
 * ...
 * @author bdubois
 */

 import driver.as.renderer.C2DQuadAS;
 import flash.display.Shape;
 import flash.display.Sprite;
 import math.Constants;
 import math.CV3D;
 import math.Utils;
 
 import CTypes;

//	***************************************
//	***	Bezier SplineNode declaration :	***
//	***************************************
typedef	SplineNode	=
{
	var Point	: CV3D;
	var In		: CV3D;
	var Out		: CV3D;
}

typedef	PrecalcSplineNode	=
{
	var Ratio : 	Array<Float>;// F32 Ratio[CSpline.SPLINE_NB_SAMPLE];
}

//	*******************************
//	***	Segment length tags :	***
//	*******************************
typedef	Segment =
{
	var Start	: Float;
	var	End		: Float;
}

//	***************************************
//	***	Game System base bezier path :	***
//	***************************************
class CSpline
{
	public static var g_SplineDefaultResolution		: Float	= 0.05;
	public static var LIGHTWEIGHT_SPLINE_SAMPLING	: Bool	= true;
	public static var SPLINE_NB_SAMPLE				: Int	= 256;
	
	//	*******************************
	//	***	Internal attributes :	***
	//	*******************************
	var		m_Nodes			: Array<SplineNode>;
	var		m_PrecalcNode	: Array<PrecalcSplineNode>;
	var		m_NbNodes		: Int;
	var		m_Length		: Float;
	var		m_Resolution	: Float;
	var		m_Closed		: Bool;
	var 	m_CumulLength	: Array<Segment>;
		
	public function new() 
	{
		m_Length		= 0;
		m_Resolution	= CSpline.g_SplineDefaultResolution;
		m_Nodes			= null;
		m_CumulLength	= null;
		m_NbNodes		= 0;
		m_PrecalcNode	= null;
		m_Closed		= false;
	}

	/*inline */public function Interpolate	( _SegmentIndex : Int, _Progression : Float, _TgtPoint : CV3D, ?_TgtTan : CV3D = null	) : Void
	{
		//ASSERTC	(	m_Nodes,	"[CResource_Spline::Interpolate] Empty spline !"	);
		//ASSERTC	(	(	_SegmentIndex	<	(	m_NbNodes	-	1	)	),
						//"[CResource_Spline::Interpolate] _SegmentIndex out of range !"
						//);
		//ASSERTC	(	(	(	_Progression	>=	-Constants.EPSILON	)
						//&&	(	_Progression	<=	(	1	+	Constants.EPSILON	)	)	),
						//"[CResource_Spline::Interpolate] _Progression	out of range"
						//);
		//ASSERTC	(	_TgtPoint,	"[CResource_Spline::Interpolate] _TgtPoint must point to an instanciated V3D !"	);
		
		if	( _TgtPoint != null )
		{
			var l_Knot0 : SplineNode	=	m_Nodes	[ _SegmentIndex	+ 0 ];  //<
			var	l_Knot1 : SplineNode	=	m_Nodes	[ _SegmentIndex	+ 1 ];	//<
			
			var l_Pt0	: CV3D	=	CV3D.NewCopy( l_Knot0.Point	);
			var l_Pt1	: CV3D	=	CV3D.NewCopy( l_Knot0.Out	);		//+l_Knot0.Point;
			var l_Pt2	: CV3D	=	CV3D.NewCopy( l_Knot1.In	);		//+l_Knot1.Point;
			var l_Pt3	: CV3D	=	CV3D.NewCopy( l_Knot1.Point	);
			
			var	l_3_Pt0	: CV3D	=	CV3D.NewCopy(	l_Pt0	);
			var	l_3_Pt1	: CV3D	=	CV3D.NewCopy(	l_Pt1	);
			var	l_6_Pt1	: CV3D	=	CV3D.NewCopy(	l_Pt1	);
			var	l_3_Pt2	: CV3D	=	CV3D.NewCopy(	l_Pt2	);
			
			l_3_Pt0	=	CV3D.OperatorScale( 3, l_3_Pt0 );
			l_3_Pt1	=	CV3D.OperatorScale( 3, l_3_Pt1 );
			l_6_Pt1	=	CV3D.OperatorScale( 6, l_6_Pt1 );
			l_3_Pt2	=	CV3D.OperatorScale( 3, l_3_Pt2 );
			
			var	l_a	: CV3D	= CV3D.NewCopy(	l_3_Pt1 );	l_a = CV3D.OperatorMinus( l_a, l_3_Pt2 );	l_a	= CV3D.OperatorPlus( l_a, l_Pt3 );		l_a	= CV3D.OperatorMinus( l_a, l_Pt0 );
			var	l_b	: CV3D	= CV3D.NewCopy(	l_3_Pt0 );	l_b	= CV3D.OperatorMinus( l_b, l_6_Pt1 );	l_b	= CV3D.OperatorPlus( l_b, l_3_Pt2 );
			var	l_c	: CV3D	= CV3D.NewCopy(	l_3_Pt1 );	l_c	= CV3D.OperatorMinus( l_c, l_3_Pt0 );
			var	l_d	: CV3D	= CV3D.NewCopy(	l_Pt0	);
			
			var l_Out : CV3D;
			l_Out	=	CV3D.OperatorPlus( CV3D.OperatorScale( _Progression, l_a ),		l_b	);
			l_Out	=	CV3D.OperatorPlus( CV3D.OperatorScale( _Progression, l_Out ),	l_c	);
			l_Out	=	CV3D.OperatorPlus( CV3D.OperatorScale( _Progression, l_Out ),	l_d	);
			
			_TgtPoint.Copy( l_Out );
			
			if	( _TgtTan != null )
			{
				//l_a	*=	(3.f*_Progression);
				//l_b	*=	(2.f*_Progression);
				//l_a	+=	l_b;
				//l_a	+=	l_c;
				
				/*
				 * l_Out = l_c + _Progression * ( ( 2.f * l_b ) + _Progression * ( 3.f * l_a ) );
				 */
				l_Out	= 	CV3D.OperatorPlus(
								l_c,
								CV3D.OperatorScale(
									_Progression,
									CV3D.OperatorPlus(
										CV3D.OperatorScale( 2, l_b ),
										CV3D.OperatorScale(
											_Progression,
											CV3D.OperatorScale( 3, l_a )
										)
									)
								)
							);
												
				CV3D.Normalize( l_Out );
				_TgtTan.Copy( l_Out );	// Dérivée
			}
		}
	}

	//	***********************
	//	***	Path Methods :	***
	//	***********************
	public function GetLength	()	: Float
	{
		return	m_Length;
	}

	//	***************************
	//	***	Bezier methods :	***
	//	***************************
	public function SetNodes	( _Nodes : Array<SplineNode>, _NbNodes : Int ) : Void
	{
		m_Nodes		= _Nodes;
		m_NbNodes	= _NbNodes;
		Precalcs	(); //<
	}
	
	private function NodeCopy( _SrcNode : SplineNode ) : SplineNode
	{
		var l_TgtNode : SplineNode	=
		{
				Point	: CV3D.NewCopy( _SrcNode.Point ),
				In		: CV3D.NewCopy( _SrcNode.In ),
				Out		: CV3D.NewCopy( _SrcNode.Out )
		}
		return l_TgtNode;
	}
	
	// 310 : !!! Not use if spline is close on export !!!
	public function SetClosed	( _Closed : Bool ) : Void
	{
		if( m_Closed != _Closed )
		{
			m_Closed	=	_Closed;

			var l_NbNodes	: Int = m_NbNodes;
			var l_Nodes		: Array<SplineNode> = null;
			if( m_Closed )
			{
				// 310 : If close spline, add last point
				l_NbNodes++;
				l_Nodes = new Array<SplineNode>();
				for ( i in 0 ... m_NbNodes )		//memcpy(l_Nodes,m_Nodes,m_NbNodes*sizeof(SplineNode));
				{
					l_Nodes[i] = NodeCopy( m_Nodes[i] );
				}
				
				l_Nodes[m_NbNodes] = NodeCopy( l_Nodes[0] );
			}
			else
			{
				// 310 : If open spline, remove last point
				l_NbNodes--;
				l_Nodes = new Array<SplineNode>();
				for ( i in 0 ... m_NbNodes )		//memcpy(l_Nodes,m_Nodes,l_NbNodes*sizeof(SplineNode));
				{
					l_Nodes[i]	= NodeCopy( m_Nodes[i] );
				}
			}
			SetNodes(l_Nodes, l_NbNodes);
			// 310 : In "setNode"
			Precalcs	();
		}
	}
	
	inline public function GetResolution	() : Float
	{
		return	m_Resolution;
	}
	
	function SetResolution	( _Resolution : Float ) : Void
	{
		m_Resolution = _Resolution;
		Precalcs	();
	}
	
	inline	function GetNodes()		: Array<SplineNode>
	{
		return	m_Nodes;
	}
	
	inline	function GetNbNodes()	: Int
	{
		return	m_NbNodes;
	}
	
	inline	function IsClosed()		: Bool
	{
		return	m_Closed;
	}
	
	//	***********************
	//	***	Interpolate :	***
	//	***********************
	function FindForwardSegmentFromDistance	( _Distance : Float , ?_StartSegment : Int = 0	) : Int
	{
		var l_Ret		: Int	=	Constants.INT_MAX;
		var l_NSegment	: Int	=	m_NbNodes;

		if	( l_NSegment != 0 )
		{
			--l_NSegment;

			//ASSERT	( _StartSegment	< l_NSegment );
			
			for ( i_EachSegment in _StartSegment ... l_NSegment )
			{
				var l_CurSeg : Segment =	m_CumulLength [ i_EachSegment ];

				//	***	In this segment ?
				if	( ( _Distance >= l_CurSeg.Start ) && ( _Distance <= l_CurSeg.End ) )
				{
					l_Ret	=	i_EachSegment;
					break;
				}	
			}
			/*
			for	( var l_EachSegment : Int = _StartSegment; (	l_EachSegment < l_NSegment ); l_EachSegment++ )
			{
				const Segment& l_CurSeg =	m_CumulLength [ l_EachSegment ];

				//	***	In this segment ?
				if	( ( _Distance >= l_CurSeg.Start ) && ( _Distance <= l_CurSeg.End ) )
				{
					l_Ret	=	l_EachSegment;
					break;
				}
			}
			*/
		}
		return	l_Ret;
	}
	
	function FindSegmentRatioFromDistance	( _Distance : Float, _Segment : Int ) : Float
	{
		var l_CurSegLen : Segment	= m_CumulLength[ _Segment ];

		//ASSERT	(  ( _Distance >= l_CurSegLen.Start )
		//		&& ( _Distance <= m_Length ) ); 
		
		//	*******************************************
		//	***	Distance to go in this segment :	***	
		//	*******************************************
		var l_DistanceInSegment : Float	= ( _Distance - l_CurSegLen.Start );

		//	***********************
		//	***	Scan segment :	***
		//	***********************
		var l_CurSeg		: SplineNode	=	m_Nodes	[	_Segment	];
		var l_CurrentPosition	: CV3D		= CV3D.NewCopy( l_CurSeg.Point );
		var	l_DiffPos			: CV3D;

		var l_SegLength			: Float		=	0;
		var	l_Ratio				: Float		=	0;
		var l_RatioFound		: Float		=	1;

		var	l_NextPosition		: CV3D		= new CV3D( 0, 0, 0 );
		//var l_NextTangent		: CV3D;
		var	l_NormDPosition		: Float;	// Norm(CurrentPosition - NextPosition)

		var l_NumPart			: Int		=	Utils.RoundNearest(	1 / m_Resolution );

		for	( i_EachPart in 0 ... l_NumPart )
		{
			//	***	Getting new point :
			Interpolate ( _Segment, ( l_Ratio + m_Resolution ), l_NextPosition );

			//	***	Distance to next point :
			l_DiffPos		=	CV3D.OperatorMinus( l_CurrentPosition, l_NextPosition );
			l_NormDPosition	=	l_DiffPos.Norm();

			//	***	Still not enough ? :
			if	( l_DistanceInSegment < ( l_SegLength + l_NormDPosition ) )
			{
				//	*******************************************
				//	***	We've reach our point so leave :	***
				//	*******************************************
				l_RatioFound = ( l_Ratio + ( ( l_DistanceInSegment - l_SegLength ) / l_NormDPosition ) * m_Resolution );
				break;
			}

			l_SegLength			+=	l_NormDPosition;
			l_Ratio				+=	m_Resolution;
			l_CurrentPosition.Copy( l_NextPosition );
		}

		//ASSERT	( ( ( l_RatioFound >= -Constants.EPSILON )	&&	( l_RatioFound <= ( 1 + Constants.EPSILON ) ) ) );

		return	l_RatioFound;
	}
	
	public function GetPositionFromDistance( _Distance : Float, _TgtPoint : CV3D, ?_TgtTan : CV3D = null ) : Void
	{
		FastGetPositionFromDistance( _Distance, _TgtPoint, _TgtTan );
		return;
	}

	public function FastGetPositionFromDistance( _Distance : Float, _TgtPoint : CV3D, ?_TgtTan : CV3D = null ) : Void
	{
		_Distance = Utils.Clamp( _Distance, 0, m_Length );
		//	*** Get the segment
		var	l_Segment	: Int		=	FindForwardSegmentFromDistance( _Distance );
		if ( l_Segment == Constants.INT_MAX )
		{
			//ASSERT(0);
			return;
		}
		var l_CurSegLen : Segment	= m_CumulLength [ l_Segment ];
		
		//	***	Find ratio
		var l_RatioFound	: Float	= 1;
		var l_BaseRatioIdxF	: Float	= ( ( ( _Distance - l_CurSegLen.Start ) / ( l_CurSegLen.End - l_CurSegLen.Start ) ) * ( CSpline.SPLINE_NB_SAMPLE - 1 ) );
		var l_BaseRatioIdx	: Float	= Math.floor( l_BaseRatioIdxF );
		var l_LerpFactor	: Float	= l_BaseRatioIdxF - l_BaseRatioIdx;
		if( l_BaseRatioIdx < ( CSpline.SPLINE_NB_SAMPLE - 1 ) )
		{
			l_RatioFound	= m_PrecalcNode[ l_Segment ].Ratio[ cast( l_BaseRatioIdx, Int )		] * ( 1 - l_LerpFactor )
							+ m_PrecalcNode[ l_Segment ].Ratio[ cast( l_BaseRatioIdx, Int ) + 1 ] * ( l_LerpFactor );
		}

		//	***	Catmul ratio
		Interpolate	( l_Segment, l_RatioFound, _TgtPoint, _TgtTan );
	}
	
	public function GetDistanceFromPosition( _Pos : CV3D ) : Float		
	{
		var l_NbSamples		: Int	= CSpline.SPLINE_NB_SAMPLE;
		var l_Step			: Float	= m_Length / l_NbSamples;

		var l_P				: CV3D	= new CV3D(0, 0, 0);
		var l_Closest		: CV3D	= CV3D.NewCopy( CV3D.ZERO );
		var l_iClosest		: Int	= 0;
		var	l_Dist2Closest	: Float	= Math.POSITIVE_INFINITY;
		
		for ( i in 0 ... l_NbSamples )
		{
			GetPositionFromDistance( l_Step * i, l_P );
			var l_Dist2 : Float	= CV3D.OperatorMinus( l_P, _Pos ).Norm2();
			if ( l_Dist2 < l_Dist2Closest )
			{
				l_Dist2Closest	= l_Dist2;
				l_Closest.Copy( l_P );
				l_iClosest		= i;
			}
		}
		
		var l_P2			: CV3D	= new CV3D(0, 0, 0);
		var l_iClosest2		: Int	= 0;
		//	***	Get second best
		if( l_iClosest == 0 ) 
		{
			l_iClosest2 = l_iClosest + 1;
			GetPositionFromDistance( l_iClosest2 * l_Step, l_P2 );
		}
		else
		{
			if( l_iClosest == l_NbSamples ) 
			{
				l_iClosest2 = l_iClosest - 1;
				GetPositionFromDistance( l_iClosest2 * l_Step, l_P2 );
			}
			else
			{
				var l_PPrev	: CV3D	= new CV3D(0, 0, 0);
				var l_PNext	: CV3D	= new CV3D(0, 0, 0);
				GetPositionFromDistance( ( l_iClosest - 1 ) * l_Step, l_PPrev );
				GetPositionFromDistance( ( l_iClosest + 1 ) * l_Step, l_PNext );
				if ( CV3D.OperatorMinus( l_PPrev, _Pos ).Norm2() < CV3D.OperatorMinus( l_PNext, _Pos ).Norm2() )
				{
					l_P2.Copy( l_PPrev );
					l_iClosest2 = l_iClosest - 1;
				}
				else
				{
					l_P2.Copy( l_PNext );
					l_iClosest2 = l_iClosest + 1;
				}
			}
		}
		//	***	Project _Pos on P-P2
		var l_VProj		: CV3D	= CV3D.OperatorMinus( l_P2, l_Closest );
		var l_Dist		: Float	= l_VProj.Norm();
		l_VProj					= CV3D.OperatorScale( 1 / l_Dist, l_VProj );
		var l_V			: CV3D	= CV3D.OperatorMinus( _Pos, l_Closest );
		var l_Dot		: Float	= CV3D.DotProduct( l_V, l_VProj );
		var l_Ratio		: Float	= l_Dot / l_Dist;
		
		var l_iFloat	: Float = l_iClosest * ( 1 - l_Ratio ) + l_iClosest2 * l_Ratio;
		
		return l_iFloat * l_Step;
	}

	public function Precalcs	() : Void
	{
		//	***********************
		//	***	Update infos :	***
		//	***********************
		var	l_NPoints	: Int	=	m_NbNodes;

		//SAFEFREE(m_CumulLength);
		//SAFEFREE(m_PrecalcNode);
		
		/* m_CumulLength = (Segment*)MALLOC(l_NPoints*sizeof(Segment)); */
		m_CumulLength = new Array<Segment>();
		
		m_Length	= 0;

		if ( l_NPoints != 0 )
		{
			//	***************************
			//	***	Computing length :	***
			//	***************************
			var l_PrevPosition	: CV3D = CV3D.NewCopy( m_Nodes[ 0 ].Point );
			var	l_Position		: CV3D	= new CV3D(0, 0, 0);

			var	l_DPosition		: CV3D	= new CV3D(0, 0, 0);
			var l_Progression	: Float;
			var l_NumPart		: Int  	= Utils.RoundNearest( 1 / m_Resolution );
			
			//for ( i_EachPoint = 0; ( i_EachPoint < ( l_NPoints - 1 ) ); i_EachPoint++ )
			for	( i_EachPoint in 0 ... l_NPoints - 1 )
			{
				var l_CurCumul : Segment= 
				{
					Start	:	m_Length,
					End		:	0.0
				} 

				l_Progression		= m_Resolution;

				//for	( i_EachPart=0; ( i_EachPart < l_NumPart ); i_EachPart++ )
				for	( i_EachPart in 0 ... l_NumPart )
				{
					Interpolate	( i_EachPoint, l_Progression, l_Position );

					l_DPosition.Copy ( l_PrevPosition );			//	***	Delta pos (derivate).
					l_DPosition		= CV3D.OperatorMinus( l_DPosition, l_Position );
					
					m_Length		+=	l_DPosition.Norm();			//	***	Update length.
					
					l_Progression	+=	m_Resolution;				//	***	Update progression.
					l_PrevPosition.Copy( l_Position );				//	***	Backup position to calc delta.
				}
				
				l_CurCumul.End	=	m_Length;
				m_CumulLength[ i_EachPoint ]	= l_CurCumul;
			}
			
			var l_LastCumul	: Segment	= 
			{
				Start	:	m_Length,
				End		:	m_Length
			}
			m_CumulLength[ l_NPoints ]	= l_LastCumul;
			
			//	***	Compute Ratio From Distance
			m_PrecalcNode = new Array<PrecalcSplineNode>();
			
			for	( i_EachPoint in 0 ... l_NPoints - 1 )
			{
				m_PrecalcNode[ i_EachPoint ]	=	{	Ratio : new Array<Float>()	}
				
				var	l_Cumul	: Segment	= m_CumulLength[ i_EachPoint ];
							
				//for ( i_RatioIdx = 0; i_RatioIdx < CSpline.SPLINE_NB_SAMPLE; i_RatioIdx++)
				for ( i_RatioIdx in 0 ... CSpline.SPLINE_NB_SAMPLE )
				{
					var l_Distance : Float = l_Cumul.Start +
												i_RatioIdx * ( l_Cumul.End - l_Cumul.Start ) /
												( CSpline.SPLINE_NB_SAMPLE - 1 );
					m_PrecalcNode[ i_EachPoint ].Ratio[ i_RatioIdx ] = FindSegmentRatioFromDistance( l_Distance, i_EachPoint );
				}
			}
		}
	}

	public function ReverseNodes() : Void
	{
		//	***	Reverse the spline
		var l_NewNodes : Array<SplineNode> = new Array<SplineNode>();
		
		//	***	Build new node array
		for ( i in 0 ... m_NbNodes )
		{
			l_NewNodes[m_NbNodes - i - 1].Point = m_Nodes[i].Point;
			l_NewNodes[m_NbNodes - i - 1].In	= m_Nodes[i].Out;
			l_NewNodes[m_NbNodes - i - 1].Out	= m_Nodes[i].In;
		}
		SetNodes( l_NewNodes, m_NbNodes );
	}

	public function Translate( _Vec : CV3D ) : Void
	{
		for ( i in 0 ... m_NbNodes )
		{
			m_Nodes[i].Point	= CV3D.OperatorPlus( m_Nodes[i].Point,	_Vec );
			m_Nodes[i].In		= CV3D.OperatorPlus( m_Nodes[i].In,		_Vec );
			m_Nodes[i].Out		= CV3D.OperatorPlus( m_Nodes[i].Out,	_Vec );
		}
		Precalcs	();
	}
/*	
	public function Debug( ?_Resolution : Int = 20, ?_Scale : Float = 20, ?_Distance : Float ) : Void
	{
		#if flash
			if ( m_DebugSprite	== null )
			{
				m_DebugSprite	= new Sprite();
				Glb.GetRendererAS().AddToSceneAS( m_DebugSprite );
				
				var l_Pos		: CV3D		 = new CV3D( 0, 0, 0 ); 
				var l_Tan		: CV3D		 = new CV3D( 0, 0, 0 );
				
				if ( m_DebugSpline == null )
				{
					m_DebugSpline	= new Shape();
					m_DebugSprite.addChild( m_DebugSpline );
					
					m_DebugSpline.graphics.lineStyle( 1, 0xFF0000 );
					
					// First point
					GetPositionFromDistance( 0, l_Pos, l_Tan );
					m_DebugSpline.graphics.moveTo( l_Pos.x * _Scale, l_Pos.z * _Scale );
					
					var l_FirstTanHandle	= new Shape();
					m_DebugSprite.addChild( l_FirstTanHandle );
					l_FirstTanHandle.graphics.lineStyle( 1, 0x0000FF );
					l_FirstTanHandle.graphics.moveTo( l_Pos.x * _Scale, l_Pos.z * _Scale );
					l_FirstTanHandle.graphics.lineTo( ( l_Tan.x * _Scale + l_Pos.x ) * _Scale, ( l_Tan.z * _Scale + l_Pos.z ) * _Scale );
					// Next ones	
					for ( i in 1 ... _Resolution +1)
					{
						// trace point
						GetPositionFromDistance( m_Length * i / _Resolution, l_Pos, l_Tan );
						m_DebugSpline.graphics.lineTo( l_Pos.x * _Scale, l_Pos.z * _Scale );
						
						// trace tangente
						var l_TanHandle	= new Shape();
						m_DebugSprite.addChild( l_TanHandle );
						l_TanHandle.graphics.lineStyle( 1, 0x0000FF );
						l_TanHandle.graphics.moveTo( l_Pos.x * _Scale, l_Pos.z * _Scale );
						l_TanHandle.graphics.lineTo( ( l_Tan.x * _Scale + l_Pos.x ) * _Scale, ( l_Tan.z * _Scale + l_Pos.z ) * _Scale );
					}
					
					var l_FileSpline	= new Shape();
					m_DebugSprite.addChild( l_FileSpline );
					l_FileSpline.graphics.lineStyle( 1, 0xFF8844 );
					
					// First point
					l_Pos.Copy( m_Nodes[0].Point );
					l_FileSpline.graphics.moveTo( l_Pos.x * _Scale, l_Pos.z * _Scale );
					var l_FirstPoint = new Shape();
					l_FirstPoint.graphics.lineStyle( 1, 0xFAFAD2 );
					m_DebugSprite.addChild( l_FirstPoint );
					l_FirstPoint.graphics.drawCircle( l_Pos.x * _Scale, l_Pos.z * _Scale, _Scale );
					// First tangente
					l_Tan	= CV3D.OperatorMinus( m_Nodes[0].Out, m_Nodes[0].In );
					CV3D.Normalize( l_Tan );
					var l_FirstDbgTanHandle	= new Shape();
					m_DebugSprite.addChild( l_FirstDbgTanHandle );
					l_FirstDbgTanHandle.graphics.lineStyle( 1, 0x00FF00 );
					l_FirstDbgTanHandle.graphics.moveTo( l_Pos.x * _Scale, l_Pos.z * _Scale );
					l_FirstDbgTanHandle.graphics.lineTo( ( l_Tan.x * _Scale + l_Pos.x ) * _Scale, ( l_Tan.z * _Scale + l_Pos.z ) * _Scale );
					
					
					// Next ones
					for ( i in 1 ... m_NbNodes )
					{
						// trace point
						l_Pos.Copy( m_Nodes[i].Point );
						l_FileSpline.graphics.lineTo( l_Pos.x * _Scale, l_Pos.z * _Scale );
						var l_Point = new Shape();
						l_Point.graphics.lineStyle( 1, 0xFAFAD2 );
						m_DebugSprite.addChild( l_Point );
						l_Point.graphics.drawCircle( l_Pos.x * _Scale, l_Pos.z * _Scale, _Scale );
						
						// trace tangente
						l_Tan	= CV3D.OperatorMinus( m_Nodes[i].Out, m_Nodes[i].In );
						CV3D.Normalize( l_Tan );
						var l_TanHandle	= new Shape();
						m_DebugSprite.addChild( l_TanHandle );
						l_TanHandle.graphics.lineStyle( 1, 0x00FF00 );
						l_TanHandle.graphics.moveTo( l_Pos.x * _Scale, l_Pos.z * _Scale );
						l_TanHandle.graphics.lineTo( ( l_Tan.x * _Scale + l_Pos.x ) * _Scale, ( l_Tan.z * _Scale + l_Pos.z ) * _Scale );
					}
					
					if ( _Distance != null )
					{
						GetPositionFromDistance( _Distance, l_Pos, l_Tan );
						var l_Point = new Shape();
						l_Point.graphics.lineStyle( 1, 0x000000 );
						l_Point.graphics.beginFill( 0xFF0000 );
						m_DebugSprite.addChild( l_Point );
						l_Point.graphics.drawCircle( l_Pos.x * _Scale, l_Pos.z * _Scale, _Scale * 0.2 );
					}
					
					m_DebugSprite.x	= 300;
					m_DebugSprite.y = 300;
				}
			}	
		#end	
	}
	
	public function ClearDebug() : Void
	{
		#if flash
			if ( m_DebugSprite != null )
			{
				Glb.GetRendererAS().RemoveFromSceneAS( m_DebugSprite );
				m_DebugSprite = null;
			}
			if ( m_DebugSpline != null )
			{
				//Glb.GetRendererAS().RemoveFromSceneAS( m_DebugSpline );
				m_DebugSpline = null;
			}
		#end
	}
	
	#if flash
		var m_DebugSprite	: Sprite;
		var m_DebugSpline	: Shape;
	#end
*/
}
