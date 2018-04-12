//
//  MainCollectionViewController.swift
//  Mylivn
//
//  Created by Karthik Kumar on 26/03/18.
//  Copyright © 2018 Karthik Kumar. All rights reserved.
//

import UIKit

class MainCollectionViewController: UICollectionViewController {
    
    // MARK: - Members variables
    fileprivate let sectionInsets = UIEdgeInsets(top: 20.0, left: 10.0, bottom: 20.0, right: 10.0)
    fileprivate let itemsPerRow: CGFloat = 3
    
    fileprivate var itemWidth: Int = 0 {
        didSet {
            largeItemWidth = (itemWidth * 2)
        }
    }

    // data source for collection view
    private var dataSource: CollectionViewDataSource!
    
    fileprivate var largeItemWidth: Int = 0
    
    fileprivate var movingIndexPath: IndexPath?
    
    // MARK: - Navigation styling
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - VC life cycle
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func loadView() {
        super.loadView()
        
        dataSource = DataHelper(delegate: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Mylivn"

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        registerCells()

        // Do any additional setup after loading the view.
        collectionView?.backgroundColor = UIColor.white
        
        addGestures()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        calculateCellWidth()
//        collectionView?.collectionViewLayout.invalidateLayout()
        dataSource.refresh()
    }
    
    override func viewLayoutMarginsDidChange() {
        super.viewLayoutMarginsDidChange()
        calculateCellWidth()
        collectionView?.collectionViewLayout.invalidateLayout()
        
    }
    
    // MARK: - Register cell classes
    private func registerCells() {
        self.collectionView!.register(MylivnCell.self, forCellWithReuseIdentifier: MylivnCell.identifier)
        self.collectionView!.register(AddCell.self, forCellWithReuseIdentifier: AddCell.identifier)
    }

    // MARK: - UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.howManyCells() + 1
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: UICollectionViewCell
        
        switch indexPath.row {
        case dataSource.howManyCells():
            let addCell = collectionView.dequeueReusableCell(withReuseIdentifier: AddCell.identifier, for: indexPath) as! AddCell
            
            cell = addCell
        default:
            
            let myLivnCell = collectionView.dequeueReusableCell(withReuseIdentifier: MylivnCell.identifier, for: indexPath) as! MylivnCell
            
            // Configure the cell
            if let data = dataSource.getImageData(for: indexPath) {
                myLivnCell.configure(data: data)
            }
            
            if isEditing {
                myLivnCell.startWiggle()
            } else {
                myLivnCell.stopWiggle()
            }
            
            myLivnCell.delegate = self
                        
            cell = myLivnCell
        }
    
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if !isRequestToMoveLastCell(sourceIndexPath: sourceIndexPath, destinationIndexPath: destinationIndexPath) {
            dataSource.swap(fromIndexPath: sourceIndexPath, toIndexPath: destinationIndexPath)
            dataSource.save()
        }
    }
    


    // MARK: - UICollectionViewDelegate
        
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? AddCell else {
            collectionView.deselectItem(at: indexPath, animated: true)
            presetConfirmAlert(for: indexPath)
            return
        }
        
        // add new image
        cell.shakeMe()
        presentAddImageAlert()
    }
    

    
    override func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        guard let _ = collectionView.cellForItem(at: indexPath) as? MylivnCell else {
            return false
        }
        
        return true
    }

}

// MARK: - MylivnLayoutDelegate methods
extension MainCollectionViewController: MylivnLayoutDelegate {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        switch indexPath.row {
        case 0:
            return CGSize(width: largeItemWidth, height: largeItemWidth)
        default:
            return CGSize(width: itemWidth, height: itemWidth)
        }
    }
}

// MARK: - DataHelperDelegate methods
extension MainCollectionViewController: DataHelperDelegate {
    func dataLoaded() {
        collectionView?.reloadData()
    }
}

// MARK: - implement alert view methods
extension MainCollectionViewController {
    private func presentDeleteConfirmAlert(for indexPath: IndexPath) {
        if let identifier = dataSource.getImageData(for: indexPath) {
            let alert = UIAlertController(title: "Delete Item", message: "Do you really want to delete the item with identifier: \(identifier.uuid)", preferredStyle: .alert)
            
            let yesAction = UIAlertAction(title: "Yes", style: .default) { (alertAction) in
                self.deleteImage(indexPath: indexPath)
            }
            
            let noAction = UIAlertAction(title: "NO", style: .default) { (alertAction) in
                
            }
            
            alert.addAction(yesAction)
            alert.addAction(noAction)
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    private func presetConfirmAlert(for indexPath: IndexPath) {
        if let identifier = dataSource.getImageData(for: indexPath) {
            let alert = UIAlertController(title: "Selected Item", message: "UUID: \(identifier.uuid)", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default) { (alertAction) in
                
            }
            
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    private func presentAddImageAlert() {
        let alert = UIAlertController(title: "Add Image", message: "Add new image URL", preferredStyle: .alert)
        
        let addAction = UIAlertAction(title: "ADD", style: .default) { (alertAction) in
            let textField = alert.textFields![0] as UITextField
            
            self.addImage(url: textField.text!)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (alertAction) in
            
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "https://google.com/my.jpg"
        }
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func presentFailedAlert() {
        let alert = UIAlertController(title: "Failed!", message: "Cannot add image", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { (alertAction) in
            
        }
        
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: - MylivnCellDelegate methods
extension MainCollectionViewController: MylivnCellDelegate {
    func deleteMe(cell: MylivnCell) {
        if let indexPath = collectionView?.indexPath(for: cell) {
            presentDeleteConfirmAlert(for: indexPath)
        }
    }
}

// MARK: - Collection view modify methods
extension MainCollectionViewController {
    private func deleteImage(indexPath: IndexPath) {
        collectionView?.performBatchUpdates({
            dataSource.deleteItem(at: indexPath)
            self.collectionView?.deleteItems(at: [indexPath])
        }, completion: { (finished) in
            self.dataSource.save()
        })
    }
    
    private func addImage(url: String) {
        if let link = validateURL(url: url) {
            let indexPath = IndexPath(item: dataSource.howManyCells(), section: 0)
            collectionView?.performBatchUpdates({
                dataSource.addItem(url: link)
                self.collectionView?.insertItems(at: [indexPath])
            }, completion: { (finished) in
                self.collectionView?.reloadItems(at: [indexPath])
                let scrollIndex = IndexPath(item: indexPath.row + 1, section: 0)
                self.collectionView?.scrollToItem(at: scrollIndex, at: .bottom, animated: true)
                self.dataSource.save()
            })
        } else {
            presentFailedAlert()
        }
    }
}

// MARK: - Animation methods
extension MainCollectionViewController {
    private func animatePickedCell(_ cell: MylivnCell?) {
        UIView.animate(withDuration: 0.1, delay: 0.0, options: [.allowUserInteraction, .beginFromCurrentState, .curveEaseOut], animations: { () -> Void in
            cell?.alpha = 0.7
            cell?.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }, completion: { finished in
            
        })
    }
    
    private func animateDroppedCell(_ cell: MylivnCell?) {
        UIView.animate(withDuration: 0.1, delay: 0.0, options: [.allowUserInteraction, .beginFromCurrentState, .curveEaseOut], animations: { () -> Void in
            cell?.alpha = 0.5
            cell?.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }, completion: { finished in
            cell?.alpha = 1.0
            cell?.transform = .identity
        })
    }
    
    private func startWigglingAllVisibleCells() {
        let cells = collectionView?.visibleCells as [UICollectionViewCell]?
        
        let movableCells = cells?.filter { $0 is MylivnCell } as! [MylivnCell]
        
        for cell in movableCells {
            if isEditing { cell.startWiggle() } else { cell.stopWiggle() }
        }
    }
}

// MARK: - Observer action methods
extension MainCollectionViewController {
    @objc
    func longPressed(gesture: UILongPressGestureRecognizer) {
        let location = gesture.location(in: collectionView)
        movingIndexPath = collectionView?.indexPathForItem(at: location)
        
        switch gesture.state {
        case .began:
            guard let indexPath = movingIndexPath else { return }
            
            guard let _ = pickedCell() else {
                movingIndexPath = nil
                return
            }
            
            setEditing(true, animated: true)
            collectionView?.beginInteractiveMovementForItem(at: indexPath as IndexPath)
            pickedCell()?.stopWiggle()
            animatePickedCell(pickedCell())
            
        case .changed:
            
            collectionView?.updateInteractiveMovementTargetPosition(location)
            
        default:
            
            guard let _ = pickedCell() else {
                movingIndexPath = nil
                collectionView?.cancelInteractiveMovement()
                stopEdit()
                return
            }
            
            gesture.state == .ended
                ? collectionView?.endInteractiveMovement()
                : collectionView?.cancelInteractiveMovement()
            
            animateDroppedCell(pickedCell())
            stopEdit()
        }
    }
}

// MARK: - Helper methods
extension MainCollectionViewController {
    private func isRequestToMoveLastCell(sourceIndexPath: IndexPath, destinationIndexPath: IndexPath) -> Bool {
        if sourceIndexPath.row == dataSource.howManyCells() || destinationIndexPath.row == dataSource.howManyCells() {
            return true
        }
        
        return false
    }
    
    private func validateURL(url: String) -> URL? {
        
        var link: URL? = nil
        
        if url.hasPrefix("https://") || url.hasPrefix("http://") {
            let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
            let matches = detector.matches(in: url, options: [], range: NSRange(location: 0, length: url.utf16.count))
            
            guard matches.count > 0 else {
                return nil
            }
            
            for match in matches {
                guard let range = Range(match.range, in: url) else {
                    continue
                }
                let urlString = String(describing: url[range])
                link = URL(string: urlString)
                
                break
            }
            
        }
        
        return link
    }
    
    private func stopEdit() {
        movingIndexPath = nil
        setEditing(false, animated: true)
    }
    
    private func pickedCell() -> MylivnCell? {
        guard let indexPath = movingIndexPath else { return nil }
        
        return collectionView?.cellForItem(at: indexPath as IndexPath) as? MylivnCell
    }
    
    private func calculateCellWidth() {
        //        let padding = sectionInsets.left * (itemsPerRow + 1)
        let width = view.frame.width
        itemWidth = Int(width / itemsPerRow)
    }
    
    private func addGestures() {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressed(gesture:))) // this
        collectionView?.addGestureRecognizer(longPressGesture)
        longPressGesture.minimumPressDuration = 0.3
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: true)
        
        startWigglingAllVisibleCells()
    }
}




