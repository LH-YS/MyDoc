# 记一次阿里云被ssh攻击，从崩溃到恢复的经历（作者LY）

## 一、前情提要

​	我有三个节点的测试集群正在尝试连续运行数仓ETL调度（写了个简单脚本每过几秒重复运行模拟数据生成的脚本），半夜三点多遭到攻击，这时笔者还不以为意，因为之前阿里云经常被攻击，上安全中心点击处理就能轻松搞定。

​	

​	第二天查看集群时发现大事不好：

​	1、xshell界面运行十分卡顿，连命令输入都要等很久

​	2、原先的服务除了hdfs外全部停止，并且进程出现很多意义不明的 --process information unavailable

​	3、无法切换用户。当使用su LY命令时不停刷屏，内容基本都是没有权限去打开文件等

​	

​	打开阿里云安全中心全是挖矿报警，手动在安全中心处理解决不了根本问题，报警像雨后春笋一般...

## 二、问题排查

​	在查阅了大量资料后发现网上没有和我一样的案例，所以我打算逐个排查。

​	首先在阿里云的安全组记录一下，然后全部删掉重新配置，只允许阿里云自带的shell访问，最底下的是云安全中心的安全组。

​	![image-20230929102642845](https://raw.githubusercontent.com/LH-YS/MyPicture/master/imgs/image-20230929102642845.png)

​	

​	然后只打开第一台机子通过阿里云Workbench进行连接，第一时间锁定用户，打开top观察进程情况：

```
passwd -l LY
top
```

​	在运行大约1-2分钟后，诡异的事情发生了：用户LY自己启动了n个ssh进程，安全中心开始报警恶意脚本+挖矿。笔者又重新启动服务器，top打开后直接su切换用户，报错信息大量刷屏，同时top观察到大量ssh又接踵而至。

​	这时笔者开始怀疑切换用户这个命令本身就有问题，进入用户的目录下观察文件

```
cd ../home/LY
ls -a
vim .bash_profile
vim .bashrc
vim .bash_logout
vim .ssh
vim .sshd
```

​	终于发现问题！其中.bash_profile和.bashrc的内容被替换为：

![](https://raw.githubusercontent.com/LH-YS/MyPicture/master/imgs/QQ%E5%9B%BE%E7%89%8720230929104925.png)

​	观察安全中心的处理详情，看看有没有漏网之鱼：

​	![image-20230929105325507](https://raw.githubusercontent.com/LH-YS/MyPicture/master/imgs/image-20230929105325507.png)



​	检查定时任务，果然定时任务中也有相同内容：

```
crontab -u root -l
crontab -u LY -l
```

​	最终得出结论：

​	攻击者植入脚本，修改用户的登录bash文件，添加定时任务，同时内部和外部疯狂进行ssh请求，结果就是bash文件加载后大量下载造成网络阻塞，开始挖矿，切换用户异常等等。



## 三、问题解决

​	定时任务和ssh登录同时会刷新彼此，只删除任何一边都会在一秒内重置，苦恼一阵后我发现可以打一个时间差。

​	linux中root用户先运行，然后定时任务才会触发，因此我先重启服务器，第一时间连接服务器并清除定时任务，删除.bash_profile和.bashrc的内容，然后覆盖重置这两个文件，打开top观察，如果没有问题用户的进程说明清除成功，解开用户即可~

```
crontab -u LY -r
crontab -u LY -l

cd ../home/LY
vim .bash_profile
vim .bashrc
cp /etc/skel/.bash_profile .
cp /etc/skel/.bashrc .

top

passwd -u LY
```



​	在另外两个机子上重复步骤，重新配置安全组，打开hadoop集群，排查损坏的数据块：

```
hdfs fsck /
```

​	至此终于全部解决了~~~