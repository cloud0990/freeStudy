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
	
	// 전역변수처럼 선언되어있지만, 해당 메소드가 호출 될 때마다 DS가 넣어줌
	@Autowired
	HttpSession        session; 
	@Autowired
	HttpServletRequest request;
	@Autowired
	HttpServletRequest response;
	
	// 인터페이스(사용설명서) 객체를 생성한다.
	// -> Override는 마지막에 재정의된 메소드가 호출되기때문에, Impl 클래스 내에서 재정의된 메소드가 호출된다.
	BoardDao boardDao;
	public void setBoardDao(BoardDao boardDao) {
		this.boardDao = boardDao;
	}

	// 전체조회
	// 1. /board/list.do
	// 3. /board/list.do?page=1
	@RequestMapping("list.do")       //파라미터는 무조건 문자열로 들어오기 때문에, 초기값은 무조건 String형이다.
	public String list(@RequestParam(value="page", required=false, defaultValue="1") int nowPage,
					   @RequestParam(value="search", required=false, defaultValue="all") String search,
					   @RequestParam(value="search_text", required=false) String search_text,
	      			   Model model) {
		
		// 세션에 저장되어있는 show 정보 삭제
		session.removeAttribute("show");
		
		// 현재 페이지를 이용해서, 게시물의 start / end 계산
		int start = (nowPage-1) * MyConstant.Board.BLOCK_LIST + 1;
		int end   = start + MyConstant.Board.BLOCK_LIST - 1;
		
		Map map = new HashMap();
		map.put("start", start);
		map.put("end", end);
		
		//전체검색이 아니면
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
		
		// 전체(조건에 맞는) 게시물 수 구하기
		int rowTotal = boardDao.selectRowTotal(map);
		
		// 검색메뉴정보를 페이징메뉴에 전달
		String search_filter = String.format("search=%s&search_text=%s", search, search_text);
		
		// 페이징 메뉴 만들기               pageUrl 현재페이지 전체게시물
		String pageMenu = Paging.getPaging("list.do", search_filter, nowPage, rowTotal, 
				                             MyConstant.Board.BLOCK_LIST, //한 화면에 보여질 게시물 수
				                             MyConstant.Board.BLOCK_PAGE  //한 화면에 보여질 페이지 수
				                             );
		
		List<BoardVo> list = boardDao.selectList(map);
		
		// DS가 request binding 할 수 있도록, model에 저장 (결과적으로 request binding)
		model.addAttribute("list", list);
		model.addAttribute("pageMenu", pageMenu);
		model.addAttribute("page", nowPage);
		
		return "board/board_list";
	}
	
	// 게시글 상세보기
	@RequestMapping("view.do")
	public String view(int b_idx, Model model) {
		
		BoardVo vo = boardDao.selectOne(b_idx);
		
		//해당게시물을 안 봤으면 조회수 증가
		if(session.getAttribute("show")==null) {
			
			//해당 페이지가 호출될 때마다 조회수 증가 -> 문제점 : 같은 사용자가 계속 새로고침해도 조회수로 적용되기때문에 session 저장
			int res = boardDao.update_readhit(b_idx);
			
			session.setAttribute("show", true);
		}// end : if
		
		model.addAttribute("vo", vo);
		
		return "board/board_view";
	}
	
	// 새 글 쓰기 폼 띄우기
	@RequestMapping("insert_form.do")
	public String insert_form() {
		
		return "board/board_insert_form";
	}
	
	// 새 글 쓰기 insert
	@RequestMapping("insert.do")
	public String insert(BoardVo vo, Model model) {
		
		//세션이 만료되어 로그아웃됐을 경우 글쓰기 제한
		if(session.getAttribute("user") == null) {
				
			model.addAttribute("reason", "session_timeout");

			return "redirect:../users/login_form.do";
		}
		
		
		String b_ip = request.getRemoteAddr();	
		
		vo.setB_ip(b_ip);
		
		int res = boardDao.insert(vo);
		
		return "redirect:list.do";
	}
	
	// 게시글 삭제 : /board/delete.do?b_idx=16&page=3&search=name&search_text=길동
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
		
		return "redirect:list.do"; // list.do?page=3&search=name&search_text=길동
	}
	
	
	// 답글쓰기 폼 띄우기
	@RequestMapping("reply_form.do")
	public String reply_form() {
		
		return "board/board_reply_form";
	}
	
	// 답글쓰기
	@RequestMapping("reply.do")
	public String reply(BoardVo vo) { 	
		
		String b_ip = request.getRemoteAddr();
		vo.setB_ip(b_ip);
		
		//기준글 정보 얻어오기
		BoardVo baseVo = boardDao.selectOne(vo.getB_idx());
		
		//기준글보다 b_step이 큰 게시물은 b_step + 1
		int res = boardDao.update_step(baseVo);
		
		//현재 답글의 정보 갱신 : 그룹글번호 그대로 받기 (같은 그룹에 있기 위함)
		vo.setB_ref(baseVo.getB_ref());
		vo.setB_step(baseVo.getB_step()+1);  //원래의 b_step보다  +1 셋팅 (원본글의 바로 밑에 위치)
		vo.setB_depth(baseVo.getB_depth()+1);//원래의 b_depth보다 +1 셋팅 (대댓글의 바로 밑에 위치) 
		
		//답글 등록
		res = boardDao.reply(vo);
		
		return "redirect:list.do";
	}
	
	// 수정폼 띄우기 : /board/modify_form.do?b_idx=16&page=3&search=name&search_text=길동
	@RequestMapping("modify_form.do") 
	public String modify_form(int b_idx, Model model) {
		
		BoardVo vo = boardDao.selectOne(b_idx);
		
		model.addAttribute("vo", vo);
		
		return "board/board_modify_form";
	}
	
	// 수정하기
	@RequestMapping("modify.do")
	public String modify(BoardVo vo,
						 int page,
						 @RequestParam(value="search", required=false, defaultValue="all") String search,
						 @RequestParam(value="search_text", required=false) String search_text,
						 Model model) {
		
		// 세션 만료된 경우
		if(session.getAttribute("user")==null) {
			model.addAttribute("reason", "session_timeout");
			return "redirect:../users/users_login_form.do";
		}
		
		String b_ip = request.getRemoteAddr();
		vo.setB_ip(b_ip);
		
		int res = boardDao.update(vo);
		
		// redirect : view.do?b_idx=16&page=3&search=name&search_text=길동
		model.addAttribute("b_idx", vo.getB_idx());
		model.addAttribute("page", page);
		model.addAttribute("search", search);
		model.addAttribute("search_text", search_text);
		
		return "redirect:view.do";
	}
	
	
	
}