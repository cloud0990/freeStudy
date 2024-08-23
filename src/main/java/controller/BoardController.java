package controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import common.MyConstant;
import dao.BoardDao;
import util.Paging;
import vo.BoardVo;

@Controller
@RequestMapping("/board/")
public class BoardController {
	
	@Autowired
	HttpSession        session; 
	@Autowired
	HttpServletRequest request;
	@Autowired
	HttpServletRequest response;
	
	BoardDao boardDao;
	public void setBoardDao(BoardDao boardDao) {
		this.boardDao = boardDao;
	}

	@RequestMapping("list.do")
	public String list(@RequestParam(value="page", required=false, defaultValue="1") int nowPage,
					   @RequestParam(value="search", required=false, defaultValue="all") String search,
					   @RequestParam(value="search_text", required=false) String search_text,
	      			   Model model) {
		
		session.removeAttribute("show");
		
		int start = (nowPage-1) * MyConstant.Board.BLOCK_LIST + 1;
		int end   = start + MyConstant.Board.BLOCK_LIST - 1;
		
		Map map = new HashMap();
		map.put("start", start);
		map.put("end", end);
		
		if(!search.equals("all")) {
			if(search.equals("subject_content_name")) {
				map.put("subject", search_text);
				map.put("content", search_text);
				map.put("name", search_text);
			}else if(search.equals("subject")) {
				map.put("subject", search_text);
			}else if(search.equals("content")) {
				map.put("content", search_text);
			}else if(search.equals("name")) {
				map.put("name", search_text);
			}
		}
		
		int rowTotal = boardDao.selectRowTotal(map);
		
		String search_filter = String.format("search=%s&search_text=%s", search, search_text);
		
		String pageMenu = Paging.getPaging("list.do", search_filter, nowPage, rowTotal,
				                             MyConstant.Board.BLOCK_LIST,
				                             MyConstant.Board.BLOCK_PAGE
				                             );
		
		List<BoardVo> list = boardDao.selectList(map);
		
		model.addAttribute("list", list);
		model.addAttribute("pageMenu", pageMenu);
		model.addAttribute("page", nowPage);
		
		return "board/board_list";
	}
	
	@RequestMapping("view.do")
	public String view(int b_idx, Model model) {
		
		BoardVo vo = boardDao.selectOne(b_idx);
		
		if(session.getAttribute("show")==null) {
			
			int res = boardDao.update_readhit(b_idx);
			
			session.setAttribute("show", true);
		}
		
		model.addAttribute("vo", vo);
		
		return "board/board_view";
	}
	
	@RequestMapping("insert_form.do")
	public String insert_form() {
		
		return "board/board_insert_form";
	}
	
	@RequestMapping("insert.do")
	public String insert(BoardVo vo, Model model) {
		if(session.getAttribute("user") == null) {
			model.addAttribute("reason", "session_timeout");
			return "redirect:../users/login_form.do";
		}

		String b_ip = request.getRemoteAddr();	
		
		vo.setB_ip(b_ip);
		
		int res = boardDao.insert(vo);
		
		return "redirect:list.do";
	}
	
	@RequestMapping("delete.do")
	public String delete(int b_idx,
						 int page,
						 @RequestParam(value="search", required=false, defaultValue="all") String search,
						 @RequestParam(value="search_text", required=false) String search_text,
						 Model model) {
		
		int res = boardDao.delete(b_idx);
		
		model.addAttribute("page", page);
		model.addAttribute("search", search);
		model.addAttribute("search_text", search_text);
		
		return "redirect:list.do";
	}
	
	@RequestMapping("reply_form.do")
	public String reply_form() {
		
		return "board/board_reply_form";
	}
	
	@RequestMapping("reply.do")
	public String reply(BoardVo vo) { 	
		
		String b_ip = request.getRemoteAddr();
		vo.setB_ip(b_ip);
		
		BoardVo baseVo = boardDao.selectOne(vo.getB_idx());
		
		int res = boardDao.update_step(baseVo);
		
		vo.setB_ref(baseVo.getB_ref());
		vo.setB_step(baseVo.getB_step()+1);
		vo.setB_depth(baseVo.getB_depth()+1);
		
		res = boardDao.reply(vo);
		
		return "redirect:list.do";
	}
	
	@RequestMapping("modify_form.do")
	public String modify_form(int b_idx, Model model) {
		BoardVo vo = boardDao.selectOne(b_idx);
		
		model.addAttribute("vo", vo);
		return "board/board_modify_form";
	}
	
	@RequestMapping("modify.do")
	public String modify(BoardVo vo,
						 int page,
						 @RequestParam(value="search", required=false, defaultValue="all") String search,
						 @RequestParam(value="search_text", required=false) String search_text,
						 Model model) {
		
		if(session.getAttribute("user")==null) {
			model.addAttribute("reason", "session_timeout");
			return "redirect:../users/users_login_form.do";
		}
		
		String b_ip = request.getRemoteAddr();
		vo.setB_ip(b_ip);
		
		int res = boardDao.update(vo);
		
		model.addAttribute("b_idx", vo.getB_idx());
		model.addAttribute("page", page);
		model.addAttribute("search", search);
		model.addAttribute("search_text", search_text);
		
		return "redirect:view.do";
	}

}