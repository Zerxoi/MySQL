# 3 DQL查询指令 2

## 3.1 `distinct`

```sql
// 查询结果集去重
// 使用 distinct 关键字去除重复记录
> select distinct job from emp;
+-----------+
| job       |
+-----------+
| CLERK     |
| SALESMAN  |
| MANAGER   |
| ANALYST   |
| PRESIDENT |
+-----------+

// distinct 关键字表示去除重复的联合字段
> select deptno, job from emp;
+--------+-----------+
| deptno | job       |
+--------+-----------+
|     20 | CLERK     |
|     30 | SALESMAN  |
|     30 | SALESMAN  |
|     20 | MANAGER   |
|     30 | SALESMAN  |
|     30 | MANAGER   |
|     10 | MANAGER   |
|     20 | ANALYST   |
|     10 | PRESIDENT |
|     30 | SALESMAN  |
|     20 | CLERK     |
|     30 | CLERK     |
|     20 | ANALYST   |
|     10 | CLERK     |
+--------+-----------+
> select distinct deptno, job from emp;
+--------+-----------+
| deptno | job       |
+--------+-----------+
|     20 | CLERK     |
|     30 | SALESMAN  |
|     20 | MANAGER   |
|     30 | MANAGER   |
|     10 | MANAGER   |
|     20 | ANALYST   |
|     10 | PRESIDENT |
|     30 | CLERK     |
|     10 | CLERK     |
+--------+-----------+

// 统计岗位的数量
> select count(distinct job) from emp;
+---------------------+
| count(distinct job) |
+---------------------+
|                   5 |
+---------------------+

// 分组函数中的表达式可以加 distinct 关键字
// 参见：https://dev.mysql.com/doc/refman/8.0/en/aggregate-functions.html
```

## 3.2 连接查询

在实际开发中，大部分情况下都不是从单表中查询数据，一般都是从多张表联合查询取出最终的结果。在实际开发中，一般一个业务都会对应多张表，因为如果将信息都存储到一张表的话，数据会存在大量的重复，导致数据的冗余。将多张表的数据连接起来查询就叫做连接查询。

### 3.2.1 链接查询的分类

根据语法出现的年代来划分：

- SQL92（一些老的DBA可能还在使用这种语法。DBA：Database Administrator，数据库管理员）
- SQL99（比较新的语法）

根据表的连接方式来划分

- 内连接
  - 等值连接
  - 非等值连接
  - 子链接
- 外连接
  - 左外连接（左连接）
  - 右外连接（右链接）
- 全连接

### 3.2.2 笛卡尔积现象

当两张表进行连接查询的时候，没有任何条件进行限制，最终的查询结果是两张表记录条数的乘积。

```sql
// 找出每一个员工的部门名称，要求显示员工名和部门名
> select ename,deptno from emp;
+--------+--------+
| ename  | deptno |
+--------+--------+
| SMITH  |     20 |
| ALLEN  |     30 |
| WARD   |     30 |
| JONES  |     20 |
| MARTIN |     30 |
| BLAKE  |     30 |
| CLARK  |     10 |
| SCOTT  |     20 |
| KING   |     10 |
| TURNER |     30 |
| ADAMS  |     20 |
| JAMES  |     30 |
| FORD   |     20 |
| MILLER |     10 |
+--------+--------+
14 rows in set (0.00 sec)
> select deptno,dname from dept;
+--------+------------+
| deptno | dname      |
+--------+------------+
|     10 | ACCOUNTING |
|     20 | RESEARCH   |
|     30 | SALES      |
|     40 | OPERATIONS |
+--------+------------+
4 rows in set (0.00 sec)
// 两张表的链接查询是两张表的笛卡尔积
> select ename, dname from emp, dept;
+--------+------------+
| ename  | dname      |
+--------+------------+
| SMITH  | ACCOUNTING |
| SMITH  | RESEARCH   |
| SMITH  | SALES      |
| SMITH  | OPERATIONS |
| ALLEN  | ACCOUNTING |
| ALLEN  | RESEARCH   |
| ALLEN  | SALES      |
| ALLEN  | OPERATIONS |
...
56 rows in set (0.00 sec)

// 查询指定表中的字段，执行效率高，可读性好
// 参考：https://dev.mysql.com/doc/refman/8.0/en/join.html
> select emp.ename, dept.dname from emp, dept;
> select e.ename, d.dname from emp e, dept d;

// 如何减少笛卡尔积现象？加条件进行过滤
// 添加了过滤条件会减少记录的匹配次数吗？不会，次数还是56次，只不过显示的是有效记录。
select e.ename, d.dname from emp e, dept d where e.deptno = d.deptno;
```

### 3.2.3 内连接

参考：[MySQL JOIN子句](https://dev.mysql.com/doc/refman/8.0/en/join.html)

```sql
// 等值连接：条件是等量关系
// 案例：查询每个员工的部门名称，要求显示员工名和部门名
// SQL92:
> select e.ename, d.dname from emp e, dept d where e.deptno = d.deptno;
+--------+------------+
| ename  | dname      |
+--------+------------+
| SMITH  | RESEARCH   |
| ALLEN  | SALES      |
| WARD   | SALES      |
| JONES  | RESEARCH   |
| MARTIN | SALES      |
| BLAKE  | SALES      |
| CLARK  | ACCOUNTING |
| SCOTT  | RESEARCH   |
| KING   | ACCOUNTING |
| TURNER | SALES      |
| ADAMS  | RESEARCH   |
| JAMES  | SALES      |
| FORD   | RESEARCH   |
| MILLER | ACCOUNTING |
+--------+------------+
// SQL99
> select e.ename, d.dname from emp e join dept d on e.deptno = d.deptno;
> select e.ename, d.dname from emp e inner join dept d on e.deptno = d.deptno;
+--------+------------+
| ename  | dname      |
+--------+------------+
| SMITH  | RESEARCH   |
| ALLEN  | SALES      |
| WARD   | SALES      |
| JONES  | RESEARCH   |
| MARTIN | SALES      |
| BLAKE  | SALES      |
| CLARK  | ACCOUNTING |
| SCOTT  | RESEARCH   |
| KING   | ACCOUNTING |
| TURNER | SALES      |
| ADAMS  | RESEARCH   |
| JAMES  | SALES      |
| FORD   | RESEARCH   |
| MILLER | ACCOUNTING |
+--------+------------+
SQL99语法结构更清晰一些：表的连接条件和后来的 where 条件分离。


// 非等值连接：表的连接条件是非等量关系
// 案例：找出每个员工的工资等级，要求显示员工名、工资、工资等级
> select ename, sal from emp;
+--------+---------+
| ename  | sal     |
+--------+---------+
| SMITH  |  800.00 |
| ALLEN  | 1600.00 |
| WARD   | 1250.00 |
| JONES  | 2975.00 |
| MARTIN | 1250.00 |
| BLAKE  | 2850.00 |
| CLARK  | 2450.00 |
| SCOTT  | 3000.00 |
| KING   | 5000.00 |
| TURNER | 1500.00 |
| ADAMS  | 1100.00 |
| JAMES  |  950.00 |
| FORD   | 3000.00 |
| MILLER | 1300.00 |
+--------+---------+
> select * from salgrade;
+-------+-------+-------+
| GRADE | LOSAL | HISAL |
+-------+-------+-------+
|     1 |   700 |  1200 |
|     2 |  1201 |  1400 |
|     3 |  1401 |  2000 |
|     4 |  2001 |  3000 |
|     5 |  3001 |  9999 |
+-------+-------+-------+
> select e.ename, e.sal, s.grade from emp e join salgrade s on (e.sal >= s.losal and e.sal <= s.hisal);
+--------+---------+-------+
| ename  | sal     | grade |
+--------+---------+-------+
| SMITH  |  800.00 |     1 |
| ALLEN  | 1600.00 |     3 |
| WARD   | 1250.00 |     2 |
| JONES  | 2975.00 |     4 |
| MARTIN | 1250.00 |     2 |
| BLAKE  | 2850.00 |     4 |
| CLARK  | 2450.00 |     4 |
| SCOTT  | 3000.00 |     4 |
| KING   | 5000.00 |     5 |
| TURNER | 1500.00 |     3 |
| ADAMS  | 1100.00 |     1 |
| JAMES  |  950.00 |     1 |
| FORD   | 3000.00 |     4 |
| MILLER | 1300.00 |     2 |
+--------+---------+-------+


// 子连接：一张表看作两张表，自己连接自己。
// 案例：找出每个员工的上级领导，要求显示员工名和对应的领导名。
> select empno, ename, mgr from emp;
+-------+--------+------+
| empno | ename  | mgr  |
+-------+--------+------+
|  7369 | SMITH  | 7902 |
|  7499 | ALLEN  | 7698 |
|  7521 | WARD   | 7698 |
|  7566 | JONES  | 7839 |
|  7654 | MARTIN | 7698 |
|  7698 | BLAKE  | 7839 |
|  7782 | CLARK  | 7839 |
|  7788 | SCOTT  | 7566 |
|  7839 | KING   | NULL |
|  7844 | TURNER | 7698 |
|  7876 | ADAMS  | 7788 |
|  7900 | JAMES  | 7698 |
|  7902 | FORD   | 7566 |
|  7934 | MILLER | 7782 |
+-------+--------+------+
> select e1.ename, e2.ename mgr from emp e1 join emp e2 on e1.mgr = e2.empno;
+--------+-------+
| ename  | mgr   |
+--------+-------+
| SMITH  | FORD  |
| ALLEN  | BLAKE |
| WARD   | BLAKE |
| JONES  | KING  |
| MARTIN | BLAKE |
| BLAKE  | KING  |
| CLARK  | KING  |
| SCOTT  | JONES |
| TURNER | BLAKE |
| ADAMS  | SCOTT |
| JAMES  | BLAKE |
| FORD   | JONES |
| MILLER | CLARK |
+--------+-------+
```

### 3.2.4 外连接

参考：[MySQL JOIN子句](https://dev.mysql.com/doc/refman/8.0/en/join.html)

内连接：假设A和B表进行连接，使用内连接的话，凡是A表和B表能够匹配上的记录查询出来，这就是内连接。A，B两表没有主副之分。
外连接：假设A和B表进行连接，使用外连接的话，AB两表中有一张是主表，另一张是副表，主要查询主表中的数据，捎带着查询副表，当副表中的数据没有和主表中的数据匹配上，附表自动模拟出 `NULL` 与之匹配。

外连接的分类：

- 左外连接（左连接）：左表是主表
- 右外连接（右连接）：右表是主表

左连接有右连接的写法，右连接有左连接的写法。

```sql
// 案例：找出每个员工的上级领导
> select e1.ename emp, e2.ename mgr from emp e1 left join emp e2 on e1.mgr = e2.empno;
// outer 可以省略
> select e1.ename emp, e2.ename mgr from emp e1 left outer join emp e2 on e1.mgr = e2.empno;
// 右连接的等价写法
> select e1.ename emp, e2.ename mgr from emp e2 right join emp e1 on e1.mgr = e2.empno;
+--------+-------+
| emp    | mgr   |
+--------+-------+
| SMITH  | FORD  |
| ALLEN  | BLAKE |
| WARD   | BLAKE |
| JONES  | KING  |
| MARTIN | BLAKE |
| BLAKE  | KING  |
| CLARK  | KING  |
| SCOTT  | JONES |
| KING   | NULL  |
| TURNER | BLAKE |
| ADAMS  | SCOTT |
| JAMES  | BLAKE |
| FORD   | JONES |
| MILLER | CLARK |
+--------+-------+


// 案例：找出哪个部门没有员工
> select dept.* from dept left join emp on dept.deptno = emp.deptno where emp.empno is null;
+--------+------------+--------+
| DEPTNO | DNAME      | LOC    |
+--------+------------+--------+
|     40 | OPERATIONS | BOSTON |
+--------+------------+--------+
```

### 3.2.5 多张表的连接

```sql
// 案例：找出每个员工的部门名称，以及工资等级
> select emp.ename, dept.dname from emp left join dept on emp.deptno = dept.deptno;
+--------+------------+
| ename  | dname      |
+--------+------------+
| SMITH  | RESEARCH   |
| ALLEN  | SALES      |
| WARD   | SALES      |
| JONES  | RESEARCH   |
| MARTIN | SALES      |
| BLAKE  | SALES      |
| CLARK  | ACCOUNTING |
| SCOTT  | RESEARCH   |
| KING   | ACCOUNTING |
| TURNER | SALES      |
| ADAMS  | RESEARCH   |
| JAMES  | SALES      |
| FORD   | RESEARCH   |
| MILLER | ACCOUNTING |
+--------+------------+
> select
    e.ename, d.dname, s.grade
from
    emp e
left join
    dept d
on
    e.deptno = d.deptno
left join
    salgrade s
on
    e.sal between s.losal and s.hisal;
+--------+------------+-------+
| ename  | dname      | grade |
+--------+------------+-------+
| SMITH  | RESEARCH   |     1 |
| ALLEN  | SALES      |     3 |
| WARD   | SALES      |     2 |
| JONES  | RESEARCH   |     4 |
| MARTIN | SALES      |     2 |
| BLAKE  | SALES      |     4 |
| CLARK  | ACCOUNTING |     4 |
| SCOTT  | RESEARCH   |     4 |
| KING   | ACCOUNTING |     5 |
| TURNER | SALES      |     3 |
| ADAMS  | RESEARCH   |     1 |
| JAMES  | SALES      |     1 |
| FORD   | RESEARCH   |     4 |
| MILLER | ACCOUNTING |     2 |
+--------+------------+-------+


// 案例：找出每个员工的部门名称，工资等级以及上级领导
> select
    e1.ename, d.dname, s.grade, e2.ename mgr
from
    emp e1
left join
    dept d
on
    e1.deptno = d.deptno
left join
    salgrade s
on
    e1.sal between s.losal and s.hisal
left join
    emp e2
on
    e1.mgr = e2.empno;
+--------+------------+-------+-------+
| ename  | dname      | grade | mgr   |
+--------+------------+-------+-------+
| SMITH  | RESEARCH   |     1 | FORD  |
| ALLEN  | SALES      |     3 | BLAKE |
| WARD   | SALES      |     2 | BLAKE |
| JONES  | RESEARCH   |     4 | KING  |
| MARTIN | SALES      |     2 | BLAKE |
| BLAKE  | SALES      |     4 | KING  |
| CLARK  | ACCOUNTING |     4 | KING  |
| SCOTT  | RESEARCH   |     4 | JONES |
| KING   | ACCOUNTING |     5 | NULL  |
| TURNER | SALES      |     3 | BLAKE |
| ADAMS  | RESEARCH   |     1 | SCOTT |
| JAMES  | SALES      |     1 | BLAKE |
| FORD   | RESEARCH   |     4 | JONES |
| MILLER | ACCOUNTING |     2 | CLARK |
+--------+------------+-------+-------+
```

## 3.3 子查询

参考：[MySQL 子查询](https://dev.mysql.com/doc/refman/8.0/en/subqueries.html)
子查询：`SELECT` 语句中嵌套 `SELECT` 语句。

```sql
// where 中使用子查询
// 案例：找出高于平均薪资的员工信息
// 1. 找出平均薪资
> select avg(sal) from emp;
+-------------+
| avg(sal)    |
+-------------+
| 2073.214286 |
+-------------+
// 2. 找出高于平均工资的员工
> select emp.* from emp where sal > (select avg(sal) from emp);
+-------+-------+-----------+------+------------+---------+------+--------+
| EMPNO | ENAME | JOB       | MGR  | HIREDATE   | SAL     | COMM | DEPTNO |
+-------+-------+-----------+------+------------+---------+------+--------+
|  7566 | JONES | MANAGER   | 7839 | 1981-04-02 | 2975.00 | NULL |     20 |
|  7698 | BLAKE | MANAGER   | 7839 | 1981-05-01 | 2850.00 | NULL |     30 |
|  7782 | CLARK | MANAGER   | 7839 | 1981-06-09 | 2450.00 | NULL |     10 |
|  7788 | SCOTT | ANALYST   | 7566 | 1987-04-19 | 3000.00 | NULL |     20 |
|  7839 | KING  | PRESIDENT | NULL | 1981-11-17 | 5000.00 | NULL |     10 |
|  7902 | FORD  | ANALYST   | 7566 | 1981-12-03 | 3000.00 | NULL |     20 |
+-------+-------+-----------+------+------------+---------+------+--------+


// from 中使用子查询
// 案例：找出每个部门的平均薪水的薪资等级
// 1. 每个部门的平均薪资
> select deptno, avg(sal) as avgsal from emp group by deptno;
+--------+-------------+
| deptno | avgsal      |
+--------+-------------+
|     20 | 2175.000000 |
|     30 | 1566.666667 |
|     10 | 2916.666667 |
+--------+-------------+
// 2. 将上面的查询结果当作临时表t，让t表和salgrade s表连接，条件是t.avgsal between  s.losal and hisal.
> select t.*, s.grade from (select deptno, avg(sal) avgsal from emp group by deptno) t join salgrade s on t.avgsal between s.losal and s.hisal;
+--------+-------------+-------+
| deptno | avgsal      | grade |
+--------+-------------+-------+
|     20 | 2175.000000 |     4 |
|     30 | 1566.666667 |     3 |
|     10 | 2916.666667 |     4 |
+--------+-------------+-------+

// 案例：找出每个部门平均的薪水等级
// 1. 找个各个部门的各员工工资等级
> select e.deptno, s.grade from emp e join salgrade s on e.sal between s.losal and s.hisal;
+--------+-------+
| deptno | grade |
+--------+-------+
|     20 |     1 |
|     30 |     3 |
|     30 |     2 |
|     20 |     4 |
|     30 |     2 |
|     30 |     4 |
|     10 |     4 |
|     20 |     4 |
|     10 |     5 |
|     30 |     3 |
|     20 |     1 |
|     30 |     1 |
|     20 |     4 |
|     10 |     2 |
+--------+-------+

> select t.deptno, avg(t.grade) from (select e.deptno, s.grade from emp e join salgrade s on e.sal between s.losal and s.hisal) t group by t.deptno;
// 升级：不把上表当作临时表，直接 group by
> select
e.deptno, avg(s.grade)
from
emp e
join
salgrade s
on
e.sal between s.losal and s.hisal
group by
e.deptno;
+--------+--------------+
| deptno | avg(s.grade) |
+--------+--------------+
|     20 |       2.8000 |
|     30 |       2.5000 |
|     10 |       3.6667 |
+--------+--------------+



// select 中使用子查询
// 找出每个员工所在的部门名称，要求显示员工名和部门名
> select e.ename, d.dname from emp e join dept d where e.deptno = d.deptno;
+--------+------------+
| ename  | dname      |
+--------+------------+
| SMITH  | RESEARCH   |
| ALLEN  | SALES      |
| WARD   | SALES      |
| JONES  | RESEARCH   |
| MARTIN | SALES      |
| BLAKE  | SALES      |
| CLARK  | ACCOUNTING |
| SCOTT  | RESEARCH   |
| KING   | ACCOUNTING |
| TURNER | SALES      |
| ADAMS  | RESEARCH   |
| JAMES  | SALES      |
| FORD   | RESEARCH   |
| MILLER | ACCOUNTING |
+--------+------------+
// 不实用
> select e.ename, (select d.dname from dept d where e.deptno = d.deptno) as dename from emp e;
+--------+------------+
| ename  | dename     |
+--------+------------+
| SMITH  | RESEARCH   |
| ALLEN  | SALES      |
| WARD   | SALES      |
| JONES  | RESEARCH   |
| MARTIN | SALES      |
| BLAKE  | SALES      |
| CLARK  | ACCOUNTING |
| SCOTT  | RESEARCH   |
| KING   | ACCOUNTING |
| TURNER | SALES      |
| ADAMS  | RESEARCH   |
| JAMES  | SALES      |
| FORD   | RESEARCH   |
| MILLER | ACCOUNTING |
+--------+------------+
```

## 3.4 `UNION`

参考：[MySQL UNION子句](https://dev.mysql.com/doc/refman/8.0/en/union.html)

UNION：将查询结果集相加

```sql
// 案例：找出工作岗位是 salesman 和 manager 的员工
> select ename, job from emp where job = 'salesman' union select ename, job from emp where job = 'manager';
+--------+----------+
| ename  | job      |
+--------+----------+
| ALLEN  | SALESMAN |
| WARD   | SALESMAN |
| MARTIN | SALESMAN |
| TURNER | SALESMAN |
| JONES  | MANAGER  |
| BLAKE  | MANAGER  |
| CLARK  | MANAGER  |
+--------+----------+
> select ename, job from emp where job = 'salesman' or job = 'manager';
> select ename, job from emp where job in ('salesman' ,'manager');
+--------+----------+
| ename  | job      |
+--------+----------+
| ALLEN  | SALESMAN |
| WARD   | SALESMAN |
| JONES  | MANAGER  |
| MARTIN | SALESMAN |
| BLAKE  | MANAGER  |
| CLARK  | MANAGER  |
| TURNER | SALESMAN |
+--------+----------+

// 将两个不相干的表中的数据拼接在一起显示(前提，union 前后的表列数一样)
> select ename from emp union select dname from dept;
+------------+
| ename      |
+------------+
| SMITH      |
| ALLEN      |
| WARD       |
| JONES      |
| MARTIN     |
| BLAKE      |
| CLARK      |
| SCOTT      |
| KING       |
| TURNER     |
| ADAMS      |
| JAMES      |
| FORD       |
| MILLER     |
| ACCOUNTING |
| RESEARCH   |
| SALES      |
| OPERATIONS |
+------------+

> select ename, job from emp union select dname from dept;
ERROR 1222 (21000): The used SELECT statements have a different number of columns
```

## 3.5 `LIMIT`

limit 是MySQL特有的，其他数据中没有，不通用。Oracle中有一个相同的机制，叫做 rownum。limit 的作用是结果集中的部分数据。limit是SQL语句执行的最后一个环节。

语法：`LIMIT {[offset,] row_count | row_count OFFSET offset}`

```sql
// 案例：取出工资前5名的员工
> select ename, sal from emp order by sal desc limit 5;
> select ename, sal from emp order by sal desc limit 0, 5;
+-------+---------+
| ename | sal     |
+-------+---------+
| KING  | 5000.00 |
| FORD  | 3000.00 |
| SCOTT | 3000.00 |
| JONES | 2975.00 |
| BLAKE | 2850.00 |
+-------+---------+

// 案例：找出工资第4到第9名的员工
> select ename, sal from emp order by sal desc limit 3, 6;
+--------+---------+
| ename  | sal     |
+--------+---------+
| JONES  | 2975.00 |
| BLAKE  | 2850.00 |
| CLARK  | 2450.00 |
| ALLEN  | 1600.00 |
| TURNER | 1500.00 |
| MILLER | 1300.00 |
+--------+---------+

每页显示pageSize条记录
第pageNo页：(pageNo - 1) * pageSize, pageSize
```
