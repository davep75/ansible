#!/usr/bin/python3
import pymysql 

# Print headers
print("Content-Type: text/html")
print()

# connect to database
conn = pymysql.connect(
            db='testdb',
            user='cmdb',
            password='Scdp62dr@p3r',
            host='localhost')
c = conn.cursor()

# Print contents
c.execute("SELECT * FROM test;")
for i in c:
    print(i)
