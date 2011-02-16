package com.rush
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	/**
	 * Example applet which uses hexagonal grid. It's a hexagonal version of the
	 * "lights out" puzzle game: http://en.wikipedia.org/wiki/Lights_Out_(game)
	 *
	 * @author Ruslan Shestopalyuk
	 *
	 * Converted to AS3
	 */
	
	public class HexLightsOut extends MovieClip
	{
		private var game:MovieClip;
		
		static public const ORANGE:int = 0xFF5721;
		static public const GRAY:int = 0xCCCCCC;
		
		static private var serialVersionUID:Number;
		
		static private const BOARD_WIDTH:int = 5;
		static private const BOARD_HEIGHT:int = 4;

		static private const L_ON:int = 1;
		static private const L_OFF:int = 2;

		static private const NUM_HEX_CORNERS:int = 6;
		static private const CELL_RADIUS:int = 40;

		//  game board cells array
		private var mCells:Array = [ [    0, L_ON, L_ON, L_ON,    0 ],
								   [ L_ON, L_ON, L_ON, L_ON, L_ON ],
								   [ L_ON, L_ON, L_ON, L_ON, L_ON ],
								   [    0,    0, L_ON,    0,    0 ] ];

		private var mCornersX:Array = [NUM_HEX_CORNERS];
		private var mCornersY:Array = [NUM_HEX_CORNERS];

		private static var mCellMetrics:HexGridCell  = new HexGridCell(CELL_RADIUS);
		
		public function HexLightsOut()
		{
			if ( stage ) stage.addEventListener( MouseEvent.MOUSE_UP, mouse_released );
			paint();
		}


		public function paint():void
		{
			this.graphics.clear();
			this.graphics.lineStyle( 2, 0, 0.9 );
			
			for ( var j:int = 0; j < BOARD_HEIGHT; j++ )
			{
				for ( var i:int = 0; i < BOARD_WIDTH; i++ )
				{
					
					mCellMetrics.setCellIndex(i, j);
					
					
					if (mCells[j][i] != 0)
					{
						mCellMetrics.computeCorners(mCornersX, mCornersY);
						
						this.graphics.beginFill( ( mCells[j][i] == L_ON ) ? ORANGE : GRAY, 1 );
						
						for ( var k:int = 0; k < mCornersX.length-1; k++ )
						{
							if( k == 0 ) this.graphics.moveTo( mCornersX[k], mCornersY[k] );
							
							this.graphics.lineTo( mCornersX[k + 1], mCornersY[k + 1] );
						}
						
						this.graphics.lineTo( mCornersX[0], mCornersY[0] );
						
						this.graphics.endFill();
					}
				}
			}
		}
		
		public function update():void
		{
			paint();
		}

		/**
		 * Returns true if cell is inside the game board.
		 *
		 * @param i cell's horizontal index
		 * @param j cell's vertical index
		 */
		private function isInsideBoard( i:int, j:int ):Boolean
		{
			return i >= 0 && i < BOARD_WIDTH && j >= 0 && j < BOARD_HEIGHT && mCells[j][i] != 0;
		}

		/**
		 * Toggles the cell's light ON<->OFF.
		 */
		private function toggleCell( i:int, j:int ):void
		{
			mCells[j][i] = (mCells[j][i] == L_ON) ? L_OFF : L_ON;
		}

		/**
		 * Returns true if all lights have been switched off.
		 */
		private function isWinCondition():Boolean
		{
			for ( var j:int = 0; j < BOARD_HEIGHT; j++) {
				for ( var i:int = 0; i < BOARD_WIDTH; i++) {
					if (mCells[j][i] == L_ON) {
						return false;
					}
				}
			}
			return true;
		}

		/**
		 * Resets the game to the initial position (all lights are on).
		 */
		private function resetGame():void
		{
			for ( var j:int = 0; j < BOARD_HEIGHT; j++) {
				for ( var i:int = 0; i < BOARD_WIDTH; i++) {
					if (mCells[j][i] == L_OFF) {
						mCells[j][i] = L_ON;
					}
				}
			}
		}
		
		private function mouse_released( e:MouseEvent ):void
		{
			mCellMetrics.setCellByPoint( mouseX, mouseY );
			
			var clickI:int = mCellMetrics.getIndexI();
			var clickJ:int = mCellMetrics.getIndexJ();

			if ( isInsideBoard( clickI, clickJ ) )
			{
				// toggle the clicked cell together with the neighbors
				toggleCell(clickI, clickJ);
				for ( var k:int = 0; k < 6; k++)
				{
					var nI:int = mCellMetrics.getNeighborI(k);
					var nJ:int = mCellMetrics.getNeighborJ(k);
					if ( isInsideBoard( nI, nJ ) )
					{
						toggleCell( nI, nJ );
					}
				}
			}
			
			paint();

			if ( isWinCondition() )
			{
				trace("Well done!");
				resetGame();
				paint();
			}
		}
	}
}

