//
//  Board.swift
//  ChessEngine
//
//  Created by Philips Jose on 08/04/26.
//

import Foundation

public struct Board {
    // White Pieces
    var whitePawns:   UInt64 = 0
    var whiteKnights: UInt64 = 0
    var whiteBishops: UInt64 = 0
    var whiteRooks:   UInt64 = 0
    var whiteQueens:  UInt64 = 0
    var whiteKing:    UInt64 = 0
    
    // Black Pieces
    var blackPawns:   UInt64 = 0
    var blackKnights: UInt64 = 0
    var blackBishops: UInt64 = 0
    var blackRooks:   UInt64 = 0
    var blackQueens:  UInt64 = 0
    var blackKing:    UInt64 = 0
    
    // State
    public var sideToMove: Color = .white
    public var castlingRights: UInt8 = 0b1111 // WK, WQ, BK, BQ
    public var enPassantSquare: Int? = nil // 0-63
}

extension Board {
    var whitePieces: UInt64 {
        return whitePawns | whiteKnights | whiteBishops | whiteRooks | whiteQueens | whiteKing
    }
    
    var blackPieces: UInt64 {
        return blackPawns | blackKnights | blackBishops | blackRooks | blackQueens | blackKing
    }
    
    var allPieces: UInt64 {
        return whitePieces | blackPieces
    }
}

extension Board {
    public static func startPosition() -> Board {
        var board = Board()
        
        /*
         White Pawns
             a b c d e f g h

          8  0 0 0 0 0 0 0 0
          7  0 0 0 0 0 0 0 0
          6  0 0 0 0 0 0 0 0
          5  0 0 0 0 0 0 0 0
          4  0 0 0 0 0 0 0 0
          3  0 0 0 0 0 0 0 0
          2  1 1 1 1 1 1 1 1
          1  0 0 0 0 0 0 0 0
        */
        board.whitePawns = 0x000000000000FF00
        // Rank 1: White Pieces
        board.whiteRooks = 0x0000000000000081   // a1 and h1
        board.whiteKnights = 0x0000000000000042 // b1 and g1
        board.whiteBishops = 0x0000000000000024 // c1 and f1
        board.whiteQueens = 0x0000000000000008  // d1
        board.whiteKing = 0x0000000000000010    // e1
        
        // Rank 7: Black Pawns
        board.blackPawns = 0x00FF000000000000
        // Rank 8: Black Pieces
        board.blackRooks = 0x8100000000000000
        board.blackKnights = 0x4200000000000000
        board.blackBishops = 0x2400000000000000
        board.blackQueens = 0x0800000000000000
        board.blackKing = 0x1000000000000000
        
        return board
    }
}

extension Board {
    func debugBitboard(_ bitboard: UInt64, label: String) {
        print("\n  Bitboard: \(label)")
        print("   a b c d e f g h\n")
        for rank in stride(from: 7, through: 0, by: -1) {
            var row = ""
            print(rank+1, terminator: "  ")
            for file in 0..<8 {
                let index = rank * 8 + file
                row += (bitboard & (1 << index) != 0) ? "1 " : "0 "
            }
            print(row)
        }
        
        print("\nHex value: 0x" + String(format: "%016llx", bitboard).uppercased())
    }
}
