import { LightningElement, track } from 'lwc';
import { loadScript } from 'lightning/platformResourceLoader';
import DaumPostCode from '@salesforce/resourceUrl/DaumPostCode'; // Static Resource 이름!

export default class GuestInquiryForm extends LightningElement {
    // @track address = '';
    isScriptLoaded = false;
    // // 1. 화면 켜지자마자 로드 시도
    // renderedCallback() {
    //     if (this.isScriptLoaded) return;
    //     loadScript(this, DaumPostCode)
    //         .then(() => {
    //             console.log('✅ 스크립트 로드 성공');
    //             this.isScriptLoaded = true;
    //         })
    //         .catch(error => {
    //             console.error('❌ 스크립트 로드 실패:', error);
    //         });
    // }

    // 2. 버튼 클릭 시 실행
    // handleSearch() {
    //     // 로드 확인
    //     if (!this.isScriptLoaded) {
    //         alert('주소 기능을 불러오는 중입니다. 잠시 후 다시 눌러주세요.');
    //         return;
    //     }

    //     // 팝업 열기
    //     try {
    //         new window.daum.Postcode({
    //             oncomplete: (data) => {
    //                 console.log('선택된 주소:', data);
    //                 // 주소 넣기
    //                 // this.address = data.userSelectedType === 'R' ? data.roadAddress : data.jibunAddress;
    //             }
    //         }).open();
    //     }  catch (error) {
    //         // ⭐ 이렇게 해야 진짜 에러 메시지가 보입니다!
    //         console.error("🔥 진짜 에러 내용:", error.message);
    //         console.error("상세 에러:", JSON.parse(JSON.stringify(error)));
            
    //         this.showToast('오류', '팝업 실행 실패: ' + error.message, 'error');
    //     }
    // }
}