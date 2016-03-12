//
//  StoreMapViewController.swift
//  Soyou
//
//  Created by CocoaBob on 30/01/16.
//  Copyright © 2016 Soyou. All rights reserved.
//

class StoreMapViewController: UIViewController {

    @IBOutlet var mapView: MKMapView!
    @IBOutlet var btnLocate: UIButton!
    private var _locationManager = CLLocationManager()
    private var mapClusterController: CCHMapClusterController!
    private var mapClusterer: CCHMapClusterer!
    private var mapAnimator: CCHMapAnimator!
    private var searchResultAnnotation: MKPointAnnotation?
    
    let leftAccessoryButton = CalloutButton(frame: CGRectMake(0,0,32,100))
    let rightAccessoryButton = CalloutButton(frame: CGRectMake(0,0,32,100))
    
    var isFullMap: Bool = false
    var brandID: NSNumber?
    var brandName: String?
    
    var searchController: UISearchController?
    
    // Life cycle
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Bars
        self.hidesBottomBarWhenPushed = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = brandName
        
        // Callout buttons
        self.leftAccessoryButton.setImage(UIImage(named: "img_duplicate"), forState: .Normal)
        self.leftAccessoryButton.backgroundColor = UIColor(rgba: Cons.UI.colorStoreMapCopy)
        self.leftAccessoryButton.addTarget(self, action: "copyAddress:", forControlEvents: UIControlEvents.TouchUpInside)
        self.rightAccessoryButton.setImage(UIImage(named: "img_road_sign"), forState: .Normal)
        self.rightAccessoryButton.backgroundColor = UIColor(rgba: Cons.UI.colorStoreMapOpen)
        self.rightAccessoryButton.addTarget(self, action: "openMap:", forControlEvents: UIControlEvents.TouchUpInside)
        
        // Update user locations
        self.initLocationManager()
        
        // Setup Cluster Controller
        self.setupMapClusterController()
        
        // Add annotations
        self.addStoreAnnotations()
        
        // Setup Search Controller
        if self.isFullMap {
            self.setupSearchController()
        } else {
            self.btnLocate.hidden = true
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillAppear(animated)
        // For navigation bar search bar
        self.definesPresentationContext = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        // For navigation bar search bar
        self.definesPresentationContext = false
    }
}

// MARK: CCHMapClusterController
extension StoreMapViewController: CCHMapClusterControllerDelegate {
    
    func setupMapClusterController() {
        self.mapClusterController = CCHMapClusterController(mapView: self.mapView)
        self.mapClusterController.delegate = self
        
//        self.mapClusterController.debuggingEnabled = true
        self.mapClusterController.cellSize = 80
//        self.mapClusterController.marginFactor = 0.5
        
        self.mapClusterer = CCHCenterOfMassMapClusterer()
        self.mapClusterController.clusterer = self.mapClusterer
//        self.mapClusterController.maxZoomLevelForClustering = DBL_MAX
//        self.mapClusterController.minUniqueLocationsForClustering = 0
        
        self.mapAnimator = CCHFadeInOutMapAnimator()
        self.mapClusterController.animator = self.mapAnimator
    }
    
    
    func mapClusterController(mapClusterController: CCHMapClusterController!, titleForMapClusterAnnotation mapClusterAnnotation: CCHMapClusterAnnotation!) -> String! {
        let annotation = mapClusterAnnotation.annotations.first as? StoreMapAnnotation
        return annotation?.title ?? ""
    }
    
    func mapClusterController(mapClusterController: CCHMapClusterController!, subtitleForMapClusterAnnotation mapClusterAnnotation: CCHMapClusterAnnotation!) -> String! {
        let annotation = mapClusterAnnotation.annotations.first as? StoreMapAnnotation
        return annotation?.subtitle ?? ""
    }
    
    func mapClusterController(mapClusterController: CCHMapClusterController!, willReuseMapClusterAnnotation mapClusterAnnotation: CCHMapClusterAnnotation!) {
        let clusterAnnotationView = self.mapView.viewForAnnotation(mapClusterAnnotation) as? ClusterAnnotationView
        clusterAnnotationView?.count = mapClusterAnnotation.annotations.count
        clusterAnnotationView?.isUniqueLocation = mapClusterAnnotation.isUniqueLocation()
    }
}

// MARK: MKMapViewDelegate & Annotations
extension StoreMapViewController: MKMapViewDelegate {
    
    func addStoreAnnotations() {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
            guard let brandID = self.brandID else { return }
            if let stores = Store.MR_findAllWithPredicate(FmtPredicate("brandId == %@", brandID)) as? [Store] {
                var annotations = [StoreMapAnnotation]()
                for store in stores {
                    let annotation = StoreMapAnnotation()
                    annotation.storeID = store.id
                    annotation.coordinate = CLLocationCoordinate2DMake(store.latitude!.doubleValue, store.longitude!.doubleValue)
                    annotation.title = store.title
                    annotation.subtitle = (store.address != nil ? (store.address! + "\n") : "") +
                        (store.zipcode != nil ? (store.zipcode! + "\n") : "") +
                        (store.phoneNumber != nil ? (store.phoneNumber!) : "")
                    if annotation.title == nil {
                        annotation.title = annotation.subtitle
                        annotation.subtitle = nil
                    }
                    annotations.append(annotation)
                }
                self.mapClusterController.addAnnotations(annotations, withCompletionHandler: nil)
            }
        }
    }
    
    func tapAnnotation(tapGR: UITapGestureRecognizer) {
        if let clusterAnnotationView = tapGR.view as? ClusterAnnotationView,
            annotation = clusterAnnotationView.annotation,
            isUniqueLocation = clusterAnnotationView.isUniqueLocation {
                if !isUniqueLocation {
                    var region = self.mapView.region
                    var span = region.span
                    span.latitudeDelta /= 2.0
                    span.longitudeDelta /= 2.0
                    region = MKCoordinateRegionMake(annotation.coordinate, span)
                    self.mapView.setRegion(region, animated: true)
                }
        }
    }
    
    // MARK: MKMapViewDelegate
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        var returnValue: MKAnnotationView?
        if annotation is CCHMapClusterAnnotation {
            let clusterAnnotation = annotation as! CCHMapClusterAnnotation
            var clusterAnnotationView = mapView.dequeueReusableAnnotationViewWithIdentifier("clusterAnnotation") as? ClusterAnnotationView
            if let annotationView = clusterAnnotationView {
                annotationView.annotation = clusterAnnotation
            } else {
                // Create new annotation view
                clusterAnnotationView = ClusterAnnotationView(annotation: clusterAnnotation, reuseIdentifier: "clusterAnnotation")
                let tapGR = UITapGestureRecognizer(target: self, action: "tapAnnotation:")
                clusterAnnotationView?.addGestureRecognizer(tapGR)
                
                // Callout left accessory button
                clusterAnnotationView?.leftCalloutAccessoryView = leftAccessoryButton
                
                // Callout right accessory button
                clusterAnnotationView?.rightCalloutAccessoryView = rightAccessoryButton
                
                clusterAnnotationView?.canShowCallout = true
            }
            
            clusterAnnotationView?.count = clusterAnnotation.annotations.count
            clusterAnnotationView?.isUniqueLocation = clusterAnnotation.isUniqueLocation()
            
            returnValue = clusterAnnotationView
        } else if annotation is MKPointAnnotation {
            var pinAnnotationView = mapView.dequeueReusableAnnotationViewWithIdentifier("pinAnnotationView") as? MKPinAnnotationView
            if let annotationView = pinAnnotationView {
                annotationView.annotation = annotation
            } else {
                pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pinAnnotationView")
                pinAnnotationView?.animatesDrop = true
                pinAnnotationView?.canShowCallout = true
            }
            
            returnValue = pinAnnotationView
        }

        return returnValue
    }
}

// MARK: CLLocationManager
extension StoreMapViewController: CLLocationManagerDelegate {
    
    private func initLocationManager() {
        _locationManager.delegate = self
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coordinate = locations.first?.coordinate {
            self.mapView?.setCenterCoordinate(coordinate, animated: true)
            manager.stopUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        DLog(error)
    }
    
    @IBAction func locateSelf() {
        if CLLocationManager.authorizationStatus() != .AuthorizedWhenInUse {
            _locationManager.requestWhenInUseAuthorization()
        } else {
            _locationManager.startUpdatingLocation()
        }
    }
}

// MARK: Routines
extension StoreMapViewController {
    
    func storeOfSelectedAnnotations(annotations: [StoreMapAnnotation]) -> Store? {
        if let clusterAnnotation = self.mapView.selectedAnnotations.first as? CCHMapClusterAnnotation,
            selectedAnnotation = clusterAnnotation.annotations.first as? StoreMapAnnotation,
            storeID = selectedAnnotation.storeID {
                return Store.MR_findFirstByAttribute("id", withValue: storeID)
        }
        return nil
    }
    
    func copyAddress(sender: UIButton) {
        if let store = self.storeOfSelectedAnnotations(self.mapView.selectedAnnotations as! [StoreMapAnnotation]) {
            let address = FmtString("%@\n%@\n%@\n%@\n%@",store.title ?? "", store.address ?? "", store.zipcode ?? "", store.city ?? "", store.country ?? "")
            let pasteboard = UIPasteboard.generalPasteboard()
            pasteboard.persistent = true
            pasteboard.string = address
            
            
            let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            hud.mode = MBProgressHUDMode.Text
            hud.labelText = NSLocalizedString("store_map_vc_address_copied")
            hud.hide(true, afterDelay: 1)
        }
        for annotation in self.mapView.selectedAnnotations {
            self.mapView.deselectAnnotation(annotation, animated: true)
        }
    }
    
    func openMap(sender: UIButton) {
        if let store = self.storeOfSelectedAnnotations(self.mapView.selectedAnnotations as! [StoreMapAnnotation]) {
            var addressDictionary = [String: String]()
            if #available(iOS 9.0, *) {
                addressDictionary[CNPostalAddressStreetKey] = store.address ?? ""
                addressDictionary[CNPostalAddressCityKey] = store.city ?? ""
                addressDictionary[CNPostalAddressPostalCodeKey] = store.zipcode ?? ""
                addressDictionary[CNPostalAddressCountryKey] = store.country ?? ""
            } else {
                addressDictionary[kABPersonAddressStreetKey as String] = store.address ?? ""
                addressDictionary[kABPersonAddressCityKey as String] = store.city ?? ""
                addressDictionary[kABPersonAddressZIPKey as String] = store.zipcode ?? ""
                addressDictionary[kABPersonAddressCountryKey as String] = store.country ?? ""
            }
            let coordinate = CLLocationCoordinate2DMake(CLLocationDegrees(store.latitude?.doubleValue ?? 0), CLLocationDegrees(store.longitude?.doubleValue ?? 0))
            let placemark = MKPlacemark(
                coordinate: coordinate,
                addressDictionary: addressDictionary)
            let mapItem = MKMapItem(placemark: placemark)
            mapItem.name = store.title
            
            
            let launchOptions: [String : AnyObject] = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving, MKLaunchOptionsMapTypeKey: MKMapType.Standard.rawValue]
            mapItem.openInMapsWithLaunchOptions(launchOptions)
        }
        for annotation in self.mapView.selectedAnnotations {
            self.mapView.deselectAnnotation(annotation, animated: true)
        }
    }
}

// MARK: - SearchControler
extension StoreMapViewController: UISearchControllerDelegate {
    
    func removeSearchResultAnnotation() {
        if let searchResultAnnotation = self.searchResultAnnotation {
            self.mapView.removeAnnotation(searchResultAnnotation)
        }
    }
    
    func addSearchResultAnnotation(mapItem: MKMapItem) {
        self.removeSearchResultAnnotation()
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = mapItem.placemark.coordinate
        annotation.title = mapItem.name
        annotation.subtitle = mapItem.placemark.addressString()
        self.mapView.addAnnotation(annotation)
        self.searchResultAnnotation = annotation
    }
    
    func setupRightBarButtonItem() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Search, target: self, action: "showSearchController")
    }
    
    func showSearchController() {
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationItem.setRightBarButtonItem(nil, animated: false)
        self.navigationItem.titleView = self.searchController!.searchBar
        self.searchController!.searchBar.becomeFirstResponder()
    }
    
    func hideSearchController() {
        self.removeSearchResultAnnotation()
        self.setupRightBarButtonItem()
        self.navigationItem.titleView = nil
    }
    
    func setupSearchController() {
        self.setupRightBarButtonItem()
        
        let storeMapSearchResultsViewController = StoreMapSearchResultsViewController.instantiate()
        storeMapSearchResultsViewController.delegate = self
        self.searchController = UISearchController(searchResultsController: storeMapSearchResultsViewController)
        self.searchController!.delegate = self
        self.searchController!.searchResultsUpdater = storeMapSearchResultsViewController
        self.searchController!.searchBar.placeholder = NSLocalizedString("store_map_vc_search_bar_placeholder")
        self.searchController!.hidesNavigationBarDuringPresentation = false
    }
    
    func willDismissSearchController(searchController: UISearchController) {
        self.navigationItem.setHidesBackButton(false, animated: false)
        self.hideSearchController()
    }
}

// MARK: StoreMapSearchResultsViewControllerDelegate
extension StoreMapViewController: StoreMapSearchResultsViewControllerDelegate {
    
    
    func searchRegion() -> MKCoordinateRegion {
        return self.mapView.region
    }
    
    func didSelectSearchResult(mapItem: MKMapItem) {
        DLog(mapItem)
        if let region = mapItem.placemark.region as? CLCircularRegion {
            self.searchController?.active = false
            let mapRegion = MKCoordinateRegionMakeWithDistance(region.center, region.radius, region.radius)
            self.mapView.setRegion(self.mapView.regionThatFits(mapRegion), animated: true)
            self.addSearchResultAnnotation(mapItem)
        }
    }
}

// MARK: Custom Annotation
class StoreMapAnnotation: MKPointAnnotation {
    
    var storeID: NSNumber?
}

// Workaround to fit the accessory views as we don't know the exact height of the callout views.
class CalloutButton: UIButton {
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        var frame = self.frame
        frame.origin.y = -(frame.size.height - 52) / 2.0 // 52 is the default height of callout view in iOS 9
        self.frame = frame
    }
}
