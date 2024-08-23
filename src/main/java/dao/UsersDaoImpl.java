package dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;

import vo.UsersVo;

public class UsersDaoImpl implements UsersDao {

	SqlSession sqlSession;
	public void setSqlSession(SqlSession sqlSession) {
		this.sqlSession = sqlSession;
	}
	
	@Override
	public List<UsersVo> selectList() {
		
		return sqlSession.selectList("users.user_list");
	}

	@Override
	public UsersVo selectOne(int u_idx) {
		
		return sqlSession.selectOne("users.user_one_idx", u_idx);
	}

	@Override
	public UsersVo selectOne(String u_id) {

		return sqlSession.selectOne("users.user_one_id", u_id);
	}

	@Override
	public int insert(UsersVo vo) {

		return sqlSession.insert("users.user_insert", vo);
	}

	@Override
	public int update(UsersVo vo) {

		return sqlSession.update("users.user_update", vo);
	}

	@Override
	public int delete(int u_idx) {

		return sqlSession.delete("users.user_delete", u_idx);
	}

}
