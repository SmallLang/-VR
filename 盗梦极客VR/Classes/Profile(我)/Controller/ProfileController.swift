//
//  ProfileController.swift
//  盗梦极客VR
//
//  Created by wl on 5/5/16.
//  Copyright © 2016 wl. All rights reserved.
//  我模块

import UIKit
import SDWebImage
import MBProgressHUD
import Alamofire

class ProfileController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var exitContainerView: UIView!
    
        /// 用户数据模型
    var user: User! {
        get {
            return UserManager.sharedInstance.user
        }
    }
    
    var staticCellProvider =  TableViewProvider()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        automaticallyAdjustsScrollViewInsets = false
        setupTableView()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(userDidLogin), name: UserDidLoginNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(userDidLoginout), name: UserDidLoginoutNotification, object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: false)
        
         MobClick.beginLogPageView("我")
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        MobClick.endLogPageView("我")
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}

// MARK: - 初始化方法
extension ProfileController {
    /**
     设置tabview
     */
    func setupTableView() {
        tableView.dataSource = staticCellProvider
        tableView.delegate = staticCellProvider
        tableView.registerClass(StaticCell.self, forCellReuseIdentifier: staticCellProvider.cellID)
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0)
        addGroup0()
        addGroup1()
        addLastGroup()
        
        if user != nil {
            setupUserInfo()
        }
    }
    
    /**
     设置需要展示的用户数据
     */
    func setupUserInfo() {
        guard let user = user else {
            return
        }
        
//        loginButton.enabled = false
        if !user.avatar.isEmpty {
            avatarImageView.sd_setImageWithURL(NSURL(string: user.avatar)!)
            avatarImageView.layer.cornerRadius =  avatarImageView.bounds.width * 0.5
            avatarImageView.layer.masksToBounds = true
        }
        usernameLabel.text = user.displayname
        exitContainerView.hidden = false
        
        addGroup0()
        tableView.reloadData()
        view.setNeedsDisplay()
    }
    /**
     清理所有的用户数据
     点击退出登录后调用
     */
    func clearUserInfo() {
//        loginButton.enabled = true
        
        avatarImageView.image = UIImage(named: "user_defaultavatar")
        usernameLabel.text = "点击登录"
        exitContainerView.hidden = true
    }
    
    /**
     添加第一组数据显示(用户数据)
     */
    func addGroup0() {
        
        var group = CellGroup(header: "基本信息", items: [], footer: "")
        
        if user == nil {
            let account = ArrowCellModel(text: "未登录", icon: nil) {
                let vc = UIStoryboard(name: "Profile", bundle: nil).instantiateViewControllerWithIdentifier("LoginController") as! LoginController
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
                if let interactivePopGestureRecognizer = self.navigationController?.interactivePopGestureRecognizer {
                    interactivePopGestureRecognizer.delegate = nil
                }
            }
            group.items = [account]
        }else {
            let account = RightDetallCellModel(text: "账号", rightDetall: user.username)
            let nickname = RightDetallWithArrowCellModel(text: "昵称", rightDetall: user.displayname)
            nickname.seletedCallBack = modifyNickname
            let email = RightDetallWithArrowCellModel(text: "邮箱", rightDetall: user.email)
            email.seletedCallBack = modifyEmail
            group.items = [account, nickname, email]
        }
        if !staticCellProvider.dataList.isEmpty {
            staticCellProvider.dataList.removeFirst()
        }
        staticCellProvider.dataList.insert(group, atIndex: 0)
    }
    
    func addGroup1() {
        let clearCell = RightDetallWithArrowCellModel(text: "清理缓存", rightDetall: SDImageCache.getCacheSizeMB()) {
            MBProgressHUD.showMessage("正在清理缓存...")
            SDImageCache.sharedImageCache().clearDiskOnCompletion {
                MBProgressHUD.hideHUD()
                self.staticCellProvider.dataList.removeAtIndex(1)
                self.addGroup1()
                let section  = NSIndexSet(index: 1)
                self.tableView.reloadSections(section, withRowAnimation: .None)
            }
            
        }
        
//        let checkVersion = ArrowCellModel(text: "版本更新", icon: nil, seletedCallBack: nil)
//        checkVersion.seletedCallBack = checkAppVersion
        
        let suggest = ArrowCellModel(text: "建议反馈")
        suggest.seletedCallBack = {
            let vc = UIStoryboard(name: "Profile", bundle: nil).instantiateViewControllerWithIdentifier("SuggestController")
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        let group = CellGroup(header: "功能",items: [clearCell, suggest])
        staticCellProvider.dataList.insert(group, atIndex: 1)
    }
    
    /**
     添加最后一组数据显示(功能数据)
     */
    func addLastGroup() {
        let aboutMe = ArrowCellModel(text: "关于我们")
        aboutMe.seletedCallBack = {
            let vc = UIStoryboard(name: "Profile", bundle: nil).instantiateViewControllerWithIdentifier("AboutMeController")
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        let mark = ArrowCellModel(text: "给个好评", icon: nil, seletedCallBack: nil)
        mark.seletedCallBack = {
            let url = NSURL(string: "itms-apps://itunes.apple.com/cn/app/dao-meng-ji-kevr/id1118642139?mt=8")!
            UIApplication.sharedApplication().openURL(url)
        }
        let group = CellGroup(header: "其他",items: [mark, aboutMe])
        staticCellProvider.dataList.append(group)
    }
}

extension ProfileController {
    
    func modifyEmail() {
        
        let alert = UIAlertController(title: "修改邮箱", message: nil, preferredStyle: .Alert)
        var newName: String = ""
        func success(user: User) {
//            staticCellProvider.dataList.removeFirst()
            setupUserInfo()
            synchronizeBBSAcount()
        }
        
        func failure(_: ErrorType) {
            // TODO: 简单提示为修改失败
            MBProgressHUD.showError("修改失败,可能已经被使用")
        }
        
        alert.addTextFieldWithConfigurationHandler { textField in
            textField.text = UserManager.sharedInstance.user!.email
        }
        let cancel = UIAlertAction(title: "取消", style: .Default, handler: nil)
        let ok = UIAlertAction(title: "确定", style: .Default) { actioin in
            if let email = alert.textFields?.first?.text where !email.isEmpty {
                
                if RegexHelper.isEmail(email) {
                    if UserManager.sharedInstance.user!.email != email {
                        MBProgressHUD.showMessage("正在修改邮箱...")
                        UserManager.sharedInstance.modifyEmail(email,success: success, failure: failure)
                    }
                }else {
                    MBProgressHUD.showWarning("邮箱格式不正确!")
                }
            }
        }
        alert.addAction(cancel)
        alert.addAction(ok)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func modifyNickname() {
        let alert = UIAlertController(title: "修改昵称", message: nil, preferredStyle: .Alert)
        var newName: String = ""
        func success(user: User) {
//            staticCellProvider.dataList.removeFirst()
            setupUserInfo()
            synchronizeBBSAcount()
        }
        
        func failure(_: ErrorType) {
            MBProgressHUD.showError("网络拥堵,请稍后尝试！")
        }
        
        alert.addTextFieldWithConfigurationHandler { textField in
            textField.text = UserManager.sharedInstance.user!.displayname
        }
        let cancel = UIAlertAction(title: "取消", style: .Default, handler: nil)
        let ok = UIAlertAction(title: "确定", style: .Default) { actioin in
            if let nickname = alert.textFields?.first?.text where !nickname.isEmpty {
                if UserManager.sharedInstance.user!.displayname != nickname {
                    MBProgressHUD.showMessage("正在修改昵称...")
                    UserManager.sharedInstance.modifyNickname(nickname,success: success, failure: failure)
                }
            }
        }
        alert.addAction(cancel)
        alert.addAction(ok)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    // TODO: 重构
    /**
     同步账号
     在注册成功后调用
     */
    func synchronizeBBSAcount() {
        MBProgressHUD.showMessage("修改成功!\n 正在同步账号信息...")
        
        func reponse(result: Bool) {
            if result == true {
                MBProgressHUD.showSuccess("同步成功!")
            }else {
                MBProgressHUD.showError("同步失败!稍后尝试")
            }
        }
        
        func failure(error: ErrorType) {
            MBProgressHUD.hideHUD()
            let alert = UIAlertController(title: "失败", message: "与论坛同步失败！\n进入论坛自动同步", preferredStyle: .Alert)
            let cancel = UIAlertAction(title: "取消",
                                       style: .Default) { _ in
                                        MBProgressHUD.showWarning("注册成功！进入论坛可自动同步!")
            }
            let reTry = UIAlertAction(title: "重试",
                                      style: .Default) { _ in
                                        self.synchronizeBBSAcount()
            }
            alert.addAction(cancel)
            alert.addAction(reTry)
            presentViewController(alert, animated: true, completion: nil)
        }
        let user = UserManager.sharedInstance.user!
        let userInfo: RegisteReturnInfo = (user.id, user.cookie)
        UserManager.sharedInstance
            .synchronizeBBSAcount(userInfo,
                                  success: reponse,
                                  failure: failure)
    }
}

// MARK: - 监听方法
extension ProfileController {
    @IBAction func loginButtonClik() {
        
        if UserManager.sharedInstance.user == nil {
            let vc = UIStoryboard(name: "Profile", bundle: nil).instantiateViewControllerWithIdentifier("LoginController") as! LoginController
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
            if let interactivePopGestureRecognizer = navigationController?.interactivePopGestureRecognizer {
                interactivePopGestureRecognizer.delegate = nil
            }
        }else {
            let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
            let camera = UIAlertAction(title: "拍照", style: .Default) { [weak self]actioin in
                if UIImagePickerController.isSourceTypeAvailable(.Camera) {
                    let imagePicker = UIImagePickerController()
                    imagePicker.allowsEditing = true
                    imagePicker.sourceType = .Camera
                    imagePicker.delegate = self
                    self?.presentViewController(imagePicker, animated: true, completion: nil)
                }else {
                    MBProgressHUD.showError("当前设备不支持照相!")
                }
            }
            let album = UIAlertAction(title: "从相册选择", style: .Default) { [weak self] (actioin) in
                let imagePicker = UIImagePickerController()
                imagePicker.allowsEditing = true
                imagePicker.sourceType = .PhotoLibrary
                imagePicker.delegate = self
                self?.presentViewController(imagePicker, animated: true, completion: nil)
            }

            let cancel = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
            sheet.addAction(camera)
            sheet.addAction(album)
            sheet.addAction(cancel)
            presentViewController(sheet, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func exitButtonClik() {
        clearUserInfo()
        UserManager.loginout()
        
        addGroup0()
        let firstSection = NSIndexSet(index: 0)
        tableView.reloadSections(firstSection, withRowAnimation: .None)
    }
    
    func userDidLogin() {
        setupUserInfo()
    }
    
    func userDidLoginout() {
        clearUserInfo()
    }
    
    
}

extension ProfileController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        picker.dismissViewControllerAnimated(true, completion: nil)
        let image = info[UIImagePickerControllerEditedImage] as! UIImage
//        print(image)
        var imageData: NSData
        if let data = UIImagePNGRepresentation(image) {
            imageData = data
        }else if let data = UIImageJPEGRepresentation(image, 1) {
            imageData = data
        }else {
            MBProgressHUD.showError("不支持的图片格式")
            return
        }

        MBProgressHUD.showMessage("正在上传头像...")
        func success(user: User) {
            synchronizeBBSAcount()
            avatarImageView.sd_setImageWithURL(NSURL(string: user.avatar)!)
            
        }
        
        func failure(_: ErrorType) {
            MBProgressHUD.showError("网络错误，请稍后重试!")
        }
        
        UserManager.sharedInstance.modifyIcon(imageData, success: success, failure: failure)
    }
}

