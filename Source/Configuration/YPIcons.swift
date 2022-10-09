//
//  YPIcons.swift
//  YPImagePicker
//
//  Created by Nik Kov on 13.04.2018.
//  Copyright © 2018 Yummypets. All rights reserved.
//

import UIKit

public struct YPIcons {

    public var shouldChangeDefaultBackButtonIcon = false
    public var hideBackButtonTitle = true
    
    public var backButtonIcon: UIImage = imageFromBundle("yp_arrow_left")
    public var arrowDownIcon: UIImage = imageFromBundle("yp_arrow_down")
    public var cropIcon: UIImage = imageFromBundle("yp_iconCrop")
    public var cropSelectedIcon: UIImage = imageFromBundle("yp_iconCrop_Selected")
    public var flashOnIcon: UIImage = imageFromBundle("yp_iconFlash_on")
    public var flashOffIcon: UIImage = imageFromBundle("yp_iconFlash_off")
    public var flashAutoIcon: UIImage = imageFromBundle("yp_iconFlash_auto")
    public var loopIcon: UIImage = imageFromBundle("yp_iconLoop")
    public var multipleSelectionOffIcon: UIImage = imageFromBundle("yp_multiple")
    public var multipleSelectionOnIcon: UIImage = imageFromBundle("yp_multiple_colored")
    public var capturePhotoImage: UIImage = imageFromBundle("yp_iconCapture")
    public var captureVideoImage: UIImage = imageFromBundle("yp_iconVideoCapture")
    public var captureVideoOnImage: UIImage = imageFromBundle("yp_iconVideoCaptureRecording")
    public var playImage: UIImage = imageFromBundle("yp_play")
    public var removeImage: UIImage = imageFromBundle("yp_remove")
    public var editImage: UIImage = imageFromBundle("cropping_edit_icon")
    public var backButtonImage: UIImage = imageFromBundle("arrow_leff_icon")
    public var multipleSelectionOffImage: UIImage = imageFromBundle("multiple_icon")
    public var multipleSelectionOnImage: UIImage = imageFromBundle("multiple_selected_icon")
    public var addButtonImage: UIImage = imageFromBundle("add_icon")
}
