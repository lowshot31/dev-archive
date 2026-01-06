import { LightningElement, api, track, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import createCase from '@salesforce/apex/PortalDashboardController.createCase';
import uploadFiles from '@salesforce/apex/PortalDashboardController.uploadFiles';
import getPricebookProducts from '@salesforce/apex/PortalDashboardController.getPricebookProducts';
import getActiveContracts from '@salesforce/apex/PortalDashboardController.getActiveContracts';

export default class PortalNewCaseForm extends LightningElement {
    @api accountId;
    @track subject = '';
    @track reason = '';
    @track description = '';
    @track issueDate = '';
    @track selectedProductId = '';
    @track selectedFiles = [];
    @track isLoading = false;
    @track productOptions = [];
    
    _contractId;

    reasonOptions = [
        { label: '제품 문의', value: '제품 문의' },
        { label: '기술 지원', value: '기술 지원' },
        { label: '배송 문의', value: '배송 문의' },
        { label: '기타', value: '기타' }
    ];

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

    async handleSubmit() {
        // Validation
        if (!this.subject || !this.description) {
            this.showToast('오류', '필수 항목을 입력해주세요.', 'error');
            return;
        }

        this.isLoading = true;
        try {
            const newCase = await createCase({
                accountId: this.accountId,
                subject: this.subject,
                priority: 'Medium', // Default priority
                reason: this.reason,
                description: this.description,
                issueDate: this.issueDate,
                relatedProductId: this.selectedProductId
            });

            // Upload files if any - Sequentially to avoid payload limits
            if (this.selectedFiles.length > 0) {
                for (const file of this.selectedFiles) {
                    try {
                        const fileArray = [{
                            fileName: file.fileName,
                            base64Data: file.base64Data
                        }];
                        // Call uploadFiles for each file to stay within request size limits
                        await uploadFiles({ recordId: newCase.Id, files: fileArray });
                    } catch (error) {
                        console.error('File Upload Individual Error:', error);
                        // Show a more specific error from Apex if available
                        const msg = error.body ? error.body.message : error.message;
                        this.showToast('파일 업로드 실패', `${file.fileName}: ${msg}`, 'error');
                    }
                }
            }

            this.showToast('성공', '케이스가 정상적으로 접수되었습니다.', 'success');
            this.dispatchEvent(new CustomEvent('success', {
                detail: { id: newCase.Id }
            }));
        } catch (error) {
            console.error('Case Creation Error:', error);
            const errorMsg = error.body ? error.body.message : error.message;
            this.showToast('케이스 접수 실패', '케이스 접수 중 오류가 발생했습니다: ' + errorMsg, 'error');
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
