import { LightningElement, api, track, wire } from 'lwc';
import getCaseFeed from '@salesforce/apex/PortalDashboardController.getCaseFeed';
import addFeedPost from '@salesforce/apex/PortalDashboardController.addFeedPost';
import uploadFiles from '@salesforce/apex/PortalDashboardController.uploadFiles';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import USER_ID from '@salesforce/user/Id';

export default class PortalCaseDetail extends LightningElement {
    @api caseId;
    @api caseSubject;
    @api caseStatus;
    @api caseNumber;
    @api casePriority;
    @api caseCreatedDate;
    @api caseDescription;
    @api caseIssueDate;
    @api caseProduct;
    @api caseOwner;

    @track comments = [];
    @track newComment = '';
    @track isLoading = true;
    @track selectedFiles = [];
    @track isProcessing = false;

    currentUserId = USER_ID;

    handleFileSelection(event) {
        const files = Array.from(event.target.files);
        this.selectedFiles = files.map(f => ({
            file: f,
            name: f.name,
            sizeKB: (f.size / 1024).toFixed(1)
        }));
    }

    get isUploadDisabled() {
        return this.selectedFiles.length === 0 || this.isProcessing;
    }

    async uploadFilesManual() {
        if (this.selectedFiles.length === 0) return;
        
        this.isProcessing = true;
        let successCount = 0;
        
        for (const f of this.selectedFiles) {
            try {
                const base64 = await this.readFileAsBase64(f.file);
                await uploadFiles({ 
                    recordId: this.caseId, 
                    files: [{ fileName: f.name, base64Data: base64 }] 
                });
                successCount++;
            } catch (err) {
                console.error('File Upload Fail:', err);
                this.showToast('실패', f.name + ' 전송 실패: ' + (err.body ? err.body.message : err.message), 'error');
            }
        }
        
        if (successCount > 0) {
            this.showToast('성공', `${successCount}개의 파일이 전송되었습니다.`, 'success');
            this.selectedFiles = [];
            this.loadComments(); // Refresh feed to show historical record if any
        }
        this.isProcessing = false;
    }

    readFileAsBase64(file) {
        return new Promise((resolve, reject) => {
            const reader = new FileReader();
            reader.onload = () => resolve(reader.result.split(',')[1]);
            reader.onerror = error => reject(error);
            reader.readAsDataURL(file);
        });
    }

    showToast(title, message, variant) {
        this.dispatchEvent(new ShowToastEvent({ title, message, variant }));
    }

    connectedCallback() {
        this.loadComments();
    }

    loadComments() {
        this.isLoading = true;
        getCaseFeed({ caseId: this.caseId })
            .then(data => {
                this.comments = data.map(item => {
                    const isMe = item.authorId === this.currentUserId;
                    return {
                        Id: item.id,
                        CommentBody: item.body,
                        authorName: item.authorName,
                        cssClass: isMe ? 'feed-item outbound' : 'feed-item inbound',
                        formattedDate: new Date(item.createdDate).toLocaleString()
                    };
                });
                this.isLoading = false;
            })
            .catch(error => {
                console.error('Error fetching feed:', error);
                this.isLoading = false;
            });
    }

    get isClosed() {
        return this.caseStatus === 'Closed';
    }

    get hasNoComments() {
        return !this.isLoading && this.comments.length === 0;
    }

    handleCommentChange(event) {
        this.newComment = event.target.value;
    }

    handleAddComment() {
        if (!this.newComment || !this.newComment.trim()) return;

        const commentText = this.newComment;
        this.isLoading = true;
        this.newComment = ''; 
        
        addFeedPost({ caseId: this.caseId, body: commentText })
            .then(() => {
                this.showToast('Success', 'Comment added successfully', 'success');
                return this.loadComments();
            })
            .catch(error => {
                console.error('Error adding comment:', error);
                this.newComment = commentText;
                this.showToast('Error', error.body ? error.body.message : 'Failed to add message', 'error');
            })
            .finally(() => {
                this.isLoading = false;
            });
    }

    handleBack() {
        this.dispatchEvent(new CustomEvent('back'));
    }
}
