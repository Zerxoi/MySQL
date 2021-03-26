# 1 基础

[MySQL 文档语法说明](https://dev.mysql.com/doc/refman/8.0/en/manual-info.html)

[MySQL文档 mysql指令](https://dev.mysql.com/doc/refman/8.0/en/mysql-commands.html)

## 1.1 SQL DB DBMS

**DB**数据库（Database）数据在硬盘上以文件的形式存在。
**DBMS**：数据库管理系统（Database Management System）数据库管理系统。
**SQL**：结构化查询语言（Structured Query Language）是一门标准通用的语言，标准的SQL适用于所有数据。高级语言，由DBMS编译执行。

## 1.2 表

**表**：表（Table）是数据库的基本组成单位，所有数据都是以表格的形式组织，可读性强。
**记录**：记录，又称数据，是表的行。
**字段**：字段（Field），表的列。字段包括字段名，数据类型和约束条件。

## 1.3 SQL语句的分类

**DQL**：数据查询语言DQL（Data Query Language）对数据进行查询 `select`
**DML**：数据操作语言DML（Data Manipulation Language）对表中的数据进行增删改 `insert` `delete` `update`
**DDL**：数据定义语言DDL（Data Definition Language）对数据库对象，例如表，索引和视图等进行增删改 `create` `drop` `alter`
**TCL**: 事务控制语言TCL（Transaction Control Language）对事务进行控制 `commit`提交事务 `rollback`回滚事务
**DCL**：数据控制语言DCL（Data Control Language）数据控制语言：用于控制对数据库中存储的数据的访问（授权） `grant`授权 `revoke`撤销授权

## 1.4 信息展示

[MySQL文档 SHOW语句](https://dev.mysql.com/doc/refman/8.0/en/show.html)：`SHOW` 具有许多形式，可提供有关数据库，表，列或有关服务器的状态信息的信息。

[MySQL文档 USE语句](https://dev.mysql.com/doc/refman/8.0/en/use.html)：`USE` 语句告诉MySQL将命名数据库用作后续语句的默认（当前）数据库。

```mysql
// 查看数据库(MySQL命令，不是SQL语句)
> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
| sakila             |
| sys                |
| world              |
+--------------------+

// 创建数据库
> create databse zerxoi;
Query OK, 1 row affected (0.22 sec)

// 使用数据库(MySQL命令，不是SQL语句)
> use zerxoi;
Database changed

// 查看当前数据库中的表(MySQL命令，不是SQL语句)
> select database();
+------------+
| database() |
+------------+
| zerxoi     |
+------------+
```

## 1.5 导入SQL脚本

[MySQL文档 从文本导入数据库](https://dev.mysql.com/doc/refman/8.0/en/mysql-batch-commands.html)

文件拓展名为`.sql`，并且文件中包含了大量的SQL语句，我们称这样的文件为SQL脚本。

使用`source /path/to/src.sql`命令执行SQL脚本。

```mysql
// 导入数据，执行SQL脚本(MySQL命令，不是SQL语句)
> source C:\Users\Zerxoi\Desktop\bjpowernode.sql
```

## 1.6 删除数据库

使用`drop database database_name`命令，删除名为`database_name`的数据库。

```mysql
// 删除数据库
> drop database zerxoi;
Query OK, 3 rows affected (1.61 sec)
```

## 1.7 查看表结构

[MySQL文档 DESCRIBE语句](https://dev.mysql.com/doc/refman/8.0/en/describe.html)：`DESCRIBE` 和 `EXPLAIN` 语句是同义词，用于获取有关表结构的信息或查询执行计划。

使用`desc table_name`命令，查看名为`table_name`的表的结构。

```mysql
// 查看表结构(MySQL命令，不是SQL语句)
> desc table_name;

+--------+-------------+------+-----+---------+-------+
| Field  | Type        | Null | Key | Default | Extra |
+--------+-------------+------+-----+---------+-------+
| DEPTNO | int         | NO   | PRI | NULL    |       |
| DNAME  | varchar(14) | YES  |     | NULL    |       |
| LOC    | varchar(13) | YES  |     | NULL    |       |
+--------+-------------+------+-----+---------+-------+
3 rows in set (0.08 sec)

> desc emp;
+----------+-------------+------+-----+---------+-------+
| Field    | Type        | Null | Key | Default | Extra |
+----------+-------------+------+-----+---------+-------+
| EMPNO    | int         | NO   | PRI | NULL    |       |
| ENAME    | varchar(10) | YES  |     | NULL    |       |
| JOB      | varchar(9)  | YES  |     | NULL    |       |
| MGR      | int         | YES  |     | NULL    |       |
| HIREDATE | date        | YES  |     | NULL    |       |
| SAL      | double(7,2) | YES  |     | NULL    |       |
| COMM     | double(7,2) | YES  |     | NULL    |       |
| DEPTNO   | int         | YES  |     | NULL    |       |
+----------+-------------+------+-----+---------+-------+
8 rows in set (0.01 sec)

> desc salgrade;
+-------+------+------+-----+---------+-------+
| Field | Type | Null | Key | Default | Extra |
+-------+------+------+-----+---------+-------+
| GRADE | int  | YES  |     | NULL    |       |
| LOSAL | int  | YES  |     | NULL    |       |
| HISAL | int  | YES  |     | NULL    |       |
+-------+------+------+-----+---------+-------+
3 rows in set (0.00 sec)
```

## 1.8 其他常用MySQL方法

[MySQL文档 Informal Functional](https://dev.mysql.com/doc/refman/8.0/en/information-functions.html#function_version)

[MySQL文档 SQL函数和运算符参考](https://dev.mysql.com/doc/refman/8.0/en/sql-function-reference.html)

```mysql
// 查看当前数据库
> select database();
+------------+
| database() |
+------------+
| zerxoi     |
+------------+

// 查看数据库版本
> select version();
+-----------+
| version() |
+-----------+
| 8.0.21    |
+-----------+

// 查看其他数据库中的表
> show tables from world;
+-----------------+
| Tables_in_world |
+-----------------+
| city            |
| country         |
| countrylanguage |
+-----------------+

// 查看创建表的语句
show create table emp;
+-------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Table | Create Table                                                                                                                                                                                                                                                                                                                                                             |
+-------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| emp   | CREATE TABLE `emp` (
  `EMPNO` int NOT NULL,
  `ENAME` varchar(10) DEFAULT NULL,
  `JOB` varchar(9) DEFAULT NULL,
  `MGR` int DEFAULT NULL,
  `HIREDATE` date DEFAULT NULL,
  `SAL` double(7,2) DEFAULT NULL,
  `COMM` double(7,2) DEFAULT NULL,
  `DEPTNO` int DEFAULT NULL,
  PRIMARY KEY (`EMPNO`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci |
+-------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
```

`\c`终止一条正在编写的语句。

`\q`、`quit`和`exit`退出MySQL。
