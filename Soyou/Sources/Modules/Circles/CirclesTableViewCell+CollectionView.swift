//
//  CirclesTableViewCell+CollectionView.swift
//  Soyou
//
//  Created by CocoaBob on 2018-03-03.
//  Copyright © 2018 Soyou. All rights reserved.
//

// MARK: - CollectionView Delegate & DataSource
extension CirclesTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imgURLs?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CircleImageCollectionViewCell",
                                                      for: indexPath)
        if let cell = cell as? CircleImageCollectionViewCell {
            if let dict = self.imgURLs?[indexPath.row] {
                var imageURL: URL?
                if let thumbnailStr = dict["thumbnail"], let thumbnailURL = URL(string: thumbnailStr) {
                    imageURL = thumbnailURL
                }
                cell.imageView.sd_setImage(with: imageURL,
                                           placeholderImage: UIImage(named: "img_placeholder_1_1_s"),
                                           options: [.continueInBackground, .allowInvalidSSLCertificates, .highPriority],
                                           progress: { (receivedSize, expectedSize, targetURL) in
                                            DispatchQueue.main.async {
                                                if expectedSize > 0 {
                                                    var progress = CGFloat(receivedSize) / CGFloat(expectedSize)
                                                    progress = max(0, min(1, progress))
                                                    if progress != 1 {
                                                        cell.progressView?.setProgress(progress, animated: true)
                                                        cell.progressView?.isHidden = false
                                                    } else  if progress == 1 {
                                                        cell.progressView?.setProgress(progress, animated: false)
                                                        cell.progressView?.isHidden = true
                                                    }
                                                }
                                            }
                },
                                           completed: { (image, error, type, url) -> Void in
                                            if let error = error {
                                                DLog(error.localizedDescription)
                                                DLog(url)
                                            } else {
                                                // Update the image with an animation
                                                if (collectionView.indexPathsForVisibleItems.contains(indexPath)), let image = image {
                                                    UIView.transition(with: cell.imageView,
                                                                      duration: 0.3,
                                                                      options: UIViewAnimationOptions.transitionCrossDissolve,
                                                                      animations: { cell.imageView.image = image },
                                                                      completion: nil)
                                                }
                                            }
                })
            } else {
                cell.imageView.image = UIImage(named: "img_placeholder_1_1_s")
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let imageView = (collectionView.cellForItem(at: indexPath) as? CircleImageCollectionViewCell)?.imageView else {
            return
        }
        self.browseImages(imageView, UInt(indexPath.row))
    }
}

// MARK: - CollectionView Waterfall Layout
extension CirclesTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func setupCollectionView() {
        // Create a flow layout
        let layout = UICollectionViewLeftAlignedLayout()
        
        // Change individual layout attributes for the spacing between cells
        layout.minimumLineSpacing = 4
        layout.minimumInteritemSpacing = 4
        layout.sectionInset = UIEdgeInsets.zero
        
        // Add the waterfall layout to your collection view
        self.imagesCollectionView.collectionViewLayout = layout
        
        // Load data
        self.imagesCollectionView.reloadData()
    }
    
    //** Size for the cells in the Waterfall Layout */
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let vc = self.parentViewController, let constraint = self.imagesCollectionViewWidth else {
            return CGSize.zero
        }
        
        let columns = CGFloat((imgURLs?.count == 1 ? 1 : (imgURLs?.count == 4 ? 2 : 3)))
        let collectionViewWidth = (vc.view.bounds.width - 74 * 2) * constraint.multiplier
        let size = floor((floor(collectionViewWidth) - (4 * (columns - 1))) / columns)
        return CGSize(width: size, height: size)
    }
}
