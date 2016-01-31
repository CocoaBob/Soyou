//
//  StoreMapViewController.swift
//  iPrices
//
//  Created by CocoaBob on 30/01/16.
//  Copyright © 2016 iPrices. All rights reserved.
//

class StoreMapViewController: UIViewController {

    @IBOutlet var mapView: MKMapView!
    private var _locationManager = CLLocationManager()
    private var mapClusterController: CCHMapClusterController!
    private var mapClusterer: CCHMapClusterer!
    private var mapAnimator: CCHMapAnimator!
    
    var brandID: NSNumber?
    var brandName: String?

    // Life cycle
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = brandName
        
        // Update user locations
        self.initLocationManager()
        
        // Setup Cluster Controller
        self.setupMapClusterController()
        
        // Add annotations
        self.addAnnotations()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
}

// MARK: CCHMapClusterController
extension StoreMapViewController: CCHMapClusterControllerDelegate {
    
    func setupMapClusterController() {
        self.mapClusterController = CCHMapClusterController(mapView: self.mapView)
        self.mapClusterController.delegate = self
        
//        self.mapClusterController.debuggingEnabled = true
        self.mapClusterController.cellSize = 32
//        self.mapClusterController.marginFactor = 0.5
        
        self.mapClusterer = CCHNearCenterMapClusterer()
        self.mapClusterController.clusterer = self.mapClusterer
//        self.mapClusterController.maxZoomLevelForClustering = DBL_MAX
//        self.mapClusterController.minUniqueLocationsForClustering = 0
        
        self.mapAnimator = CCHFadeInOutMapAnimator()
        self.mapClusterController.animator = self.mapAnimator
    }
    
    
    func mapClusterController(mapClusterController: CCHMapClusterController!, titleForMapClusterAnnotation mapClusterAnnotation: CCHMapClusterAnnotation!) -> String! {
        let annotationsCount = mapClusterAnnotation.annotations.count
        if annotationsCount > 1 {
            return FmtString(NSLocalizedString("brands_root_title_cluster_title"), annotationsCount)
        } else {
            let annotation = mapClusterAnnotation.annotations.first as? MKPointAnnotation
            return annotation?.title ?? ""
        }
    }
    
    func mapClusterController(mapClusterController: CCHMapClusterController!, subtitleForMapClusterAnnotation mapClusterAnnotation: CCHMapClusterAnnotation!) -> String! {
        let annotationsCount = min(mapClusterAnnotation.annotations.count, 5)
        if annotationsCount > 1 {
            return ""
        } else {
            let annotation = mapClusterAnnotation.annotations.first as? MKPointAnnotation
            return annotation?.subtitle ?? ""
        }
    }
    
    func mapClusterController(mapClusterController: CCHMapClusterController!, willReuseMapClusterAnnotation mapClusterAnnotation: CCHMapClusterAnnotation!) {
        let clusterAnnotationView = self.mapView.viewForAnnotation(mapClusterAnnotation) as? ClusterAnnotationView
        clusterAnnotationView?.count = mapClusterAnnotation.annotations.count
        clusterAnnotationView?.isUniqueLocation = mapClusterAnnotation.isUniqueLocation()
    }
}

// MARK: MKMapViewDelegate & Annotations
extension StoreMapViewController: MKMapViewDelegate {
    
    func addAnnotations() {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
            guard let brandID = self.brandID else { return }
            if let stores = Store.MR_findAllWithPredicate(FmtPredicate("brandId == %@", brandID)) as? [Store] {
                var annotations = [MKPointAnnotation]()
                for store in stores {
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = CLLocationCoordinate2DMake(store.latitude!.doubleValue, store.longitude!.doubleValue)
                    annotation.title = store.title ?? ""
                    annotation.subtitle = (store.address != nil ? (store.address! + "\n") : "") +
                        (store.zipcode != nil ? (store.zipcode! + "\n") : "") +
                        (store.phoneNumber != nil ? (store.phoneNumber!) : "")
                    annotations.append(annotation)
                }
                self.mapClusterController.addAnnotations(annotations, withCompletionHandler: nil)
            }
        }
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        var returnValue: MKAnnotationView?
        if annotation is CCHMapClusterAnnotation {
            var clusterAnnotationView = mapView.dequeueReusableAnnotationViewWithIdentifier("clusterAnnotation") as? ClusterAnnotationView
            if let annotationView = clusterAnnotationView {
                annotationView.annotation = annotation
            } else {
                clusterAnnotationView = ClusterAnnotationView(annotation: annotation, reuseIdentifier: "clusterAnnotation")
                clusterAnnotationView?.canShowCallout = true
            }
            
            let clusterAnnotation = annotation as! CCHMapClusterAnnotation
            clusterAnnotationView?.count = clusterAnnotation.annotations.count
            clusterAnnotationView?.isUniqueLocation = clusterAnnotation.isUniqueLocation()
            
            // RightCalloutAccessoryView
            let accessoryButton = UIButton(frame: CGRectMake(0,0,24,24))
            accessoryButton.setImage(UIImage(named: "img_cell_disclosure"), forState: .Normal)
            clusterAnnotationView?.rightCalloutAccessoryView = accessoryButton
            
            returnValue = clusterAnnotationView
        }
        return returnValue
    }
}

// MARK: CLLocationManager
extension StoreMapViewController: CLLocationManagerDelegate {
    
    private func initLocationManager() {
        _locationManager.delegate = self
        _locationManager.requestWhenInUseAuthorization()
        _locationManager.startUpdatingLocation()
        _locationManager.requestLocation()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coordinate = locations.first?.coordinate {
            self.mapView?.setRegion(MKCoordinateRegionMake(coordinate, MKCoordinateSpanMake(180, 360)), animated: false)
            manager.stopUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        DLog(error)
    }
}