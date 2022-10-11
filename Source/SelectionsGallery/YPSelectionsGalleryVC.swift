//
//  SelectionsGalleryVC.swift
//  YPImagePicker
//
//  Created by Nik Kov || nik-kov.com on 09.04.18.
//  Copyright © 2018 Yummypets. All rights reserved.
//

import UIKit
import CropViewController

enum YPSelectionsGallerySection: Int, CaseIterable {
    case selectionsGallery = 0
    case addSelectionsGallery = 1
}

public class YPSelectionsGalleryVC: UIViewController, YPSelectionsGalleryCellDelegate {
    
    override public var prefersStatusBarHidden: Bool { return YPConfig.hidesStatusBar }
    
    public var items: [YPMediaItem] = []
    public var didFinishHandler: ((_ gallery: YPSelectionsGalleryVC, _ items: [YPMediaItem]) -> Void)?
    private var lastContentOffsetX: CGFloat = 0
    private let sideMargin: CGFloat = 24
    private let spacing: CGFloat = 12
    private let overlapppingNextPhoto: CGFloat = 37
    private let screenWidth = YPImagePickerConfiguration.screenWidth
    
    var v = YPSelectionsGalleryView()
    public override func loadView() { view = v }

    public required init(items: [YPMediaItem],
                         didFinishHandler:
        @escaping ((_ gallery: YPSelectionsGalleryVC, _ items: [YPMediaItem]) -> Void)) {
        super.init(nibName: nil, bundle: nil)
        self.items = items
        self.didFinishHandler = didFinishHandler
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()

        // Register collection view cell
        v.collectionView.register(YPSelectionsGalleryCell.self, forCellWithReuseIdentifier: "item")
        v.collectionView.register(AddSelectionsGalleryCell.self, forCellWithReuseIdentifier: "addItem")
        v.collectionView.dataSource = self
        v.collectionView.delegate = self
        
        // Setup navigation bar
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: YPConfig.wordings.done,
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(done))
        navigationItem.rightBarButtonItem?.tintColor = YPConfig.colors.tintColor
        navigationItem.rightBarButtonItem?.setFont(font: YPConfig.fonts.rightBarButtonFont, forState: .disabled)
        navigationItem.rightBarButtonItem?.setFont(font: YPConfig.fonts.rightBarButtonFont, forState: .normal)
        navigationController?.navigationBar.setTitleFont(font: YPConfig.fonts.navigationBarTitleFont)
        
        YPHelper.changeBackButtonIcon(self)
        YPHelper.changeBackButtonTitle(self)
    }

    @objc
    private func done() {
        // Save new images to the photo album.
        if YPConfig.shouldSaveNewPicturesToAlbum {
            for m in items {
                if case let .photo(p) = m, let modifiedImage = p.modifiedImage {
                    YPPhotoSaver.trySaveImage(modifiedImage, inAlbumNamed: YPConfig.albumName)
                }
            }
        }
        didFinishHandler?(self, items)
    }
    
    public func selectionsGalleryCellDidTapAdd() {
        navigationController?.popViewController(animated: true)
    }
    
    public func selectionsGalleryCellDidTapRemove(cell: YPSelectionsGalleryCell) {
        if let indexPath = v.collectionView.indexPath(for: cell) {
            items.remove(at: indexPath.row)
            v.collectionView.performBatchUpdates({
                v.collectionView.deleteItems(at: [indexPath])
            }, completion: { _ in })
        }
    }
    
    public func selectionsGalleryCellDidTapEdit(cell: YPSelectionsGalleryCell) {
        if let indexPath = v.collectionView.indexPath(for: cell) {
            let item = items[indexPath.row]
            switch item {
            case .photo(let photo):
                let cropVC = CropViewController(croppingStyle: CropViewCroppingStyle.default, image: photo.image)
                //                        let cropVC = YPCropVC(image: photo.image, ratio: ratio)
                cropVC.delegate = self
                cropVC.aspectRatioPickerButtonHidden = true
                cropVC.onDidCropToRect = { [weak self] croppedImage, rect, angle in
                    photo.modifiedImage = croppedImage
                    self?.items[indexPath.row] = YPMediaItem.photo(p: photo)
                    self?.v.collectionView.reloadData()
                    cropVC.dismiss(animated: true, completion: nil)
                }
                cropVC.onDidCropToCircleImage = { [weak self] croppedImage, rect, angle in
                    photo.modifiedImage = croppedImage
                    self?.items[indexPath.row] = YPMediaItem.photo(p: photo)
                    self?.v.collectionView.reloadData()
                    cropVC.dismiss(animated: true, completion: nil)
                }
                present(cropVC, animated: true, completion: nil)
            case .video( _):
                break
            }
            
        }
    }
}

// MARK: - Collection View
extension YPSelectionsGalleryVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return YPSelectionsGallerySection.allCases.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch YPSelectionsGallerySection(rawValue: section) {
        case .selectionsGallery:
            return items.count
        default:
            if items.count < YPConfig.library.maxNumberOfItems {
                return 1
            }
            return 0
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                               cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch YPSelectionsGallerySection(rawValue: indexPath.section) {
        case .selectionsGallery:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "item",
                                                                for: indexPath) as? YPSelectionsGalleryCell else {
                return UICollectionViewCell()
            }
            cell.delegate = self
            let item = items[indexPath.row]
            switch item {
            case .photo(let photo):
                cell.imageView.image = photo.image
                cell.setEditable(YPConfig.showImageEditor)
            case .video(let video):
                cell.imageView.image = video.thumbnail
                cell.setEditable(YPConfig.showsVideoTrimmer)
            }
            cell.removeButton.isHidden = YPConfig.gallery.hidesRemoveButton
            return cell
        default:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "addItem",
                                                                for: indexPath) as? AddSelectionsGalleryCell else {
                return UICollectionViewCell()
            }
            cell.delegate = self
            return cell
        }
    }
}

extension YPSelectionsGalleryVC: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch YPSelectionsGallerySection(rawValue: section) {
        case .addSelectionsGallery:
            return .zero
        default:
            if items.count < YPConfig.library.maxNumberOfItems {
                return UIEdgeInsets(top: 0, left: sideMargin, bottom: 0, right: 0)
            }
            return UIEdgeInsets(top: 0, left: sideMargin, bottom: 0, right: sideMargin)
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let selectionSize = screenWidth - (sideMargin + overlapppingNextPhoto)
        if YPSelectionsGallerySection(rawValue: indexPath.section) == .addSelectionsGallery {
            let addSelectionSize = screenWidth - selectionSize / 2
            return CGSize(width: addSelectionSize, height: addSelectionSize)
        }
        return CGSize(width: selectionSize, height: selectionSize)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if YPSelectionsGallerySection(rawValue: indexPath.section) == .addSelectionsGallery {
            return
        }
        
        let item = items[indexPath.row]
        var mediaFilterVC: IsMediaFilterVC?
        switch item {
        case .photo(let photo):
            if !YPConfig.filters.isEmpty, YPConfig.showsPhotoFilters {
                mediaFilterVC = YPPhotoFiltersVC(inputPhoto: photo, isFromSelectionVC: true)
            } else {
                return
            }
        case .video(let video):
            if YPConfig.showsVideoTrimmer {
                mediaFilterVC = YPVideoFiltersVC.initWith(video: video, isFromSelectionVC: true)
            }
        }
        
        mediaFilterVC?.didSave = { outputMedia in
            self.items[indexPath.row] = outputMedia
            collectionView.reloadData()
            self.dismiss(animated: true, completion: nil)
        }
        mediaFilterVC?.didCancel = {
            self.dismiss(animated: true, completion: nil)
        }
        if let mediaFilterVC = mediaFilterVC as? UIViewController {
            let navVC = UINavigationController(rootViewController: mediaFilterVC)
            navVC.navigationBar.isTranslucent = false
            present(navVC, animated: true, completion: nil)
        }
    }
    
    // Set "paging" behaviour when scrolling backwards.
    // This works by having `targetContentOffset(forProposedContentOffset: withScrollingVelocity` overriden
    // in the collection view Flow subclass & using UIScrollViewDecelerationRateFast
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let isScrollingBackwards = scrollView.contentOffset.x < lastContentOffsetX
        scrollView.decelerationRate = isScrollingBackwards
            ? UIScrollView.DecelerationRate.fast
            : UIScrollView.DecelerationRate.normal
        lastContentOffsetX = scrollView.contentOffset.x
    }
}

extension YPSelectionsGalleryVC: CropViewControllerDelegate {
    
}
