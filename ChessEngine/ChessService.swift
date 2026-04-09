//
//  ChessService.swift
//  ChessEngine
//
//  Created by Philips Jose on 08/04/26.
//

import Foundation

public class ChessService: NSObject {
    
    // MARK: - Private Variables & Functions
    
    private static var sharedChessService: ChessService = {
        let service = ChessService()
        return service
    }()
    
    private override init() {
        super.init()
    }
    
    private var board = Board()
    
    // MARK: - Pubic Variables & Functions
    
    public weak var delegate: ChessServiceDelegate?
    
    public class func shared() -> ChessService {
        return sharedChessService
    }
    
    public func printBoard() {
        board = Board.startPosition()
        board.debugBitboard(board.blackRooks,   label: "Black Rooks")
        board.debugBitboard(board.blackKnights, label: "Black Knights")
        board.debugBitboard(board.blackBishops, label: "Black Bishops")
        board.debugBitboard(board.blackKing,    label: "Black King")
        board.debugBitboard(board.blackQueens,  label: "Black Queens")
        board.debugBitboard(board.blackPawns,   label: "Black Pawns")
        
        board.debugBitboard(board.whiteRooks,   label: "White Rooks")
        board.debugBitboard(board.whiteKnights, label: "White Knights")
        board.debugBitboard(board.whiteBishops, label: "White Bishops")
        board.debugBitboard(board.whiteKing,    label: "White King")
        board.debugBitboard(board.whiteQueens,  label: "White Queens")
        board.debugBitboard(board.whitePawns,   label: "White Pawns")
        
        print(board.generateFEN())
        
    }
}

extension ChessService {
    public func startNewGame() {
        self.board = Board.startPosition()
        self.delegate?.chessService(self, didUpdateBoard: self.board.generateFEN(), error: nil)
    }
}
