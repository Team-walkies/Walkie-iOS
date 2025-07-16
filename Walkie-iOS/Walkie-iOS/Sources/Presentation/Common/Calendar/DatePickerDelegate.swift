//
//  DatePickerDelegate.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 7/15/25.
//

import Foundation

protocol DatePickerDelegate: AnyObject {
    func selectDate(_ date: Date)
    func willCloseDatePicker()
}
