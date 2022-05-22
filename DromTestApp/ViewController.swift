//
//  ViewController.swift
//  DromTestApp
//
//  Created by Владимир on 21.05.2022.
//

import UIKit

private let urlsToImages: [String] = ["https://unsplash.com/photos/ebJWmbfJ7dM/download?ixid=MnwxMjA3fDB8MXxhbGx8MTd8fHx8fHwyfHwxNjUzMjA4ODE4&force=true&w=1920",
                                      "https://unsplash.com/photos/rd3Whid8qbg/download?ixid=MnwxMjA3fDB8MXxhbGx8fHx8fHx8fHwxNjUzMjEwNjU2&force=true&w=1920",
                                      "https://unsplash.com/photos/gPaT3qVyvBk/download?ixid=MnwxMjA3fDB8MXxhbGx8MjN8fHx8fHwyfHwxNjUzMjA4ODE4&force=true&w=1920",
                                      "https://unsplash.com/photos/us9EwlRd8RA/download?ixid=MnwxMjA3fDB8MXxhbGx8NTB8fHx8fHwyfHwxNjUzMjA4MjIw&force=true&w=1920",
                                      "https://unsplash.com/photos/9T2Vl2MeZfw/download?ixid=MnwxMjA3fDB8MXxhbGx8NjN8fHx8fHwyfHwxNjUzMjA4MjIz&force=true&w=1920",
                                      "https://unsplash.com/photos/jaeq30D6d6o/download?ixid=MnwxMjA3fDB8MXxhbGx8NzB8fHx8fHwyfHwxNjUzMjA4MjIz&force=true&w=1920"]

class ViewController: UIViewController {
    private let loader: ImageLoader = .init()
    private let collectionInset: UIEdgeInsets = .init(top: 10, left: 10, bottom: 10, right: 10)
    private var displayData: [String] = []
    
    lazy var collectionView: UICollectionView = {
        let layout: MoveToRightDeleteFlowLayout = .init()
        layout.sectionInset = collectionInset
        layout.minimumLineSpacing = 10
        let view: UICollectionView = .init(frame: view.frame, collectionViewLayout: layout)
        view.dataSource = self
        view.delegate = self
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        displayData = urlsToImages
        setupSubviews()
        setupCollectionView()
    }

}

private extension ViewController {
    func setupSubviews() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func setupCollectionView() {
        let refresh: UIRefreshControl = .init()
        refresh.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        collectionView.refreshControl = refresh
        collectionView.alwaysBounceVertical = true
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: "ImageCell")
    }
    
    @objc
    func refresh(_ sender: Any) {
        loader.clearCache()
        
        //Added delay for smoother UI change
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.displayData = urlsToImages
            self?.collectionView.reloadData()
            self?.collectionView.refreshControl?.endRefreshing()
        }
    }
    
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return displayData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath)
        print("request image by index - \(indexPath)")
        if let imageCell = cell as? ImageCollectionViewCell {
            let taskId = loader.loadImage(displayData[indexPath.row]) { result in
                let image: UIImage?
                do {
                    print("set image by index - \(indexPath)")
                    image = UIImage(data: try result.get())
                } catch {
                    print("\(error)")
                    image = nil
                }
                DispatchQueue.main.async {
                    imageCell.imageView?.image = image
                }
            }
            imageCell.onReuse = { [weak self] in
                guard let taskId = taskId else { return }
                self?.loader.cancelLoad(taskId)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let imageCell = collectionView.cellForItem(at: indexPath) as? ImageCollectionViewCell,
              let _ = imageCell.imageView?.image else { return }
        displayData.remove(at: indexPath.item)
        collectionView.performBatchUpdates {
            collectionView.deleteItems(at: [indexPath])
        }
    }
    
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width - collectionInset.left - collectionInset.right
        return .init(width: width, height: width)
    }
}
