-- =================================================================================================  
-- Author        :  Sakib Ahmad  (Date: 07/15/2020)
-- Purpose      :  Update Synonyms
-- Reference  :  This Secipt Will Drop Existting Synonyms from DB and create it With DB Name mentioned below
-- =================================================================================================  
DECLARE @i INT

SET @i = 4

WHILE (@i > 0)
BEGIN
			IF (@i = 4)
						USE sakib_cauth
			ELSE IF (@i = 3)
						USE sakib_ci
			ELSE IF (@i = 2)
						USE sakib_CL
			ELSE
						USE sakib_cc

			SELECT DB_NAME() /*It will select DBs sakib_cauth, sakib_ci, sakib_CL, sakib_cc one by one based on loop*/

			SELECT base_object_name
						, *
			FROM Sys.synonyms
			ORDER BY Name DESC

			SELECT *
			INTO #TempSyn
			FROM Sys.synonyms /*It will create backup of exisitng synonyms in DB into a new table #TempSyn*/

			SELECT *
			FROM #TempSyn

			DECLARE @CAuth_db VARCHAR(40) = 'sakib_cauth' /*Declaration of CoreAuth DB*/
			DECLARE @CI_db VARCHAR(40) = 'sakib_ci' /*Declaration of CoreIssue DB*/
			DECLARE @CL_db VARCHAR(40) = 'sakib_CL' /*Declaration of CoreLibrary DB*/
			DECLARE @CC_db VARCHAR(40) = 'sakib_cc' /*Declaration of CoreCollect DB*/

			/*It will set base_object_name in backup table #TempSyn for repective DBs*/
			--===================================================For Cauth DB======================================================================================
			UPDATE #TempSyn
			SET base_object_name = '[' + @CAuth_db + ']' + SUBSTRING(base_object_name, CHARINDEX(']', base_object_name) + 1, LEN(base_object_name))
			WHERE base_object_name LIKE '%Auth].%'
						OR base_object_name LIKE '%CA].%'

			--===================================================For CI DB======================================================================================
			UPDATE #TempSyn
			SET base_object_name = '[' + @CI_db + ']' + SUBSTRING(base_object_name, CHARINDEX(']', base_object_name) + 1, LEN(base_object_name))
			WHERE base_object_name LIKE '%CI].%'
						OR base_object_name LIKE '%CoreIssue].%'

			--===================================================For CC DB======================================================================================
			UPDATE #TempSyn
			SET base_object_name = '[' + @CC_db + ']' + SUBSTRING(base_object_name, CHARINDEX(']', base_object_name) + 1, LEN(base_object_name))
			WHERE base_object_name LIKE '%CC].%'
						OR base_object_name LIKE '%CoreCollect].%'
						OR base_object_name LIKE '%CCollect].%'

			--===================================================For CL DB======================================================================================
			UPDATE #TempSyn
			SET base_object_name = '[' + @CL_db + ']' + SUBSTRING(base_object_name, CHARINDEX(']', base_object_name) + 1, LEN(base_object_name))
			WHERE base_object_name LIKE '%CL].%'
						OR base_object_name LIKE '%CoreLibrary].%'
						OR base_object_name LIKE '%Clibrary].%'
						OR base_object_name LIKE '%Library].%'
						OR base_object_name LIKE '%CLib].%'

			--==========================================================================================================================================================
			DECLARE @Row INT

			SELECT @Row = Count(1)
			FROM #TempSyn

			PRINT @Row

			WHILE (@Row > 0)
			BEGIN
						DECLARE @SQlSyn VARCHAR(500)

						SELECT TOP 1 @SQlSyn = 'DROP SYNONYM ' + Name + ' CREATE SYNONYM ' + Name + ' FOR ' + base_object_name
						FROM #TempSyn
						ORDER BY Name DESC

						PRINT @SQlSyn

						EXEC (@SQlSyn)

						DELETE
						FROM #TempSyn
						WHERE Name = (
												SELECT TOP 1 Name
												FROM #TempSyn
												ORDER BY Name DESC
												)

						SET @Row = @Row - 1

						PRINT @Row
			END

			DROP TABLE #TempSyn /* It will drop temporary table #TempSyn */

			SELECT @i = @i - 1
END
						--==========================================================================================================================================================
						--==========================================================================================================================================================
						--------------------------------Check Synonyms in each DBs----------------------------------------------------------------------------------------
						/*
Declare @j int
set @j = 4
While (@j > 0 )
BEGIN
 if(@j= 4)
   use sakib_cauth
 else if(@j = 3)
  use sakib_ci
 else if (@j = 2)
  use sakib_CL
 else
  use sakib_cc

Select Name,base_object_name from Sys.synonyms   order by Name desc 
select @j = @j - 1
end

*/
