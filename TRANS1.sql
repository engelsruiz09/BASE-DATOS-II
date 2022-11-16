begin tran uno
--select*
--from accidente
--where idAccidente <> 12

update accidente
set AlturaNivelMar = 1000
where idAccidente = 12
rollback
