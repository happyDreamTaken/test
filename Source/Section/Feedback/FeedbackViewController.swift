//
//  FeedbackViewController.swift
//  IvyGate
//
//  Created by tjvs on 2019/8/26.
//  Copyright © 2019 yicheng. All rights reserved.
//

import UIKit
import CLImagePickerTool
import Photos

class FeedbackViewController: UIViewController , UITextViewDelegate{

    lazy var navigateBar = NavigateBar(frame: .zero)
    lazy var textView = KMPlaceholderTextView(frame: .zero)
    lazy var addImageBtn = UIButton()
    lazy var allImages = [ItemUpImgView]()
    lazy var allImageSources = [UIImage]()
    lazy var addImgDesLabel = UILabel()
    lazy var submitBtn =  UIGradientButton(type: .custom)
    var syncLock :Bool = true
    
    var currentFullState = false
    var currentImages = 0
    let itemInset : CGFloat = 3
    let itemWidth : CGFloat = 83
    let maxImageCounts = 3
    var imagesString:String?
    let imagePickTool = CLImagePickerTool.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(navigateBar)
        self.view.addSubview(textView)
        self.view.addSubview(addImgDesLabel)
        self.view.addSubview(submitBtn)
        
        navigateBar.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *)
                          {
                              make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
                          }else {
            make.top.equalTo(self.view.snp.top).offset(UIApplication.shared.statusBarFrame.height)
                          }
            make.height.equalTo(44)
            make.left.right.equalToSuperview()
        }
        
        textView.snp.makeConstraints { (make) in
            make.top.equalTo(navigateBar.snp.bottom).offset(30)
            make.left.equalTo(13)
            make.right.equalTo(-13)
            make.height.equalTo(180)
        }
        
        addImgDesLabel.snp.makeConstraints { (make) in
            make.top.equalTo(textView.snp.bottom).offset(125)
            make.left.equalToSuperview().offset(25)
            make.height.equalTo(20)
        }
        
        submitBtn.snp.makeConstraints { (make) in
            make.top.equalTo(addImgDesLabel.snp.bottom).offset(68)
            make.left.equalToSuperview().offset(33)
            make.right.equalToSuperview().offset(-33)
            make.height.equalTo(50)
        }
        
        
        self.view.backgroundColor = UIColor.white
        
        navigateBar.titleLabel.text = "意见反馈"
        navigateBar.titleLabel.font = UIFont.systemFont(ofSize: 17)
        navigateBar.backButton.addTarget(self, action: #selector(backButtonDidClick), for: .touchUpInside)
//        navigateBar.rightButton.setTitle("提交", for: .normal)
//        navigateBar.rightButton.addTarget(self, action: #selector(submitButtonDidClick), for: .touchUpInside)
        
        imagePickTool.isHiddenVideo = true
        imagePickTool.cameraOut = true
        imagePickTool.singleModelImageCanEditor = false
        
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.textColor = UIColor.RGBHex(0x999999)
        textView.placeholder = "我们想听听你的心声，如果愿意，你也可以留下联系方式，我们期待与你的真诚沟通。"
        textView.backgroundColor = UIColor.RGBHex(0xf4f4f4)
        textView.returnKeyType = .done
        textView.layer.cornerRadius = 5
        textView.layer.borderColor = UIColor.RGBHex(0xd3d3d3).cgColor
        textView.delegate = self
        textView.layer.borderWidth = 1
        
        self.addImageBtn = UIButton.init()
        addImageBtn.setImage(UIImage.init(named: "addImage"), for: .normal)
        self.addImageBtn.addTarget(self, action: #selector(tapOnAdd), for: .touchUpInside)
        self.view.addSubview(addImageBtn)
        
        addImgDesLabel.textColor = UIColor.RGBHex(0x9B9B9B)
        addImgDesLabel.text = "添加图片说明（最多上传三张）"
        addImgDesLabel.font = UIFont.systemFont(ofSize: 14)
        
        submitBtn.setTitle("提交", for: .normal)
        let gradientColor = [UIColor.RGBHex(0x36E273).cgColor,UIColor.RGBHex(0x33CCB3).cgColor]
        submitBtn.gradientBackgroundColor = gradientColor
        submitBtn.gradientLayer.cornerRadius = 5
        submitBtn.addTarget(self, action: #selector(submitButtonDidClick), for: .touchUpInside)

        
    }
    
    override func viewSafeAreaInsetsDidChange(){
         addImageBtn.frame = CGRect.init(x: 25, y: self.view.layoutMarginsGuide.layoutFrame.minY + 294, width: 61, height: 61)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    @objc func backButtonDidClick(){
        self.navigationController?.popViewController(animated: false)
    }
    
    @objc func submitButtonDidClick(){
        
        self.uploadAllImages(compeltion:{
            let mobile = User.shared.phone
            let text = self.textView.text ?? ""
            IvyGateServerAPI.shared.submitFeedback(phone: mobile, text: text , imageStrings:self.imagesString) { (json, error) in
                CBToast.showToastAction(message: "提交成功")
                NavigationController.shared.popViewController(animated: false)
                
            }
        })
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let view = touches.first?.view
        if (view?.isKind(of: UITextView.self))! {
            
        }else {
            textView.resignFirstResponder()
        }
    }
    

}

extension FeedbackViewController {
    
    @objc func tapOnAdd(){
       
           syncLock = false
        
        imagePickTool.cl_setupImagePickerWith(MaxImagesCount: 3) { (asserts, images) in
            
            if self.syncLock == true {
                
                return
            }
            
            self.syncLock = true
            
            
            /**
             *此处是由于ios13.2在统一的修改图片尺寸的时候convertAssetArrToThumbnailImage无法正确获取到图片，因此先用这套逻辑代替
             *
             */
            if asserts.count == 1 {
                if let image = images {
                    self.addPhotos(iamge: image)
                }else {
                    let Arr = CLImagePickerTool.convertAssetArrToThumbnailImage(assetArr: asserts, targetSize: CGSize.init(width: self.itemWidth, height: self.itemWidth))
                    for i in 0 ..< Arr.count {
                        let image = Arr[i]
                        self.addPhotos(iamge: image)
                    }
                }
            }else {
                let Arr = CLImagePickerTool.convertAssetArrToThumbnailImage(assetArr: asserts, targetSize: CGSize.init(width: self.itemWidth, height: self.itemWidth))
                for i in 0 ..< Arr.count {
                    let image = Arr[i]
                    self.addPhotos(iamge: image)
                }
            }
           
            
        }
        
        
    }
    
    
    
    fileprivate func addPhotos(iamge:UIImage) {
        currentImages += 1
               if currentImages < 3 {
                   
                   let itemUpImgView = ItemUpImgView.init(frame: .zero)
                   itemUpImgView.atIndex = currentImages
                   itemUpImgView.frame = CGRect.init(x: 14 + (itemWidth + itemInset) * CGFloat(currentImages - 1), y: 29 + textView.frame.maxY, width: itemWidth, height: itemWidth)
                itemUpImgView.bottomImgView.image = iamge
                itemUpImgView.bottomImgView.layer.cornerRadius = 4
                itemUpImgView.bottomImgView.layer.masksToBounds = true
                   self.view.addSubview(itemUpImgView)
                    itemUpImgView.rightTopDeleteBtn.addTarget(self, action: #selector(tapOnDelete(btn:)), for: .touchUpInside)
                   
                   self.addImageBtn.frame = CGRect.init(x: 14 + (itemWidth + itemInset) * CGFloat(currentImages) + 11, y: 40 + textView.frame.maxY, width: 61, height: 61)
                  
                   self.allImages.append(itemUpImgView)
                   self.allImageSources.append(iamge)
                   self.addImageBtn.isHidden = false
               }
               
               if currentImages == 3 {
                   self.addImageBtn.isHidden = true
                   
                   let itemUpImgView = ItemUpImgView.init(frame: .zero)
                   itemUpImgView.atIndex = currentImages
                   itemUpImgView.frame = CGRect.init(x: 14 + (itemWidth + itemInset) * CGFloat(currentImages - 1), y: 29 + textView.frame.maxY, width: itemWidth, height: itemWidth)
                   itemUpImgView.layer.cornerRadius = 4
                   itemUpImgView.layer.masksToBounds = true
                  itemUpImgView.bottomImgView.image = iamge
                   self.view.addSubview(itemUpImgView)
                    itemUpImgView.rightTopDeleteBtn.addTarget(self, action: #selector(tapOnDelete(btn:)), for: .touchUpInside)
                    self.allImageSources.append(iamge)
                   self.allImages.append(itemUpImgView)
               }
    }
    
    @objc func tapOnDelete(btn:UIButton) {
        let supview :ItemUpImgView = btn.superview as! ItemUpImgView
        
        let atIndex = supview.atIndex!
        currentImages -= 1
        UIView.animate(withDuration: 0.75, animations: {
            supview.alpha = 0
            supview.frame.size.width = 0
            for itemView in self.allImages {
                let eachImgView : ItemUpImgView = itemView
                if eachImgView.atIndex! > atIndex {
                    eachImgView.atIndex! -= 1
                    eachImgView.frame = CGRect.init(x: eachImgView.frame.minX - self.itemInset - self.itemWidth, y: 29 + self.textView.frame.maxY, width: self.itemWidth, height: self.itemWidth)
                    
                }
            }
            
            btn.alpha = 0
            self.addImageBtn.isHidden = false
            let orgX = 25 + (self.itemWidth + self.itemInset) * CGFloat(self.currentImages)
            self.addImageBtn.frame = CGRect.init(x: orgX, y: 40 + self.textView.frame.maxY, width: 61, height: 61)
            
            
        }) { (isOk) in
            supview.removeFromSuperview()
            self.allImages.remove(at: atIndex-1)
            self.allImageSources.remove(at: atIndex-1)
        }
        
    }
    
    //上传所有的图片
    fileprivate func uploadAllImages(compeltion: @escaping ()->Void) {
        
        IvyGateServerAPI.shared.uploadImages(params: nil, images: self.allImageSources) { (res, error) in
            if let json = res , json["code"].int == 1 {
                let dataArray:[String] = json["data"].arrayObject as![String]
                
             let dataString = dataArray.joined(separator: ",")
                self.imagesString = dataString
                compeltion()
            }
        }
        
    }
    
    
}

