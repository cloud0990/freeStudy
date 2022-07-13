<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script type="text/javascript">
	
	function result(){
	  
	  // 입력받은 데이터 얻어오기
	  var text = $("#text").val().trim();	
	
	  // 초성 배열 생성
	  var cs = ["ㄱ","ㄲ","ㄴ","ㄷ","ㄸ","ㄹ","ㅁ","ㅂ","ㅃ","ㅅ","ㅆ","ㅇ","ㅈ","ㅉ","ㅊ","ㅋ","ㅌ","ㅍ","ㅎ"];
	  
	  // result에 추가하기 위한 빈 문자열 생성
	  var result = "";
	  
	  for(var i=0; i<text.length; i++) {
	    
	    //한글인 경우 인코딩
	    var code = text.charCodeAt(i)-44032;
	    
	    if(code>-1 && code<11172) {
	    	
	    	result += cs[Math.floor(code/588)];
	    
	    //한글을 제외한다면 깨질 일이 없으므로 그대로 저장
	    } else { 
	    	result += text.charAt(i);
	    }// end : if
	  }// end : for
	  
	  //return result;
	  $("#resChosung").val(result);	
	}// end : result 
	
</script>
</head>
<body>

초성을 추출할 텍스트를 입력하세요 : <input id="text">
<br>
<input type="button" value="결과" onclick="result();">
<input id="resChosung">


</body>
</html>