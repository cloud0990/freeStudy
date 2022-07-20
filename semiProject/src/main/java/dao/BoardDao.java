package dao;

import java.util.List;
import java.util.Map;

import vo.BoardVo;

public interface BoardDao {
	
	// 전체 조회
	List<BoardVo> selectList();
	// 검색 조건 별 조회
	List<BoardVo> selectList(Map map);
	// b_idx에 해당하는 Vo 1건 구하기
	BoardVo selectOne(int b_idx);
	// 전체 행 수 구하기(페이징 처리)
	int selectRowTotal();
	// 검색 조건별 페이징 처리하기
	int selectRowTotal(Map map);
	
	int insert(BoardVo vo); // 새글 쓰기
	int reply(BoardVo vo);  // 답글 쓰기
	int delete(int b_idx);
	int update(BoardVo vo); 
	int update_step(BoardVo vo);
	int update_readhit(int b_idx); // 조회수 증가
}