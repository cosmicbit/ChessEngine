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
    private func charAt(index: Int) -> Character? {
        let bit: UInt64 = 1 << index
        
        // White pieces
        if (whitePawns & bit) != 0   { return "P" }
        if (whiteRooks & bit) != 0   { return "R" }
        if (whiteKnights & bit) != 0 { return "N" }
        if (whiteBishops & bit) != 0 { return "B" }
        if (whiteQueens & bit) != 0  { return "Q" }
        if (whiteKing & bit) != 0    { return "K" }
        
        // Black pieces
        if (blackPawns & bit) != 0   { return "p" }
        if (blackRooks & bit) != 0   { return "r" }
        if (blackKnights & bit) != 0 { return "n" }
        if (blackBishops & bit) != 0 { return "b" }
        if (blackQueens & bit) != 0  { return "q" }
        if (blackKing & bit) != 0    { return "k" }
        
        return nil
    }
    
    public func generateFEN() -> String {
        var fen = ""
        
        // 1. Piece placement (Rank 8 down to Rank 1)
        for rank in stride(from: 7, through: 0, by: -1) {
            var emptyCount = 0
            
            for file in 0..<8 {
                let index = rank * 8 + file
                
                if let pieceChar = charAt(index: index) {
                    // If we found a piece, append the number of empty squares first
                    if emptyCount > 0 {
                        fen += "\(emptyCount)"
                        emptyCount = 0
                    }
                    fen.append(pieceChar)
                } else {
                    emptyCount += 1
                }
            }
            
            if emptyCount > 0 {
                fen += "\(emptyCount)"
            }
            
            // Add rank separator, except for the last rank
            if rank > 0 {
                fen += "/"
            }
        }
        
        // 2. Side to move
        fen += (sideToMove == .white) ? " w " : " b "
        
        // 3. Castling Rights
        var castling = ""
        if (castlingRights & 0b1000) != 0 { castling += "K" }
        if (castlingRights & 0b0100) != 0 { castling += "Q" }
        if (castlingRights & 0b0010) != 0 { castling += "k" }
        if (castlingRights & 0b0001) != 0 { castling += "q" }
        fen += castling.isEmpty ? "- " : castling + " "
        
        // 4. En Passant Square
        if let ep = enPassantSquare {
            let files = ["a", "b", "c", "d", "e", "f", "g", "h"]
            let f = ep % 8
            let r = (ep / 8) + 1
            fen += "\(files[f])\(r) "
        } else {
            fen += "- "
        }
        
        // 5. Halfmove and Fullmove (Placeholder for now)
        fen += "0 1"
        
        return fen
    }
}

extension Board {
    public static func startPosition() -> Board {
        var board = Board()
        board.whitePawns = 0x000000000000FF00
        board.whiteRooks = 0x0000000000000081   // a1 and h1
        board.whiteKnights = 0x0000000000000042 // b1 and g1
        board.whiteBishops = 0x0000000000000024 // c1 and f1
        board.whiteQueens = 0x0000000000000008  // d1
        board.whiteKing = 0x0000000000000010    // e1
        
        board.blackPawns = 0x00FF000000000000
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

extension Board {
    /// Resets the board and loads a position from a FEN string
    public mutating func loadFEN(_ fen: String) {
        // Reset all bitboards to 0
        self = Board(empty: true)
        
        let components = fen.components(separatedBy: " ")
        guard components.count >= 1 else { return }
        
        // 1. Parse Piece Placement
        let ranks = components[0].components(separatedBy: "/")
        var currentRank = 7
        
        for rankString in ranks {
            var currentFile = 0
            for char in rankString {
                if let emptySquares = Int(String(char)) {
                    currentFile += emptySquares
                } else {
                    let index = currentRank * 8 + currentFile
                    setPiece(char, at: index)
                    currentFile += 1
                }
            }
            currentRank -= 1
        }
        
        // 2. Parse Side to Move
        if components.count > 1 {
            self.sideToMove = (components[1] == "w") ? .white : .black
        }
        
        // 3. Parse Castling Rights
        if components.count > 2 {
            self.castlingRights = 0
            let rights = components[2]
            if rights.contains("K") { self.castlingRights |= 0b1000 }
            if rights.contains("Q") { self.castlingRights |= 0b0100 }
            if rights.contains("k") { self.castlingRights |= 0b0010 }
            if rights.contains("q") { self.castlingRights |= 0b0001 }
        }
        
        // 4. Parse En Passant
        if components.count > 3 && components[3] != "-" {
            self.enPassantSquare = squareIndex(from: components[3])
        }
    }
    
    private mutating func setPiece(_ char: Character, at index: Int) {
        switch char {
        case "P": whitePawns.setBit(at: index)
        case "R": whiteRooks.setBit(at: index)
        case "N": whiteKnights.setBit(at: index)
        case "B": whiteBishops.setBit(at: index)
        case "Q": whiteQueens.setBit(at: index)
        case "K": whiteKing.setBit(at: index)
        case "p": blackPawns.setBit(at: index)
        case "r": blackRooks.setBit(at: index)
        case "n": blackKnights.setBit(at: index)
        case "b": blackBishops.setBit(at: index)
        case "q": blackQueens.setBit(at: index)
        case "k": blackKing.setBit(at: index)
        default: break
        }
    }
}

extension Board {
    // Create an empty board for loading FENs
    init(empty: Bool) {
        self.whitePawns = 0; self.whiteKnights = 0; self.whiteBishops = 0
        self.whiteRooks = 0; self.whiteQueens = 0; self.whiteKing = 0
        self.blackPawns = 0; self.blackKnights = 0; self.blackBishops = 0
        self.blackRooks = 0; self.blackQueens = 0; self.blackKing = 0
    }
    
    // Convert "a1" -> 0, "h8" -> 63
    private func squareIndex(from name: String) -> Int? {
        guard name.count == 2 else { return nil }
        let chars = Array(name)
        let file = Int(chars[0].asciiValue! - Character("a").asciiValue!)
        let rank = Int(chars[1].asciiValue! - Character("1").asciiValue!)
        return rank * 8 + file
    }
}
