<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>   
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> 
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시글 상세보기</title>
<!-- Bootstrap 외부라이브러리등록 -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
<!-- css -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/board_view.css">
<script type="text/javascript">
function reply_form() {
	//로그인하지 않았을 경우, 로그인 폼으로 이동
	if("${empty user}"=="true") {
		if(!confirm('답글쓰기는 로그인 후 이용가능합니다.\n로그인 하시겠습니까?')) {
			return;		
		} else {
			// url상에 특수문자.. 포함되어있을 수 있기때문에 encodeURIComponent로 인코딩
			location.href="${pageContext.request.contextPath}/users/login_form.do?url=" + encodeURIComponent(location.href);
		}
	//로그인 했을 경우, 답글쓰기 폼으로 이동	
	} else {
		location.href="reply_form.do?b_idx=${vo.b_idx}";
	}
}// end : reply_form

function del() {
	if(!confirm('정말 삭제하시겠습니까?')) return;
	//세션트레킹
	location.href="delete.do?b_idx=${vo.b_idx}&page=${param.page}&search=${param.search}&search_text=${param.search_text}";
}// end : del

function modify_form() {
	//수정폼 띄우기 (세션트레킹 : url로 b_idx, page정보, search, search_text를 함께 넘긴다)
	location.href="modify_form.do?b_idx=${vo.b_idx}&page=${param.page}&search=${param.search}&search_text=${param.search_text}";
}// end : modify_form
</script>
<!-- 댓글 관련 -->
<script type="text/javascript">
function insert_comment() {
	//로그인 여부
	if("${empty user}"=="true") {
		
		if(!confirm('댓글은 로그인 후 사용가능합니다.\n로그인 하시겠습니까?')) return;
		//현재경로를 전달해서 로그인 폼으로 이동(로그인 후, 현 위치로 돌아오기위함)
		location.href="../users/users_login_form.do?url=" + encodeURIComponent(location.href); //location.href : 현재경로
		return;
	}
	//Ajax를 이용해서 댓글 등록
	var c_content = $("#c_content").val().trim();
	
	if(c_content=='') {
		alert('댓글을 입력하세요.');
		$("#c_content").val('');
		$("#c_content").focus();
		return;
	}
	
	$.ajax({
		url : 'comment_insert.do',
		data : {'b_idx':'${vo.b_idx}', 'c_content':c_content, 'u_idx':'${user.u_idx}', 'u_nickname':'${user.u_nickname}'},
		success : function(res){
			if(res.result) {
				comment_list(global_page);
			}
		}
	});// end : ajax
}// end : insert_comment

//댓글 목록 가져오기
var global_page = 1;
function comment_list(comment_page) {
		
	$.ajax({
		url:'comment_list.do',
		data:{b_idx:"${vo.b_idx}", page:comment_page},
		dataType:'html',
		success : function(res){
			$("#disp").html(res);			
		}
	});// end : ajax
}// end : comment_list

//현재 Document가 배치완료되면
$(function(){
	//댓글목록 가져오기	
	comment_list(1);
});
</script>
</head>
<body>
<div id="header">
	<%@include file="../header/mainmenu.jsp" %>	
</div>
<div id="box">
	<div id="subject">제목: ${vo.b_subject}</div>
	<div id="content">${vo.b_content}</div>
	<div id="regdate">
		<span class="badge">by ${vo.u_nickname}</span><br>
		작성일자: ${fn:substring(vo.b_regdate,0,16)}</div>
	<div id="jobBtn">
		<input class="btn btn-primary" type="button" value="목록보기" onclick="location.href='list.do?page=${param.page}&search=${param.search}&search_text=${param.search_text}';">
		
		<!-- 답글은 메인 글, 전체 검색 시에만 답글쓰기 버튼 보여주기 -->
		<c:if test="${ (vo.b_depth eq 0) and (param.search eq 'all') }">
			<input class="btn btn-success" type="button" value="답글쓰기" onclick="reply_form();">
		</c:if>
		
		<!-- 수정/삭제 권한은 게시글 작성자 본인에게만 부여 -->
		<c:if test="${user.u_idx eq vo.u_idx}">
			<div id="btn">
				<input class="btn btn-info"   type="button" value="수정" onclick="modify_form();">
				<input class="btn btn-danger" type="button" value="삭제" onclick="del();">
			</div>
		</c:if>
	</div>
	<!-- 댓글입력폼 -->
	<hr>
	<div>
		<textarea id="c_content" placeholder="댓글을 작성하세요."></textarea>
		<input    id="btn_comment" type="button" value="댓글쓰기" onclick="insert_comment();">
	</div>	
	<hr>
	<div id="disp"></div>
</div>
</body>
</html>