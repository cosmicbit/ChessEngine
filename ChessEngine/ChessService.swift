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
    
    // MARK: - Pubic Variables & Functions
    
    public weak var delegate: ChessServiceDelegate?
    
    public class func shared() -> ChessService {
        return sharedChessService
    }
}
