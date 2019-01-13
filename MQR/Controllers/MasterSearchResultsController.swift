//
//  MapResultsController.swift
//  MQR
//
//  Created by Nuri Chun on 9/30/18.
//  Copyright © 2018 tetra. All rights reserved.
//

import MapKit
import UIKit

// Refeactor this soon.
// midY = 733.7
// topY = 366.85
// botY doesnt matter.

enum ContainerPosition {
    case bottom
    case middle
    case top
}

protocol MasterSearchResultsDelegate {
    
    func updateMapResults(frame: CGRect)
    func updateContainersCenter(cgPoint: CGPoint)
    func updateMapView(withAlpha alpha: CGFloat)
    func searchResult(withSearchBar text: String?)
    func searchFor(selectedRow location: String?)
}

/*
 NOTE: I will try to refactor a lot of this code a bit later. I know some of the code structures are unecessary in this controller.
 NEED TO CHANGE: I will setup an Enum for cleaner and more readable code for SHEET STATES.
 NEED TO CHANGE: Change some if to ternary operators as well.
 NEED TO CHANGE: Create extra extension classes for such as Animations, Color, etc.
 */

class MasterSearchResultsController: UIViewController {
    
    let cellId = "cellId"
    let searchResultsController = SearchResultsController()
    let mapController = MapController()
    var tableView = UITableView()
    var recognizer = UIPanGestureRecognizer()
    var translation: CGPoint?
    
    var isScrolling: Bool = false
    
    var delegate: MasterSearchResultsDelegate?
    
    var initialFrame = UIScreen.main.bounds
    
// -------------- THE STATE OF SHEET(containerView) IN MAPCONTROLLER--------------

    var stateTop: Bool = false
    var stateMid: Bool = false
    var stateBot: Bool = false
    
// -------------- TO CREATE AN INSTANCE TO SET FROM MAPCONTROLLER --------------
    
    var topY: CGFloat = 0
    var midY: CGFloat = 0
    var botY: CGFloat = 0
    var topYBorder2: CGFloat = 0
    
    var topYBorder: CGFloat = 633.7
    var botYBorder: CGFloat = 833.7

// -------------- PROPERTIES FOR SHEET TRANSITION FROM BOT,MID, OR TOP TO variable Y --------------
    var maxVelocityToBot: CGFloat = 3000
    var maxVelocityToTop: CGFloat = 3000
    
    var maxVelocityToBotFromMid: CGFloat = 1000
    var minVelocityToTopFromMid: CGFloat = -1000
    
    var minVelocityToMidDownY: CGFloat = 100
    var minVelocityToMidUpY: CGFloat = -100
    
// -------------- CHECKS IF THE TABLEVIEW HAS SCROLLED DOWN OR UP A CERTAIN OFFSET POINT Y --------------
    
    var targetContentOffset: UnsafeMutablePointer<CGPoint>?
    
    var isTapped: Bool = false
    
// -------------- CALCULATES THE ALPHA WHEN TRANSITIONING FROM MID SHEET TO TOP SHEET --------------
    let alphaMax: CGFloat = 550.275
    var alpha: CGFloat = 0.0
    
// -------------- GLOBAL VARIABLE FOR UIVIEW.ANIMATION PROPERTIES --------------
    let duration: TimeInterval = 0.3
    let delay: TimeInterval = 0
    let springWithDamping: CGFloat = 0.6
    let initialSpringVelocity: CGFloat = 0.5
    let options: UIView.AnimationOptions = .curveEaseOut

// -------------- CALCULATES THE ALPHA WHEN TRANSITIONING FROM MID SHEET TO TOP SHEET --------------
    var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    private func setupBackgroundColor() {
        view.backgroundColor = .clear
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTapped()
        setupHeightConstraints()
        setupSearchResultsControllerDelegate()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        if self.isTapped == false {

            UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: springWithDamping, initialSpringVelocity: initialSpringVelocity, options: options, animations: {
                self.delegate?.updateContainersCenter(cgPoint: CGPoint(x: self.view.center.x, y: self.midY))
                self.delegate?.updateMapView(withAlpha: 1.00)
            }, completion: nil)
        }
    }
    
    private func setupUI() {
        setupBackgroundColor()
        setupView()
        setupUIPanGestureRecognizer()
        setupTableViewInstance()
        addChildController()
    }
    
    private func addChildController() {
        searchResultsController.view.frame = containerView.frame
        add(searchResultsController, containerView: containerView)
        view.layoutIfNeeded()
    }
    
    private func setupView() {
        
        let lightBlurEffect = UIBlurEffect(style: .light)
        let visualEffectView = UIVisualEffectView(effect: lightBlurEffect)
        
        view.addSubview(visualEffectView)
        visualEffectView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topPad: 0, leftPad: 0, bottomPad: 0, rightPad: 0, width: 0, height: 0)
        
        view.addSubview(containerView)
        containerView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topPad: 0, leftPad: 0, bottomPad: 0, rightPad: 0, width: 0, height: 0)
    }
    
    private func setupTableViewInstance() {
        let tableView = searchResultsController.tableView
        self.tableView = tableView
    }
    
    private func setupSearchResultsControllerDelegate() {
        searchResultsController.delegate = self
    }
}

// MARK: - UIPanGestureRecognizer Calculations

extension MasterSearchResultsController {
    
    private func setupHeightConstraints() {
        
        let top = mapController.view.bounds.height * 0.55
        let mid = mapController.view.bounds.height * 1.1
        let bot = mapController.view.bounds.height * 1.39
        
        let topYBorderr = mid - 150
        let topYBorderr2 = mid - 300
        let botYBorderr = mid + 100
        
        topY = top
        midY = mid
        botY  = bot
        topYBorder = topYBorderr
        botYBorder = botYBorderr
        topYBorder2 = topYBorderr2
    }
    
    private func setupUIPanGestureRecognizer() {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        pan.delegate = self
        view.addGestureRecognizer(pan)
        view.isUserInteractionEnabled = true
    }
    
    @objc func handlePan(_ recognizer: UIPanGestureRecognizer) {
    
        self.recognizer = recognizer
        guard let view = recognizer.view else { return }
        
        let translation = recognizer.translation(in: view)
        self.translation = translation
        let velocity = recognizer.velocity(in: view)
        let velocityOfY = velocity.y
        let viewCenterY = view.center.y

        switch recognizer.state {
        case .began, .changed:
            
            changeMapView(withAlpha: alpha , withViewCenterY: viewCenterY)
            
            if viewCenterY >= topY {
                executeTranslation(withView: view, withRecognizer: recognizer, usingTranslation: translation)
            } else { break }
            
            if viewCenterY > topY { dismissKeyboard() }
            
        case .ended:
            searchContainerCalculations(viewCenterY: viewCenterY, forView: view, velocityOfY: velocityOfY)
            break
            
        default:
            break
        }
    }
    
    private func changeMapView(withAlpha: CGFloat, withViewCenterY viewCenterY: CGFloat) {
        alpha = viewCenterY / alphaMax
        delegate?.updateMapView(withAlpha: alpha)
    }
    
    private func executeTranslation(withView view: UIView, withRecognizer recognizer: UIPanGestureRecognizer, usingTranslation translation: CGPoint) {
        isScrolling = true
        tableView.isUserInteractionEnabled = false
        view.center = CGPoint(x: view.center.x, y: view.center.y + translation.y)
        recognizer.setTranslation(CGPoint.zero, in: view)
        return
    }
    
    private func searchContainerCalculations(viewCenterY: CGFloat, forView view: UIView, velocityOfY: CGFloat) {
        
        if viewCenterY <= topYBorder {
            
            animate(forView: view, stateTop: true , stateMid: false, stateBot: false)
            calculateVelocityFromTopToY(forView: view, velocityOfY: velocityOfY)
            return
            
        } else if viewCenterY > topYBorder && viewCenterY < botYBorder {
            
            animate(forView: view, stateTop: false, stateMid: true, stateBot: false)
            calculateVelocityFromMidToY(forView: view, velocityOfY: velocityOfY)
            return
            
        } else if viewCenterY > botYBorder {
            
            animate(forView: view, stateTop: false, stateMid: false, stateBot: true)
            calculateVelocityFromBotToY(forView: view, velocityOfY: velocityOfY)
            return
        }
    }
    
    // TOP SEARCH CONTAINER
    private func calculateVelocityFromTopToY(forView view: UIView, velocityOfY: CGFloat)  {
        
        if velocityOfY > minVelocityToMidDownY && velocityOfY < maxVelocityToBot {
            animate(forView: view, stateTop: false, stateMid: true, stateBot: false)
            
        } else if velocityOfY > maxVelocityToBot {
            animate(forView: view, stateTop: false, stateMid: false, stateBot: true)
        }
    }
    
    // MID SEARCH CONTAINER
    private func calculateVelocityFromMidToY(forView view: UIView, velocityOfY: CGFloat) {
        
        if velocityOfY < minVelocityToTopFromMid {
            animate(forView: view, stateTop: true, stateMid: false, stateBot: false)
            
        } else if velocityOfY > maxVelocityToBotFromMid {
            animate(forView: view, stateTop: false, stateMid: false, stateBot: true)
        }
    }
    
    // BOT SEARCH CONTAINER
    private func calculateVelocityFromBotToY(forView view: UIView, velocityOfY: CGFloat) {
        
        if velocityOfY < -maxVelocityToTop {
            animate(forView: view, stateTop: true, stateMid: false, stateBot: false)
            
        } else if velocityOfY > -maxVelocityToTop  && velocityOfY < minVelocityToMidUpY {
            animate(forView: view, stateTop: false, stateMid: true, stateBot: false)
        }
    }
    
    private func animate(forView view: UIView, stateTop: Bool, stateMid: Bool, stateBot: Bool) {
        
        if stateTop == true && stateMid == false && stateBot == false {
            
            tableView.isUserInteractionEnabled = true
            isScrolling = false
            tableView.isScrollEnabled = true
            tableView.bounces = true
            
            UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: springWithDamping, initialSpringVelocity: initialSpringVelocity, options: options, animations: {
                
                self.delegate?.updateContainersCenter(cgPoint: CGPoint(x: view.center.x, y: self.topY))
                self.delegate?.updateMapView(withAlpha: 0.75)
            }, completion: nil)
            
        } else if stateTop == false && stateMid == true && stateBot == false {
            
            tableView.isUserInteractionEnabled = false
            UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: springWithDamping, initialSpringVelocity: initialSpringVelocity, options: options, animations: {
                
                self.delegate?.updateContainersCenter(cgPoint: CGPoint(x: view.center.x, y: self.midY))
                self.delegate?.updateMapView(withAlpha: 1.0)
            }, completion: nil)
            
        } else if stateTop == false && stateMid == false && stateBot == true {
            
            tableView.isUserInteractionEnabled = false
            UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: springWithDamping, initialSpringVelocity: initialSpringVelocity, options: options, animations: {
                
                self.delegate?.updateContainersCenter(cgPoint: CGPoint(x: view.center.x, y: self.botY))
                self.delegate?.updateMapView(withAlpha: 1.0)
            }, completion: nil)
        }
    }
}

// MARK: - UIGestureRecognizerDelegate Methods

extension MasterSearchResultsController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        let view = recognizer.view
    
        if isScrolling == true && view?.center.y == topY {
            tableView.isScrollEnabled = true
            return true
        }
        return false
    }
}

// MARK: - SearchResultsControllerDelegate Protocol

extension MasterSearchResultsController: SearchResultsControllerDelegate {
    
    func updateContainerFromTableView(withVelocity velocity: CGPoint, scrollView: UIScrollView, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        guard let view = recognizer.view else { return }
        
        if targetContentOffset.pointee.y <= 0.0 && view.center.y == topY {
            self.targetContentOffset = targetContentOffset
            recognizer.isEnabled = true
            tableView.bounces = false
            isScrolling = true
        } else if targetContentOffset.pointee.y > 0.0 {
            recognizer.isEnabled = true
            dismissKeyboard()
            isScrolling = false
        }
    }
    
    func searchBarTapped(isTapped: Bool) {
        
        self.isTapped = isTapped
        
        // Needed if first tapped on searchBar the view goes up.
        UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: springWithDamping, initialSpringVelocity: initialSpringVelocity, options: options, animations: {
            // topY | mapController.view.bounds.height * 0.55
            self.delegate?.updateContainersCenter(cgPoint: CGPoint(x: self.view.center.x, y: self.topY))
            self.delegate?.updateMapView(withAlpha: 0.75)
        }, completion: nil)
        
        recognizer.isEnabled = true
        tableView.isUserInteractionEnabled = true
        
        guard let view = recognizer.view else { return }
        guard let viewCenterY = recognizer.view?.center.y else { return }
        
        if self.isTapped {
            if viewCenterY > topY || viewCenterY == midY
            {
                animate(forView: view, stateTop: true , stateMid: false, stateBot: false)
                self.delegate?.updateMapView(withAlpha: 0.75)
            }
        } else { return }
    }
    
    func searchResult(withSearchBar text: String?) {

        if text != nil {
            delegate?.searchResult(withSearchBar: text ?? "")
            animate(forView: self.containerView, stateTop: false, stateMid: true, stateBot: false)
            recognizer.isEnabled = true
            dismissKeyboard()
        }
    }
    
    func searchFor(selectedLocation location: String?) {
        
        if let location = location {
            delegate?.searchFor(selectedRow: location)
            animate(forView: self.containerView, stateTop: false, stateMid: false, stateBot: true)
            recognizer.isEnabled = true
            dismissKeyboard()
        }
    }
}
