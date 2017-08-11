//
//  SmartDatePicker.swift
//  LYDatePickerDemo
//
//  Created by 罗源 on 2017/6/9.
//  Copyright © 2017年 罗源. All rights reserved.
//

import UIKit

class SmartDatePicker: UIView,UICollectionViewDelegate,UICollectionViewDataSource{
    var days = [(String,Date)]()
    let currentDate = Date()
    var dateCollectionView : UICollectionView!
    var dateCellHeight : CGFloat = 50
    let selectOutLineView = UIView()
    let topSelectedLabel = UILabel()
    let bottomSelectedLabel = UILabel()
    var seletedDate : Date!{
        set{
            for (index,d) in days.enumerated() {
                if d.1 == newValue {
                    centerIndex = IndexPath(item: index, section: 0)
                    dateCollectionView.selectItem(at: centerIndex, animated: false, scrollPosition: UICollectionViewScrollPosition.centeredVertically)
                    break
                }
            }
        }get{
            return days[centerIndex.row].1
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        days.append((configDateStr(currentDate),currentDate))
        for _ in 0..<60 {
            let previousDate = days.first!.1.addingTimeInterval(TimeInterval(-24*3600))
            days.insert((configDateStr(previousDate),previousDate), at: 0)
            let nextDate = days.last!.1.addingTimeInterval(TimeInterval(24*3600))
            days.append((configDateStr(nextDate),nextDate))
        }
        
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.itemSize = CGSize(width: self.bounds.width, height: dateCellHeight)
        collectionViewFlowLayout.minimumLineSpacing = 0
        collectionViewFlowLayout.minimumInteritemSpacing = 0
        dateCollectionView = UICollectionView(frame: CGRect(origin: CGPoint.zero, size: frame.size), collectionViewLayout: collectionViewFlowLayout)
        
        selectOutLineView.layer.borderWidth = 1
        selectOutLineView.layer.borderColor = mainBgColor.cgColor
        selectOutLineView.layer.cornerRadius = 25
        selectOutLineView.clipsToBounds = true
        selectOutLineView.backgroundColor = UIColor.white
        selectOutLineView.frame.size = CGSize(width: 290/375*self.frame.width, height: dateCellHeight)
        dateCollectionView.addSubview(selectOutLineView)
        selectOutLineView.center = CGPoint(x: self.frame.width/2, y: CGFloat(days.count)/2*dateCellHeight)
        topSelectedLabel.font = UIFont.systemFont(ofSize: 20)
        topSelectedLabel.textColor = headerBgColor
        bottomSelectedLabel.font = UIFont.systemFont(ofSize: 20)
        bottomSelectedLabel.textColor = headerBgColor
        bottomSelectedLabel.textAlignment = .center
        topSelectedLabel.textAlignment = .center
        selectOutLineView.addSubview(topSelectedLabel)
        selectOutLineView.addSubview(bottomSelectedLabel)
        //初始化selectOutLineView中最开始时间，一开始didscroll方法中的visibleIndexs是空数组
        topSelectedLabel.center = CGPoint(x: selectOutLineView.frame.width/2, y: selectOutLineView.frame.height/2)
        topSelectedLabel.text = days[days.count/2].0
        
        dateCollectionView.delegate = self
        dateCollectionView.dataSource = self
        dateCollectionView.register(SmartDatePickerCell.classForCoder(), forCellWithReuseIdentifier: "SmartDatePickerCell")
        dateCollectionView.backgroundColor = UIColor.white
        dateCollectionView.showsVerticalScrollIndicator = false
        self.addSubview(dateCollectionView)
        dateCollectionView.reloadData()
        seletedDate = currentDate
    }
    override func layoutSubviews() {
        dateCollectionView.frame = self.bounds
        if let collectionViewFlowLayout = dateCollectionView.collectionViewLayout as? UICollectionViewFlowLayout{
            collectionViewFlowLayout.itemSize = CGSize(width: self.bounds.width, height: dateCellHeight)
            collectionViewFlowLayout.minimumLineSpacing = 0
            collectionViewFlowLayout.minimumInteritemSpacing = 0
        }
        selectOutLineView.frame.size = CGSize(width: 290/375*self.frame.width, height: dateCellHeight)
        selectOutLineView.center = CGPoint(x: self.frame.width/2, y: CGFloat(days.count)/2*dateCellHeight)
        topSelectedLabel.frame.size = selectOutLineView.frame.size
        bottomSelectedLabel.frame.size = selectOutLineView.frame.size
        topSelectedLabel.center = CGPoint(x: selectOutLineView.frame.width/2, y: selectOutLineView.frame.height/2)
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return days.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SmartDatePickerCell", for: indexPath) as! SmartDatePickerCell
        cell.dateLabel.text = days[indexPath.item].0
        return cell
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let rawCenterIndex = centerIndex
//        findCenterIndexPath()
//        dateCollectionView.reloadItems(at: [rawCenterIndex,centerIndex])
//        let centerCell = self.collectionView(dateCollectionView, cellForItemAt: centerIndex)
//        selectOutLineView.center = centerCell.center
        
        let centerOffsetY = dateCollectionView.frame.height/2+scrollView.contentOffset.y
        selectOutLineView.center = CGPoint(x: dateCollectionView.frame.width/2, y: centerOffsetY)
        
        let visibleIndexs = dateCollectionView.indexPathsForVisibleItems
//        let visibleCells = dateCollectionView.visibleCells
        
        for indexPath in visibleIndexs {
            let cell = self.collectionView(dateCollectionView, cellForItemAt: indexPath)
            if centerOffsetY - dateCellHeight < cell.center.y && centerOffsetY > cell.center.y{
                topSelectedLabel.text = days[indexPath.item].0
                topSelectedLabel.center = CGPoint(x: selectOutLineView.frame.width/2, y: cell.center.y-selectOutLineView.frame.origin.y)
            }
            if centerOffsetY + dateCellHeight > cell.center.y && centerOffsetY < cell.center.y{
                bottomSelectedLabel.text = days[indexPath.item].0
                bottomSelectedLabel.center = CGPoint(x: selectOutLineView.frame.width/2, y: cell.center.y-selectOutLineView.frame.origin.y)
            }
        }
//        if visibleCells.count == 0{
//            topSelectedLabel.text = ""
//            bottomSelectedLabel.text = ""
//        }else if visibleCells.count%2 == 0 {
//            topSelectedLabel.center = CGPoint(x: selectOutLineView.frame.width/2, y: visibleCells[visibleCells.count/2-1].center.y-selectOutLineView.center.y)
//            topSelectedLabel.text = days[visibleIndexs[visibleCells.count/2-1].item].0
//            bottomSelectedLabel.center = CGPoint(x: selectOutLineView.frame.width/2, y: visibleCells[visibleCells.count/2].center.y-selectOutLineView.center.y)
//            bottomSelectedLabel.text = days[visibleIndexs[visibleCells.count/2].item].0
//        }else if visibleCells.count%2 == 1{
//            topSelectedLabel.center = CGPoint(x: selectOutLineView.frame.width/2, y: visibleCells[visibleCells.count/2].center.y-selectOutLineView.center.y)
//            topSelectedLabel.text = days[visibleIndexs[visibleCells.count/2].item].0
//            bottomSelectedLabel.text = ""
//        }
        
        
        guard let firstIndexPath = dateCollectionView.indexPathsForVisibleItems.first else {
            return
        }
        if firstIndexPath.item <= 30{
            let firstDate = days.first!.1
            var previousDates = [(String,Date)]()
            for index in 1..<31 {
                let newDate = firstDate.addingTimeInterval(TimeInterval(-(31-index)*24*3600))
                previousDates.append(configDateStr(newDate),newDate)
            }
            days.insert(contentsOf: previousDates, at: 0)
            days.removeSubrange(90..<120)
            dateCollectionView.reloadData()
            dateCollectionView.contentOffset.y = dateCollectionView.contentOffset.y + dateCellHeight*CGFloat(30)
            return
        }
        if firstIndexPath.item >= 90{
            let endDate = days.last!.1
            var endDates = [(String,Date)]()
            for index in 1..<31 {
                let newDate = endDate.addingTimeInterval(TimeInterval(index*24*3600))
                endDates.append(configDateStr(newDate),newDate)
            }
            days.append(contentsOf: endDates)
            days.removeSubrange(0..<30)
            dateCollectionView.reloadData()
            dateCollectionView.contentOffset.y = dateCollectionView.contentOffset.y - dateCellHeight*CGFloat(30)
        }
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            makeCellCenter()
        }
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        makeCellCenter()
    }
    var centerIndex = IndexPath(item: 0, section: 0)
    func makeCellCenter(){
        findCenterIndexPath()
        dateCollectionView.scrollToItem(at: centerIndex, at: .centeredVertically, animated: true)
    }
    func findCenterIndexPath(){
        var distance = CGFloat.greatestFiniteMagnitude
        for indexPath in dateCollectionView.indexPathsForVisibleItems{
            let cell = self.collectionView(dateCollectionView, cellForItemAt: indexPath)
            let newDistance = abs(dateCollectionView.contentOffset.y+dateCollectionView.frame.height/2-cell.center.y)
            if newDistance < distance {
                distance = newDistance
                centerIndex = indexPath
            }
        }
    }
    func configDateStr(_ date:Date)->String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM月dd日 EEE"
        dateFormatter.locale = Locale(identifier: "zh_CN")
        return dateFormatter.string(from:date)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
