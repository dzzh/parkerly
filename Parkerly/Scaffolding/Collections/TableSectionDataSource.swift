//
// Created by Zmicier Zaleznicenka on 3/1/18.
// Copyright (c) 2018 Zmicier Zaleznicenka. All rights reserved.
//

import Foundation
import ParkerlyCore

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

protocol TableSectionDataSourceType {

    var numberOfRows: Int { get }

    var header: String? { get }

    func object(for row: Int) -> Any?

    func cellData(for row: Int) -> TableCellDataType?

    func reload(completion: ((ParkerlyError?) -> Void)?)
}

class TableSectionDataSource: TableSectionDataSourceType {

    var numberOfRows: Int {
        return 0
    }

    var header: String? {
        return nil
    }

    func object(for row: Int) -> Any? {
        return nil
    }

    func cellData(for row: Int) -> TableCellDataType? {
        return nil
    }

    func reload(completion: ((ParkerlyError?) -> Void)? = nil) {
        completion?(nil)
    }
}