-- 뷰 - 일반 사용자 입장에서 테이블과 동일하게 사용하는 개체
use tabledb;
select userID, name, addr from usertbl;

-- 뷰 생성
create view v_usertbl as
	select userid, name, addr from usertbl;
    
select * from v_usertbl;
drop view v_usertbl;

create view v_userbuytbl
as
select U.userid as '사용자 아이디', U.name as '이름', B.prodName as '제품 이름', U.addr, concat(U.mobile1, U.mobile2) as '전화 번호'
		from usertbl U
	inner join buytbl B
		on U.userid = B.userid;

select * from v_userbuytbl;

select * from v_userbuytbl where name = '김범수';

create view v_userbuytbl1
as
	select U.userID as 'USER ID', U.name as 'USER NAME', B.prodName as 'PROD NAME', U.addr, concat(U.mobile1, U.mobile2) as 'MOBILE PHONE'
		from usertbl U
	inner join buytbl B
		on U.userID = B.userid;
        
select * from v_userbuytbl1;

select 'USER ID', 'USER NAME' from v_userbuytbl1; -- 주의 백틱을 사용안해서 출력이 이상함
select `USER ID`, `USER NAME` from v_userbuytbl1; -- 숫자 1 옆에 `문자(백틱) 사용 하여 정상출력

alter view v_userbuytbl1 -- 호환성 문제로 별명 한글 권장 X
as
select U.userid as '사용자 아이디', U.name as '이름', B.prodName as '제품 이름', U.addr, concat(U.mobile1, U.mobile2) as '전화 번호'
		from usertbl U
	inner join buytbl B
		on U.userid = B.userid;

select * from v_userbuytbl1;
select `이름`, `전화 번호` from v_userbuytbl1;

drop view v_userbuytbl;
drop view v_userbuytbl1;

create or replace view v_usertbl -- 뷰 이름이 없으면 새로 만들고 존재하면 내용 덮어쓰기
as
	select userid, name, addr from usertbl;
    
select * from v_usertbl;
describe v_usertbl;

show create view v_usertbl; -- 뷰의 소스코드 확인

update v_usertbl set addr = '부산' where userid = 'JKW';
select * from v_usertbl;

insert into v_usertbl(userid, name, addr) values('KBM', '김병만', '충북'); -- birthYear가 참조되지 않아서 불가
desc usertbl;

create view v_sum -- sum 함수를 사용한것은 변경불가
as
	select userid as 'userid', sum(price*amount) as 'total'
		from buytbl group by userid;

select * from information_schema.views
where table_schema = 'tabledb' and table_name = 'v_sum'; -- is_updatable 업데이트가 불가능하다고 표시됨
-- 집계함수를 사용한뷰, union, join등을 사용한뷰, distinct, group by 등을 사용한 뷰는 수정하거나 삭제할 수 없다.

create view v_height177
as
	select * from usertbl where height >= 177;
    
select * from v_height177;

delete from v_height177 where height < 177;

select * from usertbl;

insert into v_height177 values('KBM', '김병만', 1977, '경기', '010', '55555555', 158, '2023-01-01');

alter view v_height177
as
	select * from usertbl where height >= 177
		with check option;
        
insert into v_height177 values('SJH', '서장훈', 2006, '서울', '010', '33333333', 155, '2023-3-3'); -- 177 미만은 입력이 불가능 하기 때문에 입력불가

create view v_userbuytbl
as
select U.userid, U.name, B.prodName, U.addr, concat(U.mobile1, U.mobile2)
		from usertbl U
	inner join buytbl B
		on U.userid = B.userid;
        
insert into v_userbuytbl values('PKL', '박경리', '운동화', '경기', '00000000000', '2023-3-2'); -- 두개 이상의 테이블이 연관되어 불가

drop table if exists buytbl, usertbl;

select * from v_userbuytbl;

check table v_userbuytbl;
-- ===================================================================================================
/*
학사관리 시스템 개발과정
PM or PL(프로젝트 리더 or 매니저)
1. 계획 수립(Planning) - 일정, 인력, 비용 등
2. 요구분석(Requirements Analysis - 기능 요구사항 : 학생관리, 입학, 수업관리, 성적 등
			성능 요구사항
            어떤 기능을 개발할지확정됨
3. 설계(Design) - 어떻게 만들것인가 How -> output
4. 구현(Implementation) - coding, programing 단계
5. 시험(Test)
6. 배치(Deployment)
7. 유지보수(MainTerence) - 에러 디버그, 업데이트, 업그레이드 (패치적용)
*/
-- ===================================================================================================
use modeldb;
select * from usertbl;
-- ===================================================================================================
-- 새로운 계정 생성 및 권한부여


-- 스토드 프로시저 - mysql에서 제공되는 프로그래밍 기능
-- 쿼리문의 집합으로 어떠한 동작을 일괄 처리하기 위한 용도로 사용 call프로시저_이름() 으로 호출
/*
delimiter $$
create procedure 스토드 프로스저 이름( in or out 파라미터)
begin
	sql코딩
end $$
delimiter;
call 스도어드 프로시저이름();
*/

drop procedure if exists userProc;
delimiter $$
create procedure userProc()
begin
	select * from userTbl;
end $$
delimiter ;


call userProc();

drop procedure if exists userProc1;
delimiter $$
create procedure userProc1(in userName varchar(10))
begin
	select * from userTbl where name = userName;
end $$
delimiter ;

call userProc1('조관우');