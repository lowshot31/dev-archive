import { LightningElement, api, wire, track } from 'lwc';
import getCaseFeed from '@salesforce/apex/PortalDashboardController.getCaseFeed';
import addFeedPost from '@salesforce/apex/PortalDashboardController.addFeedPost';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';
import USER_ID from '@salesforce/user/Id';

export default class PortalCaseDetail extends LightningElement {
    @api caseId;
    @api caseSubject;
    @api caseStatus;
    @api caseNumber;
    @api casePriority;
    @api caseCreatedDate;

    @track comments = [];
    @track newComment = '';
    @track isLoading = true;
    wiredCommentsResult;

    currentUserId = USER_ID;

    @wire(getCaseFeed, { caseId: '$caseId' })
    wiredComments(result) {
        this.wiredCommentsResult = result;
        const { data, error } = result;
        if (data) {
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
        } else if (error) {
            console.error('Error fetching feed', error);
            this.isLoading = false;
        }
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

        this.isLoading = true;
        addFeedPost({ caseId: this.caseId, body: this.newComment })
            .then(() => {
                this.newComment = '';
                return refreshApex(this.wiredCommentsResult);
            })
            .catch(error => {
                console.error('Error adding post', error);
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error',
                        message: 'Failed to add message',
                        variant: 'error'
                    })
                );
            })
            .finally(() => {
                this.isLoading = false;
            });
    }

    handleBack() {
        this.dispatchEvent(new CustomEvent('back'));
    }
}
