//
//  MainVC+FetchResultsDelegate.swift
//  weather
//
//  Created by Nipuna C on 27/8/20.
//  Copyright © 2020 Nipuna Cooray. All rights reserved.
//

import Foundation
import CoreData


extension WeatherPlanListViewController: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any,
                    at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath:  IndexPath?)
    {
        switch type {
        case .insert:
            self.tableView.insertRows(at: [newIndexPath!], with: .left)
        case .delete:
            self.tableView.deleteRows(at: [indexPath!], with: .right)
        case .update:
            self.tableView.reloadRows(at: [indexPath!], with: .left)
        default:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
            let indexSet = IndexSet(integer: sectionIndex)
            switch type {
            case .insert: tableView.insertSections(indexSet, with: .fade)
            case .delete: tableView.deleteSections(indexSet, with: .fade)
            case .update, .move:
               fatalError("Invalid change type in controller(_:didChange:atSectionIndex:for:). Only .insert or .delete should be possible.")
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
      tableView.beginUpdates()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
      tableView.endUpdates()
    }
    
    
}
