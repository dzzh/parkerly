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

struct SimpleCellDataType: TableCellDataType {
    let title: String
    let subtitle: String?
}

protocol TableSectionDataSource {

    var numberOfRows: Int { get }

    var header: String? { get }

    func object(for row: Int) -> Any?

    func cellData(for row: Int) -> TableCellDataType?
}

extension TableSectionDataSource {

    var header: String? {
        return nil
    }

    func object(for row: Int) -> Any? {
        return nil
    }
}