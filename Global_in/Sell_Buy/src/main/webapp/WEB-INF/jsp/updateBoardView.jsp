<%-- FILE START --%>
<%-- FILE PATH: src\main\webapp\WEB-INF\jsp\ updateBoardView.jsp --%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>게시글 수정</title>
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
                <h1>게시글 수정</h1>
                <form action="/board/updateBoard.do" method="post" class="board-form">
                    <input type="hidden" name="noticId" value="${board.noticId}"/>
                    <label for="uploaderId">작성자 ID:</label>
                    <input type="text" id="uploaderId" name="uploaderId" value="${board.uploaderId}" required>
                    <label for="title">제목:</label>
                    <input type="text" id="title" name="title" value="${board.title}" required>
                    <label for="content">내용:</label>
                    <textarea id="content" name="content" required>${board.content}</textarea>
                    <button type="submit">수정</button>
                    <a href="/board/getBoardList.do" class="btn">취소</a>
                </form>
            </div>
        </div>
    </div>
    <%@include file="/WEB-INF/jsp/include/footer.jsp" %>
</div>
</body>
</html>
<%-- FILE END --%>