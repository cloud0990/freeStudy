package dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;

import vo.BoardVo;

public class BoardDaoImpl implements BoardDao {

	// 자동연결(엮기)
	@Autowired 
	SqlSession sqlSession;
	// 게시글 전체조회
	@Override
	public List<BoardVo> selectList() {
		return sqlSession.selectList("board.board_list");
	}
	// b_idx에 해당하는 객체 1건 구하기 (게시글 상세보기)
	@Override
	public BoardVo selectOne(int b_idx) {
		return sqlSession.selectOne("board.board_one", b_idx);
	}
	// 페이징 처리로 조회하기
	@Override
	public List<BoardVo> selectList(Map map) {
		return sqlSession.selectList("board.board_condition_list", map);
	}
	// 게시글 작성
	@Override
	public int insert(BoardVo vo) {
		return sqlSession.insert("board.board_insert", vo);
	}
	// 답글 작성
	@Override
	public int reply(BoardVo vo) {
		return sqlSession.insert("board.board_reply", vo);
	}
	// 게시글 삭제
	@Override
	public int delete(int b_idx) {
		return sqlSession.update("board.board_delete", b_idx);
	}
	// 게시글 수정
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