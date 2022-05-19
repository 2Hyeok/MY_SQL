# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.
"""
import pymysql

# 전역변수 선언부
conn, cur = None, None
userId, userName, useremail, birthYear = "","","",""
sql=""

#메인 코드
conn = pymysql.connect(host='127.0.0.1', user='root', password='root', db='test2db', charset='utf8')
cur = conn.cursor()

#테이블 생성
cur.execute("create table userTable(id char(4), userName char(15), email char(30), birthYear int)")

#데이터 입력
while (True) :
    userId = input("사용자 ID ==> ")
    if userId == "" :
        break;
    userName = input("사용자 이름 ==> ")
    useremail = input("사용자 이메일 ==> ")
    birthYear = input("사용자 출생연도 ==> ")
    sql = "insert into userTable values('" + userId + "','" + userName + "','" + useremail + "'," + birthYear + ")"
    cur.execute(sql)

conn.commit()
conn.close()
