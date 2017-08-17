用UICollectionView做的一个日期选择器。
<br />
<img src="https://github.com/lyluoyuan/LYDatePicker/blob/master/SmartDatePicker.gif">
```
//创建
let datePicker = SmartDatePicker(frame: CGRect(x: 0, y: 100, width: 300, height: 200))
self.view.addSubview(datePicker)
//获取选择的日期
print(datePicker.seletedDate)
```