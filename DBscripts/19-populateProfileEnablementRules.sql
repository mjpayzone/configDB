USE [TerminalConfig_V5_MJ]
GO

begin transaction

insert into EnablementRules 
(ER_ProductGroupID, ER_ProfileRule)
values 
(10,'IN (588,589,592,593,594,595,596,597,598,599) ')
--(10,'IN (607,608,611,612,613,614,615,616,617,618)')
--
insert into EnablementRules 
(ER_ProductGroupID, ER_ProfileRule)
values 
(11,'NOT IN (591)')
--(11,'NOT IN (610)')
--
insert into EnablementRules 
(ER_ProductGroupID, ER_ProfileRule)
values 
(13,'NOT IN (590,591)')
--(13,'NOT IN (609,610)')
--
insert into EnablementRules 
(ER_ProductGroupID, ER_ProfileRule)
values 
(14,'NOT IN (590,591)')
--(14,'NOT IN (609,610)')
--
insert into EnablementRules 
(ER_ProductGroupID, ER_ProfileRule)
values 
(16,'NOT IN (590,591)')
--(16,'NOT IN (609,610)')
--
insert into EnablementRules 
(ER_ProductGroupID, ER_ProfileRule)
values 
(17,'NOT IN (590,591)')
--(17,'NOT IN (609,610)')
--
insert into EnablementRules 
(ER_ProductGroupID, ER_ProfileRule)
values 
(19,'NOT IN (590,591)')
--(19,'NOT IN (609,610)')
--
insert into EnablementRules 
(ER_ProductGroupID, ER_ProfileRule)
values 
(21,'NOT IN (590,591)')
--(21,'NOT IN (609,610)')
--
insert into EnablementRules 
(ER_ProductGroupID, ER_ProfileRule)
values 
(24,'IN (588,592,593,594,595,596,597,598,599)')
--(24,'IN (607,611,612,613,614,615,616,617,618)')
--
insert into EnablementRules 
(ER_ProductGroupID, ER_ProfileRule)
values 
(25,'NOT IN (590,591)')
--(25,'NOT IN (609,610)')
--
insert into EnablementRules 
(ER_ProductGroupID, ER_ProfileRule)
values 
(26,'IN (588,592,593,594,595,596,597,598,599)')
--(26,'IN (607,611,612,613,614,615,616,617,618)')
--
insert into EnablementRules 
(ER_ProductGroupID, ER_ProfileRule)
values 
(27,'NOT IN (589,590)')
--(27,'NOT IN (609,610)')
--
insert into EnablementRules 
(ER_ProductGroupID, ER_ProfileRule)
values 
(37,'IN (588,592,593,594,595,596,597,598,599)')
--(37,'IN (607,611,612,613,614,615,616,617,618)')
--
insert into EnablementRules 
(ER_ProductGroupID, ER_ProfileRule)
values 
(38,'NOT IN (590,591)')
--(38,'NOT IN (609,610)')
--
commit transaction