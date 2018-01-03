//
// Created by Zmicier Zaleznicenka on 3/1/18.
// Copyright (c) 2018 Zmicier Zaleznicenka. All rights reserved.
//

import Foundation

struct TableCellData {
    let title: String
    let subtitle: String?
}

protocol TableSectionDataSource {

    var numberOfRows: Int { get }

    var header: String? { get }

    func cellData(for row: Int) -> TableCellData?
}

extension TableSectionDataSource {

    var header: String? {
        return nil
    }
}