<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>   
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<script src="${pageContext.request.contextPath}/resources/js/jquery-3.6.0.min.js"></script>
<c:set var="serviceHistoryList" value="${pagingVO.dataList }"/>
<style>
@import url('https://fonts.googleapis.com/css2?family=IBM+Plex+Sans+KR&display=swap');
td{
	font-family: 'IBM Plex Sans KR', sans-serif;
	text-align : center;
}
th{
	font-family: 'IBM Plex Sans KR', sans-serif;
	text-align : center;
}
a{
	font-family: 'IBM Plex Sans KR', sans-serif;
}
</style>
<div class="card mb-3" style="padding:1%;  font-family: 'IBM Plex Sans KR', sans-serif; text-align:center;">
<br>
<h1 style="font-family: 'IBM Plex Sans KR', sans-serif; font-weight:bold; text-align:left; font-size: 30px;"><span class="fas fa-caret-right"></span>&nbsp;그룹웨어 사용자 목록</h1>
<hr>
<span style="text-align: left;">그룹웨어를 구매한 기업들의 서비스 현황을 확인합니다.</span>
<br>
<table class="table table-hover">
	<thead class="">
		<tr>
			<th>순번</th>
			<th>회사코드</th>
			<th>사원수</th>
			<th>서비스 이용기간</th>
			<th>서비스 명</th>
		</tr>
	</thead>
	<tbody id="listBody">
	</tbody>
</table>
	<form id="searchForm">
		<input type="hidden" name="page" />
		<input type="hidden" name="searchType" />
		<input type="hidden" name="searchWord" />
	</form>
	<div class="pagingArea">
	</div>
	<!-- (제목-title, 작성자-writer, 내용-content, 전체) -->
	<div id="searchUI" class="row g-3 justify-content-center">
		<div class="col-auto">
			<select name="searchType" class="form-control">
				<option value>전체</option>
				<option value="title" 
				>회사코드</option>
			</select>
		</div>
		<div class="col-auto">
			<input type="text" name="searchWord" placeholder="검색키워드"
				class="form-control" value=""
			/>
		</div>
		<div class="col-auto">
			<input type="button" value="검색" id="searchBtn"
				class="btn btn-outline-secondary me-1 mb-1"
			style="font-family: 'IBM Plex Sans KR', sans-serif; font-weight:bold"/>
		</div>
	</div>
</div>
<script type="text/javascript">
	let searchUI = $("#searchUI").on("click", "#searchBtn", function(event){
		let inputTags = searchUI.find(":input[name]");
		$.each(inputTags, function(index, inputTag){
			let name = $(this).attr("name");
			let value = $(this).val();
			searchForm.get(0)[name].value = value;
		});
		searchForm.submit();
	});
	let pageTag = $("[name=page]");
	let listBody = $("#listBody");
	let pagingArea = $(".pagingArea").on("click", "a", function(event){
		event.preventDefault();
		let page = $(this).data("page");
		if(!page) return false;
		pageTag.val(page);
		searchForm.submit();
		return false;
	});
	
	let makeTrTag = function(serviceHistory){
		let tr = $("<tr>");
		let aTag = $("<a style='font-family: 'IBM Plex Sans KR', sans-serif;'>").attr("href", "${pageContext.request.contextPath}/management/wareservice/serviceHistoryView.do?what="+serviceHistory.comCode)
							.text(serviceHistory.comCode);
		tr.append(
			$("<td>").html(serviceHistory.rnum)
			, $("<td>").html(aTag)
			, $("<td>").html(serviceHistory.serEmp)
			, $("<td>").html(serviceHistory.serPeri)
			, $("<td>").html(serviceHistory.serName)
		);
		
		return tr;
	}
	
	let searchForm = $("#searchForm").on("submit", function(event){
		event.preventDefault();
		let url = this.action;
		let method = this.method;
		let data = $(this).serialize();
		$.ajax({
			url : url,
			method : method,
			data : data,
			dataType : "json",
			success : function(pagingVO) {
				listBody.empty();
				console.log("pagingVO {}",pagingVO)
				pagingArea.empty();
				pageTag.val("");
				let serviceHistoryList = pagingVO.dataList;
				let trTags = [];
				if(serviceHistoryList.length > 0){
					$.each(serviceHistoryList, function(index, serviceHistory){
						let tr = makeTrTag(serviceHistory);
						trTags.push(tr);
					});
				}else{
					let tr = $("<tr>").html(
						$("<td>").attr("colspan", "6")
								 .html("조건에 맞는 검색이 아님.")
					);
					trTags.push(tr);
				}
				listBody.append(trTags);
				let pagingHTML = pagingVO.pagingHTML;
				pagingArea.html(pagingHTML);
			},
			error : function(errorResp) {
				console.log(errorResp.status);
			}
		});
		return false;
	}).submit();
</script>