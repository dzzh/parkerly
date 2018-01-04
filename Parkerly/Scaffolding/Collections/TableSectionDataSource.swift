//
// Created by Zmicier Zaleznicenka on 3/1/18.
// Copyright (c) 2018 Zmicier Zaleznicenka. All rights reserved.
//

import Foundation

protocol TableCellDataType {

    var title: String { get }
    var subtitle: String? { get }
}

extension TableCellDataType {

    var subtitle: String? {
        return nil
    }
}

protocol TableSectionDataSource {

    var numberOfRows: Int { get }

    var header: String? { get }

    func cellData(for row: Int) -> TableCellDataType?
}

extension TableSectionDataSource {

    var header: String? {
        return nil
    }
}