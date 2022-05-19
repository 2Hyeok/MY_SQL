# -*- coding: utf-8 -*-
"""
Created on Thu May 19 16:21:00 2022

@author: BIT
"""
# 유저 아이디를 입력받고 해당 테이블을 삭제하는것

import pymysql

conn, cur = None, None
deleteID = ""

conn = pymysql.connect(host='127.0.0.1', user='root', password='root',\
                       db='test2db', charset='utf8')
cur = conn.cursor()

deleteID = input("어떤 ID를 삭제할까요?: ")

cur.execute("DELETE from userTable where id='%s'" % deleteID)


cur.execute("SELECT * FROM userTable")
print("사용자ID        사용자이름      이메일          출생연도")
print('-------------------------------------------------------')

while(True):
    row = cur.fetchone()
    if row == None:
        break
    userID = row[0]
    userName = row[1]
    useremail = row[2]
    birthYear = row[3]
    print("%5s  %15s    %15s    %d" % (userID, userName, useremail, birthYear))
    
conn.commit()
conn.close()