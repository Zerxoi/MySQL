# 2 DQL查询指令

[文档语法约定](http://www.searchdoc.cn/rdbms/mysql/dev.mysql.com/doc/refman/5.7/en/manual-conventions.com.coder114.cn.html)

语法格式：[MySQL文档 SELECT语句](https://dev.mysql.com/doc/refman/8.0/en/select.html)

执行顺序：先`from`，再`where`，再`group by`，再`select`，最后`order by`。

```sql
            执行顺序
SELECT          5
    ...
FROM            1
    ...
WHERE           2
    ...
GROUP BY        3
    ...
HAVING          4
    ...
ORDER BY        6
    ...
LIMIT           7
    ...
```

注意：

- 分组函数自动忽略 `null`，因此不需要添加 `where field is not null` 的过滤条件。
- 包含 `null` 的数学运算的结果为 `null`
- `count(*)` 表示表中总记录的条数， `count(field)` 表示这个字段中不为 `null` 的记录条数。
- 能现在 `where` 过滤就现在 `where` 过滤，会提高分组函数效率；否则只能在 `having` 过滤

## 2.1 简单的查询（DQL）

语法格式：`SELECT select_expr1, select_expr2, ... FROM table_references;`

提示：

1. SQL以分号`;`结尾
2. SQL语句不区分大小写

```sql
// 查询员工工号和名字
> select empno, ename from emp;
+-------+--------+
| empno | ename  |
+-------+--------+
|  7369 | SMITH  |
|  7499 | ALLEN  |
|  7521 | WARD   |
|  7566 | JONES  |
|  7654 | MARTIN |
|  7698 | BLAKE  |
|  7782 | CLARK  |
|  7788 | SCOTT  |
|  7839 | KING   |
|  7844 | TURNER |
|  7876 | ADAMS  |
|  7900 | JAMES  |
|  7902 | FORD   |
|  7934 | MILLER |
+-------+--------+

// 查询员工名字和年薪
// 字段可以参与数学运算
> select ename,sal * 12 from emp;
+--------+----------+
| ename  | sal * 12 |
+--------+----------+
| SMITH  |  9600.00 |
| ALLEN  | 19200.00 |
| WARD   | 15000.00 |
| JONES  | 35700.00 |
| MARTIN | 15000.00 |
| BLAKE  | 34200.00 |
| CLARK  | 29400.00 |
| SCOTT  | 36000.00 |
| KING   | 60000.00 |
| TURNER | 18000.00 |
| ADAMS  | 13200.00 |
| JAMES  | 11400.00 |
| FORD   | 36000.00 |
| MILLER | 15600.00 |
+--------+----------+

// 查询结果列重命名
> select ename,sal * 12 as yearsal from emp;
+--------+----------+
| ename  | yearsal  |
+--------+----------+
| SMITH  |  9600.00 |
| ALLEN  | 19200.00 |
| WARD   | 15000.00 |
| JONES  | 35700.00 |
| MARTIN | 15000.00 |
| BLAKE  | 34200.00 |
| CLARK  | 29400.00 |
| SCOTT  | 36000.00 |
| KING   | 60000.00 |
| TURNER | 18000.00 |
| ADAMS  | 13200.00 |
| JAMES  | 11400.00 |
| FORD   | 36000.00 |
| MILLER | 15600.00 |
+--------+----------+

// 列中文重命名
// 表中SQL语句中，字符串用单引号，MySQL支持单双引号，但是双引号不通用
> select ename,sal * 12 as '年薪' from emp;
+--------+----------+
| ename  | 年薪     |
+--------+----------+
| SMITH  |  9600.00 |
| ALLEN  | 19200.00 |
| WARD   | 15000.00 |
| JONES  | 35700.00 |
| MARTIN | 15000.00 |
| BLAKE  | 34200.00 |
| CLARK  | 29400.00 |
| SCOTT  | 36000.00 |
| KING   | 60000.00 |
| TURNER | 18000.00 |
| ADAMS  | 13200.00 |
| JAMES  | 11400.00 |
| FORD   | 36000.00 |
| MILLER | 15600.00 |
+--------+----------+

// as 关键字可以省略
> select ename '姓名',sal * 12 '年薪' from emp;
+--------+----------+
| 姓名   | 年薪     |
+--------+----------+
| SMITH  |  9600.00 |
| ALLEN  | 19200.00 |
| WARD   | 15000.00 |
| JONES  | 35700.00 |
| MARTIN | 15000.00 |
| BLAKE  | 34200.00 |
| CLARK  | 29400.00 |
| SCOTT  | 36000.00 |
| KING   | 60000.00 |
| TURNER | 18000.00 |
| ADAMS  | 13200.00 |
| JAMES  | 11400.00 |
| FORD   | 36000.00 |
| MILLER | 15600.00 |
+--------+----------+

// 查看所有字段
// 但是不建议使用`*`,效率比较低
> select * from emp;
+-------+--------+-----------+------+------------+---------+---------+--------+
| EMPNO | ENAME  | JOB       | MGR  | HIREDATE   | SAL     | COMM    | DEPTNO |
+-------+--------+-----------+------+------------+---------+---------+--------+
|  7369 | SMITH  | CLERK     | 7902 | 1980-12-17 |  800.00 |    NULL |     20 |
|  7499 | ALLEN  | SALESMAN  | 7698 | 1981-02-20 | 1600.00 |  300.00 |     30 |
|  7521 | WARD   | SALESMAN  | 7698 | 1981-02-22 | 1250.00 |  500.00 |     30 |
|  7566 | JONES  | MANAGER   | 7839 | 1981-04-02 | 2975.00 |    NULL |     20 |
|  7654 | MARTIN | SALESMAN  | 7698 | 1981-09-28 | 1250.00 | 1400.00 |     30 |
|  7698 | BLAKE  | MANAGER   | 7839 | 1981-05-01 | 2850.00 |    NULL |     30 |
|  7782 | CLARK  | MANAGER   | 7839 | 1981-06-09 | 2450.00 |    NULL |     10 |
|  7788 | SCOTT  | ANALYST   | 7566 | 1987-04-19 | 3000.00 |    NULL |     20 |
|  7839 | KING   | PRESIDENT | NULL | 1981-11-17 | 5000.00 |    NULL |     10 |
|  7844 | TURNER | SALESMAN  | 7698 | 1981-09-08 | 1500.00 |    0.00 |     30 |
|  7876 | ADAMS  | CLERK     | 7788 | 1987-05-23 | 1100.00 |    NULL |     20 |
|  7900 | JAMES  | CLERK     | 7698 | 1981-12-03 |  950.00 |    NULL |     30 |
|  7902 | FORD   | ANALYST   | 7566 | 1981-12-03 | 3000.00 |    NULL |     20 |
|  7934 | MILLER | CLERK     | 7782 | 1982-01-23 | 1300.00 |    NULL |     10 |
+-------+--------+-----------+------+------------+---------+---------+--------+
```

## 2.2 条件查询

语法格式：`SELECT select_expr1, select_expr2 , ... FROM table_references WHERE where_condition;`

[MySQL文档 运算符](https://dev.mysql.com/doc/refman/8.0/en/non-typed-operators.html)

```sql
// 查询工资为5000的员工姓名
> select ename from emp where sal = 5000;
+-------+
| ename |
+-------+
| KING  |
+-------+

// 查询员工smith的工资
> select sal from emp where ename = 'smith';
+--------+
| sal    |
+--------+
| 800.00 |
+--------+

// 找出工资高于3000的员工
> select ename from emp where sal > 3000;
+-------+
| ename |
+-------+
| KING  |
+-------+

// 找出工资在1100至3000的员工（包括1100和3000）
> select ename from emp where sal between 1100 and 3000;
> select ename from emp where sal >= 1100 and sal <= 3000;
+--------+
| ename  |
+--------+
| ALLEN  |
| WARD   |
| JONES  |
| MARTIN |
| BLAKE  |
| CLARK  |
| SCOTT  |
| TURNER |
| ADAMS  |
| FORD   |
| MILLER |
+--------+

// 找出没有津贴的员工
// 数据库当中的 null 不是一个值，代表什么也没有，为空
// null 必须用 is null 或者 is not null 运算符计算
> select ename from emp where comm is null or comm = 0;
+--------+
| ename  |
+--------+
| SMITH  |
| JONES  |
| BLAKE  |
| CLARK  |
| SCOTT  |
| KING   |
| TURNER |
| ADAMS  |
| JAMES  |
| FORD   |
| MILLER |
+--------+

// 找出工作岗位是manager和salesman的员工
> select ename, job from emp where job = 'manager' or job  = 'salesman';
> select ename, job from emp where job in ('manager', 'salesman');
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

// 找出工资大于1000并且部门编号是20或30的员工
> select ename, sal, deptno from emp where sal > 1000 and (deptno = 20 or deptno = 30);
+--------+---------+--------+
| ename  | sal     | deptno |
+--------+---------+--------+
| ALLEN  | 1600.00 |     30 |
| WARD   | 1250.00 |     30 |
| JONES  | 2975.00 |     20 |
| MARTIN | 1250.00 |     30 |
| BLAKE  | 2850.00 |     30 |
| SCOTT  | 3000.00 |     20 |
| TURNER | 1500.00 |     30 |
| ADAMS  | 1100.00 |     20 |
| FORD   | 3000.00 |     20 |
+--------+---------+--------+

// 模糊查询 like
// % ：任意多个字符
// _ ：任意一个字符

// 找出名字中含有 o 的员工
> select ename from emp where ename like '%o%';
+-------+
| ename |
+-------+
| JONES |
| SCOTT |
| FORD  |
+-------+

// 找出第二个字母是 a 的员工
> select ename from emp where ename like '_a%';
+--------+
| ename  |
+--------+
| WARD   |
| MARTIN |
| JAMES  |
+--------+

// 找出名字中含有 _ 的员工
> select ename from emp where ename like '%\_%';

// 找出名字最后一个字符是 t 的员工
> select ename from emp where ename like '%t';
```

## 2.3 排序（升序，降序）

```sql
// order by 关键字
// 升序 asc 默认
// 降序 desc

// 按照工资升序找出员工名和薪资
> select ename, sal from emp order by sal;
> select ename, sal from emp order by sal asc;
+--------+---------+
| ename  | sal     |
+--------+---------+
| SMITH  |  800.00 |
| JAMES  |  950.00 |
| ADAMS  | 1100.00 |
| WARD   | 1250.00 |
| MARTIN | 1250.00 |
| MILLER | 1300.00 |
| TURNER | 1500.00 |
| ALLEN  | 1600.00 |
| CLARK  | 2450.00 |
| BLAKE  | 2850.00 |
| JONES  | 2975.00 |
| SCOTT  | 3000.00 |
| FORD   | 3000.00 |
| KING   | 5000.00 |
+--------+---------+

// 员工按照工资的升序排，工资一样的按照名字的降序排
> select ename, sal from emp order by sal asc, ename desc;
// 可以用位置替代要排序的字段
> select ename, sal from emp order by 2 asc, 1 desc;
+--------+---------+
| ename  | sal     |
+--------+---------+
| SMITH  |  800.00 |
| JAMES  |  950.00 |
| ADAMS  | 1100.00 |
| WARD   | 1250.00 |
| MARTIN | 1250.00 |
| MILLER | 1300.00 |
| TURNER | 1500.00 |
| ALLEN  | 1600.00 |
| CLARK  | 2450.00 |
| BLAKE  | 2850.00 |
| JONES  | 2975.00 |
| SCOTT  | 3000.00 |
| FORD   | 3000.00 |
| KING   | 5000.00 |
+--------+---------+

// 找出工作是 salesman 的员工并且按工资降序排列
> select ename, job, sal from emp where job = 'salesman' order by sal desc;
+--------+----------+---------+
| ename  | job      | sal     |
+--------+----------+---------+
| ALLEN  | SALESMAN | 1600.00 |
| TURNER | SALESMAN | 1500.00 |
| WARD   | SALESMAN | 1250.00 |
| MARTIN | SALESMAN | 1250.00 |
+--------+----------+---------+
```

## 2.4 分组函数/聚类函数

[MySQL文档 聚类函数](https://dev.mysql.com/doc/refman/8.0/en/aggregate-functions.html)

注：所有分组函数都是对某一组数据进行操作的

多行处理函数：输入多行，输出一行

```sql
// 找出工资总和
> select sum(sal) from emp;
+----------+
| sum(sal) |
+----------+
| 29025.00 |
+----------+

// 找出最高工资
> select max(sal) from emp;
+----------+
| max(sal) |
+----------+
|  5000.00 |
+----------+

// 找出最低工资
> select min(sal) from emp;
+----------+
| min(sal) |
+----------+
|   800.00 |
+----------+

// 找出平均工资
> select avg(sal) from emp;
+-------------+
| avg(sal)    |
+-------------+
| 2073.214286 |
+-------------+

// 找出总人数
> select count(empno) from emp;
+--------------+
| count(empno) |
+--------------+
|           14 |
+--------------+
> select count(*) from emp;
+----------+
| count(*) |
+----------+
|       14 |
+----------+

// 除非另有说明，否则聚合函数将忽略NULL值。
> select comm from emp;
+---------+
| comm    |
+---------+
|    NULL |
|  300.00 |
|  500.00 |
|    NULL |
| 1400.00 |
|    NULL |
|    NULL |
|    NULL |
|    NULL |
|    0.00 |
|    NULL |
|    NULL |
|    NULL |
|    NULL |
+---------+
> select count(comm) from emp;
+-------------+
| count(comm) |
+-------------+
|           4 |
+-------------+

// 计算每个员工的年薪
// 只要数学表达式中有 null，表达式返回的结果是 null
> select ename, (sal+comm)*12 as yearsal from emp;
+--------+----------+
| ename  | yearsal  |
+--------+----------+
| SMITH  |     NULL |
| ALLEN  | 22800.00 |
| WARD   | 21000.00 |
| JONES  |     NULL |
| MARTIN | 31800.00 |
| BLAKE  |     NULL |
| CLARK  |     NULL |
| SCOTT  |     NULL |
| KING   |     NULL |
| TURNER | 18000.00 |
| ADAMS  |     NULL |
| JAMES  |     NULL |
| FORD   |     NULL |
| MILLER |     NULL |
+--------+----------+
// 单行处理函数：输入一行，输出一行
// `ifnull(expr1, expr2)` 如果 `expr1` 为 `null`， 返回 `expr2`；如果 `expr1` 不为 `null`，返回 `expr1`。
> select ename, (sal + ifnull(comm, 0)) * 12 as yearsal from emp;
+--------+----------+
| ename  | yearsal  |
+--------+----------+
| SMITH  |  9600.00 |
| ALLEN  | 22800.00 |
| WARD   | 21000.00 |
| JONES  | 35700.00 |
| MARTIN | 31800.00 |
| BLAKE  | 34200.00 |
| CLARK  | 29400.00 |
| SCOTT  | 36000.00 |
| KING   | 60000.00 |
| TURNER | 18000.00 |
| ADAMS  | 13200.00 |
| JAMES  | 11400.00 |
| FORD   | 36000.00 |
| MILLER | 15600.00 |
+--------+----------+

// 找出工资高于平均工资的员工
> select ename, sal from emp where sal > avg(sal);
ERROR 1111 (HY000): Invalid use of group function
原因：SQL语句当中有一个语法规则，分组函数不可直接使用在 `where` 子句当中。因为 `group by` 是在 `where` 之后执行的，分组函数要在 `group by` 执行之后执行，所以分组函数不能在 `where` 子句中执行。

1. 找出平均工资
> select avg(sal) from emp;
+-------------+
| avg(sal)    |
+-------------+
| 2073.214286 |
+-------------+
2. 找出高于平均工资的员工
> select ename, sal from emp where sal > 2073.214286;
+-------+---------+
| ename | sal     |
+-------+---------+
| JONES | 2975.00 |
| BLAKE | 2850.00 |
| CLARK | 2450.00 |
| SCOTT | 3000.00 |
| KING  | 5000.00 |
| FORD  | 3000.00 |
+-------+---------+
3. 合并（子查询：select 语句嵌套 select 语句）
> select ename, sal from emp where sal > (select avg(sal) from emp);

// 使用多个分组函数
> select count(ename), sum(sal), avg(comm) from emp;
+--------------+----------+------------+
| count(ename) | sum(sal) | avg(comm)  |
+--------------+----------+------------+
|           14 | 29025.00 | 550.000000 |
+--------------+----------+------------+
 ```

## 2.5 `group by`

`group by`:按照某个字段或者某些字段进行分组。

```sql
> select job, max(sal) from emp group by job;
+-----------+----------+
| job       | max(sal) |
+-----------+----------+
| CLERK     |  1300.00 |
| SALESMAN  |  1600.00 |
| MANAGER   |  2975.00 |
| ANALYST   |  3000.00 |
| PRESIDENT |  5000.00 |
+-----------+----------+

注：分组函数一般都会和 `group by` 联合使用，这也是为什么他被成为分组函数的原因。并且任何一个分组函数都是在 `group by` 语句执行结束之后才会执行的；当一条SQL语句没有 `group by` 的话，整张表的数据会自成一组。

// ename  字段的值没有意义
// 这条语句在 Oracle 中会有语法报错，但是在 MySQL 中会执行。
> select ename, job, max(sal) from emp group by job;
+-------+-----------+----------+
| ename | job       | max(sal) |
+-------+-----------+----------+
| SMITH | CLERK     |  1300.00 |
| ALLEN | SALESMAN  |  1600.00 |
| JONES | MANAGER   |  2975.00 |
| SCOTT | ANALYST   |  3000.00 |
| KING  | PRESIDENT |  5000.00 |
+-------+-----------+----------+
// 所以，一条语句有 group by 的话，select 后面只能跟参加分组的字段和分组函数。

// 每个岗位的平均薪资
> select job, avg(sal) from emp group by job;
+-----------+-------------+
| job       | avg(sal)    |
+-----------+-------------+
| CLERK     | 1037.500000 |
| SALESMAN  | 1400.000000 |
| MANAGER   | 2758.333333 |
| ANALYST   | 3000.000000 |
| PRESIDENT | 5000.000000 |
+-----------+-------------+

// 找出每个部门不同工作岗位的最高薪资
// 使用多个字段联合分组
> select deptno, job, max(sal) from emp group by deptno, job;
+--------+-----------+----------+
| deptno | job       | max(sal) |
+--------+-----------+----------+
|     20 | CLERK     |  1100.00 |
|     30 | SALESMAN  |  1600.00 |
|     20 | MANAGER   |  2975.00 |
|     30 | MANAGER   |  2850.00 |
|     10 | MANAGER   |  2450.00 |
|     20 | ANALYST   |  3000.00 |
|     10 | PRESIDENT |  5000.00 |
|     30 | CLERK     |   950.00 |
|     10 | CLERK     |  1300.00 |
+--------+-----------+----------+
```

## 2.6 `having`

`having`:对分组之后的数据进行再次过滤。

```sql
// 找出每个部门的最高薪资，显示薪资大于2900的数据
1. 找出每个部分的最高薪资
> select deptno, max(sal) from emp group by deptno;
+--------+----------+
| deptno | max(sal) |
+--------+----------+
|     20 |  3000.00 |
|     30 |  2850.00 |
|     10 |  5000.00 |
+--------+----------+
2. 显示薪资大于2900的数据
> select deptno, max(sal) from emp group by deptno having max(sal) > 2900;
// 优化，能使用 where 的尽量使用 where，先过滤减少组合函数的运算量。
> select deptno, max(sal) from emp where sal > 2900 group by deptno;
+--------+----------+
| deptno | max(sal) |
+--------+----------+
|     20 |  3000.00 |
|     10 |  5000.00 |
+--------+----------+


// 找出每个部门的平均薪资,要求显示平均薪资大于2000的数据
1. 找出每个部门的平均薪资
> select deptno, avg(sal) from emp group by deptno;
2. 显示平均薪资大于2000的数据
> select deptno, avg(sal) from emp group by deptno having avg(sal) > 2000;
+--------+-------------+
| deptno | avg(sal)    |
+--------+-------------+
|     20 | 2175.000000 |
|     10 | 2916.666667 |
+--------+-------------+
// 错误,因为分组函数必须再 group by 之后执行，where 在 group by 之前运行
> select deptno, avg(sal) from emp where avg(sal) > 2000 group by deptno;
```
