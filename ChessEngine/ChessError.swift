//
//  ChessError.swift
//  ChessEngine
//
//  Created by Philips Jose on 08/04/26.
//

public enum ChessError {
    case none
    case invalidMove(String)      // e.g., "e2e5" is not legal for a Pawn
    case invalidFEN(String)       // The provided board string is broken
    case engineTimeout            // AI took too long to think
    case searchInterrupted
}
