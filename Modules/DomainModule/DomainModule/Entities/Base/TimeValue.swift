//
//  TimeValue.swift
//  DomainModule
//
//  Created by Chien Pham on 27/08/2024.
//

/// Time interval since 00:00:00 UTC on 1 January 1970, in seconds.
public typealias TimeValue = Int64

extension TimeValue {
    public var dateValue: Date {
        Date(timeIntervalSince1970: TimeInterval(self))
    }

    public var distantFuture: TimeValue {
        Date.distantFuture.timeValue
    }

    public var distantPast: TimeValue {
        Date.distantPast.timeValue
    }
}

extension Date {
    public var timeValue: TimeValue {
        TimeValue(timeIntervalSince1970)
    }
}
