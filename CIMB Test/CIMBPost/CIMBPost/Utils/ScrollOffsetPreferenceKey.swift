//
//  ScrollOffsetPreferenceKey.swift
//  CIMBPost
//
//  Created by Phincon on 27/09/25.
//

import SwiftUI

struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

