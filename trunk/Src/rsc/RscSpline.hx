package rsc;

/**
 * ...
 * @author bdubois
 */

 import flash.display.Shape;
 import flash.display.Sprite;
 import haxe.xml.Fast;
 import kernel.Glb;
 import math.Constants;
 import math.CV3D;
 import math.Utils;
 
 import kernel.CTypes;
 
 import rsc.CRsc;
 
 import tools.CXml;
 
//#define RSC_SPLINE (CResource_Spline::m_GUID)

//#define REGISTERRSC_SPLINE() {RSC_SPLINE		= g_System.GetResourcesManager().RegisterResourceType(&(CResource_Spline::NewResource));}

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
	var Ratio : 	Array<Float>;// F32 Ratio[CRscSpline.SPLINE_NB_SAMPLE];
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
class	CRscSpline extends CRsc
{
	public static var 	RSC_ID = CRscMan.RSC_COUNT++;
	
	public override function GetType() : Int
	{
		return RSC_ID;
	}
	
	public static var g_SplineDefaultResolution		: Float	= 0.05;
	public static var LIGHTWEIGHT_SPLINE_SAMPLING	: Bool	= true;
	public static var SPLINE_NB_SAMPLE				: Int	= 100;
	
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
	
	var 	m_XmlFile		: CXml;
	
	public function new() 
	{
		super();
		m_Length		= 0;
		m_Resolution	= CRscSpline.g_SplineDefaultResolution;
		m_Nodes			= null;
		m_CumulLength	= null;
		m_NbNodes		= 0;
		m_PrecalcNode	= null;
		m_Closed		= false;
		m_XmlFile		= new CXml();
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

			var l_Pt0	: CV3D	=	l_Knot0.Point;
			var l_Pt1	: CV3D	=	l_Knot0.Out;		//+l_Knot0.Point;
			var l_Pt2	: CV3D	=	l_Knot1.In;			//+l_Knot1.Point;
			var l_Pt3	: CV3D	=	l_Knot1.Point;

			var	l_3_Pt0	: CV3D	=	CV3D.NewCopy(	l_Pt0	);
			var	l_3_Pt1	: CV3D	=	CV3D.NewCopy(	l_Pt1	);
			var	l_6_Pt1	: CV3D	=	CV3D.NewCopy(	l_Pt1	);
			var	l_3_Pt2	: CV3D	=	CV3D.NewCopy(	l_Pt2	);
		
			l_3_Pt0	=	CV3D.OperatorScale( 3, l_3_Pt0 );
			l_3_Pt1	=	CV3D.OperatorScale( 3, l_3_Pt1 );
			l_6_Pt1	=	CV3D.OperatorScale( 6, l_6_Pt1 );
			l_3_Pt2	=	CV3D.OperatorScale( 3, l_3_Pt2 );

			var	l_a	: CV3D	=	l_3_Pt1;	l_a = CV3D.OperatorMinus( l_a, l_3_Pt2);	l_a	= CV3D.OperatorPlus( l_a, l_Pt3 );		l_a	= CV3D.OperatorMinus( l_a, l_Pt0 );
			var	l_b	: CV3D	=	l_3_Pt0;	l_b	= CV3D.OperatorMinus( l_b, l_6_Pt1);	l_b	= CV3D.OperatorPlus( l_b, l_3_Pt2 );
			var	l_c	: CV3D	=	l_3_Pt1;	l_c	= CV3D.OperatorMinus( l_c, l_3_Pt0);
			var	l_d	: CV3D	=	l_Pt0;
			
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

				var l_M : CV3D = CV3D.OperatorScale( _Progression, CV3D.OperatorScale( 2, l_b ) );
				var l_N : CV3D = CV3D.OperatorScale( _Progression, CV3D.OperatorScale( 3, l_a ) );
				
				l_Out	= CV3D.OperatorPlus( CV3D.OperatorPlus( l_c, l_M ), l_N );
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

	public function GetPosFromLength	( _PosPtr : CV3D, _PathLen : Float ) : Void
	{
		//ASSERT(_PosPtr);
		GetPositionFromDistance	( _PathLen, _PosPtr	);
	}

	public function GetLengthFromPos	( _LenPtr : Float, _DistPtr : Float, _Pos : CV3D	) : Void
	{
		//_Pos;
		//_DistPtr;
		//_LenPtr;
		//ASSERT(0);
	}

	//	***************************
	//	***	Bezier methods :	***
	//	***************************
	function SetNodes	( _Nodes : Array<SplineNode>, _NbNodes : Int ) : Void
	{
		m_Nodes		= _Nodes;
		m_NbNodes	= _NbNodes;
		Precalcs	(); //<
	}
	
	private function CopyNode( _SrcNode : SplineNode, _TgtNode : SplineNode )
	{
		_TgtNode.In.Copy( _SrcNode.In );
		_TgtNode.Out.Copy( _SrcNode.Out );
		_TgtNode.Point.Copy( _SrcNode.Point );
	}
	
	// 310 : !!! Not use if spline is close on export !!!
	function SetClosed	( _Closed : Bool ) : Void
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
					CopyNode( m_Nodes[i], l_Nodes[i] );
				}
				
				CopyNode( l_Nodes[0], l_Nodes[m_NbNodes] );
			}
			else
			{
				// 310 : If open spline, remove last point
				l_NbNodes--;
				l_Nodes = new Array<SplineNode>();
				for ( i in 0 ... m_NbNodes )		//memcpy(l_Nodes,m_Nodes,l_NbNodes*sizeof(SplineNode));
				{
					CopyNode( m_Nodes[i], l_Nodes[i] );
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

	/*
		U32	l_Segment	=	FindForwardSegmentFromDistance	(	_Distance	);
		if (l_Segment == Constants.INT_MAX)
		{
			ASSERT(0);
			return;
		}
		const	Segment&	l_CurSegLen	=	m_CumulLength	[	l_Segment	];

		ASSERT	(	(	_Distance	>=	l_CurSegLen.Start	)
					&&	(	_Distance	<=	m_Length			)	);

			*******************************************
			***	Distance to go in this segment :	***	
			*******************************************
		F32	l_DistanceInSegment	=	(	_Distance	-	l_CurSegLen.Start	);

			***********************
			***	Scan segment :	***
			***********************
		const	SplineNode&	l_CurSeg	=	m_Nodes	[	l_Segment	];
		V3D							l_CurrentPosition	=	l_CurSeg.m_Position;
		*_TgtPoint	=	l_CurSeg.Point;

		F32			l_SegLength			=	0.0f;
		F32			l_Ratio				=	0.0f;
		F32			l_RatioFound		=	1.0f;

		V3D			l_NextPosition;
		V3D			l_DiffPos;
		V3D			l_NextTangent;
		F32			l_NormDPosition;	// Norm(CurrentPosition - NextPosition)

		U32				l_NumPart	=	U32	(	1.f	/	m_Resolution	);

		for	(	U32	l_EachPart=0;	(	l_EachPart	<	l_NumPart	);	l_EachPart++	)
		{
				***	Getting new point :
			Interpolate	(	l_Segment,	(	l_Ratio	+	m_Resolution	),	&l_NextPosition,	_TgtTan	);

				***	Distance to next point :
			l_DiffPos	=	l_NextPosition;
			l_DiffPos	-=	(*_TgtPoint);
			l_NormDPosition	=	V3DLength(&l_DiffPos);

				***	Still not enough ? :
			if	(	l_DistanceInSegment	<	(	l_SegLength	+	l_NormDPosition	)	)
			{
					*******************************************
					***	We've reach our point so leave :	***
					*******************************************
				*_TgtPoint	=	l_NextPosition;
				l_RatioFound	=	(	l_Ratio
									+	(	(	l_DistanceInSegment	-	l_SegLength	)
										/	l_NormDPosition
										)
									*	m_Resolution
									);
				break;
			}

			l_SegLength	+=	l_NormDPosition;
			l_Ratio		+=	m_Resolution;
			*_TgtPoint	=	l_NextPosition;
		}
		Interpolate	(	l_Segment,	l_RatioFound,	_TgtPoint,	_TgtTan	);
	*/

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
		var l_BaseRatioIdxF	: Float	= ( ( ( _Distance - l_CurSegLen.Start ) / ( l_CurSegLen.End - l_CurSegLen.Start ) ) * ( CRscSpline.SPLINE_NB_SAMPLE - 1 ) );
		var l_BaseRatioIdx	: Float	= Math.floor( l_BaseRatioIdxF );
		var l_LerpFactor	: Float	= l_BaseRatioIdxF - l_BaseRatioIdx;
		if( l_BaseRatioIdx < ( CRscSpline.SPLINE_NB_SAMPLE - 1 ) )
		{
			l_RatioFound	= m_PrecalcNode[ l_Segment ].Ratio[ cast( l_BaseRatioIdx, Int )		] * ( 1 - l_LerpFactor )
							+ m_PrecalcNode[ l_Segment ].Ratio[ cast( l_BaseRatioIdx, Int ) + 1 ] * ( l_LerpFactor );
		}

		//	***	Catmul ratio
		Interpolate	( l_Segment, l_RatioFound, _TgtPoint, _TgtTan );
	}
	
	public function GetDistanceFromPosition( _Pos : CV3D ) : Float		
	{
		//F32 l_D = 0;
		var l_NbSamples		: Int	= CRscSpline.SPLINE_NB_SAMPLE;
		var l_Step			: Float	= m_Length / l_NbSamples;

		var l_P				: CV3D	= new CV3D(0, 0, 0);
		var l_Closest		: CV3D	= CV3D.NewCopy( CV3D.ZERO );
		var l_iClosest		: Int	= 0;
		var	l_Dist2Closest	: Float	= Math.POSITIVE_INFINITY;
		
		for ( i in 0 ... l_NbSamples +1 )
		{
			GetPositionFromDistance( l_Step * i, l_P );
			var l_Dist2 : Float	= CV3D.OperatorMinus( l_P, _Pos ).Norm2();
			if ( l_Dist2 < l_Dist2Closest )
			{
				l_Dist2Closest	= l_Dist2;
				l_Closest		= l_P;
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
					l_P2		= l_PPrev;
					l_iClosest2 = l_iClosest - 1;
				}
				else
				{
					l_P2		= l_PNext;
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
			var l_PrevPosition	: CV3D = m_Nodes[ 0 ].Point;
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
			m_CumulLength[ l_NPoints - 1 ]	= l_LastCumul;
			
			//	***	Compute Ratio From Distance
			m_PrecalcNode = new Array<PrecalcSplineNode>();
			
			for	( i_EachPoint in 0 ... l_NPoints - 1 )
			{
				m_PrecalcNode[ i_EachPoint ]	=	{	Ratio : new Array<Float>()	}
				
				var	l_Cumul	: Segment	= m_CumulLength[ i_EachPoint ];
							
				//for ( i_RatioIdx = 0; i_RatioIdx < CRscSpline.SPLINE_NB_SAMPLE; i_RatioIdx++)
				for ( i_RatioIdx in 0 ... CRscSpline.SPLINE_NB_SAMPLE )
				{
					var l_Distance : Float = l_Cumul.Start +
												i_RatioIdx * ( l_Cumul.End - l_Cumul.Start ) /
												( CRscSpline.SPLINE_NB_SAMPLE - 1 );
					m_PrecalcNode[ i_EachPoint ].Ratio[ i_RatioIdx ] = FindSegmentRatioFromDistance( l_Distance, i_EachPoint );
				}
			}
		}
	}

	public function Load( _Path : String ) : Result
	{
		m_State = E_STATE.STREAMING;
		return m_XmlFile.Load( _Path );
		
			//***	Lock Whole File
		//void * l_VFileData;
		//l_VFileData = (void * )_File-> Lock(0, 0);
		//S32	l_FileSize = _File-> GetLockedSize();
		//
		//Result l_Result = ReadBuffer((Char * ) l_VFileData, l_FileSize);
		//
		//_File-> UnLock();
		//return l_Result;
	}
	
	public function Update() : Void
	{
		m_XmlFile.Update();
		if ( m_XmlFile.IsLoaded() && m_Nodes == null )
		{
			ReadFile();
			m_State = E_STATE.STREAMED;
		}
	}

	public function	ReadFile() : Result
	{
		var l_Xml		: Xml	= Xml.parse( m_XmlFile.m_Text );
		var l_FSpline	: Fast	= new Fast( l_Xml.firstElement().firstElement() );
		
		//	***	Get Number of nodes
		var l_NbNodes : Int = Std.parseInt( l_FSpline.att.nb_nodes );
		
		//	***	Parse nodes
		var l_Nodes : Array<SplineNode> = new Array<SplineNode>();
		
		var i : Int = 0;
		for (i_Node in l_FSpline.nodes.node )
		{
			var l_Point : CV3D = new CV3D ( Std.parseFloat( i_Node.node.point.att.x ),
			                                Std.parseFloat( i_Node.node.point.att.y ),
			                                Std.parseFloat( i_Node.node.point.att.z ) );
			var l_In : CV3D = new CV3D ( 	Std.parseFloat( i_Node.node.In.att.x ),
			                                Std.parseFloat( i_Node.node.In.att.y ),
			                                Std.parseFloat( i_Node.node.In.att.z ) );
			var l_Out : CV3D = new CV3D ( 	Std.parseFloat( i_Node.node.out.att.x ),
			                                Std.parseFloat( i_Node.node.out.att.y ),
			                                Std.parseFloat( i_Node.node.out.att.z ) );
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
		SetNodes( l_Nodes, l_NbNodes );

		return SUCCESS;
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
	
	public function Debug( ?_Resolution : Int = 20, ?_Scale : Float = 20 ) : Void
	{
		#if flash
			if ( m_DebugSprite	== null )
			{
				m_DebugSprite	= new Sprite();
				Glb.GetRendererAS().AddToSceneAS( m_DebugSprite );
				
				if ( m_DebugSpline == null )
				{
					m_DebugSpline	= new Shape();
					m_DebugSprite.addChild( m_DebugSpline );
					
					m_DebugSpline.graphics.lineStyle( 1, 0xFF0000 );
					
					var l_Pos		: CV3D		 = new CV3D( 0, 0, 0 ); 
					var l_Tan		: CV3D		 = new CV3D( 0, 0, 0 ); 
					GetPositionFromDistance( 0, l_Pos, l_Tan );
					m_DebugSpline.graphics.moveTo( l_Pos.x * _Scale, l_Pos.z * _Scale );
					
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
}