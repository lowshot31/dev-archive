import { LightningElement, api, track, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import USER_ID from '@salesforce/user/Id';
import createCase from '@salesforce/apex/PortalDashboardController.createCase';
import getActiveContracts from '@salesforce/apex/PortalDashboardController.getActiveContracts';
import getPricebookProducts from '@salesforce/apex/PortalDashboardController.getPricebookProducts';

export default class PortalNewCaseForm extends LightningElement {
    @api accountId;
    @track subject = '';
    @track reason = '';
    @track description = '';
    @track issueDate = '';
    @track selectedProductId = '';
    @track isLoading = false;
    @track productOptions = [];
    
    // File Management
    @track uploadedFileIds = [];
    @track uploadedFiles = [];
    currentUserId = USER_ID;

    _contractId;

    reasonOptions = [
        { label: '배송 지연', value: 'Delivery_Delay' },
        { label: '수량 부족', value: 'Insufficient_Quantity' },
        { label: '제품 품질', value: 'Product_Quality' }, 
        { label: '서류·계약 관련 문의', value: 'Contract_Document_Inquiry' },
        { label: '기타', value: 'Other' }
    ];

    get acceptedFormats() {
        return ['.pdf', '.png', '.jpg', '.jpeg', '.docx', '.xlsx'];
    }

    @wire(getActiveContracts, { accountId: '$accountId' })
    wiredContracts({ error, data }) {
        if (data && data.length > 0) {
            this._contractId = data[0].Id;
        } else if (error) {
            console.error('Error fetching contracts:', error);
        }
    }

    @wire(getPricebookProducts, { contractId: '$_contractId' })
    wiredProducts({ error, data }) {
        if (data) {
            this.productOptions = data.map(item => ({
                label: item.Product2.Name,
                value: item.Product2Id
            }));
        } else if (error) {
            console.error('Error fetching products:', error);
        }
    }

    handleSubjectChange(event) {
        this.subject = event.target.value;
    }

    handleReasonChange(event) {
        this.reason = event.target.value;
    }

    handleDescriptionChange(event) {
        this.description = event.target.value;
    }

    handleIssueDateChange(event) {
        this.issueDate = event.target.value;
    }

    handleProductChange(event) {
        this.selectedProductId = event.target.value;
    }

    // High Performance Upload Handler (Links to User record first to guarantee success)
    handleUploadFinished(event) {
        const files = event.detail.files;
        if (files && files.length > 0) {
            files.forEach(file => {
                this.uploadedFileIds = [...this.uploadedFileIds, file.documentId];
                this.uploadedFiles = [...this.uploadedFiles, {
                    name: file.name,
                    id: file.documentId
                }];
            });
            this.showToast('성공', `${files.length}개의 파일이 준비되었습니다.`, 'success');
        }
    }

    async handleSubmit() {
        // Validation
        if (!this.subject || !this.description) {
            this.showToast('오류', '제목과 상세 내용은 필수입니다.', 'error');
            return;
        }

        this.isLoading = true;
        try {
            // Create Case and Link Files in ONE transaction
            const result = await createCase({
                accountId: this.accountId,
                subject: this.subject,
                priority: 'Medium',
                reason: this.reason,
                description: this.description,
                issueDate: this.issueDate,
                relatedProductId: this.selectedProductId,
                fileIds: this.uploadedFileIds
            });

            this.showToast('성공', `문의가 접수되었습니다. (번호: ${result.CaseNumber})`, 'success');
            
            // Dispatch success to parent (Dashboard) to close the form and refresh list
            this.dispatchEvent(new CustomEvent('success', {
                detail: { id: result.Id }
            }));
        } catch (error) {
            console.error('Submission Error:', error);
            const errorMsg = error.body ? error.body.message : error.message;
            this.showToast('접수 실패', '처리에 실패했습니다: ' + errorMsg, 'error');
        } finally {
            this.isLoading = false;
        }
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
