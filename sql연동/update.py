# -*- coding: utf-8 -*-
"""
Created on Thu May 19 16:16:28 2022

@author: BIT
"""
# 사용자 아이디를 입력받고 유저이름을 입력했을때 유저아이디를 가지는 유저 이름을 아무개로 바꿔라
import pymysql

conn, cur = None, None
userId, userName = "",""

conn = pymysql.connect(host='127.0.0.1', user='root', password='root', db='test2db', charset='utf8')
cur = conn.cursor()

updateID = input("수정할 이름의 아이디 : ")
updatename = input("수정할 이름 : ")
cur.execute("update usertable set userName = '%s' where Id = '%s'" % (updatename, updateID))

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

conn.commit()
conn.close()
