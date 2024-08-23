<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로그인</title>
<!-- BootStrap 3.x 라이브러리 등록 -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
<!-- CSS -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/users_login_form.css">
<!-- 자바스크립트 -->
<script type="text/javascript">
	
	function login(f){
		
		var u_id  = f.u_id.value.trim();
		var u_pwd = f.u_pwd.value.trim();

		if(u_id==''){
			
			alert('아이디를 입력하세요.');
			f.u_id.value='';
			f.u_id.focus();
			return;
		}
		if(u_pwd==''){
			
			alert('비밀번호를 입력하세요.');
			f.u_pwd.value='';
			f.u_pwd.focus();
			return;
		}

		f.action = "login.do";
		f.submit();

	} // end : login()
	
//서버측해당 아이디와 비밀번호가 조회되는지 제이쿼리 Ajax로 확인
/* 		$.ajax({
			
			type     : 'GET',
			url      : 'login.do',
			data     : {'memb_id':memb_id, 'memb_pwd':memb_pwd},
			dataType : 'json',
			success  : function(res){
				
				if(res.result){
					
					alert('로그인 성공!');
					
					location.href='../photo/list.do';
					
				}else {
					
					$(function(){
						alert('로그인정보가 일치하지않습니다.');
						f.memb_pwd.value='';
						
						f.memb_id.value='';
						f.memb_id.focus();
						return;
					});
				}//if~else end
			}//success() end
		
		});//ajax end
*/
</script>

<!-- 로그인정보 불일치 확인 자바스크립트 -->
<script type="text/javascript">

	$(document).ready(function(){
		
		setTimeout(showMessage, 100);
	});

	function showMessage(){
		
		//데이터를 표현할 때는(EL표현식) 커텐션마크 안에서 사용 -> 제이쿼리의 $와 혼동가능성 있기 때문
		if("${param.reason eq 'fail_id'}" == "true"){ // 'eq' = '=='
			
			alert('아이디가 틀렸습니다.');
			return;
		}
		
		//비밀번호가 틀렸을 경우
		if("${param.reason == 'fail_pwd'}" == "true"){
			
			alert('비밀번호가 틀렸습니다.');
			return;
		}
		
		//Session이 만료됐ㅇ르 경우
		if("${param.reason == 'session_timeout'}" == "true"){
			
			alert('로그아웃되었습니다.\n다시 로그인해주세요.');
			return;
		}
	}// end : showMessage()
</script>
</head>
<body>

<form>
	<div id="box">
		<div><div><h4>로그인</h4></div>
			<div>
				<table class="table table-striped" id="login_table">
					<tr>
						<th>아이디</th>
						<td><input name="u_id" value="${param.u_id}"></td>
					</tr>
					<tr>
						<th>비밀번호</th>
						<td><input type="password" name="u_pwd"></td>
					</tr>
					<tr>
						<td colspan="2" align="center">
							<div style="margin-top:13px;">
								<input type="button" value="로그인"   onclick="login(this.form);">
								<input type="button" value="목록보기" onclick="location.href='${pageContext.request.contextPath}/board/list.do';">
							</div>
						</td>
					</tr>
				</table>
			</div>
		</div>
	</div><!--#box end-->
</form>

</body>
</html>