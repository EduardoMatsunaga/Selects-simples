use master
go
if db_id('projetos') is not null
begin
    alter database projetos set single_user with rollback immediate
    drop database projetos
end
go

create database projetos
go
use projetos
go

create table projects (
id int not null	identity (10001,1),
nome varchar(45) not null,
descricao varchar(45) null,
dataa date not null check (dataa > '20140901'),
primary key (id))
go

create table users (
id int not null	identity (1,1),
nome varchar(45) not null,
username varchar(45) not null constraint uq_users_username unique,  
senha varchar (45) not null default ('123mudar'),
email varchar(45) not null,
primary key (id))
go

create table users_has_projects (   
usersId int not null,
projectsId int not null,
primary key (usersId, projectsId),
foreign key (usersId) references users (id),
foreign key (projectsId) references projects (id))
go

alter table users
drop constraint uq_users_username
go

alter table users
alter column username varchar(10) not null
go

alter table users
add constraint uq_users_username unique (username)
go

alter table users
alter column senha varchar(8) not null
go

insert into users(nome, username, senha, email) values
('Maria', 'Rh_maria', default, 'maria@empresa.com'),
('Paulo', 'Ti_paulo', '123@456', 'paulo@empresa.com'),
('Ana', 'Rh_ana', default, 'ana@empresa.com'),
('Clara', 'Ti_clara', default, 'clara@empresa.com'),
('Aparecido', 'Rh_apareci', '55@!cido', 'aparecido@empresa.com')
go

insert into projects(nome, descricao, dataa) values
('Re-folha', 'Refatoracao das folhas', '2014-09-05'),
('Manutenção PCs', 'Manutenção PCs', '2014-09-06'),
('Auditoria', null, '2014-09-07')
go

update projects
set dataa = '2014-09-12'
where nome = 'Manutenção PCs'
go

update users 
set username = 'Rh_cido'
where nome = 'Aparecido'
go

insert into users_has_projects (usersId, projectsId) values
(1, 10001),
(5, 10001),
(3, 10003),
(4, 10002),
(2, 10002)
go

update users
set senha = '888@*'
where username = 'Rh_maria' and senha = '123mudar'
go

delete from users_has_projects
where usersId = 2 and projectsId = 10002
go

select * from users
select * from projects
select * from users_has_projects
