//
//  ChessProtocols.swift
//  ChessEngine
//
//  Created by Philips Jose on 08/04/26.
//

import Foundation

public protocol ChessServiceDelegate: AnyObject {
    
    func chessService(_ engine: ChessService, didStart running: Bool, error: ChessError)
    
    func chessService(_ engine: ChessService,didUpdateBoard fen: String, error: ChessError)
    func chessService(_ engine: ChessService, didFindBestMove move: String, error: ChessError)
    func chessService(_ engine: ChessService, didGameOver winner: String?, error: ChessError)
}
