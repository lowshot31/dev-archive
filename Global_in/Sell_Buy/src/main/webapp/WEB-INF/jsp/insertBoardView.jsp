<%-- FILE START --%>
<%-- FILE PATH: src\main\webapp\WEB-INF\jsp\insertBoardView.jsp --%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %> <%-- Spring Security taglib 추가 --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>게시글 등록</title>
    <link rel="stylesheet" href="<c:url value='/style/common.css'/>">
    <link rel="stylesheet" href="<c:url value='/style/board.css'/>">
    <link href="https://fonts.googleapis.com/earlyaccess/jejuhallasan.css" rel="stylesheet">
</head>
<body>
<div id="wrap">
    <%@include file="/WEB-INF/jsp/include/header.jsp" %>
    <div class="content">
        <div class="main-container">
            <div class="board-container">
                <h1>게시글 등록</h1>
                <sec:authorize access="isAnonymous()"> <%-- 로그인되지 않은 사용자 --%>
                    <p style="color: red;">로그인 후 게시글을 작성할 수 있습니다.</p>
                    <a href="/member/login" class="btn">로그인 페이지로 이동</a>
                </sec:authorize>
                <sec:authorize access="isAuthenticated()"> <%-- 로그인된 사용자 --%>
                    <form action="/board/insertBoard.do" method="post" class="board-form">
                        <label> 닉네임: <sec:authentication
                                property="principal.nickname"/> </label> <%-- Spring Security taglib 사용 --%>
                        <label for="title">제목:</label>
                        <input type="text" id="title" name="title" required>
                        <label for="content">내용:</label>
                        <textarea id="content" name="content" required></textarea>
                        <button type="submit">등록</button>
                        <a href="/board/getBoardList.do" class="btn">취소</a>
                    </form>
                </sec:authorize>
            </div>
        </div>
    </div>
    <%@include file="/WEB-INF/jsp/include/footer.jsp" %>
</div>
</body>
</html>
<%-- FILE END --%>