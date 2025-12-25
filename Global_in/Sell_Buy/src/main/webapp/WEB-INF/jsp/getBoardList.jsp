<%-- FILE START --%>
<%-- FILE PATH: src\main\webapp\WEB-INF\jsp\getBoardList.jsp --%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>게시글 목록</title>
    <link rel="stylesheet" href="<c:url value='/style/common.css'/>">
    <link rel="stylesheet" href="<c:url value='/style/board.css'/>">
    <script src="<c:url value="/webjars/jquery/3.7.1/dist/jquery.js"/>"></script>
    <script src="<c:url value='/script/board.js'/>"></script>
            <link href="https://fonts.googleapis.com/earlyaccess/jejuhallasan.css" rel="stylesheet">
</head>
<body>
<div id="wrap">
    <%@include file="/WEB-INF/jsp/include/header.jsp" %>
    <div class="content">
        <div class="main-container">
            <div class="board-container">
                <h1>게시글 목록</h1>
                <form id="searchForm" class="search-form">
                    <select id="searchCondition" name="searchCondition">
                        <c:forEach items="${conditionMap}" var="condition">
                            <option value="${condition.value}" ${param.searchCondition == condition.value ? 'selected' : ''}>${condition.key}</option>
                        </c:forEach>
                    </select>
                    <input type="text" id="searchKeyword" name="searchKeyword" value="${param.searchKeyword}" placeholder="검색어를 입력하세요">
                    <button type="submit">검색</button>
                </form>
                <table class="board-table">
                    <thead>
                    <tr>
                        <th>글 번호</th>
                        <th>제목</th>
                        <th>작성자 ID</th>
                        <th>작성일</th>
                        <th>수정일</th>
                        <th>기능</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach items="${boardList}" var="board">
                        <tr>
                            <td>${board.noticId}</td>
                            <td><a href="/board/getBoard.do?noticId=${board.noticId}">${board.title}</a></td>
                            <td>${board.uploaderId}</td>
                             <td>${board.createDate}</td>
                            <td>${board.updateDate}</td>
                            <td>
                                <a href="/board/updateBoardView.do?noticId=${board.noticId}" class="btn">수정</a>
                                <a href="#" class="btn delete-btn" data-noticid="${board.noticId}">삭제</a>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
                 <a href="/board/insertBoardView.do" class="btn">글 등록</a>
            </div>
        </div>
    </div>
    <%@include file="/WEB-INF/jsp/include/footer.jsp" %>
</div>
</body>
</html>
<%-- FILE END --%>