CREATE PROCEDURE speliminarvuelo @idvuelo int
AS
BEGIN
BEGIN TRAN
	DECLARE @total as int =(select count(*) from vuelopasajero where idvuelo=@idvuelo );

	UPDATE Vuelo set Estatus= 0 where idVuelo = @idvuelo; --cambiar dicho estatus eliminado
	IF @total >= 1
		BEGIN
			COMMIT
			RAISERROR ('si hay reservas',16,1);
			UPDATE VueloPasajero SET idTipoEstatus = 1
								WHERE idvuelo = @idvuelo; --estatus 1- levantado
																	  --0 - cancelado
		END
	ELSE
		BEGIN 
			rollback
			RAISERROR ('no hay reservas',16,1);
		END

END;
GO
DROP PROCEDURE dbo.speliminarvuelo;
GO
exec speliminarvuelo 10;

insert into tipopasajero values('corporativo')
insert into tipoavion values('comercial');
insert into avion values(1,'airlines',60,200)
insert into vuelo values(1,1,'lima','nueva york','jor','flo',GETDATE(),GETDATE(),'C')
insert into vuelo values(1,1,'montevideo','nueva york','fer','flo',GETDATE(),GETDATE(),'C')
insert into pasajero values(1,'juan','ramirez','87688',GETDATE());
insert into tipoasiento values('vip');
insert into asiento values(1,1,5);
insert into tipoestatus values('confirmado')
insert into tipoestatus values('cancelado')
insert into tipoestatus values('reservado')
insert into tipoestatus values('eliminado')
insert into vuelopasajero values(10,1,1,1,1,GETDATE());

select * from VueloPasajero
select * from Vuelo