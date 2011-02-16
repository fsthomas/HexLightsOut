package com.rush
{

	/**
	* Uniform hexagonal grid cell's metrics utility class.
	*
	* @author Ruslan Shestopalyuk
	*
	* Converted from Java to AS3
	*
	*/

	public class HexGridCell
	{
		static private const NEIGHBORS_DI:Array = [ 0, 1, 1, 0, -1, -1 ];
		static private const NEIGHBORS_DJ:Array = [ [ -1, -1, 0, 1, 0, -1 ], [ -1, 0, 1, 1, 1, 0 ] ];
		
		private var CORNERS_DX:Array = [];
		private var CORNERS_DY:Array = [];
		
		private var SIDE:int;

		private var mX:int = 0; // cell's left coordinate
		private var mY:int = 0; // cell's top coordinate

		private var mI:int = 0; // cell's horizontal grid coordinate
		private var mJ:int = 0; // cell's vertical grid coordinate

		/**
		 * Cell radius (distance from center to one of the corners)
		 */
		public var RADIUS:int;
		/**
		 * Cell height
		 */
		public var HEIGHT:int;
		/**
		 * Cell width
		 */
		public var WIDTH:int;

		static public const NUM_NEIGHBORS:int = 6;

		/**
		 * @param radius Cell radius (distance from the center to one of the corners)
		 */
		public function HexGridCell( radius:int )
		{
			RADIUS = radius;
			WIDTH = radius * 2;
			HEIGHT = int (radius * Math.sqrt(3));
			SIDE = int( radius * 3 / 2 );

			CORNERS_DX = [ int( RADIUS / 2 ), SIDE, WIDTH, SIDE, int( RADIUS / 2 ), 0 ];
			CORNERS_DY = [ 0, 0, int(HEIGHT / 2), HEIGHT, HEIGHT, int(HEIGHT / 2 ) ];
		}

    /**
     * @return X coordinate of the cell's top left corner.
     */
    public function getLeft():int
	{
        return mX;
    }

    /**
     * @return Y coordinate of the cell's top left corner.
     */
    public function getTop():int
	{
        return mY;
    }

    /**
     * @return X coordinate of the cell's center
     */
    public function getCenterX():int
	{
        return mX + RADIUS;
    }

    /**
     * @return Y coordinate of the cell's center
     */
    public function getCenterY():int
	{
        return int( mY + HEIGHT / 2 );
    }

    /**
     * @return Horizontal grid coordinate for the cell.
     */
    public function getIndexI():int
	{
        return mI;
    }

    /**
     * @return Vertical grid coordinate for the cell.
     */
    public function getIndexJ():int
	{
        return mJ;
    }

    /**
     * @return Horizontal grid coordinate for the given neighbor.
     */
    public function getNeighborI( neighborIdx:int ):int
	{
        return mI + NEIGHBORS_DI[neighborIdx];
    }

    /**
     * @return Vertical grid coordinate for the given neighbor.
     */
    public function getNeighborJ( neighborIdx:int ):int
	{
        return mJ + NEIGHBORS_DJ[mI % 2][neighborIdx];
    }

    /**
     * Computes X and Y coordinates for all of the cell's 6 corners, clockwise,
     * starting from the top left.
     *
     * @param cornersX Array to fill in with X coordinates of the cell's corners
     * @param cornersX Array to fill in with Y coordinates of the cell's corners
     */
    public function computeCorners( cornersX:Array, cornersY:Array ):void
	{
        for ( var k:int = 0; k < NUM_NEIGHBORS; k++) {
            cornersX[k] = mX + CORNERS_DX[k];
            cornersY[k] = mY + CORNERS_DY[k];
        }
    }

    /**
     * Sets the cell's horizontal and vertical grid coordinates.
     */
    public function setCellIndex( i:int, j:int ):void
	{
        mI = i;
        mJ = j;
        mX = i * SIDE;
        mY = int( HEIGHT * (2 * j + (i % 2)) / 2 );
    }

    /**
     * Sets the cell as corresponding to some point inside it (can be used for
     * e.g. mouse picking).
     */
    public function setCellByPoint( x:int, y:int ):void
	{
        var ci:int = int( Math.floor( x / SIDE ) );
        var cx:int = x - SIDE * ci;

        var ty:int = y - (ci % 2) * HEIGHT / 2;
        var cj:int = int( Math.floor( ty / HEIGHT) );
        var cy:int = ty - HEIGHT * cj;

        if (cx > Math.abs(RADIUS / 2 - RADIUS * cy / HEIGHT)) {
            setCellIndex(ci, cj);
        } else {
            setCellIndex(ci - 1, cj + (ci % 2) - ((cy < HEIGHT / 2) ? 1 : 0));
        }
    }
}
}
