$(function () {
    adjustCategoryHeight()
    $(window).on('resize', adjustCategoryHeight);

    function adjustCategoryHeight() {
        // `.main-container` 의 외부 높이를 가져와서 `.category` 의 `max-height` 로 설정하는 함수 (기존 함수와 동일)
        const mainContainerHeight = $('.main-container').outerHeight();
        $('.category').css('max-height', mainContainerHeight + 'px');
    }

    // MutationObserver 를 사용하여 `.main-container` 내용 변경 감지 및 높이 조정 (새로운 코드 추가!)
    const mainContainerObserver = new MutationObserver(adjustCategoryHeight);
    const mainContainer = document.querySelector('.main-container');
    if (mainContainer) {
        mainContainerObserver.observe(mainContainer, {childList: true, subtree: true,});
    }

    $.get("/categories")
        .done(function (data) {
            let categoryNav = $('.category');
            categoryNav.empty(); // Clear any existing content

            // Sort categories alphabetically by name
            data.sort(function (a, b) {
                return a.name.localeCompare(b.name);
            });

            data.forEach(function (category) {
                let categoryItem = $('<div>').addClass('category-item');
                let categoryLink = $('<a>').attr('href', 'http://localhost/prod/list?catId=' + category.catId).text(category.name);
                categoryItem.append(categoryLink);
                categoryNav.append(categoryItem);
            });
        })
        .fail(function (jqXHR, textStatus, errorThrown) {
            console.error("Error fetching categories:", textStatus, errorThrown);
        });
});

function loadCategories(catId) {
    if (catId === undefined) {
        $.get('/categories')
            .done(function (data) {
                let categoryNav = $('#category-dep1');
                categoryNav.empty();
                data.sort(function (a, b) {
                    return a.name.localeCompare(b.name);
                });
                data.forEach(function (category) {
                    let categoryItem = $('<li>').addClass('category-item')
                        .attr('catId', category.catId)
                        .on('click', function () {
                            $(this).siblings().removeClass('selected');
                            $(this).addClass('selected');
                            loadCategories(category.catId);
                            $('#category-dep2').empty();
                            $('#category-dep3').empty();
                            $('#category').val('');
                        });
                    let categoryBtn = $('<button>').addClass('category-btn').attr('type', 'button');
                    let categoryName = $('<p>').text(category.name);
                    categoryItem.append(categoryBtn);
                    categoryBtn.append(categoryName);
                    categoryNav.append(categoryItem);
                });
                adjustCategoryHeight(); // AJAX 로 카테고리 목록 로딩 후 높이 조정 (기존 코드 유지)
            });
    } else {
        $.get('/categories', {catId: catId})
            .done(function (data) {
                let categoryNav;
                if (catId < 100) {
                    categoryNav = $('#category-dep2');
                    $('#category-dep3').empty();
                    $('#category').val('');
                } else if (catId < 10000) {
                    categoryNav = $('#category-dep3');
                }
                categoryNav.empty();
                data.sort(function (a, b) {
                    return a.name.localeCompare(b.name);
                });
                data.forEach(function (category) {
                    let categoryItem = $('<li>').addClass('category-item')
                        .attr('catId', category.catId)
                        .on('click', function () {
                            $(this).siblings().removeClass('selected');
                            $(this).addClass('selected');
                            if (categoryNav.is($('#category-dep3'))) {
                                $('#category').val(category.catId);
                            } else {
                                loadCategories(category.catId);
                                $('#category').val('');
                            }
                        });
                    let categoryBtn = $('<button>').addClass('category-btn').attr('type', 'button');
                    let categoryName = $('<p>').text(category.name);
                    categoryItem.append(categoryBtn);
                    categoryBtn.append(categoryName);
                    categoryNav.append(categoryItem);
                });
                adjustCategoryHeight(); // AJAX 로 카테고리 목록 로딩 후 높이 조정 (기존 코드 유지)
            });
    }
}