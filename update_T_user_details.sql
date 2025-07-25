USE master
Update t_user_details Set Status=1 where login_name in('NEWVISIONSOFT\TESTING_USERS') and db_name in ('sakib_ci', 'sakib_cc', 'sakib_cl','sakib_cauth')

