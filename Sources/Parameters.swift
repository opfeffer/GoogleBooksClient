//
//  Parameters.swift
//  GoogleBooksClient
//
//  Created by Oliver Pfeffer on 11/13/17.
//  Copyright © 2017 Astrio, LLC. All rights reserved.
//

import Foundation

public enum PrintTypes: String {
    case all
    case books
    case magazines
}

public enum Projection: String {
    case full
    case lite
}

public enum Sorting: String {
    case relevance
    case newest
}
