//
//  RMEpisodeTableViewDelegate.swift
//  RicknMortyApp
//
//  Created by Tim West on 12/8/23.
//

import UIKit

class RMEpisodeTableViewDelegate: NSObject, UITableViewDelegate {
    
    private var selectedIndex : IndexPath = IndexPath(row: -1, section: -1)
    private var isCollapsed = false
    private var notVisible = false
    
    weak var parentVC: RMEpisodeVC?
    
    init(parentVC: RMEpisodeVC) {
        self.parentVC = parentVC
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Creates a bigger cell size to reveal hidden details
        if selectedIndex == indexPath && isCollapsed == true {
            return 250
        }
        // Not selected/expanded? Returns a default size of 60
        return 60
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // Collapses and opens the episode cells
        if selectedIndex == indexPath {
            switch isCollapsed {
            case false:
                isCollapsed = true
            case true:
                isCollapsed = false
            }
        } else {
            isCollapsed = true
        }
        
        selectedIndex = indexPath
        
        tableView.beginUpdates()
        tableView.reloadRows(at: [indexPath], with: .automatic)
        // Helps prevent bottom most cells from being hidden when selected and expanded
        tableView.endUpdates()
        
        if tableView.visibleCells.last?.isEqual(tableView.cellForRow(at: indexPath)) ?? false {
            tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard let parentVC = parentVC else { return }
        
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        // Pagination for episodes/seasons
        if offsetY > contentHeight - height {
            if parentVC.currentPage < parentVC.totalPages {
                guard !parentVC.isLoadingEpisodeData else { return }
                parentVC.currentPage += 1
                DispatchQueue.main.async {
                    parentVC.fetchEpisodeData(pageNum: parentVC.currentPage)
                }
            }
        }
    }
}
