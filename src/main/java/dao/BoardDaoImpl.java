package dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;

import vo.BoardVo;

public class BoardDaoImpl implements BoardDao {

	@Autowired
	SqlSession sqlSession;

	@Override
	public List<BoardVo> selectList() {
		return sqlSession.selectList("board.board_list");
	}

	@Override
	public BoardVo selectOne(int b_idx) {
		return sqlSession.selectOne("board.board_one", b_idx);
	}

	@Override
	public List<BoardVo> selectList(Map map) {
		return sqlSession.selectList("board.board_condition_list", map);
	}

	@Override
	public int insert(BoardVo vo) {
		return sqlSession.insert("board.board_insert", vo);
	}

	@Override
	public int reply(BoardVo vo) {
		return sqlSession.insert("board.board_reply", vo);
	}

	@Override
	public int delete(int b_idx) {
		return sqlSession.update("board.board_delete", b_idx);
	}

	@Override
	public int update(BoardVo vo) {
		return sqlSession.update("board.board_update", vo);
	}

	@Override
	public int update_step(BoardVo vo) {
		return sqlSession.update("board.board_update_step", vo);
	}

	@Override
	public int update_readhit(int b_idx) {
		return sqlSession.update("board.board_update_readhit", b_idx);
	}

	@Override
	public int selectRowTotal() {
		return sqlSession.selectOne("board.board_row_total");
	}

	@Override
	public int selectRowTotal(Map map) {
		return sqlSession.selectOne("board.board_condition_row_total", map);
	}
}