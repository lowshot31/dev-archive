/* slider.js */
$(document).ready(function () {
    const sliderWrapper = $('.slider-wrapper');
    const slides = $('.slides');
    const slide = $('.slide');
    const prevButton = $('.prev-slide');
    const nextButton = $('.next-slide');
    const slideIndicators = $('.slide-indicators');
    const slideIndicator = $('.slide-indicator');

    let slideIndex = 0;
    const slideCount = slide.length;
    const slideWidth = $('.slider-container').width(); // 컨테이너 너비 사용

    slides.width(slideWidth * slideCount); // slides 전체 너비 설정
    slide.width(slideWidth); // slide 개별 너비 설정

    function updateSlider() {
        slides.css('transform', `translateX(-${slideWidth * slideIndex}px)`);
        updateIndicators();
    }

    function updateIndicators() {
        slideIndicator.removeClass('active');
        slideIndicators.children().eq(slideIndex).addClass('active');
    }

    prevButton.on('click', function () {
        slideIndex = (slideIndex - 1 + slideCount) % slideCount;
        updateSlider();
    });

    nextButton.on('click', function () {
        slideIndex = (slideIndex + 1) % slideCount;
        updateSlider();
    });

    slideIndicators.on('click', '.slide-indicator', function () {
        slideIndex = $(this).data('slide');
        updateSlider();
    });

    updateIndicators(); // 초기 인디케이터 활성화
});