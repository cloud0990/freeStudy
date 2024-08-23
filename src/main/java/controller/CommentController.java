package controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import common.MyConstant;
import dao.CommentDao;
import util.Paging;
import vo.CommentVo;

@Controller
@RequestMapping("/board/")
public class CommentController {

	@Autowired
	HttpServletRequest request;
	
	CommentDao commentDao;
	public void setCommentDao(CommentDao commentDao) {
		this.commentDao = commentDao;
	}
	
	@RequestMapping("comment_list.do")
	public String comment_list(int b_idx, @RequestParam(value="page", required=false, defaultValue="1")int nowPage, Model model) {
		int start = (nowPage - 1) * MyConstant.Comment.BLOCK_LIST + 1;
		int end   = start + MyConstant.Comment.BLOCK_LIST-1;
		
		Map map = new HashMap();
		map.put("start", start);
		map.put("end", end);
		map.put("b_idx", b_idx);
		
		List<CommentVo> list = commentDao.selectList(map);
	
		int rowTotal = commentDao.selectRowTotal(b_idx);
		
		String pageMenu = Paging.getCommentPaging(nowPage, rowTotal, MyConstant.Comment.BLOCK_LIST, MyConstant.Comment.BLOCK_PAGE);
		
		model.addAttribute("list", list);
		model.addAttribute("pageMenu", pageMenu);
		
		return "board/comment_list";
	}
	
	@RequestMapping("comment_insert.do")
	@ResponseBody
	public Map comment_insert(CommentVo vo) {
		String c_content = vo.getC_content().replaceAll("\n", "<br>");
		String c_ip      = request.getRemoteAddr();
		vo.setC_content(c_content);
		vo.setC_ip(c_ip);
		
		int res = commentDao.insert(vo);
		
		Map map = new HashMap();
		map.put("result", res==1 ? true : false);

		return map;
	}
	
	@RequestMapping("comment_delete.do")
	@ResponseBody
	public Map comment_delete(int c_idx) {
		
		int res = commentDao.delete(c_idx);
		
		Map map = new HashMap();
		map.put("result", res==1 ? true : false);
		
		return map;
	}
}