//
//  AMPGameModel.h
//  TicTacToe
//
//  Created by Alberto Plata on 8/8/17.
//  Copyright © 2017 Alberto Plata. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AMPSquareButton.h"

typedef NS_OPTIONS(NSUInteger, AMPGameOwnershipState) {
    AMPGameOwnershipStateNone = 0,        // Used while a square has not been selected. Default state for squares
    AMPGameOwnershipStateX,               // Used when a square is selected by player X
    AMPGameOwnershipStateO,               // Used when a square is selected by player O
};

extern CGFloat const AMPGameRowColLength;           // Represents the length of a row and column => 3
extern NSInteger const AMPGameBoardSize;            // Represents the size of the board => 9

/**
 * AMPGameModel is the data model used for this application. It contains the properties necessary
 * to play this Tic Tac Toe game. It also performs most of the game logic to follow MVC design patterns.
 *
 * This model can update the state of square within the squareMatrix, retrieve a state from the 
 * squareMatrix, check for a winner, reset the game and toggle the current player.
 *
 * This class was built using MVC design patterns and has no knowledge of the views contained within
 * this application.
 */
@interface AMPGameModel : NSObject

@property NSMutableArray *squareMatrix;                 // A 2-dimensional array for maintaining state
@property NSInteger movesCounter;                       // Counts number of moves within the game
@property BOOL isPlayerXMove;                           // YES if current player is X, NO if player is O

#pragma mark - Init method
/**
 * Init method for AMPGameModel. Does initial setup of its properties above.
 */
- (instancetype) init;

#pragma mark - Public methods
/**
 * Updates the ownership state of a newly selected square to either AMPSquareButtonOwnershipStateX
 * or AMPSquareButtonOwnershipStateO and increments the movesCounter. 
 *
 * @return YES if square was not previously selected and update took place, NO otherwise
 */
- (BOOL) updateStateForRow:(NSInteger)row col:(NSInteger)col;

/**
 * Returns the current state of a particular square at row and col.
 *
 * @return AMPGameOwnershipState
 */
- (AMPGameOwnershipState) getStateForRow:(NSInteger)row col:(NSInteger)col;

/**
 * Performs logic to check whether a newly clicked square creates a win for either an X player or an
 * O player. This logic runs in O(n) time where n is the length of the squareMatrix's row and col, not
 * the total amount of cells contained with the squareMatrix itself. This logic is performed within 
 * this model class, rather than the controller, to maintain a MVC design pattern.
 *
 * This method could have run in constant time O(1), however, a trade-off would have been the inability to 
 * support varying squareMatrix sizes. Given that O(n) is still very fast when considering row and col 
 * length, and the ability to support various squareMatrix sizes dynamically (i.e 3x3, 4x4, NxN), the 
 * O(n) algorithm appears to be the right choice.
 *
 * @return YES if button created a winner, NO otherwise
 */
- (BOOL) isWinnerAtRow:(NSInteger)row col:(NSInteger)col;

/**
 * Toggles the current player between X and O.
 */
- (void) toggleCurrentPlayer;

/**
 * Resets the game. Sets the above properties back to their default state after a player wins or there is a 
 * tie. Note that this method does not update what the views display directly, it only updates the models back
 * to their default state. The controller updates the display of the views to maintain MVC design.
 */
- (void) resetGame;

@end
