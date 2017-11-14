//
//  Foundation+GoogleBooksClient.swift
//  GoogleBooksClient
//
//  Created by Oliver Pfeffer on 11/13/17.
//  Copyright © 2017 Astrio, LLC. All rights reserved.
//

import Foundation

extension URL: ExpressibleByStringLiteral {

    public init(stringLiteral value: String) {
        self.init(string: value)!
    }
}
