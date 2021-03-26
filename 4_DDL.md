# 4 DDL

## 4.1 创建表

参考：[MySQL CREATE TABLE语句](https://dev.mysql.com/doc/refman/8.0/en/create-table.html)

建表语句的语法格式

```sql
create table 表名 (
    字段名1 数据类型,
    字段名1 数据类型,
    ...
);
```

## 4.2 常见数据类型

参考：[MySQL 数据类型](https://dev.mysql.com/doc/refman/8.0/en/data-types.html)

- `int`     整数型(int)
- `bigint`  长整型(long)
- `float`   浮点型(float)
- `char`    定长字符串(String)
- `varchar` 变长字符串(StringBuffer,StringBuilder)
- `date`    日期类型(java.sql.Date)
- `BLOB`    Binary Large OBject二进制大对象(Object)
- `CLOB`    Character Large OBject字符大对象(Object)

## 4.3 `CHAR` 和 `VARCHAR`

在实际开发中，当某个数据长度不发生变化的时候，是定长的，例如：性别、生日等都是采用`char`。

在一个字段的数据长度不确定的时候，例如：简介、姓名都是采用`varchar`。

## 4.4 `CREATE TABLE` 创建学生表

学生信息：
    - 学号(`bigint`)
    - 姓名(`varchar`)
    - 性别(`char`)
    - 班级编号(`varchar`)
    - 生日(`char`)

```sql
create table t_student (
    id bigint,
    name varchar(255),
    sex char(1),
    class varchar(255),
    birth char(10)
);
```

## 4.5 `CREATE TABLE SELECT` 表的复制

参考:[MySQL CREATE TABLE SELECT语句](https://dev.mysql.com/doc/refman/8.0/en/create-table-select.html)

```sql
> create table emp1 select empno, ename from emp; -- 将查询结果当作表创建出来
> select * from emp1;
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
```

## 4.6 `TRUNCATE` 删除大表中的数据

参考:[MySQL TRUNCATE TABLE语句](https://dev.mysql.com/doc/refman/8.0/en/truncate-table.html)

为了获得高性能，TRUNCATE TABLE绕过了删除数据的DML方法。因此，它不会导致触发ON DELETE触发器，无法对具有父子外键关系的InnoDB表执行，也无法像DML操作一样回滚。

```sql
mysql> select * from dept1;
+--------+------------+----------+
| DEPTNO | DNAME      | LOC      |
+--------+------------+----------+
|     10 | ACCOUNTING | NEW YORK |
|     20 | RESEARCH   | DALLAS   |
|     30 | SALES      | CHICAGO  |
|     40 | OPERATIONS | BOSTON   |
+--------+------------+----------+
mysql> truncate table dept1;
mysql> select * from dept1;
Empty set (0.07 sec)
```

## 4.7 `ALTER`

对于表结构的修改可以用工具来完成,因为在实际开发中表一旦设计好之后,对表结构的修改是很少的,修改表结构就是对之前的设计进行了否定,即使需要修改表结构,我们也可以直接使用工具操作.

修改表结构的语句不会出现在Java代码当中.出现在Java代码当中的SQL语句包括:`insert`,`delete`,`update`,`select`.CRUD,即Create(创建),Retrieve(检索),Update(更新),Delete(删除).

## 4.8 约束(Constraint)

[MySQL文档 CREATE TABLE语句](https://dev.mysql.com/doc/refman/8.0/en/create-table.html)

添加约束的目的是为了保证表中数据的合法性,有效性和完整性.

- 非空约束(`NOT NULL`):约束字段不能为NULL
- 唯一约束(`UNIQUE [KEY]`):约束字段不能重复
- 主键约束(`[PRIMARY]KEY`):约束字段既不能为NULL也不能重复(简称PK)
- 外键约束(`FOREIGN KEY`):...(简称FK)
- 检查约束(`CHECK`)

### 4.8.1 非空约束

```sql
mysql> drop table if exists t_user;
mysql> create table t_user (
    id int,
    username varchar(255) not null,
    password varchar(255)
);
mysql> insert t_user (id, password) values (1, '123456');
ERROR 1364 (HY000): Field 'username' doesn't have a default value
mysql> insert t_user (id, username, password) values (1, 'alice', '123456');
Query OK, 1 row affected (0.10 sec)
mysql> select * from t_user;
+------+----------+----------+
| id   | username | password |
+------+----------+----------+
|    1 | alice    | 123456   |
+------+----------+----------+
```

### 4.8.2 唯一性约束（`UNIQUE`）

唯一性修饰字段具有唯一性,不能重复.但可以为NULL.

```sql
# 案例:给某一列添加unique
> drop table if exists t_user;
> create table t_user (
    id int,
    username varchar(255) unique,
    password varchar(255)
);
> insert t_user values (1, 'zhangsan', '123456');
Query OK, 1 row affected (0.10 sec)
> insert t_user values (1, 'zhangsan', '123456');
ERROR 1062 (23000): Duplicate entry 'zhangsan' for key 't_user.username'
> insert t_user (id) values (2);
> insert t_user (id) values (3);
> insert t_user (id) values (4);
> select * from t_user;
+------+----------+----------+
| id   | username | password |
+------+----------+----------+
|    1 | zhangsan | 123456   |
|    2 | NULL     | NULL     |
|    3 | NULL     | NULL     |
|    4 | NULL     | NULL     |
+------+----------+----------+


# 给多给多个列添加unique
# 表级约束:多个字段联合起来添加1个unique约束
> drop table if exists t_user;
> create table t_user (
    id int,
    username varchar(255),
    sex char(1),
    unique(username, sex)
);
> insert t_user values (1, 'alice', 'f');
> insert t_user values (2, 'alice', 'm');
> insert t_user values (3, 'bob', 'f');
> select * from t_user;
+------+----------+------+
| id   | username | sex  |
+------+----------+------+
|    1 | alice    | f    |
|    2 | alice    | m    |
|    3 | bob      | m    |
+------+----------+------+

# 分别unique
# 列级约束:在字段后面直接添加unique
> drop table if exists t_user;
> create table t_user (
    id int,
    username varchar(255) unique,
    sex char(1) unique
);
> insert t_user values (1, 'alice', 'f');
Query OK, 1 row affected (0.24 sec)
> insert t_user values (2, 'alice', 'm');
ERROR 1062 (23000): Duplicate entry 'alice' for key 't_user.username'
> insert t_user values (3, 'bob', 'f');
ERROR 1062 (23000): Duplicate entry 'f' for key 't_user.sex'
> select * from t_user;
+------+----------+------+
| id   | username | sex  |
+------+----------+------+
|    1 | alice    | f    |
+------+----------+------+
```

### 4.8.3 主键约束（`PRIMARY KEY`）

主键既不能重复也不能为空
列级约束：
```sql
> drop table if exists t_user;
> create table t_user (
    id int primary key,
    username varchar(255),
    email varchar(255)
);
> insert into t_user values (1, 'Sin Lee', 'sinlee@163.com');
> insert into t_user values (2, 'Xin Zhao', 'xinzhao@qq.com');
> insert into t_user values (3, 'Goudan Lee', 'goudanlee@gmail.com');
> select * from t_user;
+----+------------+---------------------+
| id | username   | email               |
+----+------------+---------------------+
|  1 | Sin Lee    | sinlee@163.com      |
|  2 | Xin Zhao   | xinzhao@qq.com      |
|  3 | Goudan Lee | goudanlee@gmail.com |
+----+------------+---------------------+

# 主键不能重复
> insert into t_user values (1, 'Jack Ma', 'jackma@alibaba.com');
ERROR 1062 (23000): Duplicate entry '1' for key 't_user.PRIMARY'
# 主键不能为空
> insert into t_user (username, email) values ('Jack Ma', 'jackma@alibaba.com');
ERROR 1364 (HY000): Field 'id' doesn't have a default value
# 总结：主键既不能重复也不能为空
```

主键的相关术语

- 主键约束: primary key
- 主键字段： id字段后添加 primary key 之后，id 叫做主键字段
- 主键值： id字段中的每个值都是主键值

表的设计三范式中要求，第一范式要求任何一张表都要有主键

主键值是这行记录在这张表中的唯一标识

**一张表的主键约束只能有一个**

主键的分类：
    - 根据主键字段的字段数量来划分
        - 单一主键（推荐按常用）
        - 复合主键（多个字段联合起来添加一个主键约束）（复合主键不建议使用，因为复合主键违背三范式，会产生部分依赖）
    - 根据主键的性质来划分
        - 自然主键：主键值最好就是一个和业务没有任何关系的自然数
        - 业务主键：主键值和业务挂钩，例如:拿着银行卡的开好做主键，拿着身份证号码做主键（不推荐使用）

表级约束
```sql
# 单一主键
# 创建的表和上面列级约束的效果一样
> drop table if exists t_user;
> create table t_user (
    id int,
    username varchar(255),
    email varchar(255),
    primary key(id)
);

# 复合主键(不常用)
> drop table if exists t_user;
> create table t_user (
    id int,
    username varchar(255),
    email varchar(255),
    primary key(id, username)
);
> insert into t_user value (1, 'Sin Lee', 'sinlee@163.com');
> insert into t_user value (2, 'Sin Lee', 'sinlee@gmail.com');
> insert into t_user value (1, 'Sin Lee', 'sinlee@qq.com');
ERROR 1062 (23000): Duplicate entry '1-Sin Lee' for key 't_user.PRIMARY'
```

主键值自增

自动维护一个从1开始递增的数字
```sql
> drop table if exists t_user;
> create table t_user (
    id int primary key auto_increment,
    username varchar(255),
    email varchar(255)
);
> insert into t_user(username) value ('a');
> insert into t_user(username) value ('b');
> insert into t_user(username) value ('c');
> insert into t_user(username) value ('d');
> insert into t_user(username) value ('e');
> select * from t_user;
+----+----------+-------+
| id | username | email |
+----+----------+-------+
|  1 | a        | NULL  |
|  2 | b        | NULL  |
|  3 | c        | NULL  |
|  4 | d        | NULL  |
|  5 | e        | NULL  |
+----+----------+-------+
```

提示：Oracle当中也提供了一个自增机制，叫做：序列（sequence）对象。

### 4.8.4 外键约束

外键约束相关术语：

- 外键约束：foreign key
- 外键字段：添加有外键约束的字段
- 外键值：外键字段中的每个值

业务背景：
    设计一个数据库表，用来维护员工名和部门名称的信息

方案一：
|empno(pk)|ename   |deptno  |dname       |
|---------|--------|--------|------------|
|    7369 | SMITH  |     20 | RESEARCH   |
|    7499 | ALLEN  |     30 | SALES      |
|    7521 | WARD   |     30 | SALES      |
|    7566 | JONES  |     20 | RESEARCH   |
|    7654 | MARTIN |     30 | SALES      |
|    7698 | BLAKE  |     30 | SALES      |
|    7782 | CLARK  |     10 | ACCOUNTING |
|    7788 | SCOTT  |     20 | RESEARCH   |
|    7839 | KING   |     10 | ACCOUNTING |
|    7844 | TURNER |     30 | SALES      |
|    7876 | ADAMS  |     20 | RESEARCH   |
|    7900 | JAMES  |     30 | SALES      |
|    7902 | FORD   |     20 | RESEARCH   |
|    7934 | MILLER |     10 | ACCOUNTING |
缺点：冗余，如果部门名很长名且重复次数多会造成数据的冗余

方案二：
dept表
|deptbo(pk)|dname       |
|----------|------------|
|       10 | ACCOUNTING |
|       20 | RESEARCH   |
|       30 | SALES      |
|       40 | OPERATIONS |

emp表
|empno(pk)|ename   |deptno(fk)|
|---------|--------|----------|
|    7369 | SMITH  |       20 |
|    7499 | ALLEN  |       30 |
|    7521 | WARD   |       30 |
|    7566 | JONES  |       20 |
|    7654 | MARTIN |       30 |
|    7698 | BLAKE  |       30 |
|    7782 | CLARK  |       10 |
|    7788 | SCOTT  |       20 |
|    7839 | KING   |       10 |
|    7844 | TURNER |       30 |
|    7876 | ADAMS  |       20 |
|    7900 | JAMES  |       30 |
|    7902 | FORD   |       20 |
|    7934 | MILLER |       10 |

emp中的deptno字段引用dept表中的deptno字段，此时emp表叫做子表，dept表叫做父表。

外键约束要求子表外键字段的外键值只能是父表的引用字段中的值。

**外键可以为NULL**

被引用字段不要求为主键，但是要具有*唯一性（UNIQUE）*，但一般都是引用主键。

顺序要求：
    删除数据的时候，先删除子表，再删除父表。
    删除表的时候，先删除子表，再删除父表。
    添加数据的时候，先添加父表，在添加子表。
    创建表的时候，先创建父表，再创建子表。

```sql
# 先建父表
> create table t_dept (
    deptno int primary key,
    dname varchar(255),
    loc varchar(255)
);

# 再建子表
> create table t_emp (
    empno int primary key,
    ename varchar(255),
    deptno int,
    foreign key (deptno) references t_dept (deptno)
);

# 先添加父表数据
> insert into t_dept value (10, 'accouting', 'new york');
> insert into t_dept value (20, 'research', 'dallas');
> insert into t_dept value (30, 'sales', 'chicago');

# 再见添加子表数据
> insert into t_emp value (7369, 'smith', 20);
> insert into t_emp value (7499, 'allen', 30);
> insert into t_emp value (7521, 'ward', 30);
> insert into t_emp value (7788, 'scott', 20);

> select * from t_emp;
> select * from t_dept;

# 不满足外键约束
> insert into t_emp value (7934, 'clerk', 40);
ERROR 1452 (23000): Cannot add or update a child row: a foreign key constraint fails (`zerxoi`.`t_emp`, CONSTRAINT `t_emp_ibfk_1` FOREIGN KEY (`deptno`) REFERENCES `t_dept` (`deptno`))

# 外键可以为NULL
> insert into t_emp (empno, ename) value (8002, 'chris');
> select * from t_emp;
+-------+-------+--------+
| empno | ename | deptno |
+-------+-------+--------+
|  7369 | smith |     20 |
|  7499 | allen |     30 |
|  7521 | ward  |     30 |
|  7788 | scott |     20 |
|  8002 | chris |   NULL |
+-------+-------+--------+
```

## 4.9 表选项

### 4.9.1 字符集及其排序规则

[Character Sets and Collations in MySQL](https://dev.mysql.com/doc/refman/8.0/en/charset-mysql.html)

[MYSQL中的COLLATE是什么？](https://juejin.cn/post/6844903726499512334)

[Collation Naming Conventions - 排序规则命名约定](https://dev.mysql.com/doc/refman/8.0/en/charset-collation-names.html)

使用 `SHOW CHARACTER SET` 语句查看所有可用字符集。

使用 `SHOW COLLATION` 语言查看所有可用的排序规则。

排序规则的命名规范：

```
_ai Accent-insensitive 
_as Accent-sensitive 
_ci Case-insensitive 
_cs Case-sensitive 
_ks Kana-sensitive 
_bin Binary 
```