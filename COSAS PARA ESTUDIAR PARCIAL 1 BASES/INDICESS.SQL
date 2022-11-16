/*
Missing Index Details from OPTIMIZACIONDECONSULTAS.sql - DESKTOP-7JVFE0D.AdventureWorks2019 (DESKTOP-7JVFE0D\julio ruiz (61))
The Query Processor estimates that implementing the following index could improve the query cost by 56.4382%.
*/
--MISSING INDEX DETAILS
*
USE [AdventureWorks2019]
GO
CREATE NONCLUSTERED INDEX IX_SALESORDERDETAIL_UNITPRICE
ON [Sales].[SalesOrderDetail] ([UnitPrice])
--INCLUDE ([CarrierTrackingNumber],[OrderQty],[ProductID],[SpecialOfferID],[UnitPriceDiscount],[LineTotal],[rowguid],[ModifiedDate])
GO
*/
