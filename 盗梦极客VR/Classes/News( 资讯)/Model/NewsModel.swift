//
//	Post.swift
//
//	Create by wl on 25/4/2016
//	Copyright © 2016. All rights reserved.
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import SwiftyJSON

class NewsModel : NSObject, NSCoding{

    	/// 新闻类别
	var categories : [Category]!
    	/// HTML
	var content : String!
    	/// 用于评论模块
	var customFields : CustomField!
    	/// 发布时间
	var date : String!
    	/// 新闻简介
	var excerpt : String!
    	/// 文章唯一ID
	var id : Int!
    	/// 用于tableView显示的长图
	var listThuUrl : String!
    	/// 最后一次修改时间
	var modified : String!
    	/// 标签
	var tags : [Tag]!
    	/// 标题
	var title : String!
	var type : String!
    	/// html的URL
	var url : String!

        /// 获取评论模块的数据
    var bbsInfo : BBSInfo!

        /// 设备模块特有数据
    var taxonomyPlatformsDevice : [TaxonomyPlatformsDevice]!
        /// 视频模块特有数据
    var taxonomyVideos : [TaxonomyVideo]!
    
    var eventStartDate: String!
    
    var tag: String {
        guard let str = type else {
            return ""
        }
        
        if str == "review" {
            return "评测"
        }else if str == "video" {
            return "视频"
        }else {
            return "资讯"
        }
    }
    
    var specialTag: String {
        if let str = taxonomyPlatformsDevice.first?.title {
            return str
        }else if let str = taxonomyVideos.first?.title {
            return str
        }
        return ""
    }
    
	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	required init(fromJson json: JSON!){
		if json == nil{
			return
		}
		categories = [Category]()
		let categoriesArray = json["categories"].arrayValue
		for categoriesJson in categoriesArray{
			let value = Category(fromJson: categoriesJson)
			categories.append(value)
		}

		content = json["content"].stringValue
		let customFieldsJson = json["custom_fields"]
		if customFieldsJson != JSON.null{
			customFields = CustomField(fromJson: customFieldsJson)
		}
		date = json["date"].stringValue
		excerpt = json["excerpt"].stringValue
		id = json["id"].intValue
		listThuUrl = json["list_thu_url"].stringValue
		modified = json["modified"].stringValue
		tags = [Tag]()
		let tagsArray = json["tags"].arrayValue
		for tagsJson in tagsArray{
			let value = Tag(fromJson: tagsJson)
			tags.append(value)
		}
		title = json["title"].stringValue
		type = json["type"].stringValue
        url = json["url"].stringValue
        
        let bbsInfoJson = json["bbs_info"]
        if bbsInfoJson != JSON.null{
            bbsInfo = BBSInfo(fromJson: bbsInfoJson)
        }
        
        taxonomyPlatformsDevice = [TaxonomyPlatformsDevice]()
        let taxonomyPlatformsDeviceArray = json["taxonomy_platforms_device"].arrayValue
        for taxonomyPlatformsDeviceJson in taxonomyPlatformsDeviceArray{
            let value = TaxonomyPlatformsDevice(fromJson: taxonomyPlatformsDeviceJson)
            taxonomyPlatformsDevice.append(value)
        }
        
        taxonomyVideos = [TaxonomyVideo]()
        let taxonomyVideosArray = json["taxonomy_videos"].arrayValue
        for taxonomyVideosJson in taxonomyVideosArray{
            let value = TaxonomyVideo(fromJson: taxonomyVideosJson)
            taxonomyVideos.append(value)
        }
        eventStartDate = json["event_start_date"].stringValue
	}

	/**
	 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> NSDictionary
	{
		let dictionary = NSMutableDictionary()
		if categories != nil{
			var dictionaryElements = [NSDictionary]()
			for categoriesElement in categories {
				dictionaryElements.append(categoriesElement.toDictionary())
			}
			dictionary["categories"] = dictionaryElements
		}
		if content != nil{
			dictionary["content"] = content
		}
		if customFields != nil{
			dictionary["custom_fields"] = customFields.toDictionary()
		}
		if date != nil{
			dictionary["date"] = date
		}
		if excerpt != nil{
			dictionary["excerpt"] = excerpt
		}
		if id != nil{
			dictionary["id"] = id
		}
		if listThuUrl != nil{
			dictionary["list_thu_url"] = listThuUrl
		}
		if modified != nil{
			dictionary["modified"] = modified
		}
		if tags != nil{
			var dictionaryElements = [NSDictionary]()
			for tagsElement in tags {
				dictionaryElements.append(tagsElement.toDictionary())
			}
			dictionary["tags"] = dictionaryElements
		}
		if title != nil{
			dictionary["title"] = title
		}
		if type != nil{
			dictionary["type"] = type
		}
		if url != nil{
			dictionary["url"] = url
		}
        if bbsInfo != nil{
            dictionary["bbs_info"] = bbsInfo.toDictionary()
        }
        if taxonomyPlatformsDevice != nil{
            var dictionaryElements = [NSDictionary]()
            for taxonomyPlatformsDeviceElement in taxonomyPlatformsDevice {
                dictionaryElements.append(taxonomyPlatformsDeviceElement.toDictionary())
            }
            dictionary["taxonomy_platforms_device"] = dictionaryElements
        }
        if taxonomyVideos != nil{
            var dictionaryElements = [NSDictionary]()
            for taxonomyVideosElement in taxonomyVideos {
                dictionaryElements.append(taxonomyVideosElement.toDictionary())
            }
            dictionary["taxonomy_videos"] = dictionaryElements
        }
        if eventStartDate != nil{
            dictionary["event_start_date"] = eventStartDate
        }
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         categories = aDecoder.decodeObjectForKey("categories") as? [Category]
         content = aDecoder.decodeObjectForKey("content") as? String
         customFields = aDecoder.decodeObjectForKey("custom_fields") as? CustomField
         date = aDecoder.decodeObjectForKey("date") as? String
         excerpt = aDecoder.decodeObjectForKey("excerpt") as? String
         id = aDecoder.decodeObjectForKey("id") as? Int
         listThuUrl = aDecoder.decodeObjectForKey("list_thu_url") as? String
         modified = aDecoder.decodeObjectForKey("modified") as? String
         tags = aDecoder.decodeObjectForKey("tags") as? [Tag]
         title = aDecoder.decodeObjectForKey("title") as? String
         type = aDecoder.decodeObjectForKey("type") as? String
         url = aDecoder.decodeObjectForKey("url") as? String
         bbsInfo = aDecoder.decodeObjectForKey("bbs_info") as? BBSInfo
         taxonomyPlatformsDevice = aDecoder.decodeObjectForKey("taxonomy_platforms_device") as? [TaxonomyPlatformsDevice]
         taxonomyVideos = aDecoder.decodeObjectForKey("taxonomy_videos") as? [TaxonomyVideo]
        eventStartDate = aDecoder.decodeObjectForKey("event_start_date") as? String
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encodeWithCoder(aCoder: NSCoder)
	{
		if categories != nil{
			aCoder.encodeObject(categories, forKey: "categories")
		}
		if content != nil{
			aCoder.encodeObject(content, forKey: "content")
		}
		if customFields != nil{
			aCoder.encodeObject(customFields, forKey: "custom_fields")
		}
		if date != nil{
			aCoder.encodeObject(date, forKey: "date")
		}
		if excerpt != nil{
			aCoder.encodeObject(excerpt, forKey: "excerpt")
		}
		if id != nil{
			aCoder.encodeObject(id, forKey: "id")
		}
		if listThuUrl != nil{
			aCoder.encodeObject(listThuUrl, forKey: "list_thu_url")
		}
		if modified != nil{
			aCoder.encodeObject(modified, forKey: "modified")
		}
		if tags != nil{
			aCoder.encodeObject(tags, forKey: "tags")
		}
		if title != nil{
			aCoder.encodeObject(title, forKey: "title")
		}
		if type != nil{
			aCoder.encodeObject(type, forKey: "type")
		}
		if url != nil{
			aCoder.encodeObject(url, forKey: "url")
		}
        if bbsInfo != nil{
            aCoder.encodeObject(bbsInfo, forKey: "bbs_info")
        }
        if taxonomyPlatformsDevice != nil{
            aCoder.encodeObject(taxonomyPlatformsDevice, forKey: "taxonomy_platforms_device")
        }
        if taxonomyVideos != nil{
            aCoder.encodeObject(taxonomyVideos, forKey: "taxonomy_videos")
        }
        if eventStartDate != nil{
            aCoder.encodeObject(eventStartDate, forKey: "event_start_date")
        }
	}

}