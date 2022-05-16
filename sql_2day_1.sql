use sqldb;

-- 테이블 복사
create table buytbl2 (select * from buytbl);

select * from buytbl2;

-- 특정 부분만 테이블 복사
create table buytbl3 (select  userId, prodName from buytbl);

select * from buytbl3;

-- 유저 테이블에서 유저 아이디와 유저 이름을 복사해서 생성

select * from usertbl;
create table usertbl2 (select userId, name from usertbl);

select * from usertbl2;

-- group by 그룹으로 묶어주는 역할, 집계함수와 같이 사용 (sum같은거)
-- ex) select userId, sum(amount) from buytbl group by userId;

select * from buytbl;
select userId, sum(amount) from buytbl group by userId;

-- 총 구매 개수
select userId as "사용자 아이디", sum(amount) as "총구매 개수" from buytbl group by userId;

-- 총 구매 가격
select userId as "사용자 아이디", sum(price * amount) as "총구매 금액" from buytbl group by userId;

-- avg(), min(), max(), count(), count(distinct), stdev(), var_samp() 등 다 집계함수
select avg(amount) as "평균 구매 개수" from buytbl;
select avg(amount) as "평균 구매 개수" from buytbl group by userId;
select userId, avg(amount) as "평균 구매 개수" from buytbl group by userId;

-- 유저 테이블에서 키가 제일큰 사람과 제일 작은사람의 이름
select name, max(height), min(height) from usertbl;
select name, max(height), min(height) from usertbl group by name;

-- 키가 제일 큰사람과 작은사람만 추출
select name, height from usertbl where height = (select max(height) from usertbl)
								    or height = (select min(height) from usertbl);

-- 유저테이블의 모든 레코드의 개수(null 값 제외)
select count(*) from usertbl;

select count(mobile1) from usertbl;

-- having - where와 비슷한 개념의 조건절 꼭 group by 절 다음에 나와야한다.
select userId as "사용자", sum(price * amount) as "총구매 금액"
	from buytbl
    group by userId;

-- 총 구매 금액이 천만원 이상인사람 해당 내용은 에러표출 where은 집계함수 불가
select userId as "사용자", sum(price * amount) as "총구매 금액"
	from buytbl
	where sum(price * amount) > 1000
    group by userId;

-- having 이용하여 표출
select userId as "사용자", sum(price * amount) as "총구매 금액"
	from buytbl
	group by userId
    having sum(price * amount) > 1000;

-- 오름차순
select userId as "사용자", sum(price * amount) as "총구매 금액"
	from buytbl
	group by userId
    having sum(price * amount) > 1000
    order by sum(price * amount);

-- 내림차순
select userId as "사용자", sum(price * amount) as "총구매 금액"
	from buytbl
	group by userId
    having sum(price * amount) > 1000 
    order by sum(price * amount) desc;

-- rollup - 총합 또는 중간합계
-- 총 구매 금액 구하기
select num, groupName, sum(price * amount) as "비용"
	from buytbl
    group by groupName, num
    with rollup;
/*   문장의 순서
select 
	from
    where
    group by
    having - 반드시 그룹바이 뒤에 오도록
    order by - 순서를 어떤식으로 할지
    */
    
-- DDL - 데이터 정의 언어 Data Definition Language
-- DML - 데이터 조작 언어 Data Manipulatin Language
-- DCL - 데이터 제어 언어 Data Contron Language

-- insert [into] 테이블(열1, 열2 ---) values(값1, 값2, --)
-- 테이블 이름 다음에 나오는열 생략 가능, 생략할 경우 values 다음에 나오는 값들의
-- 순서 및 개수가 테이블이 정의된 열 순서 및 개수가 동일해야함

-- 자동으로 증가하는 auto_increment
-- 해당 열이 없다고 생가각하고 입력, null 값 지정시 자동으로 값 입력

-- 샘플파일 생성
create table testtbl1
(id int,
 usename char(3),
 age int
 );
 
 desc testtbl1;
 
 insert into testtbl1 values(1, '홍길동', 25);
 
 -- 일부 컬럼만 대입
 insert into testtbl1 (id, usename) values(2, '설현');
 
 -- 순서에 맞게 values 배열도 똑같이
 insert into testtbl1(usename, age, id) values('아이유', 28, 3);
 
 select * from testtbl1;
 
 -- auto_increment 사용
 create table testtbl2
(id int auto_increment primary key,
 userName char(3),
 age int
 );
 
 insert into testtbl2 values(null, '지민', 25);
 insert into testtbl2 values(null, '유니', 22);
 insert into testtbl2 values(null, '유경', 21);
 insert into testtbl2 values(null, '나경', 27);
 
 select * from testtbl2;
 
 insert into testtbl2 values(null, '슈기', 28), (null, '지민', 29), (null,'BTS', 25);
 
 alter table testtbl2 auto_increment=100;
 insert into testtbl2 values(null, '화경', 22);
 insert into testtbl2 values(null, '진경', 26);
 
 select last_insert_id();
 
  select * from testtbl2;
  
create table testtbl3
(id int auto_increment primary key,
 userName char(3),
 age int
 );
 
 alter table testtbl3 auto_increment = 1000;
 set @@auto_increment_increment=3; -- 3씩 증가
 
 insert into testtbl3 values(null, '지민', 25);
 insert into testtbl3 values(null, '유니', 22);
 insert into testtbl3 values(null, '유경', 21);
 insert into testtbl3 values(null, '나경', 27);
 
 select * from testtbl3;
 
select * from employees;

create table testtbl4
(id int,
 Fname varchar(50),
 Lname varchar(50)
 );
 
 -- 다른 데이블의 정보 가져오기
 insert into testtbl4
		select emp_no, first_name, last_name from employees.employees;
        
select * from testtbl4;

select count(*) from testtbl4;

create table testtbl5
	(select emp_no, first_name, last_name from employees.employees);
    
select * from testtbl5;

select count(*) from testtbl5;

-- employees emp_no, last_name, gender만 가져와서 생성

select * from employees;

create table testtbl6
	(select emp_no, last_name, gender from employees.employees);
    
select * from testtbl6;
select count(*) from testtbl6;

-- 12명의 데이터를 저장할 테이블을 생성, 칼럼은 알아서 하고 최소 7개이상 작성
-- 첫번째 칼럼은 넘버(auto_inctement), 12명의 실명, 테이블생성

create table ai_webclass
(class_no int auto_increment primary key,
 name varchar(5) not null,
 age int not null,
 ph_no char(13),
 gender char(1),
 addr char(2) not null,
 birth_date date
 );
 
 alter table ai_webclass auto_increment=1;
  set @@auto_increment_increment=1;
  
insert into ai_webclass value(null, 'ooo', 24, '010-0000-0000', "M", "경기", '1999-1-2');
insert into ai_webclass value(null, 'ggg', 31, '010-1111-2222', "M", "서울", '1980-11-5');
insert into ai_webclass value(null, 'fff', 27, '010-2222-2121', "M", "서울", '1996-8-9');
insert into ai_webclass value(null, 'eee', 26, '010-1313-1211', "M", "대전", '1997-5-27');
insert into ai_webclass value(null, 'ddd', 26, '010-5555-1212', "M", "전북", '1996-7-6');
insert into ai_webclass value(null, 'ccc', 25, '010-5678-1234', "M", "전북", '1997-12-17');
insert into ai_webclass value(null, 'bbb', 28, '010-6789-1234', "M", "전남", '1994-3-11');
insert into ai_webclass value(null, 'aaa', 29, '010-1515-1515', "M", "강원", '1993-12-5');
insert into ai_webclass value(null, 'hhh', 26, '010-3213-9879', "M", "경기", '1996-8-14');
insert into ai_webclass value(null, 'iii', 26, '010-1357-2468', "M", "서울", '1996-11-5');
insert into ai_webclass value(null, 'jjj', 24, '010-3333-7777', "M", "강원", '1999-5-7');
insert into ai_webclass value(null, 'kkk', 30, '010-6666-6666', "M", "경기", '1992-11-8');

 select * from ai_webclass;
 
 -- update - 기존에 입력되어 있는값 변경
 /* update 테이블이름
		set 열1=값1, 열2 = 값2
		where 조건 ;
        */
-- 
update testtbl5
	set first_name = '없음'
    where last_name = 'Facello';

select * from testtbl5;

-- 유저테이블에 강승윤 추가
select * from usertbl;

desc usertbl;
use usertbl;
insert into usertbl values('KSY', '강승윤', 1990, '서울', '010', '11112222', 180, '2022-05-16');

-- 강승윤의 전화번호 변경
update usertbl
	set mobile2 = '22223333'
    where userId = 'KSY';
    
-- 주소가 서울인사람을 경기로변경
update usertbl
	set addr = '경기'
    where addr = '서울';
    
-- 나자신의 정보 변경
update ai_webclass
	set ph_no = '010-9999-9999', addr = "서울"
    where name = "임두혁";

select * from ai_webclass;

select * from buytbl;

-- 구매 테이블 업데이트문(가격 50% 높임)
update buytbl
	set price = price*1.5;

select * from buytbl;    

-- delete 행단위 데이터 삭제 구문
-- delete from 테이블의 이름 where 조건;
delete from usertbl where name = '강승윤';
select * from usertbl;

delete from usertbl; -- 삭제 불가

delete from ai_webclass; -- 12명의 테이블 삭제
select * from ai_webclass; -- 삭제된거 확인가능

truncate table ai_webclass;

create table temptbl1(select * from employees.employees);
create table temptbl2(select * from employees.employees);
create table temptbl3(select * from employees.employees);

select * from temptbl1;
select * from temptbl2;
select * from temptbl3;

delete from temptbl1;
drop table temptbl1; -- 테이블 완전 삭제
truncate table temptbl3;

-- insert ignore - 에러 발생해도 다음구문으로 넘어감
-- on duplicate key update - 기본키가 중복되면 데이터를 수정되도록 하는 구문도 활용가능

-- insert ignore
create table membertbl (select userId, name, addr from usertbl limit 3);
select * from membertbl;

-- constraint - 제약조건 
alter table membertbl
		add constraint pk_membertbl primary key(userId);
        
insert into membertbl values('BBK', '비비킹', '미국'); -- 프라이머리 키값 중복값으로 인해 오류 발생 다른부분들도 추가 불가
insert into membertbl values('SJH', '서장훈', '한국');
insert into membertbl values('HJY', '한주엽', '한국');

-- insert ignore 문을 활용했을경우
insert ignore into membertbl values('BBK', '비비킹', '미국'); -- 중복값이 있다는 오류가 발생하지만 이값을 제외한 다른값은 추가 가능
insert ignore into membertbl values('SJH', '서장훈', '한국');
insert ignore into membertbl values('HJY', '한주엽', '한국');

-- on duplicate update - 내용이 있으면 수정을하고 없다면 내용을추가한다.
insert into membertbl values('BBK', '비비킹', '미국')
	on duplicate key update name = '비비킹', addr = '미국';
insert into membertbl values('JJM', '짜장면', '중국')
	on duplicate key update name = '짜장면', addr = '중국';
    
-- with 절과 cte -  cte는 비재귀적 cte와 재귀적 cte가 있지만 주로 사용되는 것은 비재귀적 cte
/*  with cte_테이블이름
	as
    (
		<쿼리문>
	)
    select 열이름 from cte_테이블이름;
*/

select userId as '사용자', sum(price * amount) as '총구매액'
	from buytbl group by userId;
    
-- with 절 사용
with abc(userId, total)
as
	(
		select userId, sum(price * amount)
		from buytbl group by userId
	)
select * from abc order by total desc;

-- 각 지역별 최고키의 평균값 구하기
with cte_usertbl(addr, maxHeight)
as
(
	select addr, max(height)
    from usertbl group by addr
)
select avg(maxHeight * 1.0) as '각 지역별 최고키의 평균' from cte_usertbl;

/* =================================== cahp07 로 넘어감 =================================== */
/*  create a new  view in the actve schemas 이용하여 만든 테이블
CREATE TABLE `sqldb`.`student` (
  `id` INT NOT NULL,
  `stu_name` VARCHAR(45) NULL,
  `age` INT NULL,
  `depart` VARCHAR(45) NULL,
  `birt_date` VARCHAR(45) NULL,
  `height` VARCHAR(45) NULL,
  `studentcol` INT NULL,
  `grade_avg` VARCHAR(45) NULL,
  `ph_num` VARCHAR(45) NULL,
  `studentcol2` VARCHAR(45) NULL,
  `addr` VARCHAR(45) NULL,
  PRIMARY KEY (`id`));
*/

-- 변수선언 해주기
set @myvar1 = 5;
set @myvar2 = 3;
set @myvar3 = 3.15;
set @myvar4 = '가수 이름:   ';

-- 출력
select @myvar1;
select @myvar2;
select @myvar3;
select @myvar4;

-- 변수선언한것을 연산자를이요하여 연산
select @myvar2 + @myvar3;

-- usertbl에서 키가 180 이상인 사람의 이름
select @myvar4, name from usertbl where height > 180;


select name, height from usertbl order by height limit 3;

set @myvar1 = 5;

prepare myQuery
	from 'select name, height from usertbl order by height limit ?';
execute myQuery using @myvar1;

-- 데이터의 형식변환
select avg(amount) as '평균 구매 개수' from buytbl;

-- cast를 이용한 형변환
select cast(avg(amount) as signed integer) as '평균 구매 개수' from buytbl;

-- convert를 이용한 형변환
select convert(avg(amount), signed integer) as '평균 구매 개수' from buytbl;

-- 명시적 형변환
select cast('2020$12$12' as date) as '$문자 사용';
select cast('2020/12/12' as date) as '/문자 사용';
select cast('2020%12%12' as date) as '%문자 사용';
select cast('2020@12@12' as date) as '@문자 사용';

select num, concat(cast(price as char(10)), 'x', cast(amount as char(4)), '=') as '단가x수량',
		price*amount as '구매액'
        from buytbl;
        
-- 묵시적 형변환
select '100' + '200';
select 100 + 200;
select concat('100', '200');
select 1 > '2Mega';
select 3 > '2Mega';
select 0 > 'Mega2';

-- 조건문
select if(100>200, '참이다', '거짓이다');
select ifnull(null, '널이 맞습니다'), ifnull(100, '널이 맞습니다');

select nullif(100,100), nullif(200,100);

select case 10
		when 1 then '1 입니다'
        when 5 then '5 입니다'
        when 10 then '10 입니다'
        else '잘 모르겠습니다.'
	end as 'case 문 연습';

-- 문자열 함수
select ascii('A'), char(65);

select char(65);
select bit_length('abc'), char_length('abc'), length('abc');
select bit_length('가나다'), char_length('가나다'), length('가나다');

select concat_ws('/', '2025', '01', '01');
select concat_ws('-', '2025', '01', '01');

select elt(2, '하나', '둘', '셋'), field('둘', '하나', '둘', '셋'), find_in_set('둘', '하나,둘,셋'),
	   instr('하나둘셋','둘'), locate('둘', '하나둘셋');

-- 수학 함수
SELECT FORMAT(123456.123456, 4);

SELECT BIN(31), HEX(31), OCT(31);

SELECT INSERT('abcdefghi', 3, 4, '@@@@'), INSERT('abcdefghi', 3, 2, '@@@@');

SELECT LEFT('abcdefghi', 3), RIGHT('abcdefghi', 3);

SELECT LOWER('abcdEFGH'), UPPER('abcdEFGH');

SELECT LPAD('이것이', 5, '##'), RPAD('이것이', 5, '##');

SELECT LTRIM('   이것이'), RTRIM('이것이   ');

SELECT TRIM('   이것이   '), TRIM(BOTH 'ㅋ' FROM 'ㅋㅋㅋ재밌어요.ㅋㅋㅋ');

SELECT REPEAT('이것이', 3);

SELECT REPLACE ('이것이 MySQL이다', '이것이' , 'This is');

SELECT REVERSE ('MySQL');

SELECT CONCAT('이것이', SPACE(10), 'MySQL이다');

SELECT SUBSTRING('대한민국만세', 3, 2);

SELECT SUBSTRING_INDEX('cafe.naver.com', '.', 2),  SUBSTRING_INDEX('cafe.naver.com', '.', -2);

SELECT ABS(-100);

SELECT CEILING(4.7), FLOOR(4.7), ROUND(4.7);

SELECT CONV('AA', 16, 2), CONV(100, 10, 8);

SELECT DEGREES(PI()), RADIANS(180);

SELECT MOD(157, 10), 157 % 10, 157 MOD 10;

SELECT POW(2,3), SQRT(9);

SELECT RAND(), FLOOR(1 + (RAND() * (6-1)) );

SELECT SIGN(100), SIGN(0), SIGN(-100.123);

SELECT TRUNCATE(12345.12345, 2), TRUNCATE(12345.12345, -2);

-- 날짜 및 시간을 조작하는 함수
SELECT ADDDATE('2025-01-01', INTERVAL 31 DAY), ADDDATE('2025-01-01', INTERVAL 1 MONTH);
SELECT SUBDATE('2025-01-01', INTERVAL 31 DAY), SUBDATE('2025-01-01', INTERVAL 1 MONTH);

SELECT ADDTIME('2025-01-01 23:59:59', '1:1:1'), ADDTIME('15:00:00', '2:10:10');
SELECT SUBTIME('2025-01-01 23:59:59', '1:1:1'), SUBTIME('15:00:00', '2:10:10');

SELECT YEAR(CURDATE()), MONTH(CURDATE()), DAYOFMONTH(CURDATE());
SELECT HOUR(CURTIME()), MINUTE(CURRENT_TIME()), SECOND(CURRENT_TIME), MICROSECOND(CURRENT_TIME);

SELECT DATE(NOW()), TIME(NOW());

SELECT DATEDIFF('2025-01-01', NOW()), TIMEDIFF('23:23:59', '12:11:10');

SELECT DAYOFWEEK(CURDATE()), MONTHNAME(CURDATE()), DAYOFYEAR(CURDATE());

SELECT LAST_DAY('2025-02-01');

SELECT MAKEDATE(2025, 32);

SELECT MAKETIME(12, 11, 10);

SELECT PERIOD_ADD(202501, 11), PERIOD_DIFF(202501, 202312);

SELECT QUARTER('2025-07-07');

SELECT TIME_TO_SEC('12:11:10');

SELECT CURRENT_USER(), DATABASE();

USE sqldb;
SELECT * FROM usertbl;
SELECT FOUND_ROWS();

USE sqldb;
UPDATE buytbl SET price=price*2;
SELECT ROW_COUNT();

SELECT SLEEP(5);
SELECT '5초후에 이게 보여요';

SELECT DATEDIFF('1999-01-02', NOW());
SELECT TIME_TO_SEC('17:31:10');