USE sakib_ci
SELECT COUNT(1) FROM Sys.synonyms WHERE  base_object_name NOT LIKE '%sakib%'

SELECT * FROM COMMONTNP WITH(NOLOCK) WHERE ATID=60 
-------------------------------------------------------------------------------------------------------
SELECT * FROM ERRORTNP WITH(NOLOCK)     