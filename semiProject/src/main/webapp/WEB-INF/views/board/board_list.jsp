<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>   
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> 
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>답변형 게시판 : 전체 목록</title>
<!-- Bootstrap 외부라이브러리등록 -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
<!-- css  -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/board_list.css">
<script type="text/javascript">
//로그인 폼으로 이동
function insert_form() {
	// 로그인 여부 확인
	if("${empty user}"=="true") {
		if(!confirm('로그인 후 이용가능합니다.\n로그인 하시겠습니까?')) return;
		// 로그인 폼으로 이동
		location.href='${pageContext.request.contextPath}/users/login_form.do';
		return;
	}
	location.href='insert_form.do';
}// end : insert_form
</script>
</head>
<body>
<div id="header">
	<%@include file="../header/mainmenu.jsp" %>	
</div>
<div id="box">
	<div id="logInOut">
		<div>
			<input class="btn btn-default" type="button" value="새글작성" id="writeBtn" onclick="insert_form();">
		</div>
	</div>
<!-- 게시판 목록 출력 -->
	<table class="table table-striped" style="background-color: white;">
		<tr class="default">
			<th class="headText">번호</th>	
			<th class="headText" width="60%">제목</th>	
			<th class="headText">작성자</th>	
			<th class="headText">작성일자</th>	
			<th class="headText">조회수</th>	
		</tr>
		<!-- 데이터가 없는 경우 -->
		<c:if test="${empty list}">
			<tr>
				<td colspan="5" align="center">
					<font color="red">작성된 게시글이 없습니다.</font>
				</td>
			</tr>
		</c:if>
		<!-- 데이터가 있는 경우 -->
		<c:forEach var="vo" items="${list}">
			<tr>
				<td>${vo.b_idx}</td>	

				<td style="text-align: left;">
					
					<!-- 들여쓰기 (1 ~ b_depth 반복)-->
					<c:forEach begin="1" end="${vo.b_depth}">
						&nbsp;&nbsp;&nbsp;
					</c:forEach>
					<c:if test="${vo.b_depth ne 0}">ㄴ</c:if>
					
					<!-- 사용가능한 게시물인 경우 -->
					<c:if test="${vo.b_use_yn eq 'y'}">
						<a href="view.do?b_idx=${vo.b_idx}&page=${empty param.page ? 1 : param.page}&search=${empty param.search ? 'all' : param.search}&search_text=${param.search_text}">
							${vo.b_subject}
							<c:if test="${vo.comment_count gt 0}">
								<span class="badge">${vo.comment_count}</span>
							</c:if>
						</a>					
					</c:if>
					<!-- 삭제된 게시물인 경우 -->					
					<c:if test="${vo.b_use_yn eq 'n'}">
						<font color="red">삭제된 게시글입니다.</font>
					</c:if>
				</td>	
				<td>${vo.u_nickname}</td>	
				<td>${fn:substring(vo.b_regdate,0,16)}</td>	
				<td>${vo.b_readhit}</td>	
			</tr>
		</c:forEach>
	</table>
	<!-- 페이징 메뉴 -->	
	<div style="text-align: center; font-size: 18px;">
		${pageMenu}		
	</div>
</div><!-- end : box -->
</body>
</html>