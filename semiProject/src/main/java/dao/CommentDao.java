package dao;

import java.util.List;
import java.util.Map;

import vo.CommentVo;

public interface CommentDao {
	
	// b_idx에 해당하는 댓글 목록 가져오기
	List<CommentVo> selectList(int b_idx);
	List<CommentVo> selectList(Map map);
	List<CommentVo> selectOne(int c_idx);
	
	int insert(CommentVo vo);
	int update(CommentVo vo);
	int delete(int c_idx);
}