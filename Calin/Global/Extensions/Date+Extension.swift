//
//  Date+Ext.swift
//  Calin
//
//  Created by shinisac on 7/22/25.
//

import Foundation

extension Date {
    /// "YYYY년 M월 dd일" 형식 문자열을 반환하는 함수
    func toYearMonthDayString() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 M월 d일"
        return formatter.string(from: self)
    }

    /// "YYYY년 M월" 형식 문자열을 반환하는 함수
    func toYearMonthString() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 M월"
        return formatter.string(from: self)
    }
    
    /// "M월 dd일" 형식 문자열을 반환하는 함수
    func toMonthDayString() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "M월 d일"
        return formatter.string(from: self)
    }
    
    /// 시간 정보를 제거하고 연/월/일만 유지한 Date 반환
    func removeTimeStamp() -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: self)
        return calendar.date(from: components) ?? self
    }
}
