/**
 * ...
 * @author de
 */

package math;

import math.CV3D;
import math.CMatrix44;

class Registers 
{
	//engine use
	public static var V0 : CV3D = new CV3D(0,0,0);
	public static var V1 : CV3D = new CV3D(0,0,0);
	public static var V2 : CV3D = new CV3D(0,0,0);
	public static var V3 : CV3D = new CV3D(0,0,0);
	
	//math use
	public static var V4 : CV3D = new CV3D(0,0,0);
	public static var V5 : CV3D = new CV3D(0,0,0);
	public static var V6 : CV3D = new CV3D(0,0,0);
	public static var V7 : CV3D = new CV3D(0,0,0);
	
	//user use
	public static var V8 : CV3D = new CV3D(0,0,0);
	public static var V9 : CV3D = new CV3D(0,0,0);
	public static var V10 : CV3D = new CV3D(0,0,0);
	public static var V11 : CV3D = new CV3D(0,0,0);
	
	//engine use
	public static var M0 : CMatrix44 = new CMatrix44();
	public static var M1 : CMatrix44 = new CMatrix44();
	public static var M2 : CMatrix44 = new CMatrix44();
	public static var M3 : CMatrix44 = new CMatrix44();
	
	//user use
	public static var M4 : CMatrix44 = new CMatrix44();
	public static var M5 : CMatrix44 = new CMatrix44();
	public static var M6 : CMatrix44 = new CMatrix44();
	public static var M7 : CMatrix44 = new CMatrix44();
}