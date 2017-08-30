//
//  AMPTicTacToeViewController.m
//  TicTacToe
//
//  Created by Alberto Plata on 8/8/17.
//  Copyright © 2017 Alberto Plata. All rights reserved.
//

#import "AMPTicTacToeViewController.h"
#import "AMPUtils.h"
#import "AMPGameModel.h"

NSInteger const AMPTicTacToeIndent = 15;            // Indentation for board
NSInteger const AMPTicTacToePadding = 4;            // Padding for the board

NSString *const AMPTicTacToeXName = @"X";           // NSString constant for the X image
NSString *const AMPTicTacToeOName = @"O";           // NSString constant for the O image

@interface AMPTicTacToeViewController ()

@property UIView *boardView;                // UIView for the board
@property AMPGameModel *gameModel;          // Game model object for state and logic information
@property NSMutableArray *buttons;          // 2-dimensional array of AMPSquareButton views to display X's and O's

@end

@implementation AMPTicTacToeViewController

#pragma mark - Lifecycle methods

- (void) loadView {
    
    self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view setBackgroundColor:[UIColor whiteColor]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupBoardView];
    [self setupGameModel];
    [self setupButtons];
}

#pragma mark - Setup methods
// This method displays the board image on the screen
- (void) setupBoardView {
    
    NSInteger boardLength = SCREEN_WIDTH - (AMPTicTacToeIndent * 2);
    
    // Dynamically calculate position and size needed for board image
    CGRect frame = CGRectMake(AMPTicTacToeIndent,
                              SCREEN_HEIGHT * 0.3,
                              boardLength,
                              boardLength);
    self.boardView = [[UIView alloc] initWithFrame:frame];
    
    // Add separator lines to the board based on the number of rows and cols
    for (NSInteger i = 1; i < AMPGameRowColLength; i++) {
        // Add vertical separator lines to the board
        [self addSeparatorLineWithFrame:CGRectMake(boardLength / AMPGameRowColLength * i, 0, 1, boardLength)
                                 toView:self.boardView];
        
        // Add horizontal separator lines to the board
        [self addSeparatorLineWithFrame:CGRectMake(0, boardLength / AMPGameRowColLength * i, boardLength, 1)
                                 toView:self.boardView];
    }
    
    // set userInteractionEnabled to YES so AMPSquareButton object can respond to clicks
    [self.boardView setUserInteractionEnabled:YES];
    [self.view addSubview:self.boardView];
}

// Adds a separator line with a provided frame to the view
- (void) addSeparatorLineWithFrame:(CGRect)frame toView:(UIView *)view{
    
    UIView *separatorLine = [[UIView alloc] initWithFrame:frame];
    [separatorLine setBackgroundColor:[UIColor blackColor]];
    [view addSubview:separatorLine];
}

// This method creates the game model for the game
- (void) setupGameModel {
    
    self.gameModel = [AMPGameModel new];
}

// This method creates and displays the AMPSquareButton objects to display to the user
- (void) setupButtons {
    
    CGFloat boardWidth = self.boardView.frame.size.width;
    CGFloat boardHeight = self.boardView.frame.size.height;
    
    // Add AMPSquareButton objects to a 2-dimensional array to maintain a reference
    self.buttons = [NSMutableArray new];
    for (NSInteger i = 0; i < AMPGameRowColLength; i++) {
        [self.buttons addObject:[NSMutableArray new]];
        for (NSInteger j = 0; j < AMPGameRowColLength; j++) {
            
            // Dynamically calculate position and size needed for each AMPSquareButton on the board
            CGRect frame = CGRectMake((j / AMPGameRowColLength ) * boardWidth + AMPTicTacToePadding,
                                      (i / AMPGameRowColLength ) * boardHeight + AMPTicTacToePadding,
                                      boardWidth / AMPGameRowColLength - (AMPTicTacToePadding * 2),
                                      boardHeight / AMPGameRowColLength - (AMPTicTacToePadding * 2));
            AMPSquareButton *button = [[AMPSquareButton alloc] initWithFrame:frame row:i col:j];
            [button addTarget:self action:@selector(squareButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            [(NSMutableArray *)self.buttons[i] addObject:button];
            
            // Add AMPSquareButton object to the board so it displays
            [self.boardView addSubview:button];
            [self.boardView bringSubviewToFront:button];
        }
    }
}

#pragma mark - Button event method
// This method updates the board with a AMPSquareButton is clicked
- (void) squareButtonClicked:(AMPSquareButton *)button {
    
    NSInteger row = button.row;
    NSInteger col = button.col;
    
    // Tell the game model to update state for this row and col if it hasn't already
    if ([self.gameModel updateStateForRow:row col:col]) {
        
        // set player to current player, X or O
        NSString *player = ([self.gameModel getStateForRow:row col:col] == AMPGameOwnershipStateX) ? AMPTicTacToeXName : AMPTicTacToeOName;
        
        // set AMPSquareButton object to an X or O image based on the current player
        [button updateImageWithName:player];
        
        // If there is a winner or a tie, display the alert controller and then clear the board
        if ([self.gameModel isWinnerAtRow:row col:col]) {
            
            NSString *alertMessage = [NSString stringWithFormat:@"%@ won!",player];
            [self showAlertWithMessage:alertMessage];
        }
        else if (self.gameModel.movesCounter == AMPGameBoardSize) {
            
            [self showAlertWithMessage:@"It's a tie."];
        }
        // Tell the game model to toggle the current player
        [self.gameModel toggleCurrentPlayer];
    }
}

#pragma mark - Alert view method
// This method displays the UIAlertController when a game is won or tied
- (void) showAlertWithMessage:(NSString *)message {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Game over" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    // Reset the game and remove the alert controller when the "Play again" button is clicked
    UIAlertAction *playAgain = [UIAlertAction actionWithTitle:@"Play again" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [self resetGame];
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    [alert addAction:playAgain];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Reset game method
// This method resets the game by notifying the game model and clearing the views of any images
- (void) resetGame {
    // Notify the game model to reset its data
    [self.gameModel resetGame];
    
    // Iterate through the 2-dimensional array and clear any X and O images
    for (NSInteger i = 0; i < AMPGameRowColLength; i++) {
        for (NSInteger j = 0; j < AMPGameRowColLength; j++) {
            AMPSquareButton *button = (AMPSquareButton *)[(NSMutableArray *)self.buttons[i] objectAtIndex:j];
            [button updateImageWithName:nil];
        }
    }
}

@end
