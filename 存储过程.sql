drop database if exists proc_func;

create database proc_func;

use proc_func;

-- 存储过程的创建及调用
-- 存储过程的创建及调用
-- 存储过程的创建及调用



delimiter //

create procedure hello_procedure()
begin
	select 'hello procedure';
end//

call hello_procedure()//

drop procedure hello_procedure//

-- 变量的创建与赋值
-- 变量的创建与赋值
-- 变量的创建与赋值

create procedure sp_var01()
begin
	-- 局部变量 begin end 块内容有效
    -- 需要先使用 declare 声明
	declare var01 varchar(32) default 'sf';
    set var01 = 'ug';
    select var01;
end//

drop procedure sp_var01//

create procedure sp_var01()
begin
	declare var01 varchar(32) default 'sf';
    select var01;
    set var01 = 'ug';
end//

-- begin end 块外获取不到该变量
-- select var01//

call sp_var01()//

drop procedure sp_var01//

-- 用户变量，当前连接（会话）内有效
-- 用户变量不需要声明，直接使用
create procedure sp_var02()
begin
	set @var02 = 'wr';
end//

select @var02//

call sp_var02();

-- begin end 块外也能获取到该变量
select @var02//

-- 使用 select 为变量赋值
select author into @aa from jandan_pic.comment where id = 4753197;
select @aa//

-- 存储过程参数
-- 存储过程参数
-- 存储过程参数

drop procedure sp_param01//

-- 入参
create procedure sp_param01(in param01 varchar(32))
begin
	set @param01 = param01;
end//

call sp_param01('fadsfsd');
select @param01//

-- 出参
drop procedure sp_param02//

create procedure sp_param02(in id_param int, out author_param varchar(64))
begin
	select author into author_param from jandan_pic.comment where id = id_param;
end//

call sp_param02(4753197, @param02);
select @param02//

-- 出入参
drop procedure sp_param03//

set @param03 = 333;

create procedure sp_param03(in in_param int, inout inout_param int)
begin
	set inout_param = 666;
    set inout_param = inout_param + in_param;
end;

call sp_param03(333 ,@param03)//

select @param03//

-- 控制流
-- 控制流
-- 控制流

drop procedure sp_if;

create procedure sp_if(in score int, out grade varchar(1))
begin
	if score >= 90
		then set grade = 'A';
	elseif score >= 80
		then set grade = 'B';
	elseif score >= 70
		then set grade = 'C';
	elseif score >= 60
		then set grade = 'D';
	else
		set grade = 'E';
	end if;
end//

call sp_if(80, @param_if);

select @param_if//

drop procedure sp_case;

create procedure sp_case(in score int, out grade varchar(1))
begin
	case
		when score >= 90 then set grade = 'A';
		when score >= 80 then set grade = 'B';
		when score >= 70 then set grade = 'C';
		when score >= 60 then set grade = 'D';
        else set grade = 'E';
	end case;
end//

call sp_case(90, @param_case);
select @param_case//


-- 循环
-- 循环
-- 循环

-- 查看进程
show processlist//
-- 杀死进程
-- kill id//

drop procedure sp_loop//

create procedure sp_loop()
begin
	declare num_index int default 0;
    num_loop:loop
		select num_index;
		set num_index = num_index + 1;
		if num_index < 10 then
			iterate num_loop;  --  类似continue
		end if;
        leave num_loop; -- 类似 break
	end loop num_loop;
end//

call sp_loop()//

drop procedure sp_repeat//

create procedure sp_repeat()
begin
	declare num_index int default 0;
    num_loop:repeat
		-- 语句开始
		select num_index;
		set num_index = num_index + 1;
        -- 语句结束
        until num_index >= 10
	end repeat num_loop;
end//

call sp_while()//

drop procedure sp_while//

create procedure sp_while()
begin
	declare num_index int default 0;
	while num_index < 10 do
		-- 语句开始
		select num_index;
		set num_index = num_index + 1;
        -- 语句结束
	end while;
end//

call sp_while()//

-- 游标与handler句柄
-- 游标与handler句柄
-- 游标与handler句柄

drop procedure sp_cusor_handler//

create procedure sp_cusor_handler()
begin
	declare id_param int;
    declare author_param varchar(32);
    declare flag boolean default true;
	declare comment_cursor cursor for
		select 
			id, author 
        from 
			jandan_pic.comment
		where 
			id between 4753197 and 4753250;

	-- 游标取出最后一个元素会抛出1329的错误，通过handler句柄捕捉错误
    -- 将flag设为false，并在出错的语句继续执行
	declare continue handler for 1329 set flag = false;
	open comment_cursor;
    	while flag do
			-- 语句开始
			fetch comment_cursor into id_param, author_param;
			select author_param;
			-- 语句结束
		end while;
    close comment_cursor;
end//

call sp_cusor_handler()//

-- 例题
-- 例题
-- 例题

create procedure sp_create_table()
begin
	begin
		declare next_year int;
        declare next_month int;
        declare next_month_str char(2);
        declare next_month_day int;
		declare next_month_day_str varchar(2);
        declare table_name_str char(10);
        declare t_index int default 1;
		
        set next_year = year(date_add(now(), interval 1 month));
        set next_month = month(date_add(now(), interval 1 month));
        set next_month_day = dayofmonth(last_day(date_add(now(), interval 1 month)));
        
        if next_month < 10 then
			set next_month_str = concat('0', next_month);
		else
			set next_month_str = concat('', next_month);
		end if;
        
        while t_index <= next_month_day do
			if t_index < 10 then
				set next_month_day_str = concat('0', t_index);
                -- if t_index = 1 then
					select next_month_day_str;
				-- end if;
			else
				set next_month_day_str = concat('', t_index);
			end if;
            
            
			set table_name_str = concat(next_year,'_', next_month_str,'_', next_month_day_str);
            set @create_table_sql = concat(
				'create table comp_',
                table_name_str,
                '(`grade` int, `losal` int, `hisal` int)'
            );
            prepare create_table_stmt from @create_table_sql;
            execute create_table_stmt;
            deallocate prepare create_table_stmt;
            set t_index = t_index + 1;
        end while;
    end;
end;

call sp_create_table()//