//
// Created by Zmicier Zaleznicenka on 3/1/18.
// Copyright (c) 2018 Zmicier Zaleznicenka. All rights reserved.
//

import os.log
import ParkerlyCore
import UIKit

class AbstractTableWithButtonViewModel: NSObject {

    private let defaultCellReuseIdentifier = "DefaultCellReuseIdentifier"
    private let value2CellReuseIdentifier = "Value2CellReuseIdentifier"

    // MARK: - State

    let sections: [TableSectionDataSource]
    let actionButtonTitle: String?

    // MARK: - Initialization

    init(sections: [TableSectionDataSource], actionButtonTitle: String?) {
        self.sections = sections
        self.actionButtonTitle = actionButtonTitle
    }
}

extension AbstractTableWithButtonViewModel: UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let sectionDataSource = sections[safe: indexPath.section],
            let cellData = sectionDataSource.cellData(for: indexPath.row) else {
            os_log("Couldn't get cell data for index path (%d, %d)", indexPath.section, indexPath.row)
            return UITableViewCell()
        }

        let identifier = cellData.subtitle != nil ? value2CellReuseIdentifier : defaultCellReuseIdentifier
        let cell: UITableViewCell
        if let _cell = tableView.dequeueReusableCell(withIdentifier: identifier) {
            cell = _cell
        } else {
            let style = cellData.subtitle != nil ? UITableViewCellStyle.value2 : UITableViewCellStyle.default
            cell = UITableViewCell(style: style, reuseIdentifier: identifier)
        }
        cell.textLabel?.text = cellData.title
        cell.detailTextLabel?.text = cellData.subtitle
        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionDataSource = sections[safe: section] else {
            os_log("Invalid section index %d", section)
            return 0
        }

        return sectionDataSource.numberOfRows
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sectionDataSource = sections[safe: section] else {
            os_log("Invalid section index %d", section)
            return nil
        }

        return sectionDataSource.header
    }
}
