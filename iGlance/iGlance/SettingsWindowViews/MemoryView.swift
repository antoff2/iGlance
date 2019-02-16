//
//  MemoryView.swift
//  iGlance
//
//  Created by Dominik on 27.10.18.
//  Copyright © 2018 iGlance Corp. All rights reserved.
//

import Cocoa

class MemoryView: NSViewController {
    // define the color values for the memory icon
    var colRedMem: CGFloat = 0
    var colBlueMem: CGFloat = 0
    var colGreenMem: CGFloat = 0
    var colAlphaMem: CGFloat = 0

    // define the outlet and the action of the checkbox which displays the memory usage icon
    @IBOutlet var cbMemUtil: NSButton! {
        didSet {
            cbMemUtil.state = AppDelegate.UserSettings.userWantsMemUsage ? NSButton.StateValue.on : NSButton.StateValue.off
        }
    }

    @IBAction func cbMemUtil_clicked(_: NSButton) {
        let checked = (cbMemUtil.state == NSButton.StateValue.on)
        AppDelegate.UserSettings.userWantsMemUsage = checked
        MemUsageComponent.sItemMemUsage.isVisible = checked
        UserDefaults.standard.set(checked, forKey: "userWantsMemUsage")
        checked ? MyStatusItems.insertItem(item: MyStatusItems.StatusItems.memUtil) : MyStatusItems.removeItem(item: MyStatusItems.StatusItems.memUtil)
    }

    // define the outlet and the action of the checkbox which enables and disables the border of the memory icon
    @IBOutlet var cbMemBorder: NSButton! {
        didSet {
            cbMemBorder.state = AppDelegate.UserSettings.userWantsMemBorder ? NSButton.StateValue.on : NSButton.StateValue.off
        }
    }

    @IBAction func cbMemBorder_clicked(_: NSButton) {
        AppDelegate.UserSettings.userWantsMemBorder = (cbMemBorder.state == NSButton.StateValue.on)
        UserDefaults.standard.set((cbMemBorder.state == NSButton.StateValue.on), forKey: "userWantsMemBorder")
    }

    // define the outlet and the action of the color well to change the color of the memory icon
    @IBOutlet var cpMemUtil: NSColorWell! {
        didSet {
            cpMemUtil.color = AppDelegate.UserSettings.memColor
            AppDelegate.UserSettings.memColor.getRed(&colRedMem, green: &colGreenMem, blue: &colBlueMem, alpha: &colAlphaMem)
        }
    }

    @IBAction func cpMem_clicked(_ sender: NSColorWell) {
        AppDelegate.UserSettings.memColor = sender.color
        sender.color.usingColorSpace(NSColorSpace.genericRGB)?.getRed(&colRedMem, green: &colGreenMem, blue: &colBlueMem, alpha: &colAlphaMem)
        UserDefaults.standard.set(CGFloat(round(colRedMem * 10000) / 10000), forKey: "colRedMem")
        UserDefaults.standard.set(CGFloat(round(colGreenMem * 10000) / 10000), forKey: "colGreenMem")
        UserDefaults.standard.set(CGFloat(round(colBlueMem * 10000) / 10000), forKey: "colBlueMem")
        UserDefaults.standard.set(CGFloat(round(colAlphaMem * 10000) / 10000), forKey: "colAlphaMem")
    }
    
    
    @IBOutlet weak var popUpMemoryVisualization: NSPopUpButton! {
        didSet {
            switch AppDelegate.UserSettings.memUsageVisualization {
            case AppDelegate.VisualizationType.Bar:
                popUpMemoryVisualization.selectItem(at: 0)
                break
            case AppDelegate.VisualizationType.Graph:
                popUpMemoryVisualization.selectItem(at: 1)
                // if the graph was selected make the width textfield visible
                // if the graph was selected make the width textfield visible
                memGraphWidth.isHidden = popUpMemoryVisualization.indexOfSelectedItem == 0
                memGraphPixelLabel.isHidden = memGraphWidth.isHidden
                memGraphWidthLabel.isHidden = memGraphWidth.isHidden
            }
            
        }
    }
    @IBAction func popUpMemoryVisualization(_ sender: Any) {
        AppDelegate.UserSettings.memUsageVisualization = popUpMemoryVisualization.indexOfSelectedItem == 0 ? AppDelegate.VisualizationType.Bar : AppDelegate.VisualizationType.Graph
        // adjust the length of the status item according to the visualization type
        MemUsageComponent.sItemMemUsage.length = popUpMemoryVisualization.indexOfSelectedItem == 0 ? 27 : CGFloat(AppDelegate.UserSettings.memGraphWidth+5)
        UserDefaults.standard.set((popUpMemoryVisualization.indexOfSelectedItem == 0) ? 0 : 1, forKey: "memUsageVisualization")
        
        // if the graph was selected make the width textfield visible
        memGraphWidth.isHidden = popUpMemoryVisualization.indexOfSelectedItem == 0
        memGraphPixelLabel.isHidden = memGraphWidth.isHidden
        memGraphWidthLabel.isHidden = memGraphWidth.isHidden
    }
    
    @IBOutlet weak var memGraphWidthLabel: NSTextField!
    @IBOutlet weak var memGraphPixelLabel: NSTextField!
    @IBOutlet weak var memGraphWidth: NSTextField! {
        didSet {
            // subtract 3 pixel because of the border of the graph
            memGraphWidth.intValue = Int32(MemUsageComponent.sItemMemUsage.length-5)
        }
    }
    @IBAction func memGraphWidth(_ sender: Any) {
        // if the graph option is not selected just return
        if popUpMemoryVisualization.indexOfSelectedItem == 0 {
            return
        }
        
        // set the length of the status item. We have to add 3 pixel because of the border of the graph and to make some space
        MemUsageComponent.sItemMemUsage.length = CGFloat(memGraphWidth.intValue+5)
        // save it to the user settings
        UserDefaults.standard.set(memGraphWidth.intValue, forKey: "memGraphWidth")
    }
}
