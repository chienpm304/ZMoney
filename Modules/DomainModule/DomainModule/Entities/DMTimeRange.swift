//
//  DMTimeRange.swift
//  DomainModule
//
//  Created by Chien Pham on 16/09/2024.
//

import Foundation

public struct DMTimeRange {
    let startTime: TimeValue
    let endTime: TimeValue

    public init(startTime: TimeValue, endTime: TimeValue) {
        self.startTime = startTime
        self.endTime = endTime
    }
}
