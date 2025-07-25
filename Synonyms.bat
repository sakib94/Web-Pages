TITLE Restore Database

ECHO start job "BPLQADB01_DBOWNER_Permission"  from SSMS  

timeout 05

sqlcmd -S BPLQADB01 -i "SQL\start_Job.sql"

timeout 05

ECHO "Correcting Synonym"
sqlcmd -S BPLQADB01 -i "SQL\Syn_KB(one_click).sql" -o "Output\Synonym.out"


ECHO "Checking Synonyms"
sqlcmd -S BPLQADB01 -i "SQL\Synonym_Check.sql"

ECHO "Done"