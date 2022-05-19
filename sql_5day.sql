-- 2개의 프로시저
drop procedure if exists userProc2;
delimiter $$
create procedure userProc2(in userBirth int, in userHeight int)
begin
	select * from userTbl where birthYear > userBirth and height > userHeight;
end $$
delimiter ;

call userProc2(1970, 178);

-- in, out 둘다
drop procedure if exists userProc3;
delimiter $$
create procedure userProc3(in txtValue char(10), outValue int)
begin
	insert into testTBL values(null, txtValue);
	select max(id) into outValue from testTBL;
end $$
delimiter ;


create table if not exists testTBL(id int auto_increment primary key, txt char(10));

call userProc3('테스트값', @myValue);
select concat('현재 입력된 ID 값 ==>', @myValue);

-- if else문 사용
drop procedure if exists ifelseProc;
delimiter $$
create procedure ifelseProc(in userName varchar(10))
begin
	declare bYear int;
    select birthYear into bYear from userTbl
		where name = userName;
	if (bYear >= 1980) then
			select '아직 젊군요..';
	else
			select '나이가 지긋하시네요';
	end if;
end $$
delimiter ;

call ifelseProc('조용필');
-- ==================================================================================================
DROP PROCEDURE IF EXISTS caseProc;
DELIMITER $$
CREATE PROCEDURE caseProc(
    IN userName VARCHAR(10)
)
BEGIN
    DECLARE bYear INT; 
    DECLARE tti  CHAR(3);-- 띠
    SELECT birthYear INTO bYear FROM userTbl
        WHERE name = userName;
    CASE 
        WHEN ( bYear%12 = 0) THEN    SET tti = '원숭이';
        WHEN ( bYear%12 = 1) THEN    SET tti = '닭';
        WHEN ( bYear%12 = 2) THEN    SET tti = '개';
        WHEN ( bYear%12 = 3) THEN    SET tti = '돼지';
        WHEN ( bYear%12 = 4) THEN    SET tti = '쥐';
        WHEN ( bYear%12 = 5) THEN    SET tti = '소';
        WHEN ( bYear%12 = 6) THEN    SET tti = '호랑이';
        WHEN ( bYear%12 = 7) THEN    SET tti = '토끼';
        WHEN ( bYear%12 = 8) THEN    SET tti = '용';
        WHEN ( bYear%12 = 9) THEN    SET tti = '뱀';
        WHEN ( bYear%12 = 10) THEN    SET tti = '말';
        ELSE SET tti = '양';
    END CASE;
    SELECT CONCAT(userName, '의 띠 ==>', tti);
END $$
DELIMITER ;

CALL caseProc ('김범수');
-- ==================================================================================================

DROP TABLE IF EXISTS guguTBL;
CREATE TABLE guguTBL (txt VARCHAR(100)); -- 구구단 저장용 테이블

DROP PROCEDURE IF EXISTS whileProc;
DELIMITER $$
CREATE PROCEDURE whileProc()
BEGIN
    DECLARE str VARCHAR(100); -- 각 단을 문자열로 저장
    DECLARE i INT; -- 구구단 앞자리
    DECLARE k INT; -- 구구단 뒷자리
    SET i = 2; -- 2단부터 계산
    
    WHILE (i < 10) DO  -- 바깥 반복문. 2단~9단까지.
        SET str = ''; -- 각 단의 결과를 저장할 문자열 초기화
        SET k = 1; -- 구구단 뒷자리는 항상 1부터 9까지.
        WHILE (k < 10) DO
            SET str = CONCAT(str, '  ', i, 'x', k, '=', i*k); -- 문자열 만들기
            SET k = k + 1; -- 뒷자리 증가
        END WHILE;
        SET i = i + 1; -- 앞자리 증가
        INSERT INTO guguTBL VALUES(str); -- 각 단의 결과를 테이블에 입력.
    END WHILE;
END $$
DELIMITER ;

CALL whileProc();
SELECT * FROM guguTBL;
-- ==================================================================================================

DROP PROCEDURE IF EXISTS errorProc;
DELIMITER $$
CREATE PROCEDURE errorProc()
BEGIN
    DECLARE i INT; -- 1씩 증가하는 값
    DECLARE hap INT; -- 합계 (정수형). 오버플로 발생시킬 예정.
    DECLARE saveHap INT; -- 합계 (정수형). 오버플로 직전의 값을 저장.

    DECLARE EXIT HANDLER FOR 1264 -- INT형 오버플로가 발생하면 이 부분 수행
    BEGIN
        SELECT CONCAT('INT 오버플로 직전의 합계 --> ', saveHap);
        SELECT CONCAT('1+2+3+4+...+',i ,'=오버플로');
    END;
    
    SET i = 1; -- 1부터 증가
    SET hap = 0; -- 합계를 누적
    
    WHILE (TRUE) DO  -- 무한 루프.
        SET saveHap = hap; -- 오버플로 직전의 합계를 저장
        SET hap = hap + i;  -- 오버플로가 나면 11, 12행을 수행함
        SET i = i + 1; 
    END WHILE;
END $$
DELIMITER ;

CALL errorProc();
-- ==================================================================================================

SELECT routine_name, routine_definition FROM INFORMATION_SCHEMA.ROUTINES
    WHERE routine_schema = 'tabledb' AND routine_type = 'PROCEDURE';
    
-- ==================================================================================================
SELECT parameter_mode, parameter_name, dtd_identifier
	FROM INFORMATION_SCHEMA.PARAMETERS
	WHERE specific_name = 'userProc3';
    
-- ==================================================================================================

SHOW CREATE PROCEDURE tabledb.userProc3;
SHOW CREATE PROCEDURE tabledb.ifelseProc;

-- ==================================================================================================

DROP PROCEDURE IF EXISTS nameProc;
DELIMITER $$
CREATE PROCEDURE nameProc(
    IN tblName VARCHAR(20)
)
BEGIN
 SELECT * FROM tblName;
END $$
DELIMITER ;

CALL nameProc ('userTBL');
-- ==================================================================================================
/* 스토어드 프로시저 특징
- 모듈식
	언제든지 실행가능
	스토어드 프로시저로 저장해 놓은 쿼리수정,삭제 수월
    모듈식 프로ㅡ래밍 언어와 동일한 장점을 가짐alter
- 보안강화
	사용자 별로 테이블 접근 권한을 주지않고 스토어드 프로시저에만 접근 권한을 주어 보안강화
		뷰 또한 스토어드 프로시저와 같이 보안강화가능
*/

-- 스토어드 함수 - 사용자가 직접 만들어서 사용하는 함수
		-- 파라미터에 in out 사용불가
        -- returns문으로 반환할 값의 데이터형식지정
        -- select 문장안에서 호출
        -- 함수 안에서 집합 결과 반환하는 select 사용불가
        -- 어떤 계산을 통해서 하나의 값을 반환하는데 주로사용
        
/* 스토어드 함수 개요
delimiter $$
create procedure 스토드 함수 이름(파라미터)
begin

	프로그램 코딩
    return 반환값;
    
end $$
delimiter;
select 스토어드_함수이름();
*/

use sqldb;
DROP function IF EXISTS userFunc;
DELIMITER $$
CREATE function userFunc( value int, value int)
    returns int
BEGIN
 return value1 + value2;
END $$
DELIMITER ;

-- 만나이
use sqldb;
DROP function IF EXISTS getAgeFunc;
DELIMITER $$
CREATE function getAgeFunc(bYear int)
    returns int
BEGIN
 declare age int;
 set age = year(curdate()) - bYear;
 return age;
END $$
DELIMITER ;

select getAgeFunc(1979) into @age1979;
select getAgeFunc(1997) into @age1989;
select concat('1997과 1979년의 나이차 ==>', (@age1979-@age1989));

select userID, name, getAgeFunc(birthYear) as '만 나이' from userTbl;

drop function getAgeFunc;


-- cursor(커서) - 위치, 지점 - 프로시저 내부에서 생성됨
DROP PROCEDURE IF EXISTS cursorProc;
DELIMITER $$
CREATE PROCEDURE cursorProc()
BEGIN
    DECLARE userHeight INT; -- 고객의 키
    DECLARE cnt INT DEFAULT 0; -- 고객의 인원 수(=읽은 행의 수)
    DECLARE totalHeight INT DEFAULT 0; -- 키의 합계
    
    DECLARE endOfRow BOOLEAN DEFAULT FALSE; -- 행의 끝 여부(기본을 FALSE)

    DECLARE userCuror CURSOR FOR-- 커서 선언
        SELECT height FROM userTbl;

    DECLARE CONTINUE HANDLER -- 행의 끝이면 endOfRow 변수에 TRUE를 대입 
        FOR NOT FOUND SET endOfRow = TRUE;
    
    OPEN userCuror;  -- 커서 열기

    cursor_loop: LOOP
        FETCH  userCuror INTO userHeight; -- 고객 키 1개를 대입
        
        IF endOfRow THEN -- 더이상 읽을 행이 없으면 Loop를 종료
            LEAVE cursor_loop;
        END IF;

        SET cnt = cnt + 1;
        SET totalHeight = totalHeight + userHeight;        
    END LOOP cursor_loop;
    
    -- 고객 키의 평균을 출력한다.
    SELECT CONCAT('고객 키의 평균 ==> ', (totalHeight/cnt));
    
    CLOSE userCuror;  -- 커서 닫기
END $$
DELIMITER ;

CALL cursorProc();

-- 추가하기
select * from usertbl;
ALTER TABLE userTbl ADD grade VARCHAR(5);  -- 고객 등급 열 추가

desc usertbl;

DROP PROCEDURE IF EXISTS gradeProc;
DELIMITER $$
CREATE PROCEDURE gradeProc()
BEGIN
    DECLARE id VARCHAR(10); -- 사용자 아이디를 저장할 변수
    DECLARE hap BIGINT; -- 총 구매액을 저장할 변수
    DECLARE userGrade CHAR(5); -- 고객 등급 변수
    
    DECLARE endOfRow BOOLEAN DEFAULT FALSE; 

    DECLARE userCuror CURSOR FOR-- 커서 선언
        SELECT U.userid, sum(price*amount)
            FROM buyTbl B
                RIGHT OUTER JOIN userTbl U
                ON B.userid = U.userid
            GROUP BY U.userid, U.name ;

    DECLARE CONTINUE HANDLER 
        FOR NOT FOUND SET endOfRow = TRUE;
    
    OPEN userCuror;  -- 커서 열기
    grade_loop: LOOP
        FETCH  userCuror INTO id, hap; -- 첫 행 값을 대입
        IF endOfRow THEN
            LEAVE grade_loop;
        END IF;

        CASE  
            WHEN (hap >= 1500) THEN SET userGrade = '최우수고객';
            WHEN (hap  >= 1000) THEN SET userGrade ='우수고객';
            WHEN (hap >= 1) THEN SET userGrade ='일반고객';
            ELSE SET userGrade ='유령고객';
         END CASE;
        
        UPDATE userTbl SET grade = userGrade WHERE userID = id;
    END LOOP grade_loop;
    
    CLOSE userCuror;  -- 커서 닫기
END $$
DELIMITER ;

CALL gradeProc();
SELECT * FROM userTBL;

-- ===========================================================================================
-- 트리거 - 테이블에 무슨 일이 일어나면 자동으로 실행
-- 제약 조건과 더불어 무결성을 위해 mysql에서 사용할 수 있는 기능
--  직접실행 불가 - 테이블에 이벤트 가 일어나야 자동 실행

CREATE DATABASE IF NOT EXISTS testDB;
USE testDB;
CREATE TABLE IF NOT EXISTS testTbl (id INT, txt VARCHAR(10));
INSERT INTO testTbl VALUES(1, '레드벨벳');
INSERT INTO testTbl VALUES(2, '잇지');
INSERT INTO testTbl VALUES(3, '블랙핑크');

select * from testtbl;

DROP TRIGGER IF EXISTS testTrg;
DELIMITER // 
CREATE TRIGGER testTrg  -- 트리거 이름
    AFTER  DELETE -- 삭제후에 작동하도록 지정
    ON testTbl -- 트리거를 부착할 테이블
    FOR EACH ROW -- 각 행마다 적용시킴
BEGIN
	SET @msg = '가수 그룹이 삭제됨' ; -- 트리거 실행시 작동되는 코드들
END // 
DELIMITER ;

SET @msg = '';
INSERT INTO testTbl VALUES(4, '마마무');
SELECT @msg;
UPDATE testTbl SET txt = '블핑' WHERE id = 3;
SELECT @msg;
DELETE FROM testTbl WHERE id = 4;
SELECT @msg;

-- 텍스트 검색
/*
select * from 신문기사_테이블 where 신문기사내용 like '교통%' - 교통 키워드로 기사 검색
select * from 신문기사_테이블 where 신문기사내용 like '%교통%'- 중간에 들어간경우 인덱스 사용불가

SELECT * FROM newspaper 
  WHERE MATCH(article) AGAINST('영화');

SELECT * FROM newspaper 
  WHERE MATCH(article) AGAINST('영화 배우');

SELECT * FROM newspaper 
   WHERE MATCH(article) AGAINST('영화*' IN BOOLEAN MODE);

SELECT * FROM newspaper 
   WHERE MATCH(article) AGAINST('영화 배우' IN BOOLEAN MODE);

SELECT * FROM newspaper 
   WHERE MATCH(article) AGAINST('영화 배우 +공포' IN BOOLEAN MODE);

SELECT * FROM newspaper 
   WHERE MATCH(article) AGAINST('영화 배우 -남자' IN BOOLEAN MODE);

인덱스 생성
create table 테이블읾 (
'''
열이름 데이터 형식
'''
fulltext 인덱스 이름
);
*/

-- 텍스트 인덱스 삭제
-- alter table 테이블이름
--	drop index fulltext(열 이름)

CREATE DATABASE IF NOT EXISTS FulltextDB;
USE FulltextDB;
DROP TABLE IF EXISTS FulltextTbl;
CREATE TABLE FulltextTbl ( 
	id int AUTO_INCREMENT PRIMARY KEY, 	-- 고유 번호
	title VARCHAR(15) NOT NULL, 		-- 영화 제목
	description VARCHAR(1000)  		-- 영화 내용 요약
);

INSERT INTO FulltextTbl VALUES
(NULL, '광해, 왕이 된 남자','왕위를 둘러싼 권력 다툼과 당쟁으로 혼란이 극에 달한 광해군 8년'),
(NULL, '간첩','남한 내에 고장간첩 5만 명이 암약하고 있으며 특히 권력 핵심부에도 침투해있다.'),
(NULL, '남자가 사랑할 때', '대책 없는 한 남자이야기. 형 집에 얹혀 살며 조카한테 무시당하는 남자'), 
(NULL, '레지던트 이블 5','인류 구원의 마지막 퍼즐, 이 여자가 모든 것을 끝낸다.'),
(NULL, '파괴자들','사랑은 모든 것을 파괴한다! 한 여자를 구하기 위한, 두 남자의 잔인한 액션 본능!'),
(NULL, '킹콩을 들다',' 역도에 목숨을 건 시골소녀들이 만드는 기적 같은 신화.'),
(NULL, '테드','지상최대 황금찾기 프로젝트! 500년 전 사라진 황금도시를 찾아라!'),
(NULL, '타이타닉','비극 속에 침몰한 세기의 사랑, 스크린에 되살아날 영원한 감동'),
(NULL, '8월의 크리스마스','시한부 인생 사진사와 여자 주차 단속원과의 미묘한 사랑'),
(NULL, '늑대와 춤을','늑대와 친해져 모닥불 아래서 함께 춤을 추는 전쟁 영웅 이야기'),
(NULL, '국가대표','동계올림픽 유치를 위해 정식 종목인 스키점프 국가대표팀이 급조된다.'),
(NULL, '쇼생크 탈출','그는 누명을 쓰고 쇼생크 감옥에 감금된다. 그리고 역사적인 탈출.'),
(NULL, '인생은 아름다워','귀도는 삼촌의 호텔에서 웨이터로 일하면서 또 다시 도라를 만난다.'),
(NULL, '사운드 오브 뮤직','수녀 지망생 마리아는 명문 트랩가의 가정교사로 들어간다'),
(NULL, '매트릭스',' 2199년.인공 두뇌를 가진 컴퓨터가 지배하는 세계.');

SELECT * FROM FulltextTbl WHERE description LIKE '%남자%' ;

CREATE FULLTEXT INDEX idx_description ON FulltextTbl(description);

SHOW INDEX FROM FulltextTbl;

SELECT * FROM FulltextTbl WHERE MATCH(description) AGAINST('남자*' IN BOOLEAN MODE);

SELECT *, MATCH(description) AGAINST('남자* 여자*' IN BOOLEAN MODE) AS 점수 
	FROM FulltextTbl WHERE MATCH(description) AGAINST('남자* 여자*' IN BOOLEAN MODE);

SELECT * FROM FulltextTbl 
	WHERE MATCH(description) AGAINST('+남자* +여자*' IN BOOLEAN MODE);

SELECT * FROM FulltextTbl 
	WHERE MATCH(description) AGAINST('남자* -여자*' IN BOOLEAN MODE);

SET GLOBAL innodb_ft_aux_table = 'fulltextdb/fulltexttbl'; -- 모두 소문자
SELECT word, doc_count, doc_id, position 
	FROM INFORMATION_SCHEMA.INNODB_FT_INDEX_TABLE;

DROP INDEX idx_description ON FulltextTbl;

CREATE TABLE user_stopword (value VARCHAR(30));

INSERT INTO user_stopword VALUES ('그는'), ('그리고'), ('극에');

SET GLOBAL innodb_ft_server_stopword_table = 'fulltextdb/user_stopword'; -- 모두 소문자
SHOW GLOBAL VARIABLES LIKE 'innodb_ft_server_stopword_table';

CREATE FULLTEXT INDEX idx_description ON FulltextTbl(description);

SELECT word, doc_count, doc_id, position 
	FROM INFORMATION_SCHEMA.INNODB_FT_INDEX_TABLE;
-- ==============================================================================================
-- 공간 데이터
-- 		속성 데이터 - 기존에 사영해왔던 문자, 숫자, 날자 등의 데이터 형식
-- 	 	공간 데이터 - 지구상에 존재하는 지형정보 표현 데이터

create database test2db;

use test2db;
select * from usertable;