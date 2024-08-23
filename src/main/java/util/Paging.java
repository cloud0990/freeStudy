package util;

public class Paging {
	public static String getPaging(String pageURL, int nowPage, int rowTotal,int blockList, int blockPage){
		
		int totalPage, startPage, endPage;

		boolean isPrevPage, isNextPage;
		
		StringBuffer sb;
		
		isPrevPage=isNextPage=false;

		totalPage = (int)(rowTotal/blockList);

		if(rowTotal%blockList!=0) totalPage++;

		if(nowPage > totalPage) nowPage = totalPage;

		startPage = (int)(((nowPage-1)/blockPage)*blockPage+1);
		endPage = startPage + blockPage - 1;
		
		if(endPage > totalPage)endPage = totalPage;
		
		if(endPage < totalPage) isNextPage = true;

		if(startPage > 1)isPrevPage = true;
		
		sb = new StringBuffer();

		if(isPrevPage){
			sb.append("<a href ='"+pageURL+"?page=");
			sb.append(startPage-1);
			sb.append("'>◀</a>");
		} else {
			sb.append("◀");
		}

		for(int i=startPage; i<= endPage ;i++){
			if(i>totalPage)break;
			if(i == nowPage){
				sb.append("&nbsp;<b><font color='red'>");
				sb.append("<span class='num_box'>");
				sb.append(i);
				sb.append("</span>");
				sb.append("</font></b>");
			}else {
				sb.append("&nbsp;<a href='"+pageURL+"?page=");
				sb.append(i);
				sb.append("'>");
				sb.append("<span class='num_box'>");
				sb.append(i);
				sb.append("</span>");	
				sb.append("</a>");
			}
		}

		sb.append("&nbsp;");
		
		if(isNextPage){
			sb.append("<a href='"+pageURL+"?page=");
			sb.append(endPage+1);
			sb.append("'>▶</a>");
		} else {
			sb.append("▶");
		}

		return sb.toString();
	}
	
	public static String getPaging(String pageURL, String search_filter, int nowPage, int rowTotal,int blockList, int blockPage){
		
		int totalPage, startPage, endPage;

		boolean isPrevPage, isNextPage;
		
		StringBuffer sb;
		
		isPrevPage=isNextPage=false;

		totalPage = (int)(rowTotal/blockList);

		if(rowTotal%blockList!=0) totalPage++;

		if(nowPage > totalPage) nowPage = totalPage;
		
		startPage = (int)(((nowPage-1)/blockPage)*blockPage+1);
		endPage = startPage + blockPage - 1;
		
		if(endPage > totalPage)endPage = totalPage;
		
		if(endPage < totalPage) isNextPage = true;

		if(startPage > 1)isPrevPage = true;
		
		sb = new StringBuffer();

		if(isPrevPage){
			sb.append("<a href ='"+pageURL+"?page=");
			sb.append(startPage-1);
			sb.append("&");
			sb.append(search_filter);
			sb.append("'>◀</a>");
		} else {
			sb.append("◀");
		}

		for(int i=startPage; i<= endPage ;i++){
			if(i>totalPage)break;
			if(i == nowPage) {
				sb.append("&nbsp;<b><font color='yellow'>");
				sb.append("<span class='num_box'>");
				sb.append(i);
				sb.append("</span>");
				sb.append("</font></b>");
			}else {
				sb.append("&nbsp;<a href='"+pageURL+"?page=");
				sb.append(i);
				sb.append("&");
				sb.append(search_filter);
				sb.append("'>");
				sb.append("<span class='num_box'>");
				sb.append(i);
				sb.append("</span>");	
				sb.append("</a>");
			}
		}
		
		sb.append("&nbsp;");

		if(isNextPage){
			sb.append("<a href='"+pageURL+"?page=");
			sb.append(endPage+1);
			sb.append("&");
			sb.append(search_filter);
			sb.append("'>▶</a>");
		} else {
			sb.append("▶");
		}

		return sb.toString();
	}

	public static String getCommentPaging(int nowPage, int rowTotal,int blockList, int blockPage) {
		
		int totalPage, startPage, endPage;

		boolean isPrevPage, isNextPage;
		
		StringBuffer sb;
		
		isPrevPage=isNextPage=false;

		totalPage = (int)(rowTotal/blockList);

		if(rowTotal%blockList!=0)totalPage++;

		if(nowPage > totalPage)nowPage = totalPage;
		
		startPage = (int)(((nowPage-1)/blockPage)*blockPage+1);
		endPage = startPage + blockPage - 1;
		
		if(endPage > totalPage)endPage = totalPage;
		
		if(endPage < totalPage) isNextPage = true;

		if(startPage > 1)isPrevPage = true;
		
		sb = new StringBuffer();

		if(isPrevPage){
			sb.append("<span class='num_box'>");
			sb.append(String.format("<a href=\'#comment_page\' onclick=\'comment_list(%d);\'>%d</a>", startPage-1, startPage-1));
			sb.append("</span>");
		} else {
			sb.append("◀");
		}

		for(int i=startPage; i<= endPage ;i++) {
			if(i>totalPage)break;
			if(i == nowPage){
				sb.append("<span class='num_box'>");
				sb.append(String.format("<a href=\'#comment_page\' onclick=\'comment_list(%d);\'><font color='red'>%d</font></a>", nowPage, nowPage));
				sb.append("</span>");
				sb.append("&nbsp;&nbsp;");
			}else {
				sb.append("<span class='num_box'>");
				sb.append(String.format("<a href=\'#comment_page\' onclick=\'comment_list(%d);\'>%d</a>", i, i));
				sb.append("</span>");
				sb.append("&nbsp;&nbsp;");
			}
		}
		
		if(isNextPage){
			sb.append("<span class='num_box'>");
			sb.append(String.format("<a href=\'#comment_page\' onclick=\'comment_list(%d);\'>%d</a>", endPage-1, endPage-1));
			sb.append("</span>");
		} else {
			sb.append("▶");
		}

		return sb.toString();
	}	
}