##iOS知识点快速回顾
一些可能比较生僻或零散的知识的总结；看懂这些代码对于相关知识的理解很有帮助，当然也有助于iOS面试

#### NEMainTableViewController
NEMainTableViewController为入口界面，包含知识点：
1. category方法覆盖相关注意点
2. load、initialize方法知识点
3. loadView方法使用示例



#### NEAnimationTestViewController
包含动画的知识点
1. 隐式动画、显示动画；如何及何时需要关闭隐式动画
2. 多个动画的衔接
3. spring动画
4. UIDynamic动画
5. 动画组


#### NETableViewTestViewController
包含tableview相关的一些知识点测试
1. tableView:heightForRowAtIndexPath在开始的时候回调用table的行数次


#### NELogPrintViewController
此类下展示了一些跟UI无关的测试，测试的NSLog被重定向到textview中；包括：
1. 全局变量如何在其他类中引用个改变
2. block的测试
3. GCD的一些测试

#### NEResponderViewController
主要演示了如何优雅地扩大一个按钮的点击区域，以及当一个子视图超出父视图范围后，如何响应点击事件，涉及到的知识点：
1. 响应链及事件处理
2. 通过自定义子类修改事件响应的默认行为
