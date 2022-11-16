begin tran dos
select*
from accidente--(nolock)
where idAccidente in (3,5,1)

update accidente
set AlturaNivelMar = 1000
where idAccidente <> 12
rollback

insert accidente
values(100,1,'xyz',1)

insert Accidente
values(100,1,'xyz',1)

