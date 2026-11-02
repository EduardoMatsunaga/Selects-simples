use master
go
if db_id('locadorafilmes') is not null
begin
    alter database locadorafilmes set single_user with rollback immediate
    drop database locadorafilmes
end
go

create database locadorafilmes 
go
use locadorafilmes
go

create table filme (
id int not null identity (1001,1),
titulo varchar(40) not null,
ano int null check (ano <= 2021),
primary key (id))
go

create table dvd (
num int not null identity (10001, 1),
data_fabricacao date not null check (data_fabricacao < getdate() ),
filmeId int not null,
primary key (num),
foreign key (filmeId) references filme (id))
go

create table cliente (
num_cadastro int not null identity (5501,1),
nome varchar(70) not null,
logradouro varchar(150) not null,
num int not null check (num > 0),
cep char(8) null check (len(cep) = 8 ),
primary key (num_cadastro))
go

create table estrela (
id int not null identity (9901,1),
nome varchar(50) not null,
primary key (id))
go

create table filme_estrela (
filmeId int not null,
estrelaId int not null,
primary key (filmeId, estrelaId),
foreign key (filmeId) references filme (id),
foreign key (estrelaId) references estrela (id))
go

create table locacao (
dvdNum int not null,
clienteNum int not null,
data_locacao date not null default getdate(),
data_devolucao date not null,
valor decimal (7,2) not null check (valor > 0),
primary key (dvdNum, clienteNum, data_locacao),
foreign key (dvdNum) references dvd (num),
foreign key (clienteNum) references cliente (num_cadastro),
constraint chk_devolucao check (data_devolucao > data_locacao))
go
	
alter table estrela
add nome_real varchar(50) null
go

alter table filme
alter column titulo varchar(80) not null
go

insert into filme (titulo, ano) values
('Whiplash', '2015'),
('Birdman', '2015'),
('Interestelar', '2014'),
('A culpa é das estrelas', '2014'),
('Alexandre e o Dia Terrível, Horrível, Espantoso e Horroroso', '2014'),
('Sing', '2016')
go

insert into estrela (nome, nome_real) values
('Michael Keaton', 'Michael John Douglas'),
('Emma Stone', 'Emily Jean Stone'),
('Miles Teller', null),
('Steve Carell', 'Steven John Carell'),
('Jennifer Garner', 'Jennifer Anne Garner')
go

insert into dvd (data_fabricacao, filmeId) values
('2020-12-02', '1001'),
('2019-10-18', '1002'),
('2020-04-03', '1003'),
('2020-12-02', '1001'),
('2019-10-18', '1004'),
('2020-04-03', '1002'),
('2020-12-02', '1005'),
('2019-10-18', '1002'),
('2020-04-03', '1003')
go

insert into cliente (nome, logradouro, num, cep) values
('Matilde Luz', 'Rua Síria', '150', '03086040'),
('Carlos Carreiro', 'Rua Bartolomeu Aires', '1250', '04419110'),
('Daniel Ramalho', 'Rua Itajutiba', '169', NULL),
('Roberta Bento', 'Rua Jayme Von Rosenburg', '36', NULL),
('Rosa Cerqueira', 'Rua Arnaldo Simões Pinto', '235', '02917110')
go

insert into locacao (dvdNum, clienteNum, data_locacao, data_devolucao, valor) values
('10001', '5502', '2021-02-18', '2021-02-21', '3.50'),
('10009', '5502', '2021-02-18', '2021-02-21', '3.50'),
('10002', '5503', '2021-02-18', '2021-02-19', '3.50'),
('10002', '5505', '2021-02-20', '2021-02-23', '3.00'),
('10004', '5505', '2021-02-20', '2021-02-23', '3.00'),
('10005', '5505', '2021-02-20', '2021-02-23', '3.00'),
('10001', '5501', '2021-02-24', '2021-02-26', '3.50'),
('10008', '5501', '2021-02-24', '2021-02-26', '3.50')
go

insert into filme_estrela (filmeId, estrelaId) values
('1002', '9901'),
('1002', '9902'),
('1001', '9903'),
('1005', '9904'),
('1005', '9905')
go

update cliente
set cep = '08411150'
where num_cadastro = '5503'
go

update cliente 
set cep = '02918190'
where num_cadastro = '5504'
go

update locacao
set valor = '3.25'
where data_locacao = '2021-02-18' and clienteNum = '5502'
go

update locacao 
set valor = '3.10'
where data_locacao = '2021-02-24' and clienteNum = '5501'
go

update dvd 
set data_fabricacao = '2019-07-14'
where num = '10005'	
go

update estrela 
set nome_real = 'Miles Alexander Teller'
where nome = 'Miles Teller'
go

delete from filme
where titulo = 'Sing'
go

select titulo
from filme
where ano = '2014'

select id, ano
from filme
where titulo = 'Birdman'

select id, ano
from filme
where titulo like '%plash'

select id, nome, nome_real
from estrela
where nome like 'Steve%'

select filmeId, convert(char(10), data_fabricacao, 103) as fab
from dvd
where data_fabricacao >= '20200101'

select dvdNum, data_locacao, data_devolucao, valor, valor + 2.00 as valor_com_multa
from locacao
where clienteNum = 5505

select logradouro, num, cep
from cliente 
where nome = 'Matilde Luz'

select nome_real
from estrela
where nome = 'Michael Keaton'

select num_cadastro, nome,
       logradouro + ', ' + cast(num as varchar(10)) + ', ' + cep as end_comp
from cliente
where num_cadastro >= 5503

