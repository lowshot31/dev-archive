import { LightningElement, api, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import uploadFiles from '@salesforce/apex/PortalDashboardController.uploadFiles';

export default class PortalNewCaseForm extends LightningElement {
    @api accountId;
    @track selectedFiles = [];
    @track isLoading = false;

    // Handle file selection
    handleFileChange(event) {
        const files = event.target.files;
        if (files.length > 0) {
            Array.from(files).forEach(file => {
                const reader = new FileReader();
                reader.onload = () => {
                    const base64 = reader.result.split(',')[1];
                    this.selectedFiles = [...this.selectedFiles, {
                        fileName: file.name,
                        base64Data: base64,
                        name: file.name,
                        sizeText: (file.size / 1024).toFixed(1) + ' KB'
                    }];
                };
                reader.readAsDataURL(file);
            });
        }
    }

    handleSubmit(event) {
        event.preventDefault();
        this.isLoading = true;
        const fields = event.detail.fields;
        // 필수 필드 값 고정 (히든 설정)
        fields.AccountId = this.accountId;
        fields.Origin = 'Web'; // 사례 출처를 'Web'으로 고정
        fields.Status = 'New'; // 상태를 'New'로 고정

        this.template.querySelector('lightning-record-edit-form').submit(fields);
    }

    async handleSuccess(event) {
        const newCaseId = event.detail.id;

        // If files are selected, upload them
        if (this.selectedFiles.length > 0) {
            try {
                const filesToUpload = this.selectedFiles.map(f => ({
                    fileName: f.fileName,
                    base64Data: f.base64Data
                }));
                await uploadFiles({ recordId: newCaseId, files: filesToUpload });
                this.showToast('성공', '케이스와 첨부파일이 정상적으로 접수되었습니다.', 'success');
            } catch (error) {
                console.error('File Upload Error:', error);
                const errorMsg = error.body ? error.body.message : error.message;
                this.showToast('파일 업로드 실패', '케이스는 생성되었으나 파일 업로드 중 오류가 발생했습니다: ' + errorMsg, 'error');
            }
        } else {
            this.showToast('성공', '케이스가 정상적으로 접수되었습니다.', 'success');
        }

        this.isLoading = false;
        this.dispatchEvent(new CustomEvent('success', {
            detail: { id: newCaseId }
        }));
    }

    handleError(error) {
        this.isLoading = false;
        this.showToast('오류', '문의 접수 중 오류가 발생했습니다.', 'error');
        console.error(error);
    }

    handleCancel() {
        this.dispatchEvent(new CustomEvent('cancel'));
    }

    showToast(title, message, variant) {
        this.dispatchEvent(new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        }));
    }
}
