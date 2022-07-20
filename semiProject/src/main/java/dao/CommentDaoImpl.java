package dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;

import vo.CommentVo;

public class CommentDaoImpl implements CommentDao {

	SqlSession sqlSession;
	public void setSqlSession(SqlSession sqlSession) {
		this.sqlSession = sqlSession;
	}
	@Override
	public List<CommentVo> selectList(int b_idx) {
		return sqlSession.selectList("comment.comment_list", b_idx);
	}
	@Override
	public List<CommentVo> selectList(Map map) {
		return sqlSession.selectList("comment.comment_page_list", map);
	}
	@Override
	public List<CommentVo> selectOne(int c_idx) {
		return sqlSession.selectOne("comment.comment_one", c_idx);
	}
	@Override
	public int insert(CommentVo vo) {
		return sqlSession.insert("comment.comment_insert", vo);
	}
	@Override
	public int update(CommentVo vo) {
		return sqlSession.update("comment.comment_update", vo);
	}
	@Override
	public int delete(int c_idx) {
		return sqlSession.delete("comment.comment_delete", c_idx);
	}
}