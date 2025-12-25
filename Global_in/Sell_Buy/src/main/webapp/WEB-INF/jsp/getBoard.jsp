<%-- FILE START --%>
<%-- FILE PATH: src\main\webapp\WEB-INF\jsp\getBoard.jsp --%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>게시글 상세</title>
    <link rel="stylesheet" href="<c:url value='/style/common.css'/>">
    <link rel="stylesheet" href="<c:url value='/style/board.css'/>">
    <link href="https://fonts.googleapis.com/earlyaccess/jejuhallasan.css" rel="stylesheet">
</head>
<body>
<div id="wrap">
    <%@include file="/WEB-INF/jsp/include/header.jsp" %>
    <div class="content">
        <div class="main-container">
            <div class="board-detail">
                <h2>게시글 상세</h2>
                <div class="detail-item">
                    <strong>제목:</strong>
                    <p>${board.title}</p>
                </div>
                <div class="detail-item">
                    <strong>작성자 ID:</strong>
                    <p>${board.uploaderId}</p>
                </div>
                <div class="detail-item">
                    <strong>내용:</strong>
                    <p>${board.content}</p>
                </div>
                <div class="detail-item">
                    <strong>작성일:</strong>
                    <p>${board.createDate}</p>
                </div>
                <div class="detail-item">
                    <strong>수정일:</strong>
                    <p>${board.updateDate}</p>
                </div>
                <a href="/board/getBoardList.do" class="btn">목록</a>
                <a href="/board/updateBoardView.do?noticId=${board.noticId}" class="btn">수정</a>
            </div>
        </div>
    </div>
    <%@include file="/WEB-INF/jsp/include/footer.jsp" %>
</div>
</body>
</html>
<%-- FILE END --%>