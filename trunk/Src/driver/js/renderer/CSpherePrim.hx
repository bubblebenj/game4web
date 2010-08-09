/**
 * ...
 * @author de
 */

package driver.js.renderer;

class CSpherePrim extends CPrimitiveJS
{

	public function new() 
	{
		
	}

	public override function Build() : Void
	{
		var geometryData = [ ];
		var normalData = [ ];
		var texCoordData = [ ];
		var indexData = [ ];
		
		for (var latNumber = 0; latNumber <= lats; ++latNumber) {
			for (var longNumber = 0; longNumber <= longs; ++longNumber) {
				var theta = latNumber * Math.PI / lats;
				var phi = longNumber * 2 * Math.PI / longs;
				var sinTheta = Math.sin(theta);
				var sinPhi = Math.sin(phi);
				var cosTheta = Math.cos(theta);
				var cosPhi = Math.cos(phi);
				
				var x = cosPhi * sinTheta;
				var y = cosTheta;
				var z = sinPhi * sinTheta;
				var u = 1-(longNumber/longs);
				var v = latNumber/lats;
				
				normalData.push(x);
				normalData.push(y);
				normalData.push(z);
				texCoordData.push(u);
				texCoordData.push(v);
				geometryData.push(radius * x);
				geometryData.push(radius * y);
				geometryData.push(radius * z);
			}
		}
		
		for (var latNumber = 0; latNumber < lats; ++latNumber) {
			for (var longNumber = 0; longNumber < longs; ++longNumber) {
				var first = (latNumber * (longs+1)) + longNumber;
				var second = first + longs + 1;
				indexData.push(first);
				indexData.push(second);
				indexData.push(first+1);

				indexData.push(second);
				indexData.push(second+1);
				indexData.push(first+1);
			}
		}
		
		var retval = { };
		
		retval.normalObject = ctx.createBuffer();
		ctx.bindBuffer(ctx.ARRAY_BUFFER, retval.normalObject);
		ctx.bufferData(ctx.ARRAY_BUFFER, new WebGLFloatArray(normalData), ctx.STATIC_DRAW);

		retval.texCoordObject = ctx.createBuffer();
		ctx.bindBuffer(ctx.ARRAY_BUFFER, retval.texCoordObject);
		ctx.bufferData(ctx.ARRAY_BUFFER, new WebGLFloatArray(texCoordData), ctx.STATIC_DRAW);

		retval.vertexObject = ctx.createBuffer();
		ctx.bindBuffer(ctx.ARRAY_BUFFER, retval.vertexObject);
		ctx.bufferData(ctx.ARRAY_BUFFER, new WebGLFloatArray(geometryData), ctx.STATIC_DRAW);
		
		retval.numIndices = indexData.length;
		retval.indexObject = ctx.createBuffer();
		ctx.bindBuffer(ctx.ELEMENT_ARRAY_BUFFER, retval.indexObject);
		ctx.bufferData(ctx.ELEMENT_ARRAY_BUFFER, new WebGLUnsignedShortArray(indexData), ctx.STREAM_DRAW);

	}
	
}