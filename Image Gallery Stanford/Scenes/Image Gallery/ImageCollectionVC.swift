//
//  ImageGalleryVC.swift
//  Image Gallery Stanford
//
//  Created by aleksandre on 18.07.22.
//

import UIKit

public class ImageGalleryCollectionViewController: UICollectionViewController
{
    
//    private var dataSource = DataStore.sharedDataStore
    var document: ImageGalleryDocument?
    var imageGallery: ImageGallery?
    
    private var cellWidthScale: CGFloat = 150
    
    private var lastDraggedCellIndexPath: IndexPath?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        initGestureRecognizers()
        collectionView.dragDelegate = self
        collectionView.dropDelegate = self
        // Add a dropZone
        self.navigationController?.navigationBar.addInteraction(UIDropInteraction(delegate: self))
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        document?.open() { success in
            if success {
                print("document opened successfully")
                self.title = self.document?.localizedName
                if self.document?.imageGallery != nil {
                    self.imageGallery = self.document?.imageGallery
                } else {
                    
                }
            }
        }
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        document?.imageGallery = imageGallery
        document?.updateChangeCount(.done)
    }
    
    private func initGestureRecognizers() {
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(resizeCell))
        collectionView.addGestureRecognizer(pinchGesture)
    }
    
    @objc
    private func resizeCell(sender: UIPinchGestureRecognizer) {
        let minimumScale: CGFloat = 0.5
        let maximumScale: CGFloat = 2
        
        if sender.state == UIGestureRecognizer.State.changed ||
        sender.state == UIGestureRecognizer.State.ended {
            if sender.scale > minimumScale && sender.scale < maximumScale {
                cellWidthScale *= sender.scale
                flowLayout.invalidateLayout()
            }
        }
    }
    
    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? UICollectionViewCell {
            if let chosenRow = collectionView.indexPath(for: cell)?.row {
                if segue.identifier == "showDetails" {
                    let targetVC = segue.destination as! ImageDetailsViewController
                    targetVC.imageData = imageGallery?.galleryImages?[chosenRow]
                }
            }
        }
    }
    
}

// MARK: -- CollectionView delegate methods
extension ImageGalleryCollectionViewController: UICollectionViewDelegateFlowLayout
{
    var flowLayout: UICollectionViewFlowLayout {
        return collectionView.collectionViewLayout as! UICollectionViewFlowLayout
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidthScale, height: (cellWidthScale * (imageGallery?.galleryImages?[indexPath.row].aspectRatio ?? 150)))
    }
    
    public override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionCell", for: indexPath)
        if let imageCell = cell as? ImageCollectionCell {
            if let imageUrl = imageGallery?.galleryImages?[indexPath.item].url {
                imageCell.imageURL = imageUrl
                imageCell.galleryImageView.fetchImage(with: imageUrl) { fetchingStarted in
                    if fetchingStarted {
                        imageCell.loadingSpinner.startAnimating()
                    }
                } completion: { fetchingFinished in
                    imageCell.loadingSpinner.stopAnimating()
                }
            }
        }
        return cell
    }
    
    public override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageGallery?.galleryImages?.count ?? 0
    }
}

//MARK: - Drag and Drop Delegate Methods
extension ImageGalleryCollectionViewController: UICollectionViewDragDelegate, UICollectionViewDropDelegate
{
    /// Get a drag object
    private func dragItems(at indexPath: IndexPath) -> [UIDragItem] {
        if let image = (collectionView.cellForItem(at: indexPath) as? ImageCollectionCell)?.galleryImageView.image {
            let dragItem = UIDragItem(itemProvider: NSItemProvider(object: image))
            dragItem.localObject = image
            return [dragItem]
        } else {
            return []
        }
    }
    
    /// Begin dragging
    public func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        session.localContext = view
        return dragItems(at: indexPath)
    }
    
    /// Detect if Collection View can handle a drop of the appropriate object types
    public func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        if session.localDragSession != nil {
            return session.canLoadObjects(ofClass: UIImage.self)
        }
        return (session.canLoadObjects(ofClass: URL.self) && session.canLoadObjects(ofClass: UIImage.self))
    }
    
    /// Return a drop proposal( copy, move or cancel)
    public func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        // If drag initiator is self collectionView, permit object to move, if not - copy
        let isSelf = (session.localDragSession?.localContext as? UICollectionView) == collectionView
        
        // Get source indexPath for a dragged item
        let location = session.location(in: collectionView)
        collectionView.performUsingPresentationValues {
            if let sourceIndexPath = collectionView.indexPathForItem(at: location) {
                lastDraggedCellIndexPath = sourceIndexPath
            }
        }
        return UICollectionViewDropProposal(operation: isSelf ? .move : .copy, intent: .insertAtDestinationIndexPath)
    }
    
    /// Perform a drop
    public func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        let destinationIndexPath = coordinator.destinationIndexPath ?? IndexPath(item: 0, section: 0)
        for item in coordinator.items {
            // If drag item is local collection cell image
            if let sourceIndexPath = item.sourceIndexPath {
                collectionView.performBatchUpdates {
                    if let sortedImage = imageGallery?.galleryImages?.remove(at: sourceIndexPath.item) {
                        imageGallery?.galleryImages?.insert(sortedImage, at: destinationIndexPath.item)
                        collectionView.deleteItems(at: [sourceIndexPath])
                        collectionView.insertItems(at: [destinationIndexPath])
                    }
                }
                coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
            // If drag item is an exported object
            } else {
                var newGalleryItem = GalleryImage()
                let placeholderContext = coordinator.drop(item.dragItem, to: UICollectionViewDropPlaceholder(insertionIndexPath: destinationIndexPath, reuseIdentifier: "DropPlaceholderCell"))
                // Get an object image aspect ratio
                item.dragItem.itemProvider.loadObject(ofClass: UIImage.self) { imageProvider, _ in
                    DispatchQueue.main.async {
                        if let image = imageProvider as? UIImage {
                            let aspectRatio = image.size.height / image.size.width
                            newGalleryItem.aspectRatio = aspectRatio
                        } else {
                            placeholderContext.deletePlaceholder()
                        }
                    }
                }
                // Get an object URL
                item.dragItem.itemProvider.loadObject(ofClass: NSURL.self) { urlProvider, _ in
                    DispatchQueue.main.async {
                        if let imageUrl = urlProvider as? URL {
                            placeholderContext.commitInsertion { insertionIndexPath in
                                newGalleryItem.url = imageUrl
                                self.imageGallery!.galleryImages!.insert(newGalleryItem, at: insertionIndexPath.item)
                            }
                        } else {
                            placeholderContext.deletePlaceholder()
                        }
                    }
                }
            }
        }
    }
}
    
extension ImageGalleryCollectionViewController: UIDropInteractionDelegate
{
//    public func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
//        return session.canLoadObjects(ofClass: UIImage.self)
//    }
//
    public func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        return UIDropProposal(operation: .copy)
    }
    
    public func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        
        session.loadObjects(ofClass: UIImage.self) { image in
            if let sourceIndexPath = self.lastDraggedCellIndexPath {
                self.collectionView.performBatchUpdates {
                    self.imageGallery?.galleryImages?.remove(at: sourceIndexPath.row)
                    self.collectionView.deleteItems(at: [sourceIndexPath])
                }
            }
        }
    }
    
}
