# HiveSQL个人笔记（作者LY）

## 一、简介

​	本笔记用来记录个人的HiveSQL练习，以题目为单位记录各个练习从子查询到最后组装的过程。

​	暂不分类别，对于题目中可能用到的DDL语句放在第三板块。

​	后期计划更新题目索引、难度区分，持续更新中......



## 二、题目

###### 1、查询出没有学全所有课的学生的学号、姓名

```hive
--课程类数
select count(*)
from course_info;

--筛选出id
select stu_id,count(stu_id)
from score_info
group by stu_id
having count(stu_id) < (select count(*)
from course_info);

--最后组装
select t1.stu_id,s1.stu_name
from (select stu_id,count(stu_id)
from score_info
group by stu_id
having count(stu_id) < (select count(*)
from course_info)) t1 left join student_info s1 on t1.stu_id = s1.stu_id
order by t1.stu_id
```



###### 2、查询出只选修了三门课程的全部学生的学号和姓名

```hive
--筛选id
select stu_id,count(stu_id)
from score_info
group by stu_id
having count(stu_id) = 3;
--组装
select t1.stu_id,s1.stu_name
from (select stu_id,count(stu_id)
from score_info
group by stu_id
having count(stu_id) = 3) t1
    left join student_info s1 on t1.stu_id = s1.stu_id
order by stu_id asc;
```



###### 3、查询所有学生的学号、姓名、选课数、总成绩

```hive
select s1.stu_id,s1.stu_name,count(t1.course_id) cource_num,nvl(sum(t1.score),0) score_sum
from student_info s1 left join score_info t1 on t1.stu_id = s1.stu_id
group by s1.stu_id,s1.stu_name
order by s1.stu_id;
```

这里贴出之前写错的：

首先重复select了，可以直接join；最重要的是，这样会获取不到没考试的学生信息，想要获取所有的学生信息需要以学生表为主表进行join，并且select中要选主表的id

```hive
--运行错误的，获取不到没考试的学生信息
select t1.stu_id,s1.stu_name,t1.cource_num,t1.score_sum
from (select stu_id,count(stu_id) cource_num,nvl(sum(score),0) score_sum
from score_info
group by stu_id) t1
    left join student_info s1 on t1.stu_id = s1.stu_id
order by stu_id;
```



###### 4、查询学生的选课情况：学号，姓名，课程号，课程名称

```hive
select si.stu_id,si.stu_name,ci.course_id,ci.course_name
from student_info si left join score_info on score_info.stu_id = si.stu_id
left join course_info ci on score_info.course_id = ci.course_id
order by si.stu_id
```



###### 5、查询课程编号为03且课程成绩在80分以上的学生的学号和姓名及课程信息

```hive
--第一种实现，先join大表，再查
select si.stu_id,si.stu_name,ci.course_id,ci.course_name,sc.score
from score_info sc left join student_info si on sc.stu_id = si.stu_id
left join course_info ci on sc.course_id = ci.course_id
where ci.course_id = 03 and sc.score > 80

--第二种更好一些，先查再join
select
    s.stu_id,
    s.stu_name,
    t1.score,
    t1.course_id,
    c.course_name
from student_info s
join (
    select
        stu_id,
        score,
        course_id
    from score_info
    where score > 80 and course_id = '03'
    ) t1
on s.stu_id = t1.stu_id
join course_info c on c.course_id = t1.course_id;

```



###### 6、查询所有课程成绩在70分以上的学生的姓名、课程名称和分数，按分数升序排列

思路是做个flag，如果所有成绩都大于70则flag和为0，起到筛选的作用。

这里要注意，left join和join的区别。join的话可以得笛卡尔积。

```hive
--筛选
select stu_id,
       sum(if(score>70,0,1)) flag
from score_info
group by stu_id
having flag = 0;
--组装sql，注意join
select si.stu_name,ci.course_name,sc.score
from student_info si
    join (select stu_id,
       sum(if(score>70,0,1)) flag
from score_info
group by stu_id
having flag = 0) t1 on si.stu_id=t1.stu_id
    join score_info sc on sc.stu_id = si.stu_id
    left join course_info ci on sc.course_id = ci.course_id
order by sc.score asc;
```

###### 7、查询该学生不同课程的成绩相同的学生编号、课程编号、学生成绩

这道题考察笛卡尔积

```hive
select s1.stu_id,s1.course_id,s1.score
from score_info s1 join score_info s2 on s1.stu_id = s2.stu_id
where s1.course_id <> s2.course_id and s1.score == s2.score
```

###### 8、查询课程编号为“01”的课程比“02”的课程成绩高的所有学生的学号

先查询两个表，然后inner join

```hive
select t1.stu_id
from (select stu_id,course_id,score
from score_info
where course_id = '01') t1
    inner join (select stu_id,course_id,score
from score_info
where course_id = '02') t2 on t1.stu_id = t2.stu_id
where t1.score > t2.score;
```

###### 9、查询学过编号为“01”的课程并且也学过编号为“02”的课程的学生的学号、姓名

```hive
--先求id列表
select stu_id
from score_info
where course_id = '01';
--再用于筛选
select stu_id
from score_info
where stu_id in (select stu_id
from score_info
where course_id = '01') and course_id = '02';
--组装
select t1.stu_id,si.stu_name
from (
    select stu_id
from score_info
where stu_id in (select stu_id
from score_info
where course_id = '01') and course_id = '02'
     ) t1 left join student_info si on t1.stu_id = si.stu_id;
```

###### 10、查询学过“李体音”老师所教的所有课的同学的学号、姓名

这道题做错很多次，关键在于t1不能left join stu表，以及不能嵌套太多in

```hive
select t2.stu_id,si.stu_name
 from
(select t1.stu_id,count(t1.stu_id)
from (
    select stu_id
    from score_info
    where course_id in (
        select ci.course_id
        from course_info ci
        left join teacher_info ti on ci.tea_id = ti.tea_id
        where ti.tea_name = '李体音'
        )) t1
group by t1.stu_id
having count(t1.stu_id) = (
    select count(course_id)
        from course_info ci left join teacher_info t on ci.tea_id = t.tea_id
        where t.tea_name = '李体音'))t2 left join student_info si on t2.stu_id = si.stu_id;
```

###### 11、查询至少有一门课与学号为“001”的学生所学课程相同的学生的学号和姓名

```
select
    si.stu_id,
    si.stu_name
from score_info sc
join student_info si
on sc.stu_id = si.stu_id
where sc.course_id in
(
    select
        course_id
    from score_info
    where stu_id='001'    
) and sc.stu_id <> '001'  
group by si.stu_id,si.stu_name;

```

