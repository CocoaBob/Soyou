//
//  StoreMapViewController.swift
//  Soyou
//
//  Created by CocoaBob on 30/01/16.
//  Copyright © 2016 Soyou. All rights reserved.
//

class StoreMapViewController: UIViewController {

    @IBOutlet var mapView: CustomMapView!
    @IBOutlet var btnLocate: UIButton!
    fileprivate var _locationManager = CLLocationManager()
    fileprivate var mapClusterController: CCHMapClusterController!
    fileprivate var mapClusterer: CCHMapClusterer!
    fileprivate var mapAnimator: CCHMapAnimator!
    fileprivate var searchResultAnnotation: MKPointAnnotation?
    fileprivate var calloutView: SMCalloutView!
    
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
        
        // Callout view
        self.calloutView = SMCalloutView.platform()
        self.mapView.calloutView = self.calloutView
        
        let leftButton = StoreMapAnnotationCalloutButton(frame: CGRect(x: 0, y: 0, width: 44, height: 128))
        leftButton.setImage(UIImage(named: "img_duplicate"), for: .normal)
        leftButton.tintColor = UIColor.white
        leftButton.backgroundColor = Cons.UI.colorStoreMapCopy
        leftButton.addTarget(self, action: #selector(StoreMapViewController.copyAddress(_:)), for: UIControlEvents.touchUpInside)
        self.calloutView.leftAccessoryView = leftButton
        
        let rightButton = StoreMapAnnotationCalloutButton(frame: CGRect(x: 0, y: 0, width: 44, height: 128))
        rightButton.setImage(UIImage(named: "img_road_sign"), for: .normal)
        rightButton.tintColor = UIColor.white
        rightButton.backgroundColor = Cons.UI.colorStoreMapOpen
        rightButton.addTarget(self, action: #selector(StoreMapViewController.openMap(_:)), for: UIControlEvents.touchUpInside)
        self.calloutView.rightAccessoryView = rightButton

        
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
            self.btnLocate.isHidden = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillAppear(animated)
        // For navigation bar search bar
        self.definesPresentationContext = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
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
    
    
    func mapClusterController(_ mapClusterController: CCHMapClusterController!, titleFor mapClusterAnnotation: CCHMapClusterAnnotation!) -> String! {
        let annotation = mapClusterAnnotation.annotations.first as? StoreMapAnnotation
        return annotation?.title ?? ""
    }
    
    func mapClusterController(_ mapClusterController: CCHMapClusterController!, subtitleFor mapClusterAnnotation: CCHMapClusterAnnotation!) -> String! {
        let annotation = mapClusterAnnotation.annotations.first as? StoreMapAnnotation
        return annotation?.subtitle ?? ""
    }
    
    func mapClusterController(_ mapClusterController: CCHMapClusterController!, willReuse mapClusterAnnotation: CCHMapClusterAnnotation!) {
        let clusterAnnotationView = self.mapView.view(for: mapClusterAnnotation) as? ClusterAnnotationView
        clusterAnnotationView?.count = mapClusterAnnotation.annotations.count
        clusterAnnotationView?.isUniqueLocation = mapClusterAnnotation.isUniqueLocation()
    }
}

// MARK: MKMapViewDelegate & Annotations
extension StoreMapViewController: MKMapViewDelegate {
    
    func addStoreAnnotations() {
        DispatchQueue.global(qos: .background).async {
            guard let brandID = self.brandID else { return }
            if let stores = Store.mr_findAll(with: FmtPredicate("brandId == %@", brandID)) as? [Store] {
                var annotations = [StoreMapAnnotation]()
                for store in stores {
                    let annotation = StoreMapAnnotation()
                    annotation.storeID = store.id
                    annotation.coordinate = CLLocationCoordinate2DMake(store.latitude!.doubleValue, store.longitude!.doubleValue)
                    annotation.title = store.title
                    let addressString = store.address != nil ? (store.address! + "\n") : ""
                    let zipcodeString = store.zipcode != nil ? (store.zipcode! + "\n") : ""
                    let storeString = store.phoneNumber != nil ? (store.phoneNumber!) : ""
                    annotation.subtitle = addressString + zipcodeString + storeString
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
    
    // MARK: MKMapViewDelegate
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var returnValue: MKAnnotationView?
        if annotation is CCHMapClusterAnnotation {
            if let clusterAnnotation = annotation as? CCHMapClusterAnnotation {
                var clusterAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "clusterAnnotation") as? ClusterAnnotationView
                if let annotationView = clusterAnnotationView {
                    annotationView.annotation = clusterAnnotation
                } else {
                    // Create new annotation view
                    clusterAnnotationView = ClusterAnnotationView(annotation: clusterAnnotation, reuseIdentifier: "clusterAnnotation")
                    clusterAnnotationView?.canShowCallout = false
                }
                
                clusterAnnotationView?.count = clusterAnnotation.annotations.count
                clusterAnnotationView?.isUniqueLocation = clusterAnnotation.isUniqueLocation()
                
                returnValue = clusterAnnotationView
            }
        } else if annotation is MKPointAnnotation {
            var pinAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "pinAnnotationView") as? MKPinAnnotationView
            if let annotationView = pinAnnotationView {
                annotationView.annotation = annotation
            } else {
                pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pinAnnotationView")
                pinAnnotationView?.animatesDrop = true
                pinAnnotationView?.canShowCallout = false
            }
            
            returnValue = pinAnnotationView
        }

        return returnValue
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if (view is ClusterAnnotationView || view is MKPinAnnotationView) {
            // Zoom in for cluster annotation
            if let annotation = view.annotation as? CCHMapClusterAnnotation {
                if (annotation.isUniqueLocation()) {
                    (self.calloutView.leftAccessoryView as? StoreMapAnnotationCalloutButton)?.annotation = annotation
                    (self.calloutView.rightAccessoryView as? StoreMapAnnotationCalloutButton)?.annotation = annotation
                } else {
                    var region = self.mapView.region
                    var span = region.span
                    span.latitudeDelta /= 2.0
                    span.longitudeDelta /= 2.0
                    region = MKCoordinateRegionMake(annotation.coordinate, span)
                    UIView.animate(withDuration: 0.3) {
                        self.mapView.setRegion(region, animated: true)
                    }
                    return
                }
            }
            
            // apply the MKAnnotationView's basic properties
            if let title = view.annotation?.title {
                self.calloutView.title = title
            }
            if let subtitle = view.annotation?.subtitle {
                self.calloutView.subtitle = subtitle
            }
            
            // Apply the MKAnnotationView's desired calloutOffset (from the top-middle of the view)
            self.calloutView.calloutOffset = view.calloutOffset
            
            // This does all the magic.
            self.calloutView.presentCallout(from: view.bounds, in: view, constrainedTo: self.mapView, animated: true)
        }
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        self.calloutView.dismissCallout(animated: true)
    }
}

// MARK: CLLocationManager
extension StoreMapViewController: CLLocationManagerDelegate {
    
    fileprivate func initLocationManager() {
        _locationManager.delegate = self
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coordinate = locations.first?.coordinate {
            self.mapView?.setCenter(coordinate, animated: true)
            manager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        DLog(error)
    }
    
    @IBAction func locateSelf() {
        let authorizationStatus = CLLocationManager.authorizationStatus()
        if authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways {
            _locationManager.startUpdatingLocation()
        } else {
            if authorizationStatus == .notDetermined {
                _locationManager.requestWhenInUseAuthorization()
            } else {
                let alertView = SCLAlertView(appearance: SCLAlertView.SCLAppearance(showCloseButton: false))
                alertView.addButton(NSLocalizedString("store_map_vc_go_to_settings")) { () -> Void in
                    if let url = URL(string: UIApplicationOpenSettingsURLString) {
                        UIApplication.shared.openURL(url)
                    }
                }
                alertView.showWarning(NSLocalizedString("store_map_vc_location_service_unavailable_title"),
                                      subTitle: NSLocalizedString("store_map_vc_location_service_unavailable_content"),
                                      closeButtonTitle: NSLocalizedString("alert_button_close"))
            }
        }
    }
}

// MARK: Routines
extension StoreMapViewController {
    
    func storeOfSelectedAnnotation(_ annotation: CCHMapClusterAnnotation) -> Store? {
        if let selectedAnnotation = annotation.annotations.first as? StoreMapAnnotation,
            let storeID = selectedAnnotation.storeID {
                return Store.mr_findFirst(byAttribute: "id", withValue: storeID)
        }
        return nil
    }
    
    @objc func copyAddress(_ sender: UIButton) {
        if let selectedAnnotations = (sender as? StoreMapAnnotationCalloutButton)?.annotation as? CCHMapClusterAnnotation,
            let store = self.storeOfSelectedAnnotation(selectedAnnotations) {
            let address = FmtString("%@\n%@\n%@\n%@\n%@",store.title ?? "", store.address ?? "", store.zipcode ?? "", store.city ?? "", store.country ?? "")
            let pasteboard = UIPasteboard.general
            pasteboard.string = address
            
            
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud.mode = MBProgressHUDMode.text
            hud.label.text = NSLocalizedString("store_map_vc_address_copied")
            hud.hide(animated: true, afterDelay: 1)
        }
        for annotation in self.mapView.selectedAnnotations {
            self.mapView.deselectAnnotation(annotation, animated: true)
        }
    }
    
    @objc func openMap(_ sender: UIButton) {
        if let selectedAnnotations = (sender as? StoreMapAnnotationCalloutButton)?.annotation as? CCHMapClusterAnnotation,
            let store = self.storeOfSelectedAnnotation(selectedAnnotations) {
            var addressDictionary = [String: String]()
            addressDictionary[CNPostalAddressStreetKey] = store.address ?? ""
            addressDictionary[CNPostalAddressCityKey] = store.city ?? ""
            addressDictionary[CNPostalAddressPostalCodeKey] = store.zipcode ?? ""
            addressDictionary[CNPostalAddressCountryKey] = store.country ?? ""
            let coordinate = CLLocationCoordinate2DMake(CLLocationDegrees(store.latitude?.doubleValue ?? 0), CLLocationDegrees(store.longitude?.doubleValue ?? 0))
            let placemark = MKPlacemark(
                coordinate: coordinate,
                addressDictionary: addressDictionary)
            let mapItem = MKMapItem(placemark: placemark)
            mapItem.name = store.title
            
            
            let launchOptions: [String : Any] = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving, MKLaunchOptionsMapTypeKey: MKMapType.standard.rawValue]
            mapItem.openInMaps(launchOptions: launchOptions)
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
    
    func addSearchResultAnnotation(_ mapItem: MKMapItem) {
        self.removeSearchResultAnnotation()
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = mapItem.placemark.coordinate
        annotation.title = mapItem.name
        annotation.subtitle = mapItem.placemark.addressString()
        self.mapView.addAnnotation(annotation)
        self.searchResultAnnotation = annotation
    }
    
    func setupRightBarButtonItem() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(StoreMapViewController.showSearchController))
    }
    
    @objc func showSearchController() {
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationItem.setRightBarButton(nil, animated: false)
        let searchBar = self.searchController!.searchBar
        if #available(iOS 11.0, *) {
            let searchBarContainer = SearchBarContainerView(searchBar: searchBar)
            searchBarContainer.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 44)
            self.navigationItem.titleView = searchBarContainer
        } else {
            self.navigationItem.titleView = searchBar
        }
        self.searchController!.searchBar.becomeFirstResponder()
    }
    
    func hideSearchController() {
        self.removeSearchResultAnnotation()
        self.setupRightBarButtonItem()
        self.navigationItem.titleView = nil
    }
    
    func setupSearchController() {
        let storeMapSearchResultsViewController = StoreMapSearchResultsViewController.instantiate()
        storeMapSearchResultsViewController.delegate = self
        self.searchController = UISearchController(searchResultsController: storeMapSearchResultsViewController)
        self.searchController!.delegate = self
        self.searchController!.searchResultsUpdater = storeMapSearchResultsViewController
        self.searchController!.searchBar.placeholder = NSLocalizedString("store_map_vc_search_bar_placeholder")
        self.searchController!.searchBar.showsCancelButton = false
        self.searchController!.hidesNavigationBarDuringPresentation = false
        
        self.setupRightBarButtonItem()
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        self.navigationItem.setHidesBackButton(false, animated: false)
        self.hideSearchController()
    }
}

// MARK: StoreMapSearchResultsViewControllerDelegate
extension StoreMapViewController: StoreMapSearchResultsViewControllerDelegate {
    
    func searchRegion() -> MKCoordinateRegion {
        return self.mapView.region
    }
    
    func didSelectSearchResult(_ mapItem: MKMapItem) {
        DLog(mapItem)
        if let region = mapItem.placemark.region as? CLCircularRegion {
            self.searchController?.isActive = false
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


// MARK: CustomMapView
class CustomMapView: MKMapView {
    
    var calloutView: SMCalloutView?
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if let convertedPoint = self.calloutView?.convert(point, from: self),
            let calloutMaybe = self.calloutView?.hitTest(convertedPoint, with: event) {
            return calloutMaybe
        }
        return super.hitTest(point, with: event)
    }
}

class StoreMapAnnotationCalloutButton: UIButton {
    
    var annotation: MKAnnotation?
}
