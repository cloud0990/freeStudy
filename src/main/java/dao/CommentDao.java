package dao;

import java.util.List;
import java.util.Map;

import vo.CommentVo;

public interface CommentDao {
	
	List<CommentVo> selectList(int b_idx);

	List<CommentVo> selectList(Map map);

	List<CommentVo> selectOne(int c_idx);
	
	int selectRowTotal(int b_idx);

	int insert(CommentVo vo);

	int update(CommentVo vo);

	int delete(int c_idx);
}