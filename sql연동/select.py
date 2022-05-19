# -*- coding: utf-8 -*-
"""
Created on Thu May 19 16:05:53 2022

@author: BIT
"""

import pymysql


conn, cur = None, None
userId, userName, useremail, birthYear = "","","",""
row=None

#메인 코드
conn = pymysql.connect(host='127.0.0.1', user='root', password='root', db='test2db', charset='utf8')
cur = conn.cursor()
cur.execute("select * from usertable")

print("사용자ID          사용자이름   이메일        출생연도")
print("-------------------------------------------------------")

while(True) :
    row = cur.fetchone()
    if row == None :
        break
    userId = row[0]
    userName = row[1]
    useremail = row[2]
    birthYear = row[3]
    print("%5s  %15s  %15s  %d" % (userId, userName, useremail, birthYear))