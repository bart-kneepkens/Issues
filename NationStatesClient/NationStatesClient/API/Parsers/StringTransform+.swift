//
//  StringTransform+.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 29/12/2020.
//

import Foundation

extension StringTransform {
    // See ICU project docs about this transliterator:
    // https://unicode-org.github.io/icu/userguide/transforms/general/#icu-transliterators
    public static let HexAny: StringTransform = StringTransform("Hex-Any")
}
