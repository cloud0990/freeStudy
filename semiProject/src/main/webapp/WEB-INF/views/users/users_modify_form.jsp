<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원수정</title>
<!-- BootStrap 3.x 라이브러리 -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
<!-- 다음 주소찾기 API -->
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<!-- SweetAlert2 라이브러리 -->
<script src="//cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<!-- css -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/users_modify_form.css">
<!-- 자바스크립트 -->
<script type="text/javascript">
	
	//주소찾기 함수
	function find(){
		
		 //팝업 위치를 지정(화면의 가운데 정렬)
         var width  = 500; //팝업의 너비
         var height = 600; //팝업의 높이
		
		 new daum.Postcode({
	        oncomplete: function(data) {
	            
	        	//선택된 주소의 우편번호 넣기
	        	$("#u_zipcode").val(data.zonecode);
	        	
	        	//선택된 주소의 주소 넣기
	        	$("#u_addr").val(data.address);
	        },
            width : width, //생성자에 크기 값을 명시적으로 지정해야 합니다.
            height: height
		 }).open({
            left: (window.screen.width / 2) - (width / 2),
            top : (window.screen.height / 2) - (height / 2)
		 });
	}// end : find
	
	//수정하기
	function send(f){
		
		var u_nickname = f.u_nickname.value.trim();
		var u_grade    = f.u_grade.value.trim();
		var u_id       = f.u_id.value.trim();
		var u_pwd      = f.u_pwd.value.trim();
		var u_zipcode  = f.u_zipcode.value.trim();
		var u_addr     = f.u_addr.value.trim();
		
		if(u_nickname==''){

			Swal.fire({
			  icon : 'error',
			  title: '이름을 입력하세요.',
			  text : '수정할 이름이 비어있습니다.',
			  returnFocus : false
			}).then((result)=>{
				if(result.isConfirmed){
					f.u_nickname.value = null;
					f.u_nickname.focus();
				}	
			});

			return;
			
			//then처리를 안 했을 경우
			//값은 제대로 지워진다
			//f.memb_name.value = null;
			
			//위의 비동기함수 때문에, 비동기함수 실행과 함께 실행된다.
			//비동기 함수가 요청해놓고 다음코드를 바로 수행하기때문에 동시에 실행되는 것이다.
			//그러고 나서 focus()가 비동기함수로 뺏김.
			//알람창을 끄고도 이름창에 focus가 있어야하는데 알람창으로 포커스 뺏기는 게 문제임
			//f.u_nickname.focus();
			//return;
		}
		
		if(u_grade==''){
			alert('등급을 입력하세요.');
			f.u_grade.value = null;
			f.u_grade.focus();
			return;
		}
		
		if(u_id==''){
			alert('아이디를 입력하세요.');
			f.u_id.value = null;
			f.u_id.focus();
			return;
		}
		
		if(u_pwd==''){
			alert('비밀번호를 입력하세요.');
			f.u_pwd.value = null;
			f.u_pwd.focus();
			return;
		}
		
		if(u_zipcode==''){
			alert('우편번호를 입력하세요.');
			f.u_zipcode.value = null;
			f.u_zipcode.focus();
			return;
		}
		
		if(u_addr==''){
			alert('주소를 입력하세요.');
			f.u_addr.value = null;
			f.u_addr.focus();
			return;
		}
		
		Swal.fire({
		  title: '정말 수정하시겠습니까?',
		  text : "변경된 정보로 수정합니다.",
		  icon : 'question',
		  showCancelButton  : true,
		  confirmButtonColor: '#3085d6', 
		  cancelButtonColor : '#d33',
		  confirmButtonText : '수정',
		  cancelButtonText  : '취소'
		
		}).then((result) => {
			
		  if (result.isConfirmed) {
				
			  f.action = "modify.do"; //전송대상 지정
			  f.submit(); //전송
		  }
		});
	}// end : send()
</script>
<!-- 등급관리 -->
<script type="text/javascript">
$(document).ready(function(){
	($("#u_grade").val('${vo.u_grade}'))
});
</script>
</head>
<body>

<form>
	<input type="hidden" name="u_idx" value="${vo.u_idx}">
	<div id="box">
	   <div class="panel panel-default">
	      <div class="panel-heading"><h4>회원정보 수정</h4></div>
	      <div class="panel-body">
	      		<table class="table table-striped">
	      			<tr>
	      				<th>이름</th>
      					<td><input name="u_nickname" id="u_nickname" value="${vo.u_nickname}"></td>
	      			</tr>
      				<tr>
	      				<th>아이디</th>
      					<td><input name="u_id" id="u_id" value="${vo.u_id}" readonly="readonly"></td>
	      			</tr>
      				<tr>
	      				<th>비밀번호</th>
      					<td><input name="u_pwd" id="u_pwd" value="${vo.u_pwd}"></td>
	      			</tr>
      				<tr>
	      				<th>우편번호</th>
      					<td><input id="u_zipcode" name="u_zipcode" value="${vo.u_zipcode}">
      						<input class="btn btn-default" type="button" value="Find Address" onclick="find();">
   						</td>
	      			</tr>
      				<tr>
	      				<th>주소</th>
      					<td><input name="u_addr" id="u_addr" size="50px" value="${vo.u_addr}"></td>
	      			</tr>
      				<tr>
	      				<th>회원등급</th>
						<td>
							<select id="u_grade" name="u_grade">
								<option value="일반">일반</option>
								<option value="관리자">관리자</option>
							</select>
						</td>
	      			</tr>
	      			<tr>
	      				<td colspan="2" align="center">
	      					<input class="btn btn-default" type="button" value="수정하기" id="btn_register" onclick="send(this.form);">
	      					<input class="btn btn-default" type="button" value="목록보기" id="btn_list"     onclick="location.href='list.do'">
	      				</td>
	      			</tr>
	      		</table>	
	      </div>
	   </div>
	</div>
</form>

</body>
</html>