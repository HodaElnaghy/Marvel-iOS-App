//
//  String + https.swift
//  Marvel
//
//  Created by Hoda Elnaghy on 1/26/24.
//

import Foundation

extension String {
    var imagePath: String {
            return "https" + self.dropFirst(4) + "/portrait_uncanny.jpg"
    }
}
