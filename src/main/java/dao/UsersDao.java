package dao;

import java.util.List;

import vo.UsersVo;

public interface UsersDao {
		
	public List<UsersVo> selectList();
	
	public UsersVo selectOne(int u_idx);

	public UsersVo selectOne(String u_id);
	
	public int insert(UsersVo vo);

	public int update(UsersVo vo);

	public int delete(int u_idx);
	
}