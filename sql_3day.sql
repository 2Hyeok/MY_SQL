use moviedb;

create table movietbl
(movie_id int,
 movie_title varchar(30),
 movie_director varchar(20),
 movie_star varchar(20),
 movie_script longtext,
 movie_film longblob
 ) default charset=utf8mb4;
 
 desc movietbl;
 
 insert into movietbl values(1, '쉰들러 리스트', '스필버그', '리암니슨', load_file('C:/Users/BIT/Desktop/sql/Movies/Schindler.txt'),
																 load_file('C:/Users/BIT/Desktop/sql/Movies/Schindler.mp4'));

select * from movietbl;

show variables like 'max_allowed_packet';

show variables like 'secure_file_priv';
-- ini파일 수정후 다시 시작, ini파일 수정후 null값인 txt파일이 출력가능
truncate movietbl; -- 기존 행 모두 제거

insert into movietbl values(1, '쉰들러 리스트', '스필버그', '리암니슨', load_file('C:/Movies/Schindler.txt'),
																 load_file('C:/Movies/Schindler.mp4'));
                                                                 
insert into movietbl values(2, '쇼생크 탈출', '프랭크 다라본트', '팀 로빈스', load_file('C:/Movies/Shawshank.txt'),
																 load_file('C:/Movies/Shawshank.mp4'));
                                                                 
insert into movietbl values(3, '라스트 모히칸', '마이클 만', '다니엘 데이 루이스', load_file('C:/Movies/Mohican.txt'),
																 load_file('C:/Movies/Mohican.mp4'));
                                                                 
select * from movietbl;

select movie_script from movietbl where movie_id = 1  -- 텍스트파일을 다른이름으로 복사하여 저장
	into outfile 'C:/Movies/Schindler_out.txt'
    lines terminated by '\\n';
    
select movie_script from movietbl where movie_id = 3 -- 동영상 파일을 다른이름으로 복사하여 저장
	into dumpfile 'C:/Movies/Mohican_out.mp4';

-- 피벗 구현
use sqldb;
create table pivottest
( uName char(3),
 season char(2),
 amount int);
 
 INSERT  INTO  pivottest VALUES
   ('김범수' , '겨울',  10) , ('윤종신' , '여름',  15) , ('김범수' , '가을',  25) , ('김범수' , '봄',    3) ,
   ('김범수' , '봄',    37) , ('윤종신' , '겨울',  40) , ('김범수' , '여름',  14) ,('김범수' , '겨울',  22) ,
   ('윤종신' , '여름',  64) ;
   
select * from pivottest;

select uName,
	sum(if(season = '봄', amount, 0)) as '봄',
    sum(if(season = '여름', amount, 0)) as '여름',
    sum(if(season = '가을', amount, 0)) as '가을',
    sum(if(season = '겨울', amount, 0)) as '겨울',
    sum(amount) as '합계' from pivottest group by uName;
    
-- json 활용
select json_object('name', name, 'height', height) as 'json 값'
	from usertbl
    where height >= 180;
    
set @json = '{ "usertbl" : 
	[
		{"name" : "임재범", "height" : 182},
        {"name" : "이승기", "height" : 182},
        {"name" : "성시경", "height" : 186}
	]
}' ;
select json_valid(@json) as json_valid;
select json_search(@json, 'one', '성시경') as json_search;
select json_extract(@json, '$.usertbl[2].name') as json_extract;
select json_insert(@json, '$.usertbl[0].mDate', '2009-09-09') as json_insert;
select json_replace(@json, '$.usertbl[0].name', '홍길동') as json_replace;
select json_remove(@json, '$.usertbl[0]') as json_remove;

-- 조인
-- 두개 이상의 테이블을 서로 묶어서 하나의 결합 집합으로 만들어 내는 것

-- 내부조인
/* 조인 중에서 가장 많이 사용되는 조인
select <열 목록>
from 첫번째 테이블
	inner join 두번째 테이블
	on 조인될 조건
[where 조건검색]
*/

use sqldb;
select * from buytbl
	inner join usertbl
    on buytbl.userId = usertbl.userId
where buytbl.userId = 'JYP';

select * from buytbl
	inner join usertbl
    on buytbl.userId = usertbl.userId
order by num;

-- 오류구문
select userId, name, prodName, addr, concat(mobile1, mobile2) as '연락처' from buytbl
	inner join usertbl
    on buytbl.userId = usertbl.userId
order by num;

-- 오류구문 해결
select buytbl.userId, name, prodName, addr, concat(mobile1, mobile2) as '연락처' from buytbl
	inner join usertbl
    on buytbl.userId = usertbl.userId
order by num;

-- 테이블 이름 명시
select buytbl.userId, usertbl.name, buytbl.prodName, usertbl.addr, concat(usertbl.mobile1, usertbl.mobile2) as '연락처' 
	from buytbl
	inner join usertbl
    on buytbl.userId = usertbl.userId
order by num;

-- 테이블의 별칭을 주어 간결하게 가능
select B.userId, U.name, B.prodName, U.addr, concat(U.mobile1, U.mobile2) as '연락처' from buytbl B
	inner join usertbl U
		on B.userId = U.userId
order by B.num;

-- 구매 테이블 기준으로 jyp 아이디 사용자 조인하여 결과 출력
select B.userId, U.name, B.prodName, U.addr, concat(U.mobile1, U.mobile2) as '연락처' from buytbl B
	inner join usertbl U
		on B.userId = U.userId
where B.userId = 'jyp';

-- 유저 테이블 기준으로 jyp 결과 출력
select U.userId, U.name, B.prodName, U.addr, concat(U.mobile1, U.mobile2) as '연락처' from usertbl U
	inner join buytbl B
		on U.userId = B.userId
where B.userId = 'jyp';

-- where 조건을 뺀 후 결과보기 - 회원 아이디 순으로
select U.userId, U.name, B.prodName, U.addr, concat(U.mobile1, U.mobile2) as '연락처' from usertbl U
	inner join buytbl B
		on U.userId = B.userId
order by B.userId = 'jyp';

-- distinct 문을 활용하여 회원의 주소록 가져오기
select distinct U.userId, U.name, U.addr from usertbl U
	inner join buytbl B
		on U.userId = B.userId
	order by U.userId;
    
-- exists문 활용하기
select U.userId, U.name, U.addr from usertbl U
	where exists(
		select * from buytbl B
        where U.userId = B.userId);

-- 세 개 이상의 테이블 조인
create table stdtbl
( stdName varchar(10) not null primary key,
  addr char(4) not null
  );
create table clubtbl
( clubName varchar(10) not null primary key,
  roomNo char(4) not null
  );
  create table stdclubtbl
  ( num int auto_increment not null primary key,
    stdName varchar(10) not null,
    clubName varchar(10) not null,
    foreign key(stdName) references stdtbl(stdName),
    foreign key(clubName) references clubtbl(clubName)
    );
    
    insert into stdtbl values ('김범수', '경남'), ('성시경', '서울'), ('조용필', '경기'), ('은지원', '경북'), ('바비킴', '서울');
    insert into clubtbl values ('수영', '101호'), ('바둑', '102호'), ('축구', '103호'), ('봉사', '104호');
    
    select * from stdtbl;
    select * from clubtbl;
    
    insert into stdclubtbl values (null, '김범수', '바둑'), (null, '김범수', '축구'), (null, '조용필', '축구'),
						(null, '은지원', '축구'), (null, '은지원', '봉사'), (null, '바비킴', '봉사');
                        
select * from stdclubtbl;

-- 학생을 기준으로 이름/지역/가입한동아리/ 동아리방을 출력
select S.stdName, S.addr, C.clubName, C.roomNo from stdtbl S
	inner join stdclubtbl SC
		on S.stdName = SC.stdName
	inner join clubtbl C
		on SC.clubName = C.clubName
order by S.stdName;

-- clubtbl 이 조인되는 형식으로 쿼리문 작성
select C.clubName, C.roomNo, S.stdName, S.addr from stdtbl S
	inner join stdclubtbl SC
		on SC.stdName = S.stdName
	inner join clubtbl C
		on SC.clubName = C.clubName
	order by C.clubName;
    
-- 외부조인
-- 조인의 조건에 만족되지 않는 행까지도 포함
/* select
	from
		<left|right|full> outer join
			on 조인될 조건
		where 조건검색;
*/
use sqldb;

-- 왼쪽 테이블의 것 모두 출력
select U.userId, U.name, B.prodName, U.addr, concat(U.mobile1, U.mobile2) as '연락처' from usertbl U
	left outer join buytbl B
		on U.userId = B.userId
	order by U.userId;

-- 오른쪽 테이블의 것 모두 출력
select U.userId, U.name, B.prodName, U.addr, concat(U.mobile1, U.mobile2) as '연락처' from buytbl B
	right outer join usertbl U
		on U.userId = B.userId
	order by U.userId;
    
-- 구매한 적 없는 유령회원
select U.userId, U.name, B.prodName, U.addr, concat(U.mobile1, U.mobile2) as '연락처' from usertbl U
	left outer join buytbl B
		on U.userId = B.userId
	where B.prodName is null
	order by U.userId;
    
-- left / right / full outer join 실습

use sqldb;
SELECT S.stdName, S.addr, C.clubName, C.roomNo FROM stdtbl S 
      LEFT OUTER JOIN stdclubtbl SC
          ON S.stdName = SC.stdName
      LEFT OUTER JOIN clubtbl C
          ON SC.clubName = C.clubName
   ORDER BY S.stdName;

SELECT C.clubName, C.roomNo, S.stdName, S.addr FROM  stdtbl S
      LEFT OUTER JOIN stdclubtbl SC
          ON SC.stdName = S.stdName
      RIGHT OUTER JOIN clubtbl C
          ON SC.clubName = C.clubName
   ORDER BY C.clubName ;

SELECT S.stdName, S.addr, C.clubName, C.roomNo FROM stdtbl S 
      LEFT OUTER JOIN stdclubtbl SC
          ON S.stdName = SC.stdName
      LEFT OUTER JOIN clubtbl C
          ON SC.clubName = C.clubName
UNION  -- 합산
SELECT S.stdName, S.addr, C.clubName, C.roomNo FROM  stdtbl S
      LEFT OUTER JOIN stdclubtbl SC
          ON SC.stdName = S.stdName
      RIGHT OUTER JOIN clubtbl C
          ON SC.clubName = C.clubName;
          
-- cross join 상호 조인 모든 행들과 다른 쪽 테이블의 모든행을 조인
select * from buytbl
	cross join usertbl; -- cross join 구문

-- 카운트문
use employees;
select count(*) as '데이터의 개수' from employees
	cross join titles;
    
-- self join (자체조인) 자기자신이 조인한다는 의미
use sqldb;

CREATE TABLE empTbl (emp CHAR(3), manager CHAR(3), empTel VARCHAR(8));

INSERT INTO empTbl VALUES('나사장',NULL,'0000');
INSERT INTO empTbl VALUES('김재무','나사장','2222');
INSERT INTO empTbl VALUES('김부장','김재무','2222-1');
INSERT INTO empTbl VALUES('이부장','김재무','2222-2');
INSERT INTO empTbl VALUES('우대리','이부장','2222-2-1');
INSERT INTO empTbl VALUES('지사원','이부장','2222-2-2');
INSERT INTO empTbl VALUES('이영업','나사장','1111');
INSERT INTO empTbl VALUES('한과장','이영업','1111-1');
INSERT INTO empTbl VALUES('최정보','나사장','3333');
INSERT INTO empTbl VALUES('윤차장','최정보','3333-1');
INSERT INTO empTbl VALUES('이주임','윤차장','3333-1-1');

select * from empTbl;

select A.emp as '부하직원', B.emp as '직속상관', B.empTel as '직속상관 연락처' from empTbl A
	inner join empTbl B
		on A.manager = B.emp
	where A.emp = '우대리';

-- union / union all / not in/ in
-- union - 중복열 제거후 데이터 정렬
-- union all 중복열을 포함하여 모두 출력
SELECT stdName, addr FROM stdtbl
   UNION ALL
SELECT clubName, roomNo FROM clubtbl;

-- not in - 첫번째 쿼리의 결과중 두번째 쿼리의 결과를 제외하는것
SELECT name, CONCAT(mobile1, mobile2) AS '전화번호' FROM usertbl
   WHERE name NOT IN ( SELECT name FROM usertbl WHERE mobile1 IS NULL);

-- in - 첫번째 쿼리의 결과중 두번째 쿼리에 해당하는것만 조회
SELECT name, CONCAT(mobile1, mobile2) AS '전화번호' FROM usertbl
   WHERE name IN ( SELECT name FROM usertbl WHERE mobile1 IS NULL);

/* ================================ 테이블과 뷰 ===================================== */
create database tabledb;
use tabledb;

DROP TABLE IF EXISTS buytbl, usertbl;

CREATE TABLE usertbl 
( userID  CHAR(8) NOT NULL PRIMARY KEY, -- 제약조건 (constraint)
  name    VARCHAR(10) NOT NULL, 
  birthYear   INT NOT NULL,  
  addr     CHAR(2) NOT NULL,
  mobile1   CHAR(3) NULL, 
  mobile2   CHAR(8) NULL, 
  height    SMALLINT NULL, 
  mDate    DATE NULL 
);
CREATE TABLE buytbl 
(  num INT auto_increment NOT NULL PRIMARY KEY, 
   userid  CHAR(8) NOT NULL ,
   prodName CHAR(6) NOT NULL,
   groupName CHAR(4) NULL , 
   price     INT  NOT NULL,
   amount    SMALLINT  NOT NULL,
   foreign key(userid) references usertbl(userID)
);

INSERT INTO usertbl VALUES('LSG', '이승기', 1987, '서울', '011', '1111111', 182, '2008-8-8');
INSERT INTO usertbl VALUES('KBS', '김범수', 1979, '경남', '011', '2222222', 173, '2012-4-4');
INSERT INTO usertbl VALUES('KKH', '김경호', 1971, '전남', '019', '3333333', 177, '2007-7-7');

INSERT INTO buytbl VALUES(NULL, 'KBS', '운동화', NULL, 30, 2);
INSERT INTO buytbl VALUES(NULL, 'KBS', '노트북', '전자', 1000, 1);
INSERT INTO buytbl VALUES(NULL, 'JYP', '모니터', '전자', 200, 1); -- 한번에 묶어서 실행시 부모테이블에 'jyp'값이 없기 때문에 이 이후부터는 추가불가

-- 추가 입력 
INSERT INTO usertbl VALUES('JYP', '조용필', 1950, '경기', '011', '4444444', 166, '2009-4-4'); -- 이테이블을 먼저 추가 후 위에 추가하면 가능
INSERT INTO usertbl VALUES('SSK', '성시경', 1979, '서울', NULL  , NULL      , 186, '2013-12-12');
INSERT INTO usertbl VALUES('LJB', '임재범', 1963, '서울', '016', '6666666', 182, '2009-9-9');
INSERT INTO usertbl VALUES('YJS', '윤종신', 1969, '경남', NULL  , NULL      , 170, '2005-5-5');
INSERT INTO usertbl VALUES('EJW', '은지원', 1972, '경북', '011', '8888888', 174, '2014-3-3');
INSERT INTO usertbl VALUES('JKW', '조관우', 1965, '경기', '018', '9999999', 172, '2010-10-10');
INSERT INTO usertbl VALUES('BBK', '바비킴', 1973, '서울', '010', '0000000', 176, '2013-5-5');
INSERT INTO buytbl VALUES(NULL, 'JYP', '모니터', '전자', 200,  1);
INSERT INTO buytbl VALUES(NULL, 'BBK', '모니터', '전자', 200,  5);
INSERT INTO buytbl VALUES(NULL, 'KBS', '청바지', '의류', 50,   3);
INSERT INTO buytbl VALUES(NULL, 'BBK', '메모리', '전자', 80,  10);
INSERT INTO buytbl VALUES(NULL, 'SSK', '책'    , '서적', 15,   5);
INSERT INTO buytbl VALUES(NULL, 'EJW', '책'    , '서적', 15,   2);
INSERT INTO buytbl VALUES(NULL, 'EJW', '청바지', '의류', 50,   1);
INSERT INTO buytbl VALUES(NULL, 'BBK', '운동화', NULL   , 30,   2);
INSERT INTO buytbl VALUES(NULL, 'EJW', '책'    , '서적', 15,   1);
INSERT INTO buytbl VALUES(NULL, 'BBK', '운동화', NULL   , 30,   2);

select * from usertbl;
select * from buytbl;

DROP TABLE IF EXISTS buytbl, usertbl;
CREATE TABLE usertbl 
( userID  CHAR(8) NOT NULL PRIMARY KEY, 
  name    VARCHAR(10) NOT NULL, 
  birthYear   INT NOT NULL
);

DESCRIBE usertbl;

-- 프라이머리키 추가
DROP TABLE IF EXISTS usertbl;
CREATE TABLE usertbl 
( userID  CHAR(8) NOT NULL, 
  name    VARCHAR(10) NOT NULL, 
  birthYear   INT NOT NULL,  
  CONSTRAINT PRIMARY KEY PK_usertbl_userID (userID)
);

DROP TABLE IF EXISTS usertbl;

-- 프라이머리키 없음
CREATE TABLE usertbl 
(   userID  CHAR(8) NOT NULL, 
    name    VARCHAR(10) NOT NULL, 
    birthYear   INT NOT NULL
);

desc usertbl; -- 생성시 userID값에 primary key없음

-- constraint 를 이용해 primary key 추가해주기
alter table usertbl
	add constraint PK_usertbl_userID
    primary key(userID);
-- --------------------------------------------------------------
DROP TABLE IF EXISTS prodTbl;

CREATE TABLE prodTbl
( prodCode CHAR(3) NOT NULL,
  prodID   CHAR(4)  NOT NULL,
  prodDate DATETIME  NOT NULL,
  prodCur  CHAR(10) NULL
);

alter table prodTbl
	add constraint PK_prodTbl_prodCode
    primary key(prodCode);
    
-- 칼럼 2개에 primary key값 넣기
alter table prodTbl
	add constraint PK_prodTbl_prodCode
    primary key(prodCode, prodID);
    
desc prodTbl;

-- --------------------------------------------------------------
-- foreign키
DROP TABLE IF EXISTS buytbl;
CREATE TABLE buytbl 
(  num INT AUTO_INCREMENT NOT NULL PRIMARY KEY , 
   userID  CHAR(8) NOT NULL, 
   prodName CHAR(6) NOT NULL,
   CONSTRAINT FK_usertbl_buytbl FOREIGN KEY(userID) REFERENCES usertbl(userID)
);

DROP TABLE IF EXISTS buytbl;
CREATE TABLE buytbl 
(  num INT AUTO_INCREMENT NOT NULL PRIMARY KEY , 
   userID  CHAR(8) NOT NULL, 
   prodName CHAR(6) NOT NULL,
   CONSTRAINT FK_usertbl_buytbl FOREIGN KEY(userID) REFERENCES usertbl(userID)
);

-- foreing key 제거
alter table buytbl
	drop constraint FK_usertbl_buytbl; -- 외래키 제거
    
-- foreing key 추가
alter table buytbl
	add constraint FK_usertbl_buytbl
	foreign key (userID)
	references usertbl(userID);
    
alter table buytbl
	add constraint FK_usertbl_buytbl
	foreign key (userID)
	references usertbl(userID)
	on update cascade;

show index from buytbl; -- buytbl내에 있는 제약조건 정보확인

-- unique - 중복되지않는 유일한 값을 입력해야함, null값 허용
DROP TABLE IF EXISTS buytbl, usertbl;

CREATE TABLE usertbl 
( userID  CHAR(8) NOT NULL PRIMARY KEY, 
  name    VARCHAR(10) NOT NULL, 
  birthYear   INT NOT NULL,  
  email   CHAR(30) NULL  UNIQUE
);

CREATE TABLE usertbl 
( userID  CHAR(8) NOT NULL PRIMARY KEY, 
  name    VARCHAR(10) NOT NULL, 
  birthYear   INT NOT NULL,  
  email   CHAR(30) NULL,
  constraint uk_email unique(email) -- ak_email도 가능
);

-- ckeck 제약조건 - 입력되는 데이터를 점검
-- 출생연도가 1900년 이후 그리고 2023년 이전, 이름은 반드시 넣어야 함.
DROP TABLE IF EXISTS usertbl;
CREATE TABLE usertbl 
( userID  CHAR(8) PRIMARY KEY,
  name    VARCHAR(10) , 
  birthYear  INT CHECK  (birthYear >= 1900 AND birthYear <= 2023),
  mobile1   char(3) NULL, 
  CONSTRAINT CK_name CHECK ( name IS NOT NULL)  
);

-- default - 값이 입력되지 않을때 자동으로 입력되는 기본값 정의
-- 휴대폰 국번 체크
ALTER TABLE usertbl
   ADD CONSTRAINT CK_mobile1
   CHECK  (mobile1 IN ('010','011','016','017','018','019')) ;

DROP TABLE IF EXISTS usertbl;
CREATE TABLE usertbl 
( userID     CHAR(8) NOT NULL PRIMARY KEY,  
  name       VARCHAR(10) NOT NULL, 
  birthYear   INT NOT NULL DEFAULT -1,
  addr        CHAR(2) NOT NULL DEFAULT '서울',
  mobile1   CHAR(3) NULL, 
  mobile2   CHAR(8) NULL, 
  height   SMALLINT NULL DEFAULT 170, 
  mDate       DATE NULL
);

DROP TABLE IF EXISTS usertbl;
CREATE TABLE usertbl 
( userID     CHAR(8) NOT NULL PRIMARY KEY,  
  name       VARCHAR(10) NOT NULL, 
  birthYear   INT NOT NULL,
  addr        CHAR(2) NOT NULL,
  mobile1   CHAR(3) NULL, 
  mobile2   CHAR(8) NULL, 
  height   SMALLINT NULL, 
  mDate       DATE NULL
);
ALTER TABLE usertbl
   ALTER COLUMN birthYear SET DEFAULT -1; -- 생일 칼럼에 디폴트값 추가
ALTER TABLE usertbl
   ALTER COLUMN addr SET DEFAULT '서울';
ALTER TABLE usertbl
   ALTER COLUMN height SET DEFAULT 170;
   
-- default 문은 DEFAULT로 설정된 값을 자동 입력한다.
INSERT INTO usertbl VALUES ('LHL', '이혜리', default, default, '011', '1234567', default, '2023.12.12');
-- 열이름이 명시되지 않으면 DEFAULT로 설정된 값을 자동 입력한다
INSERT INTO usertbl(userID, name) VALUES('KAY', '김아영');
-- 값이 직접 명기되면 DEFAULT로 설정된 값은 무시된다.
INSERT INTO usertbl VALUES ('WB', '원빈', 1982, '대전', '019', '9876543', 176, '2020.5.5');

desc usertbl;

-- 추가
alter table usertbl
	add column homepage varchar(30)
    default  'httpL//www.naver.com'
    null;

-- 삭제
alter table usertbl
	drop column homepage;
    
-- 칼럼의 이름변경
alter table usertbl
	change column name userName varchar(20) null;

-- 키값 삭제 - 단독으로 있을경우
alter table usertbl
	drop primary key;

-- =============================================================================================
USE tabledb;
DROP TABLE IF EXISTS buytbl, usertbl;

CREATE TABLE usertbl 
( userID  CHAR(8), 
  name    VARCHAR(10),
  birthYear   INT,  
  addr     CHAR(2), 
  mobile1   CHAR(3), 
  mobile2   CHAR(8), 
  height    SMALLINT, 
  mDate    DATE 
);
CREATE TABLE buytbl 
(  num int AUTO_INCREMENT PRIMARY KEY,
   userid  CHAR(8),
   prodName CHAR(6),
   groupName CHAR(4),
   price     INT ,
   amount   SMALLINT
);

INSERT INTO usertbl VALUES('LSG', '이승기', 1987, '서울', '011', '1111111', 182, '2008-8-8');
INSERT INTO usertbl VALUES('KBS', '김범수', NULL, '경남', '011', '2222222', 173, '2012-4-4');
INSERT INTO usertbl VALUES('KKH', '김경호', 1871, '전남', '019', '3333333', 177, '2007-7-7');
INSERT INTO usertbl VALUES('JYP', '조용필', 1950, '경기', '011', '4444444', 166, '2009-4-4');
INSERT INTO buytbl VALUES(NULL, 'KBS', '운동화', NULL   , 30,   2);
INSERT INTO buytbl VALUES(NULL,'KBS', '노트북', '전자', 1000, 1);
INSERT INTO buytbl VALUES(NULL,'JYP', '모니터', '전자', 200,  1);
INSERT INTO buytbl VALUES(NULL,'BBK', '모니터', '전자', 200,  5); -- 삭제후에도 foreing key 설정후에도 부모키에 없기때문에 삽입불가

-- 유저테이블에 유저 아이디에 프라이머리 키로 설정하기 alter를 이용
alter table usertbl
	add constraint PK_usertbl_userID
    primary key(userID);
    
desc usertbl;

-- 구매 테이블에있는 유저아이디가 유저테이블에 있는 유저아이디를 참조하는 constraint, alter 사용
alter table buytbl
	add constraint FK_usertbl_buytbl
	foreign key (userID)
	references usertbl(userID);
-- 오류 발생 - 부모테이블에 bbk가 없기때문에 오류발생
-- 자식테이블에 bbk삭제후 다시 실행

delete from buytbl where userid = 'BBK';

desc buytbl;

set foreign_key_checks = 0; -- 0: off - 사용시 부모테이블에 없어도 삽입 가능

-- 추가
INSERT INTO buytbl VALUES(NULL, 'BBK', '모니터', '전자', 200,  5);
INSERT INTO buytbl VALUES(NULL, 'KBS', '청바지', '의류', 50,   3);
INSERT INTO buytbl VALUES(NULL, 'BBK', '메모리', '전자', 80,  10);
INSERT INTO buytbl VALUES(NULL, 'SSK', '책'    , '서적', 15,   5);
INSERT INTO buytbl VALUES(NULL, 'EJW', '책'    , '서적', 15,   2);
INSERT INTO buytbl VALUES(NULL, 'EJW', '청바지', '의류', 50,   1);
INSERT INTO buytbl VALUES(NULL, 'BBK', '운동화', NULL   , 30,   2);
INSERT INTO buytbl VALUES(NULL, 'EJW', '책'    , '서적', 15,   1);
INSERT INTO buytbl VALUES(NULL, 'BBK', '운동화', NULL   , 30,   2);

set foreign_key_checks = 1; -- 1: on

select * from buytbl;
-- check constraint
-- 유저테이블에 birthYear check constraint에 1900년부터 2023년까지

alter table usertbl
	add constraint CK_birthYear -- 유저테이블 내에 레코드에서 연도 범위가 다르기때문에 불가능
    check ((birthYear >= 1900 and birthYear <=2023) and (birthYear is not null));
    
-- 유저 아이디가 김범수인 레코드에 1979로 수정
-- 김경호도 1977로 수정
update usertbl set birthYear=1979 where userID = 'KBS';
update usertbl set birthYear=1971 where userID = 'KKH';

-- 다시실행
alter table usertbl
	add constraint CK_birthYear
    check ((birthYear >= 1900 and birthYear <=2023) and (birthYear is not null));
  
-- 1900년 부터 2023년까지의 범위 이기 때문에 삽입불가
insert into usertbl values('MS', '미래소년', 2999, '서울', '010', '12345678', '180', '2999-04-04');

INSERT INTO usertbl VALUES('SSK', '성시경', 1979, '서울', NULL  , NULL , 186, '2013-12-12');
INSERT INTO usertbl VALUES('LJB', '임재범', 1963, '서울', '016', '6666666', 182, '2009-9-9');
INSERT INTO usertbl VALUES('YJS', '윤종신', 1969, '경남', NULL  , NULL , 170, '2005-5-5');
INSERT INTO usertbl VALUES('EJW', '은지원', 1972, '경북', '011', '8888888', 174, '2014-3-3');
INSERT INTO usertbl VALUES('JKW', '조관우', 1965, '경기', '018', '9999999', 172, '2010-10-10');
INSERT INTO usertbl VALUES('BBK', '바비킴', 1973, '서울', '010', '0000000', 176, '2013-5-5');

-- 바비킴이 유저아이디를 BBK에서 VVK로 바꾼다
update usertbl set userID = 'VVK' where userID = 'BBK'; -- foreign key로 인해 변경불가

set foreign_key_checks = 0;
update usertbl set userID = 'VVK' where userID = 'BBK';
set foreign_key_checks = 1;

select * from usertbl;

-- buytbl usertbl join시키기
-- 구매 회원의 아이디, 회원명, 구매비용, 주소, 연락처 출력
select B.userid, U.name, B.prodName, U.addr, concat(U.mobile1, U.mobile2) as  '연락처' from buytbl B
	inner join usertbl U
    on B.userid = U.userID;

select count(*) from buytbl; -- 8개 밖에 안나와 4개가 출력이 안됨, 유저아이디를 BBK -> VVK로 변경했기때문

select * from usertbl;

-- outer join으로 변경 - 12개 출력
select B.userid, U.name, B.prodName, U.addr, concat(U.mobile1, U.mobile2) as  '연락처' from buytbl B
	left outer join usertbl U
    on B.userid = U.userID
    order by B.userID;

-- 다시 BBK로 변경 but 참조불가
set foreign_key_checks = 0;
update usertbl set userID = 'BBK' where userID = 'VVK';
set foreign_key_checks = 1;

-- on update cascade 문 활용해야함
alter table buytbl
	drop foreign key FK_usertbl_buytbl;
    
alter table buytbl
	add constraint FK_usertbl_buytbl
	foreign key (userID)
	references usertbl(userID)
    on update cascade;

update usertbl set userID = 'VVK' where userID = 'BBK'; -- 변경
    
select B.userid, U.name, B.prodName, U.addr, concat(U.mobile1, U.mobile2) as  '연락처' from buytbl B
	inner join usertbl U
    on B.userid = U.userID
    order by B.userid;

delete from usertbl where userID = 'VVK'; -- 삭제불가

alter table buytbl
	drop foreign key FK_usertbl_buytbl;
    
alter table buytbl
	add constraint FK_usertbl_buytbl
	foreign key (userID)
	references usertbl(userID)
    on update cascade
    on delete cascade;
    
delete from usertbl where userID = 'VVK'; -- 삭제가능

select * from usertbl;
select * from buytbl;

alter table usertbl
	drop column birthYear; -- check 한것도 삭제가능
    
desc usertbl;