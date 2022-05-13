use employees;

select * from departments;
select * from dept_emp;
select * from deptmanager;
select * from employees;
select * from salaries;
select * from titles;

select first_name, last_name from employees;
select emp_no, title from titles;
-- 여기는 주석입니다.
/* 여러줄 주석입니다.
	여러줄 주석입니다.*/

show databases;
show tables;
show table status;

describe departments;

desc employees;

select first_name as 이름 , last_name as 성 from employees;
select first_name as 이름 , gender as 성별,hire_date as "입사 일자" from employees;

create database sqldb;
use sqldb;

create table usertbl  -- 사용자테이블
( userId char(8) not null primary key,
  name varchar(10) not null,
  birthYear int not null,
  addr char(2) not null,
  mobile1 char(3),
  mobile2 char(8),
  height smallint not null,
  mDate date
  );
  
  desc usertbl;
  
create table buytbl
( num int auto_increment not null primary key,
  userId char(8) not null,
  prodName char(6) not null,
  groupName char(4),
  price int not null,
  amount smallint not null,
  foreign key (userId) references usertbl(userId)
  );

desc buytbl;

INSERT INTO usertbl VALUES('LSG', '이승기', 1987, '서울', '011', '1111111', 182, '2008-8-8');
INSERT INTO usertbl VALUES('KBS', '김범수', 1979, '경남', '011', '2222222', 173, '2012-4-4');
INSERT INTO usertbl VALUES('KKH', '김경호', 1971, '전남', '019', '3333333', 177, '2007-7-7');
INSERT INTO usertbl VALUES('JYP', '조용필', 1950, '경기', '011', '4444444', 166, '2009-4-4');
INSERT INTO usertbl VALUES('SSK', '성시경', 1979, '서울', NULL  , NULL      , 186, '2013-12-12');
INSERT INTO usertbl VALUES('LJB', '임재범', 1963, '서울', '016', '6666666', 182, '2009-9-9');
INSERT INTO usertbl VALUES('YJS', '윤종신', 1969, '경남', NULL  , NULL      , 170, '2005-5-5');
INSERT INTO usertbl VALUES('EJW', '은지원', 1972, '경북', '011', '8888888', 174, '2014-3-3');
INSERT INTO usertbl VALUES('JKW', '조관우', 1965, '경기', '018', '9999999', 172, '2010-10-10');
INSERT INTO usertbl VALUES('BBK', '바비킴', 1973, '서울', '010', '0000000', 176, '2013-5-5');
INSERT INTO buytbl VALUES(NULL, 'KBS', '운동화', NULL   , 30,   2);
INSERT INTO buytbl VALUES(NULL, 'KBS', '노트북', '전자', 1000, 1);
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
/* ================================================================================================= */

select userId, name from usertbl;

select name as 이름, mDate as 가입일 from usertbl;

select * from usertbl where name = "김경호";

select * from buytbl where prodName = "모니터";

select userId, amount from buytbl where prodName = "책";

-- 유저티비엘 이름 키 출력하는데 조건이 키가 183이고 생년이 1970인 사람
select userId, name from usertbl where birthYear >= 1970 and height >= 182;

-- 유저티비엘 이름 키 출력하는데 조건이 키가 183 이거나 생년이 1970인사람
select userId, name from usertbl where birthYear >= 1970 or height >= 182;

-- 유저티비엘 이름 키 출력하는데 조건이 키가 180~183 사이에 있는
select userId, name from usertbl where height >= 180 and height <= 183;

-- 유저티비엘 이름 키 출력하는데 조건이 키가 180~183 사이에 있는
-- between a and b 문 활용
select userId, name from usertbl where height between 180 and 183;

-- 유저 티비엘에서 주소가 전남 이거나 경남이거나 전북인사람 이름 주소 칼럼출력
select name, addr from usertbl where addr = "경남" or addr = "전남" or addr = "경북";
select name, addr from usertbl where addr in ("경남", "전남", "경북");

-- 유저테이블에서 addr이 서울이거나 경기인 사람의 유저아이디와 네임 컬럼값 addr 출력
select userId, name, addr from usertbl where addr = "서울" or addr = "경기";
select userId, name, addr from usertbl where addr in ("서울", "경기");

-- 와일드카드 - liek '시작문자%'를 사용해 시작 문자 입력후 특정문자의 이름 출력
select name, height from usertbl where name like '김%';

-- 와일드카드 - liek '_문자'를 사용해 특정문자의 끝을 포함한 문자 출력
select name, height from usertbl where name like '_종신';

-- 유저테이블에서 조씨 성을 가진 회원들을 출력하는 코드
select * from usertbl where name like '조%';

-- 유저테이블에서 성이 생각이안나고 시경이라는 이름만 생각날때 출력하는 코드
select * from usertbl where name like '_시경';

-- 유저테이블에서 키가 177 미만인 사람의 이름과 키 칼럼
select name, height from usertbl where height < 177;

-- 김경호의 키를 도출하는 코드 작성
select height from usertbl where name = "김경호";

-- 서브쿼리 ,서브쿼리의 결과가 둘 이상이 되면 에러 발생
select name, height from usertbl
	where height > (select height from usertbl where name = "김경호");
    
-- 유저 테이블에서 주소가 전남인 사람의 키보다 크거나 같은 사람의 이름과 키를 출력하는 sql문
select name, height from usertbl
	where height >= (select height from usertbl where addr = "전남"); -- 경남이면 오류출력 경남이 2명이상이기때문
    
-- ANY, ALL, SOME
-- any - 여러개의 결과중 한가지만 충족 =any(서브쿼리) 는 in(서브쿼리)와 동일하다
-- 유저 테이블에서 주소가 경남인 사람의 키보다 크거나 같은 사람의 이름과 키를 출력하는 sql문
select name, height from usertbl
	where height >= ANY (select height from usertbl where addr = "경남");
    
select name, height from usertbl
	where height = ANY (select height from usertbl where addr = "경남");
    
-- all - 여러개의 결과중 모두 만족
-- 173이상인 사람
select name, height from usertbl
	where height >= ALL (select height from usertbl where addr = "경남");

-- ORDER BY
-- 오름차순 순으로 정렬(ASC를 끝에 삽입하지만 디폴트값이라 생략가능)
-- 내림차순의 경우 열 이름 뒤에 DESC 삽입
select name, height from usertbl order by height;
select name, height from usertbl order by height desc;
select name, height from usertbl order by height desc, name asc;
select name, height from usertbl order by height desc, name desc;

-- 유저테이블에서 이름, 회원가입일, 회원가입일 기준으로 오름차순 정렬
select name, mDate from usertbl order by mDate;

-- 유저테이블에서 이름, 회원가입일, 회원가입일 기준으로 내림차순 정렬
select name, mDate from usertbl order by mDate desc;

-- 유저테이블에서 주소를 오름차순 정렬
select addr from usertbl order by addr;

-- distinct 중복된 것을 세기 어려울때 사용 중복된것 하나만 출력(꼭 칼럼 앞에 사용)
select distinct addr from usertbl;

-- 출력갯수 재한 하는 limit n 구문 사용
use employees;

select * from employees;

select emp_no, hire_date from employees order by hire_date asc;

select emp_no, hire_date from employees order by hire_date asc limit 0, 5;
select emp_no, hire_date from employees order by hire_date asc limit 5 offset 0;
select emp_no, hire_date from employees order by hire_date asc limit 10,5;

-- 유저테이블에서 출신지역이 몇가지인지 작성
