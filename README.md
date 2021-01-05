# XiuCaiAllSDK
XiuCaiAllSDK Description


## 需求第一步
把给到的10个第三方库，打包成自己的Framework

## 说明
1、创建framework项目：XiuCaiAllSDK

2、分解所有的第三方framework。(导入第三方的导入类库)

3、enable bitcode ： No
     mach-o type ： 静态库
     
4、修改 #import <> 改为 #import "“
      注释DWJQDialogHelper
      修改DWJQSVProgressHUD中冲突的变量名


## Author

kent, chengyakun11@163.com

## License

PodXiuCaiAllSDK is available under the MIT license. See the LICENSE file for more info.
