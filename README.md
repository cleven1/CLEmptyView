# swift版本空界面处理

#### 本库采用链式语法编写，如果项目依赖MJRefresh可直接使用，如果不依赖MJRefresh删除项目中MJRefresh扩展文件即可,使用相当简单方便,可满足大众空界面需求,如果在使用的过程中,遇到问题,还请告知,感谢,如果对您有帮助,请star鼓励一下

![Markdown](http://i1.bvimg.com/628975/35e865ed2216aa8b.gif)

### 集成方式可以直接pod导入:
`pod 'CLEmptyView'`

## 使用方法:可一行代码,添加空界面和加载动画
```
tableView.normalEmptyView()
```
#### 下面是normalEmptyView的具体实现,写一个tableView的extension,配置需要显示的信息即可,外部可一句话调用,
```
extension UITableView {

public func normalEmptyView(){
config.clEmptyView.addEmptyImage(imageNmae: "empty")
.addEmptyTis(tips: NSAttributedString(string: "这是一个标题"))
.addLoadingImage(imageNames: ["timg"])
.addLoadingTips(tips: NSAttributedString(string: "正在加载中..."))
.addLoadingDuration(duration: 0.5) //默认1秒
.endConfig()
setUpEmptyView()
}
}
```

#### 扩展属性很多,都可以使用链式语法调用,进行配置,`切记`在配置完成后,最后必须调用`endConfig()`,才可以生效此配置

## 下面讲解一下如何在tableView中使用

```
tableView.normalEmptyView()
```
### 这句话已经为tableView添加了加载动画,和空界面展示,关闭加载动画显示,需要在网络请求完成的地方调用
```
self.tableView.successReload()
```
### or

```
self.tableView.failedReload()
```

### 如果需要单独管理加载动画,提供了一个属性
```
self.config.clEmptyView.setIsHiddenLoading = true
```

### 如果您的界面需要根据网络状态显示不同的占位图片,只需要在配置信息的地方按照网络状态给此函数赋值即可:
```
config.clEmptyView.setEmptyImage(imageName: "home_no_network", tips: tipsAtt)
```

## 更多使用方法,请看demo,或者直接看源码

