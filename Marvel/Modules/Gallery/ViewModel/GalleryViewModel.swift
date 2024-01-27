//
//  GalleryViewModel.swift
//  Marvel
//
//  Created by Hoda Elnaghy on 1/27/24.
//

import Foundation

class GalleryViewModel {
    let posterArray: [PosterUIModel]
    let index: Int

    init(posterArray: [PosterUIModel], index: Int) {
        self.posterArray = posterArray
        self.index = index
    }

}
