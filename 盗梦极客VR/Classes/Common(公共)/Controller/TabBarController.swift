//
//  TabBarController.swift
//  盗梦极客VR
//
//  Created by wl on 4/20/16.
//  Copyright © 2016 wl. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupRootNavController()
    }

}

extension TabBarController {
    
    /**
     添加导航控制器
     */
    func setupRootNavController() {
        addRootNavController("News", title: "资讯", iconName: "")
        addRootNavController("Evaluation", title: "评测", iconName: "")
        addRootNavController("BBS", title: "论坛", iconName: "")
        addRootNavController("Profile", title: "我", iconName: "")
    }
    
    /**
     在程序最开始运行自动调用
     为当前TabBarController初始化并添加一个控制器
     
     - parameter storyboardName: storyboard文件名
     - parameter identifier:     需要加载的控制器标识符
     - parameter title:          tabbarItem名称
     - parameter iconName:       图标
     */
    private func addRootNavController(storyboardName: String,
                                      identifier: String = "NavigationController",
                                      title: String,
                                      iconName: String
        ) {
        let sb = UIStoryboard(name: storyboardName, bundle: nil)
        let vc = sb.instantiateViewControllerWithIdentifier(identifier)
        vc.tabBarItem.title = title
        vc.tabBarItem.image = nil
        vc.tabBarItem.selectedImage = nil
        addChildViewController(vc)
    }
}
