/**
 * ...
 * @author de
 */

package math;

class CMatrix44 
{	
	public var m_Buffer : Array<Float>;
	
	/*
	 * 00 01 02 03 
	 * 10
	 * 20
	 * 30		33
	 * */
	
	public function new() 
	{
		m_Buffer = new Array<Float>();
		
		Identity();
	}

	public inline function Identity() : Void
	{
		Zero();
		M(0,0,1); 
		M(1,1,1);
		M(2,2,1);
		M(3,3,1); 
	}
	
	public inline function Zero() : Void
	{
		for( i in 0...16 )
		{
			m_Buffer[i] = 0;
		}
	}
	
	
	public inline function M( _i : Int,_j :Int , _f : Float) : Void
	{
		m_Buffer[ _i * 4 + _j ] = _f;
	}
	
	public inline function Get( _i : Int,_j :Int ) : Float
	{
		return m_Buffer[ _i * 4 + _j];
	}
	
	public inline function Set( 	_00, _01, _02, _03,
									_10, _11, _12, _13,
									_20, _21, _22, _23,
									_30, _31, _32, _33
							)
	{
		M(0,0,	_00);
		M(0,1,	_01);
		M(0,2,	_02);
		M(0,3,	_03);
		
		M(1,0,	_10);
		M(1,1,	_11);
		M(1,2,	_12);
		M(1,3,	_13);
		
		M(2,0,	_20);
		M(2,1,	_21);
		M(2,2,	_22);
		M(2,3,	_23);

		M(3,0,	_30);
		M(3,1,	_31);
		M(3,2,	_32);
		M(3,3,	_33);
	}
	
	public inline function Copy( _Mat : CMatrix44 )
	{
		for( i in 0...16 )
		{
			m_Buffer[i] = _Mat.m_Buffer[i];
		}
	}
	
	public function Perspective( _fovy : Float, _aspect : Float, _znear : Float, _zfar: Float) : Void
	{
		var l_ymax = _znear * Math.tan(_fovy * Math.PI / 360.0);
		var l_ymin = - l_ymax;
		var l_xmin = l_ymin * _aspect;
		var l_xmax = l_ymax * _aspect;

		return Frustum( l_xmin, l_xmax, l_ymin, l_ymax, _znear, _zfar);
	}

	public function Frustum(_left: Float, _right: Float,
							_bottom: Float, _top: Float,
							_znear: Float, _zfar : Float)  : Void
	{
		var l_X = 2*_znear/(_right-_left);
		var l_Y = 2*_znear/(_top-_bottom);
		var l_A = (_right+_left)/(_right-_left);
		var l_B = (_top+_bottom)/(_top-_bottom);
		var l_C = -(_zfar+_znear)/(_zfar-_znear);
		var l_D = -2*_zfar*_znear/(_zfar-_znear);

		Set(l_X, 	0, 		0, 	0,
			0, 		l_Y, 	0, 	0,
			l_A, 	l_B, 	l_C, -1,
			0,		 0, 	l_D, 0	);
	}

	public function LookAt(	eyex: Float, eyey: Float, eyez: Float,
							centerx: Float, centery: Float, centerz: Float,
							upx: Float, upy: Float, upz : Float) : Void
	{
		var l_Matrix = new CMatrix44();
		
		// Z vector
		var zx = eyex - centerx;
		var zy = eyey - centery;
		var zz = eyez - centerz;
		
		var mag : Float = Math.sqrt(zx * zx + zy * zy + zz * zz);
		if( mag > Constants.EPSILON) 
		{
			var l_InvMag = 1.0 / mag;
			zx *= l_InvMag;
			zy *= l_InvMag;
			zz *= l_InvMag;
		}

		// Y vector
		var yx : Float = upx;
		var yy : Float = upy;
		var yz : Float = upz;

		// X vector = Y cross Z
		var xx =  yy * zz - yz * zy;
		var xy = -yx * zz + yz * zx;
		var xz =  yx * zy - yy * zx;

		// Recompute Y = Z cross X
		yx = zy * xz - zz * xy;
		yy = -zx * xz + zz * xx;
		yx = zx * xy - zy * xx;

		// cross product gives area of parallelogram, which is < 1.0 for
		// non-perpendicular unit-length vectors; so normalize x, y here

		var mag = Math.sqrt(xx * xx + xy * xy + xz * xz);
		if( Math.abs(mag) > math.Constants.EPSILON ) 
		{
			xx /= mag;
			xy /= mag;
			xz /= mag;
		}

		mag = Math.sqrt(yx * yx + yy * yy + yz * yz);
		if( Math.abs(mag) > math.Constants.EPSILON) 
		{
			yx /= mag;
			yy /= mag;
			yz /= mag;
		}

		l_Matrix.Set(
		xx,
		xy,
		xz,
		0,
		
		yx,
		yy,
		yz,
		0,
		
		zx,
		zy,
		zz,
		0,
		
		0,
		0,
		0,
		1);
		
		Translate( l_Matrix,l_Matrix ,-eyex, -eyey, -eyez);
		
		Mult(this,this,l_Matrix);
	}
	
	public function Translation( _x,_y,_z) : Void
	{
		Identity();
		
		M(3,0,_x);
		M(3,1,_y);
		M(3,2,_z);
	}
	
	public static inline function Translate( 	_Out: CMatrix44, 
												_In : CMatrix44, 
												_x : Float, _y : Float, _z : Float)
	{
		var l_Temp : CMatrix44 = Registers.M0;
		
		l_Temp.Identity();
		l_Temp.M(3,0,_x);
		l_Temp.M(3,1,_y);
		l_Temp.M(3,2,_z);
		
		Mult( _Out, _In, l_Temp);
	}
	
	/*
	 * 				00 01 02 03 
	 * 				10
	 * 				20
	 * 				30		33
	 * 00 01 02 03 
	 * 10
	 * 20
	 * 30		33
	 * */
	public static function Mult( _Out : CMatrix44, _M0 : CMatrix44, _M1 : CMatrix44 ) : Void
	{
		_Out.Zero();
		
		for( _i in 0...3 )
		{
			for( _j in 0...3 )
			{
				_Out.M(_i, _j, _M0.Get(_i, _j) * _M1.Get(_j, _i) + _Out.Get(_i, _j) );
			}
		}
	}
	
	public static inline function Det22(a : Float, b : Float, c : Float, d : Float) : Float
	{
		return a * d - b * c;
	}

	public static function Det33( 	a1 : Float, a2 : Float, a3 : Float,
									b1 : Float, b2 : Float, b3 : Float,
									c1 : Float, c2 : Float, c3 : Float ) : Float
	{
		 return 	a1 * Det22(b2, b3, c2, c3)
				- 	b1 * Det22(a2, a3, c2, c3)
				+ 	c1 * Det22(a2, a3, b2, b3);

	}
	
	public function Det44() : Float
	{
		var a1 : Float = Get(0,0);
		var b1 : Float = Get(0,1); 
		var c1 : Float = Get(0,2);
		var d1 : Float = Get(0,3);

		var a2 : Float = Get(1,0);
		var b2 : Float = Get(1,1); 
		var c2 : Float = Get(1,2);
		var d2 : Float = Get(1,3);

		var a3 : Float = Get(2,0);
		var b3 : Float = Get(2,1); 
		var c3 : Float = Get(2,2);
		var d3 : Float = Get(2,3);

		var a4 : Float = Get(3,0);
		var b4 : Float = Get(3,1); 
		var c4 : Float = Get(3,2);
		var d4 : Float = Get(3,3);

		return a1 * Det33(b2, b3, b4, c2, c3, c4, d2, d3, d4)
			 - b1 * Det33(a2, a3, a4, c2, c3, c4, d2, d3, d4)
			 + c1 * Det33(a2, a3, a4, b2, b3, b4, d2, d3, d4)
			 - d1 * Det33(a2, a3, a4, b2, b3, b4, c2, c3, c4);
	}

	public function Adjoint( _Out : CMatrix44) : Void
	{
		var a1 : Float = Get(0,0);
		var b1 : Float = Get(0,1); 
		var c1 : Float = Get(0,2);
		var d1 : Float = Get(0,3);

		var a2 : Float = Get(1,0);
		var b2 : Float = Get(1,1); 
		var c2 : Float = Get(1,2);
		var d2 : Float = Get(1,3);

		var a3 : Float = Get(2,0);
		var b3 : Float = Get(2,1); 
		var c3 : Float = Get(2,2);
		var d3 : Float = Get(2,3);

		var a4 : Float = Get(3,0);
		var b4 : Float = Get(3,1); 
		var c4 : Float = Get(3,2);
		var d4 : Float = Get(3,3);

		// Row column labeling reversed since we transpose rows & columns
		_Out.Set(   	Det33(b2, b3, b4, c2, c3, c4, d2, d3, d4),
					- 	Det33(a2, a3, a4, c2, c3, c4, d2, d3, d4),
						Det33(a2, a3, a4, b2, b3, b4, d2, d3, d4),
					- 	Det33(a2, a3, a4, b2, b3, b4, c2, c3, c4),
					
					- 	Det33(b1, b3, b4, c1, c3, c4, d1, d3, d4),
						Det33(a1, a3, a4, c1, c3, c4, d1, d3, d4),
					- 	Det33(a1, a3, a4, b1, b3, b4, d1, d3, d4),
						Det33(a1, a3, a4, b1, b3, b4, c1, c3, c4),
					
						Det33(b1, b2, b4, c1, c2, c4, d1, d2, d4),
					- 	Det33(a1, a2, a4, c1, c2, c4, d1, d2, d4),
						Det33(a1, a2, a4, b1, b2, b4, d1, d2, d4),
					- 	Det33(a1, a2, a4, b1, b2, b4, c1, c2, c4),
					
					- 	Det33(b1, b2, b3, c1, c2, c3, d1, d2, d3),
						Det33(a1, a2, a3, c1, c2, c3, d1, d2, d3),
					- 	Det33(a1, a2, a3, b1, b2, b3, d1, d2, d3),
						Det33(a1, a2, a3, b1, b2, b3, c1, c2, c3));
	}

	public function MultScalar( _InOut : CMatrix44, _f : Float ) : Void
	{
		for ( i in 0...16)
		{
			m_Buffer[i] *= _f;
		}
	}
	
	public function Invert( _Out : CMatrix44 ) : Bool
	{
		// Calculate the 4x4 determinant
		// If the determinant is zero, 
		// then the inverse matrix is not unique.
		var l_Det : Float = Det44();

		if (Math.abs(l_Det) < Constants.EPSILON)
		{
			return false;
		}

		Adjoint( _Out );
		MultScalar( _Out, 1.0 / l_Det );
		
		return true;
	}
	
	public static function Ortho( _Out : CMatrix44 , _left : Float, _right : Float, _bottom : Float, _top : Float, _near : Float, _far : Float )
	{
		var l_tx = (_left + _right) / (_left - _right);
		var l_ty = (_top + _bottom) / (_top - _bottom);
		var l_tz = (_far + _near) / (_far - _near);
		
		_Out.M(0,0, 2 / (_left - _right));
		_Out.M(0,1, 0);
		_Out.M(0,2, 0);
		_Out.M(0,3, 0);
		_Out.M(1,0, 0);
		_Out.M(1,1, 2 / (_top - _bottom));
		_Out.M(1,2, 0);
		_Out.M(1,3, 0);
		_Out.M(2,0, 0);
		_Out.M(2,1, 0);
		_Out.M(2,2, -2 / (_far - _near));
		_Out.M(2,3, 0);
		_Out.M(3,0, l_tx);
		_Out.M(3,1, l_ty);
		_Out.M(3,2, l_tz);
		_Out.M(3,3, 1);
	}

}





