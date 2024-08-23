package dao;

import java.util.List;
import java.util.Map;

import vo.BoardVo;

public interface BoardDao {
	
	List<BoardVo> selectList();

	List<BoardVo> selectList(Map map);

	BoardVo selectOne(int b_idx);

	int selectRowTotal();

	int selectRowTotal(Map map);
	
	int insert(BoardVo vo);

	int reply(BoardVo vo);

	int delete(int b_idx);

	int update(BoardVo vo);

	int update_step(BoardVo vo);

	int update_readhit(int b_idx);
}