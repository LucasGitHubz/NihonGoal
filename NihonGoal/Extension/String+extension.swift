//
//  String+extension.swift
//  NihonGoal
//
//  Created by kuroro on 15/09/2020.
//  Copyright © 2020 lucasam. All rights reserved.
//
import Foundation

public extension String {
    func localizedString(usingArguments args: [CVarArg]? = nil) -> String {
        let result = Bundle.main.localizedString(forKey: self, value: nil, table: "Localizable")
        return args == nil ? result : String(format: result, locale: nil as Locale?, arguments: args!)
    }
}
