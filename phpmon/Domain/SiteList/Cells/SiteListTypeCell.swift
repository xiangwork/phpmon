//
//  SiteListTypeCell.swift
//  PHP Monitor
//
//  Created by Nico Verbruggen on 16/03/2022.
//  Copyright © 2022 Nico Verbruggen. All rights reserved.
//

import Cocoa
import AppKit

class SiteListTypeCell: NSTableCellView, SiteListCellProtocol
{
    static let reusableName = "siteListTypeCell"
    
    @IBOutlet weak var labelDriver: NSTextField!
    @IBOutlet weak var labelPhpVersion: NSTextField!
    
    func populateCell(with site: ValetSite) {
        labelDriver.stringValue = site.driver ?? "driver.not_detected".localized
        
        // Determine the Laravel version
        if site.driver == "Laravel" && site.notableComposerDependencies.keys.contains("laravel/framework") {
            let constraint = site.notableComposerDependencies["laravel/framework"]!
            labelDriver.stringValue = "Laravel (\(constraint))"
        }
        
        // PHP version
        labelPhpVersion.stringValue = site.composerPhp == "???" ? "Any PHP" : "PHP \(site.composerPhp)"
    }
}
