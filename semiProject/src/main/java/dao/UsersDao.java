package dao;

import java.util.List;

import vo.UsersVo;

public interface UsersDao {
		
//전체조회 (u_grade=관리자만 가능)
	public List<UsersVo> selectList();
	
//회원정보 수정
	public UsersVo selectOne(int u_idx); //u_idx(PK)에 해당되는 객체 1건 구하기

//로그인
	public UsersVo selectOne(String u_id); //u_id(unique)에 해당되는 객체 1건 구하기
	
//DML	
	public int insert(UsersVo vo); //삽입
	public int update(UsersVo vo); //수정
	public int delete(int u_idx);  //삭제
	
}