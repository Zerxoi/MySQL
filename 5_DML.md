# 5 DML

## 5.1 `INSERT`

参考:[MySQL INSERT语句](https://dev.mysql.com/doc/refman/8.0/en/insert.html)

```sql
> desc t_student;
+-------+--------------+------+-----+---------+-------+
| Field | Type         | Null | Key | Default | Extra |
+-------+--------------+------+-----+---------+-------+
| id    | bigint       | YES  |     | NULL    |       |
| name  | varchar(255) | YES  |     | NULL    |       |
| sex   | char(1)      | YES  |     | NULL    |       |
| class | varchar(255) | YES  |     | NULL    |       |
| birth | char(10)     | YES  |     | NULL    |       |
+-------+--------------+------+-----+---------+-------+

> insert into t_student (id, name, sex, class, birth) values (1, 'zhangsan', '1', 'gaosan1ban','1950-10-12');
> insert into t_student (name, sex, class, birth, id) values ('zhaosi', '1', 'gaoer1ban','1950-10-12', '2'); # 字段必须和值一一对应
> insert into t_student (name) values ('wangwu'); # 除name字段紫外,剩下的所有字段自动插入NULL
> select * from t_student;
+------+----------+------+------------+------------+
| id   | name     | sex  | class      | birth      |
+------+----------+------+------------+------------+
|    1 | zhangsan | 1    | gaosan1ban | 1950-10-12 |
|    2 | zhaosi   | 1    | gaoer1ban  | 1950-10-12 |
| NULL | wangwu   | NULL | NULL       | NULL       |
+------+----------+------+------------+------------+

> drop table if exists t_student; # 删表,如果t_student表存在,删除该表
> create table t_student (
    id bigint,
    name varchar(255),
    sex char(1) default 1,
    class varchar(255),
    birth char(10)
); # 为性别设定默认值1,没有指定默认值默认值为 null
> desc t_student;
+-------+--------------+------+-----+---------+-------+
| Field | Type         | Null | Key | Default | Extra |
+-------+--------------+------+-----+---------+-------+
| id    | bigint       | YES  |     | NULL    |       |
| name  | varchar(255) | YES  |     | NULL    |       |
| sex   | char(1)      | YES  |     | 1       |       |
| class | varchar(255) | YES  |     | NULL    |       |
| birth | char(10)     | YES  |     | NULL    |       |
+-------+--------------+------+-----+---------+-------+
> select * from t_student;
+------+-------+------+-------+------------+
| id   | name  | sex  | class | birth      |
+------+-------+------+-------+------------+
| NULL | bob   | 1    | NULL  | NULL       |
+------+-------+------+-------+------------+
> insert into t_student values ('1', 'jack','0','2-3', '2000-02-17'); # 字段列表省略,代表按照定义字段顺序的列表,values的顺序和个数都要对
+------+-------+------+-------+------------+
| id   | name  | sex  | class | birth      |
+------+-------+------+-------+------------+
| NULL | bob   | 1    | NULL  | NULL       |
|    1 | jack  | 0    | 2-3   | 2000-02-17 |
+------+-------+------+-------+------------+
> insert into t_student values ('2', 'rose', '1', '2-3', '2001-03-16'), ('3', 'chris', '0', '1-2', '2002-08-08'); # 插入多行数据
> select * from t_student;
+------+-------+------+-------+------------+
| id   | name  | sex  | class | birth      |
+------+-------+------+-------+------------+
| NULL | bob   | 1    | NULL  | NULL       |
|    1 | jack  | 0    | 2-3   | 2000-02-17 |
|    2 | rose  | 1    | 2-3   | 2001-03-16 |
|    3 | chris | 0    | 1-2   | 2002-08-08 |
+------+-------+------+-------+------------+
```

## 5.2 `INSERT SELECT`

参考:[MySQL INSERT SELECT语句](https://dev.mysql.com/doc/refman/8.0/en/insert-select.html)

```sql
> insert emp1 select empno, ename from emp where sal >2500;
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
|  7566 | JONES  |
|  7698 | BLAKE  |
|  7788 | SCOTT  |
|  7839 | KING   |
|  7902 | FORD   |
+-------+--------+
```

## 5.3 `UPDATE`

参考:[MySQL Update语句](https://dev.mysql.com/doc/refman/8.0/en/update.html)

```sql
# 案例:将部门10的LOC修改为SHANGHAI,将部门名称修改为RESNSHIBU
> select * from dept;
+--------+------------+----------+
| DEPTNO | DNAME      | LOC      |
+--------+------------+----------+
|     10 | ACCOUNTING | NEW YORK |
|     20 | RESEARCH   | DALLAS   |
|     30 | SALES      | CHICAGO  |
|     40 | OPERATIONS | BOSTON   |
+--------+------------+----------+
> update dept set dname = 'RENSHIBU', loc = 'SHANGHAI' where deptno = 10;
> select * from dept;
+--------+------------+----------+
| DEPTNO | DNAME      | LOC      |
+--------+------------+----------+
|     10 | RENSHIBU   | SHANGHAI |
|     20 | RESEARCH   | DALLAS   |
|     30 | SALES      | CHICAGO  |
|     40 | OPERATIONS | BOSTON   |
+--------+------------+----------+
```

## 5.4 `DELETE`

参考:[MySQL Delete语句](https://dev.mysql.com/doc/refman/8.0/en/delete.html)

```sql
> select * from dept1;
+--------+------------+----------+
| DEPTNO | DNAME      | LOC      |
+--------+------------+----------+
|     10 | ACCOUNTING | NEW YORK |
|     20 | RESEARCH   | DALLAS   |
|     30 | SALES      | CHICAGO  |
|     40 | OPERATIONS | BOSTON   |
|     10 | ACCOUNTING | NEW YORK |
|     20 | RESEARCH   | DALLAS   |
|     30 | SALES      | CHICAGO  |
|     40 | OPERATIONS | BOSTON   |
+--------+------------+----------+

# 案例:删除10部门的数据
> select * from dept1;
+--------+------------+----------+
| DEPTNO | DNAME      | LOC      |
+--------+------------+----------+
|     10 | ACCOUNTING | NEW YORK |
|     20 | RESEARCH   | DALLAS   |
|     30 | SALES      | CHICAGO  |
|     40 | OPERATIONS | BOSTON   |
|     10 | ACCOUNTING | NEW YORK |
|     20 | RESEARCH   | DALLAS   |
|     30 | SALES      | CHICAGO  |
|     40 | OPERATIONS | BOSTON   |
+--------+------------+----------+
> select * from dept1;
+--------+------------+---------+
| DEPTNO | DNAME      | LOC     |
+--------+------------+---------+
|     20 | RESEARCH   | DALLAS  |
|     30 | SALES      | CHICAGO |
|     40 | OPERATIONS | BOSTON  |
|     20 | RESEARCH   | DALLAS  |
|     30 | SALES      | CHICAGO |
|     40 | OPERATIONS | BOSTON  |
+--------+------------+---------+

# 删除全部数据
> delete from dept1;
Query OK, 6 rows affected (0.15 sec)
> select * from dept1;
Empty set (0.00 sec)
```
