drop table clients;


create table if not exists clients(
	id_client int primary key not null auto_increment,
	last_name varchar(35) not null,
	first_name varchar(35) not null,
	middle_name varchar(35),
	birthday date,
	phone_number varchar(20) not null,
	address varchar(55),
	email text);
	
	
create table if not exists orders(
id_order int primary key not null auto_increment,
id_client int not null,
total_price varchar(5) not null,
id_status int not null);	


create table if not exists products(
id_product int primary key not null auto_increment,
id_product_category varchar(10) not null,
name_product varchar(55) not null,
amount varchar(10) not null,
coast varchar(10) not null);
	
create table if not exists product_category(
id_category int primary key not null auto_increment,
name_category varchar(55) not null);

create table if not exists basket(
id_basket int primary key not null auto_increment,
id_product int not null,
amount varchar(5) not null,
coast varchar(10) not null,
id_order int not null);


create table if not exists clients_orders(
id_client int,
id_order int,
primary key (id_client, id_order));


alter table clients
add index ind_client (id_client);

alter table clients_orders
add index client_ind (id_client),
add index order_ind (id_order),
add foreign key (id_client)
references clients(id_client)
on delete cascade,
add foreign key (id_order)
references orders(id_order)
on delete cascade;

alter table orders
add index product_ind (id_product),
add foreign key (id_product)
references products(id_product)
on delete cascade;


alter table products
add index product_category_ind (id_product_category),
add foreign key (id_product_category)
references product_category(id_product_category)
on delete cascade;


alter table products
drop index product_ind;

alter table clients
change column middle_name middle_name text;

insert into clients
value
(1, 'Иванов', 'Иван', 'Иванович', '2000-04-24', 89991562562, '', null),
(2, 'Сидоров', 'Сидор', 'Сидорович', '1998-01-24', 89991225587, '', null),
(3, 'Иванова', 'Иванна', null, '1988-04-24', 89181561552, '', null),
(4, 'Чон', 'Чонгук', null, '1997-09-01', 89185421684, '', null),
(5, 'Мин', 'Юнги', null, '1993-03-09', 89991565462, '', null);

insert into product_category
values
(1, 'монитор'),
(2, 'мышь'),
(3, 'футболка'),
(4, 'кепка');


insert into products
values
(null, 1, 'Монитор C134', 10, 10000),
(null, 2, 'Мышь sony', 100, 1000),
(null, 4, 'Кепка', 150, 600),
(null, 1, 'Монитор C54', 10, 10000),
(null, 3, 'Футболка', 80, 1200);


alter table orders
change column id_status id_status enum('заказан', 'оплачен', 'отправлен', 'получен');

insert into orders
values
(null, 1, '', 'оплачен'),
(null, 3, '', 'отправлен'),
(null, 2, '', 'получен'),
(null, 4, '', 'заказан');


insert into basket
values
(null, 3, 3, '', 1),
(null, 4, 1, '', 1),
(null, 1, 5, '', 2),
(null, 2, 2, '', 2);


select * from clients
where last_name like 'И%';

select * from clients
where birthday like '2000-04-24';

select * from clients
where birthday between '1998-01-01' and '2001-01-01';

delete from clients
where last_name like 'Иванов';
 
update clients
set last_name='Иванов', first_name='Иван', middle_name='Иванович', birthday='2000-04-24'
where id_client=3;

update products, basket
set amount=amount-basket.amount;

update basket, products
set basket.coast=products.coast*basket.amount
where basket.id_product=products.id_product;

update orders o inner join(
select id_order, sum(coast) c from basket
group by id_order) b
set o.total_price=c
where o.id_order=b.id_order;

select clients.last_name, clients.first_name, clients.middle_name, 
clients.birthday, clients.phone_number, clients.email, orders.total_price-orders.total_price*0.05, 
orders.status
from clients join orders
on clients.id_client=orders.id_client
where total_price>=5000;