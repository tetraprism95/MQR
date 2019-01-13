//
//  SearchResultsController.swift
//  MQR
//
//  Created by Nuri Chun on 10/6/18.
//  Copyright © 2018 tetra. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import MapKit

@objc protocol SearchResultsControllerDelegate
{
    @objc optional func updateContainerFromTableView(withVelocity velocity: CGPoint, scrollView: UIScrollView, targetContentOffset: UnsafeMutablePointer<CGPoint>)
    @objc optional func searchBarTapped(isTapped: Bool)
    @objc optional func searchResult(withSearchBar text: String?)
    @objc optional func searchFor(selectedLocation location: String?)
}

class SearchResultsController : UIViewController {
    
    let application = UIApplication.shared
    
    let cellId = "cellId"
    var delegate: SearchResultsControllerDelegate?
    
    var searchBarIsTapped: Bool = false
    
    var completerResults = [MKLocalSearchCompletion]()
    var searchCompleter = MKLocalSearchCompleter()
    
    let headerHeight: CGFloat = 0.0
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    var topContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    var tabView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layoutIfNeeded()
        return view
    }()
    
    var searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Search Desired Location..."
        sb.barStyle = .blackTranslucent
        sb.tintColor = .clear
        sb.searchBarStyle = .minimal
        return sb
    }()
    
    var bottomContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    var tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = true
        tv.backgroundColor = .clear
        tv.isScrollEnabled = false
        tv.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 44, right: 0)
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        tableView.backgroundColor = .clear
        setupUI()
        setupTableView()
        setupSearchBarDelegate()
        setupMKLocalSearchCompleterDelegate()
    }
    
    override func viewDidLayoutSubviews() { super.viewDidLayoutSubviews() }

    private func setupUI() {
        
        view.addSubview(topContainerView)
        topContainerView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right:  view.rightAnchor, topPad: 0,  leftPad: 0, bottomPad: 0, rightPad: 0, width: 0, height: 84)
        
        topContainerView.addSubview(tabView)
        tabView.centerXAnchor.constraint(equalTo: topContainerView.centerXAnchor).isActive = true
        tabView.anchor(top: topContainerView.topAnchor, left: nil, bottom: nil, right: nil, topPad: 10, leftPad: 0, bottomPad:  0, rightPad: 0 , width: view.frame.width / 4.5, height: 3.5)
        
        topContainerView.addSubview(searchBar)
        searchBar.anchor(top: tabView.bottomAnchor, left: nil, bottom: nil,  right: nil, topPad: 10, leftPad: 0, bottomPad: 0,  rightPad: 0, width: view.frame.width, height: view.frame.width / 8)

        view.addSubview(bottomContainerView)
        bottomContainerView.anchor(top: topContainerView.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right:  view.rightAnchor, topPad: 0, leftPad: 0, bottomPad: 0, rightPad: 0, width: 0, height: 0)

        bottomContainerView.addSubview(tableView)
        tableView.anchor(top: bottomContainerView.topAnchor, left: bottomContainerView.leftAnchor, bottom: bottomContainerView.bottomAnchor, right: bottomContainerView.rightAnchor, topPad: 0, leftPad: 0, bottomPad: 0, rightPad: 0, width: 0, height: 0)
        
        setupSearchBarTextColor()
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(LocationViewCell.self, forCellReuseIdentifier: cellId)
    }
    
    private func setupSearchBarDelegate() {
        searchBar.delegate = self
    }
    
    private func setupSearchBarTextColor() {
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension SearchResultsController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return completerResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let searchResult = completerResults[indexPath.row]
    
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! LocationViewCell
        cell.backgroundColor = .clear
        cell.locationTitleLabel.text = searchResult.title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedCell = tableView.cellForRow(at: indexPath) as! LocationViewCell
        let selectedLocation = selectedCell.locationTitleLabel.text
        delegate?.searchFor?(selectedLocation: selectedLocation)
    
        print("selected location: \(selectedLocation ?? "")")
        print("IndexPath: \(indexPath)")
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let emptyMessageView = EmptyMessageView()
        return emptyMessageView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return completerResults.count == 0 ? 350 : 0
    }
}

// MARK: - UIScrollViewDelegate

extension SearchResultsController: UIScrollViewDelegate {

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
    
        if targetContentOffset.pointee.y == 0 {
            tableView.bounces = false
            if let updateContainerFromTableViewDelegate = delegate?.updateContainerFromTableView?(withVelocity: velocity, scrollView: scrollView, targetContentOffset: targetContentOffset) {
                updateContainerFromTableViewDelegate
            }
        } else if targetContentOffset.pointee.y > 0 {
            tableView.bounces = true
            
            if let updateContainerFromTableViewDelegate = delegate?.updateContainerFromTableView?(withVelocity: velocity, scrollView: scrollView, targetContentOffset: targetContentOffset) {
                updateContainerFromTableViewDelegate
            }
        }
    }
}

// MARK: - UISearchBarDelegate

extension SearchResultsController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if !searchText.isEmpty {
            searchCompleter.queryFragment = searchText
        }
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        
        searchBarIsTapped = true
    
        if let searchBarTappedDelegate = delegate?.searchBarTapped?(isTapped: searchBarIsTapped) {
            searchBarTappedDelegate
        }
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let indexPath: IndexPath = IndexPath(row: 0, section: 0)
        tableView.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.top, animated: true)
        
        if let text = searchBar.text {
            if let executeDelegateSearch = delegate?.searchResult?(withSearchBar: text) {
                application.beginIgnoringInteractionEvents()
                executeDelegateSearch
            } else {
                print("Cannot be searched")
            }
        } else {
            print("No Text In Search Bar")
        }
    }
}

// MARK: - MKLocalSearchCompleterDelegate

// This will update the UITableViewCell's
extension SearchResultsController: MKLocalSearchCompleterDelegate {
    
    private func setupMKLocalSearchCompleterDelegate() {
        searchCompleter.delegate = self
    }
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        completerResults = completer.results
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        if let error = error as Error? {
            print("Search Results Encountered an Error: \(error.localizedDescription)")
        }
    }
}






