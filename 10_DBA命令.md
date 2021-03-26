# 10 DBA命令

## 10.1 用户创建删除

[MySQL文档 CREATE USER语句](https://dev.mysql.com/doc/refman/8.0/en/create-user.html)
[MySQL文档 DROP USER语句](https://dev.mysql.com/doc/refman/8.0/en/drop-user.html)

## 10.2 用户授权及回收权限

[MySQL文档 GRANT语句](https://dev.mysql.com/doc/refman/8.0/en/grant.html)
[MySQL文档 REVOKE语句](https://dev.mysql.com/doc/refman/8.0/en/revoke.html)

## 10.4 数据导出

参考: 
[MySQL文档 mysqldump](https://dev.mysql.com/doc/refman/8.0/en/mysqldump.html)
`mysqldump --help`

```bash
# mysqldump -u username -p database [tables] > /path/to/xx.sql
> mysqldump -uroot -p zerxoi emp > E:/emp.sql
```

## 10.5 数据导入

[MySQL文档 从文本导入数据库](https://dev.mysql.com/doc/refman/8.0/en/mysql-batch-commands.html)
