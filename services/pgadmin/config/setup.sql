---------------------------------------------------------
-- DATABASE SETUP SCRIPT - BÁLINT TÓTH - 2024. 09. 26. --
---------------------------------------------------------

-- USERS
create table user
(
	id number primary key,
	creation_time timestamp default current_date not null,
	email varchar2(50 CHAR) not null,
	password varchar2 (256 CHAR) not null
);

-- PORTFOLIOS
create table portfolio
(
	id number primary key,
	creation_time timestamp default current_date not null,
	name varchar2(50 CHAR) not null,
	user_fk number not null
);
create index user_fk_idx on portfolio (user_fk);

-- STOCKS
create table stock
(
	id number primary key,
	valid_from date not null,
	valid_to date not null,
	available number(1) not null,
	symbol varchar2(16 CHAR) not null,
	-- meta:
	excange_name varchar2(16 CHAR) null,
	excange_currency varchar2(3 CHAR) null,
	exchange_timezone varchar2(16 CHAR) null,
	stock_type varchar2(16 CHAR) null
)
partition by list (available)
(
	partition stock_alive values (1),
	partition stock_dead  values (0)
);
create index concurrently symbol_idx on stock_alive (symbol);

-- TRANZACTIONS
create table tranzaction
(
	id number primary key,
	creation_time timestamp default current_date not null,
	order_date date default current_date not null,
	portfolio_fk number not null,
	stock_fk number not null,
	amount number not null
)
partition by list (order_date);
create index portfolio_fk_idx on tranzaction (portfolio_fk);

-- STOCK INPUT DATA
create table stock_input
(
	creation_time date not null,
	id number primary key,
	symbol varchar2(16 CHAR) not null,
	last_update date null,
	excange_name varchar2(16 CHAR) null,
	excange_currency varchar2(3 CHAR) null,
	exchange_timezone varchar2(16 CHAR) null,
	stock_type varchar2(16 CHAR) null,
	flag varchar2(1 CHAR) null
);

-- STOCK INPUT HISTORIZATION
create table stock_input_history
(
	creation_time date not null,
	id number primary key,
	symbol varchar2(16 CHAR) not null,
	last_update date null,
	excange_name varchar2(16 CHAR) null,
	excange_currency varchar2(3 CHAR) null,
	exchange_timezone varchar2(16 CHAR) null,
	stock_type varchar2(16 CHAR) null,
	flag varchar2(1 CHAR) null
)
partition by range (creation_time);
create index symbol_idx on stock (symbol);

-- (1/2) HISTORIZING STOCK DATA
create or replace procedure stock_historize is
begin
	execute immediate 'create table stock_input_history_' || to_char(current_date, 'YYYYMMDD') ||
	' partition of stock_input_history for values from (''' current_date ''') to (''' current_date + interval '1 day' ''')';
	
	insert into stock_input_history	select * from stock_input;
	
	execute immediate 'truncate table';
end;

-- (2/2) UPDATING STOCK DATA
create or replace procedure stock_update is
today as date;
begin
	select current_date into today;

	-- flags
	
	update stock_input set flag = 'U'
	where (exchange_name, exchange_currency, exchange_timezone, stock_type) !=
	(select s.exchange_name, s.exchange_currency, s.exchange_timezone, s.stock_type from stock s where available = 1 and s.symbol = symbol);
	
	update stock_input set flag = 'I'
	where symbol not in (select t.symbol from stock t where t.available = 1);
	
	insert stock_input (symbol, flag)
	select s.symbol, 'D' from stock s where s.available = 1 and s.symbol not in (select i.symbol from stock_input i);
	
	-- operations

	update stock set valid_to = today, available = 0
	where available = 1 and symbol in (select i.symbol from stock_input i where i.flag in ('D', 'U'));
	
	insert into stock (symbol, exchange_name, exchange_currency, exchange_timezone, stock_type)
	select symbol, exchange_name, exchange_currency, exchange_timezone, stock_type from stock_input where flag in ('I', 'U');
	
	-- commit
	COMMIT;
END;
