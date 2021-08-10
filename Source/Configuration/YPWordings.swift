//
//  YPWordings.swift
//  YPImagePicker
//
//  Created by Sacha DSO on 12/03/2018.
//  Copyright © 2018 Yummypets. All rights reserved.
//

import Foundation

public struct YPWordings {
    
    public var permissionPopup = PermissionPopup()
    public var videoDurationPopup = VideoDurationPopup()
    public var cropViewController = CropViewController()

    public struct PermissionPopup {
        public var title = ypLocalized("YPImagePickerPermissionDeniedPopupTitle")
        public var message = ypLocalized("YPImagePickerPermissionDeniedPopupMessage")
        public var cancel = ypLocalized("YPImagePickerPermissionDeniedPopupCancel")
        public var grantPermission = ypLocalized("YPImagePickerPermissionDeniedPopupGrantPermission")
    }
    
    public struct VideoDurationPopup {
        public var title = ypLocalized("YPImagePickerVideoDurationTitle")
        public var tooShortMessage = ypLocalized("YPImagePickerVideoTooShort")
        public var tooLongMessage = ypLocalized("YPImagePickerVideoTooLong")
    }
    
    public struct CropViewController {
        public var done = ypLocalized("Done")
        public var cancel = ypLocalized("Cancel")
        public var reset = ypLocalized("Reset")
        public var original = ypLocalized("Original")
        public var square = ypLocalized("Square")
        public var deleteChanges = ypLocalized("Delete Changes")
        public var yes = ypLocalized("Yes")
        public var no = ypLocalized("No")
    }

    public var ok = ypLocalized("YPImagePickerOk")
    public var done = ypLocalized("YPImagePickerDone")
    public var cancel = ypLocalized("YPImagePickerCancel")
    public var save = ypLocalized("YPImagePickerSave")
    public var processing = ypLocalized("YPImagePickerProcessing")
    public var trim = ypLocalized("YPImagePickerTrim")
    public var cover = ypLocalized("YPImagePickerCover")
    public var albumsTitle = ypLocalized("YPImagePickerAlbums")
    public var libraryTitle = ypLocalized("YPImagePickerLibrary")
    public var cameraTitle = ypLocalized("YPImagePickerPhoto")
    public var videoTitle = ypLocalized("YPImagePickerVideo")
    public var next = ypLocalized("YPImagePickerNext")
    public var filter = ypLocalized("YPImagePickerFilter")
    public var crop = ypLocalized("YPImagePickerCrop")
    public var warningMaxItemsLimit = ypLocalized("YPImagePickerWarningItemsLimit")
}
