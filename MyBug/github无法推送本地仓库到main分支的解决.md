# github无法推送本地仓库到main分支的解决（作者LY）



**问题描述：**

​		多年前刚接触github的时候默认分支还是master，最近上传一些作品和笔记的时候发现无法推送到main分支。而网上的教程还是原来的master分支，官网的文档也没找到，最后在外网论坛上找到了解决方案。

现在的主分支：

![image-20231015212820376](https://raw.githubusercontent.com/LH-YS/MyPicture/master/imgs/image-20231015212820376.png)

实现以下代码时报错：

```shell
git init
git add .
git commit -m "first commit"
git push -u origin main
```

错误信息：

![image-20231015220029916](https://raw.githubusercontent.com/LH-YS/MyPicture/master/imgs/image-20231015220029916.png)

​	目前网上大部分的方法是针对master默认分支的版本，不适用

**解决方法：**

```shell
git checkout -b main
git push --set-upstream origin main
```

​	第一句是创建一个名为main的分支，与正在工作的分支相同。

​	第二句--set-upstream是切换新分支提交时使用的。

​	