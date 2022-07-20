<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<!-- css -->
<link rel="stylesheet" href="${pageContext.request.contextPath }/resources/css/header/mainmenuHeader.css">
<script type="text/javascript">
function insertCard(){
	if(!confirm('로그인 후 이용가능합니다.\n로그인 하시겠습니까?')) {
		return;
	}
	var url_insert = "http://localhost:9090/teka/card/insertCardForm.do"
	location.href="../tekamember/loginForm.do?url=" + encodeURIComponent(url_insert);
}
//카드 검색
function find() {
	
	search      = $("#search").val();
	search_text = $("#search_text").val().trim();

	//전체보기가 아니면서 search_text가 비어있을 경우
	if(search!='all' && search_text=='') {
		
		alert('검색어를 입력하세요.');
		$("#search_text").val('');
		$("#search_text").focus();
		return;
	}
	//검색요청 (자바스크립트 내에서 location url을 통해서 전달되는 데이터는 인코딩 해서 전송해야한다.)
	location.href="list.do?search=" + search + "&search_text=" + encodeURIComponent(search_text);	
}// end : find

$(function(){
	if("${not empty param.search}"=="true") {
		$("#search").val('${param.search}');	
	}
	
	//전체보기면 검색어 지우기
	if("${empty param.search or param.search eq 'all'}"=="true") {
		$("#search_text").val("");
	}
});
</script>
</head>
<body>
	<nav id="bar" class="navbar navbar-inverse navbar-fixed-top">
		<div class="container-fluid">
			<div class="navbar-header">
				<a class="navbar-brand" href="../board/list.do" style="font-size: x-large; font-weight: bolder;">게시판</a>
			</div>
			<ul class="nav navbar-nav">
				<li><a href="../board/list.do">홈페이지</a></li>
			</ul>
			<div id="searchbar" class="navbar-form navbar-left">
				<div class="form-group">
					<select id="search" class="form-control">
						<option value="all">전체검색</option>
						<option value="subject">제목</option>
						<option value="content">내용</option>
						<option value="name">작성자</option>
						<option value="subject_content_name">제목+내용+작성자</option>
					</select>
					<input class="form-control" placeholder="검색어를 입력하세요." value="${param.search_text}" id="search_text" onkeyup="if(window.event.keyCode==13){search();}">
				</div>
				<input type="button" class="btn btn-default" value="검색" onclick="find();">
			</div>
			
			<ul class="nav navbar-nav navbar-right">
				<c:if test="${empty user}">
					<li><a href="../users/insert_form.do"><span class="glyphicon glyphicon-user"></span>회원가입</a></li>
					<li><a href="../users/login_form.do"><span class="glyphicon glyphicon-log-in"></span>로그인</a></li>
				</c:if>
				<!-- 로그인 된 경우 : 일반회원 -->
				<c:if test="${!empty user && user.u_grade=='일반'}">
					<li><a><span class="glyphicon glyphicon-user"></span>${user.u_nickname}님</a></li>
					<li><a href='${pageContext.request.contextPath}/users/logout.do'><span class="glyphicon glyphicon-log-out"></span>로그아웃</a></li>
				</c:if>
				<!-- 로그인 된 경우 : 관리자회원 -->
				<c:if test="${ not empty user && user.u_grade=='관리자' }">
					<li><a><span class="glyphicon glyphicon-user"></span>${user.u_nickname}님</a></li>
					<li><a href="${pageContext.request.contextPath}/users/list.do"><span class="glyphicon glyphicon-user"></span>회원관리</a></li>
					<li><a href='${pageContext.request.contextPath}/users/logout.do'><span class="glyphicon glyphicon-log-out"></span>로그아웃</a></li>
				</c:if>
			</ul>
			
		</div>
	</nav>
</body>
</html>