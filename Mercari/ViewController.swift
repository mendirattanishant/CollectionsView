//
//  ViewController.swift
//  Mercari
//

import UIKit

class ViewController: UICollectionViewController {
    
    fileprivate let reuseIdentifier = "ItemCell"
    fileprivate let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 80.0, right: 20.0)
    
    fileprivate var json: [NSDictionary] = []
    fileprivate var contents: [[String: Any]] = []
    fileprivate let itemsPerRow: CGFloat = 3
    fileprivate var photoUrl: [String] = []
    fileprivate var price: [Int] = []
    fileprivate var images: [UIImage?] = []
    
    fileprivate var onSale: [Bool] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func loadData() {
        if let path = Bundle.main.path(forResource: "all", ofType: "json") {
            do {
                let jsonData = try NSData(contentsOfFile: path, options: NSData.ReadingOptions.mappedIfSafe)
                do {
                    let jsonResult: NSDictionary = try JSONSerialization.jsonObject(with: jsonData as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                    if let people : [NSDictionary] = jsonResult["data"] as? [NSDictionary] {
                        for person: NSDictionary in people {
                            json.append(person)
                            for (name,value) in person {
                                print("\(name) , \(value)")
                                if let photo = name as? String {
                                    if photo == "photo" {
                                        photoUrl.append(value as! String)
                                        images.append(nil)
                                    }
                                    if photo == "price" {
                                        price.append(value as! Int)
                                    }
                                    if photo == "status" {
                                        if value as! String == "sold_out" {
                                            onSale.append(true)
                                        } else {
                                            onSale.append(false)
                                        }
                                        
                                    }
                                }
                            }
                        }
                    }
                } catch {
                    print("Error")
                }
            } catch {
                print("Error")
            }
        }
    }
}

// MARK: - UICollectionViewDataSource

extension ViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return json.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                      for: indexPath) as! ItemCell
        cell.imageView.image = nil
        cell.soldimageView.image = nil
        
        cell.price.text = "$"+String(price[indexPath.item])
        if let image = images[indexPath.item] {
            cell.imageView.image = image
        } else if let url = URL(string: photoUrl[indexPath.item]) {
            serverUtils.getDataFromUrl(url: url) { (data, response, error)  in
                guard let data = data, error == nil else { return }
                print(response?.suggestedFilename ?? url.lastPathComponent)
                print("Download Finished")
                DispatchQueue.main.async() { () -> Void in
                    let image = UIImage(data: data)
                    self.images[indexPath.item] = image!
                    cell.imageView.image = image
                }
            }
        }
        if self.onSale[indexPath.item] == true {
            cell.soldimageView.image = UIImage(named: "sold")!
        }
        cell.updateUI()
        cell.layoutIfNeeded()
        return cell
    }
}

// MARK: - UICollectionViewDelegate Methods

extension ViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}
