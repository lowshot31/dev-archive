// FILE START
// FILE PATH: src\main\resources\static\script\board.js
$(document).ready(function() {
    // 검색 폼 제출 처리
    $('#searchForm').submit(function(event) {
        event.preventDefault();
        var searchCondition = $('#searchCondition').val();
        var searchKeyword = $('#searchKeyword').val();
        window.location.href = '/board/getBoardList.do?searchCondition=' + searchCondition + '&searchKeyword=' + searchKeyword;
    });

    // 게시글 삭제 처리
    $('.delete-btn').click(function(event) {
        event.preventDefault();
        var noticId = $(this).data('noticid');
        if (confirm('정말로 삭제하시겠습니까?')) {
            window.location.href = '/board/deleteBoard.do?noticId=' + noticId;
        }
    });
});
// FILE END