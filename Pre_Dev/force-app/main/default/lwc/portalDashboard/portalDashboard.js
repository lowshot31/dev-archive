import { LightningElement, wire, track, api } from 'lwc';
import getRelatedRecords from '@salesforce/apex/PortalDashboardController.getRelatedRecords';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';
import { CurrentPageReference, NavigationMixin } from 'lightning/navigation';



const ORDER_COLUMNS = [
    { label: '주문번호', fieldName: 'OrderNumber', type: 'text' },
    { label: '주문상태', fieldName: 'Status', type: 'text' },
    { label: '총 금액', fieldName: 'TotalAmount', type: 'currency', typeAttributes: { currencyCode: 'KRW' } },
    { label: '배송현황', fieldName: 'Delivery_Staus__c', type: 'text' },
    { label: '주문일자', fieldName: 'CreatedDate', type: 'date' },
    { label: '주문내용', fieldName: 'Description', type: 'text' }
];

const CASE_COLUMNS = [
    { 
        label: '문의번호', 
        type: 'button', 
        typeAttributes: { 
            label: { fieldName: 'CaseNumber' }, 
            variant: 'base',
            name: 'view_case'
        } 
    },
    { label: '제목', fieldName: 'Subject', type: 'text' },
    { label: '상태', fieldName: 'Status', type: 'text' },
    { label: '우선순위', fieldName: 'Priority', type: 'text' },
    { label: '이슈발생일', fieldName: 'Issue_Date__c', type: 'date' },
    { label: '관련제품', fieldName: 'ProductName', type: 'text' },
    { label: '생성일', fieldName: 'CreatedDate', type: 'date' },
    { label: '첨부파일', fieldName: 'HasAttachment', type: 'text' }
];

const CONTRACT_COLUMNS = [
    { label: 'Contract Number', fieldName: 'ContractNumber', type: 'text' },
    { label: 'Status', fieldName: 'Status', type: 'text' },
    { label: 'Start Date', fieldName: 'StartDate', type: 'date' },
    { label: 'End Date', fieldName: 'EndDate', type: 'date' }
];

export default class PortalDashboard extends NavigationMixin(LightningElement) {
    @api recordId;
    
    // Pagination settings
    pageSize = 5;

    // Type: { data: [], currentPage: 1, totalPages: 1, visibleData: [] }
    @track orderState = this.initPaginationState();
    @track caseState = this.initPaginationState();
    @track contractState = this.initPaginationState();

    @track isLoading = true;
    @track showModal = false;
    @track showCaseModal = false;
    @track activeTab = 'overview'; // Default tab

    // View State
    @track viewMode = 'dashboard'; // 'dashboard' or 'case_detail'
    @track selectedCase = null;

    // Raw data for Overview tab
    @track orders = [];
    @track cases = [];
    @track contracts = [];

    get isDashboardView() {
        return this.viewMode === 'dashboard';
    }

    get isCaseDetailView() {
        return this.viewMode === 'case_detail';
    }

    get showNewOrderButton() {
        return this.isDashboardView && this.activeTab === 'orders';
    }

    get showNewCaseButton() {
        return this.isDashboardView && this.activeTab === 'cases';
    }

    get visibleOrdersSummary() {
        return this.orders ? this.orders.slice(0, 5).map(order => ({
            ...order,
            badgeClass: this.getOrderBadgeClass(order.Status),
            deliveryBadgeClass: this.getDeliveryBadgeClass(order.Delivery_Staus__c)
        })) : [];
    }

    get visibleCasesSummary() {
        return this.cases ? this.cases.slice(0, 5).map(caseItem => ({
            ...caseItem,
            badgeClass: this.getCaseBadgeClass(caseItem.Status)
        })) : [];
    }

    get visibleContractsSummary() {
        return this.contracts ? this.contracts.slice(0, 5).map(contract => ({
            ...contract,
            badgeClass: this.getContractBadgeClass(contract.Status)
        })) : [];
    }

    orderColumns = ORDER_COLUMNS;
    caseColumns = CASE_COLUMNS;
    contractColumns = CONTRACT_COLUMNS;

    // Badge color methods
    getOrderBadgeClass(status) {
        const statusMap = {
            'Requested': 'badge-orange',
            'Confirmed': 'badge-blue',
            'Delivered': 'badge-green'
        };
        return statusMap[status] || 'badge-gray';
    }

    getCaseBadgeClass(status) {
        const statusMap = {
            'New': 'badge-green',
            'Pending': 'badge-yellow',
            'Working': 'badge-blue',
            'Escalated': 'badge-red',
            'Closed': 'badge-gray'
        };
        return statusMap[status] || 'badge-gray';
    }

    getContractBadgeClass(status) {
        const statusMap = {
            'Draft': 'badge-gray',
            'Activated': 'badge-purple',
            '계약만료': 'badge-red'
        };
        return statusMap[status] || 'badge-gray';
    }

    getDeliveryBadgeClass(deliveryStatus) {
        const statusMap = {
            'Ready': 'badge-orange',        // 배송전
            'Delivered': 'badge-green'      // 배송완료
        };
        return statusMap[deliveryStatus] || 'badge-gray';
    }

    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
        if (currentPageReference) {
            // If tab is provided, set it. Defaults to overview.
            const tabParam = (currentPageReference.state.tab || 'overview').toLowerCase();
            if (['orders', 'cases', 'contracts', 'overview'].includes(tabParam)) {
                this.activeTab = tabParam;
            }
            // Always back to dashboard list when header links are clicked
            this.viewMode = 'dashboard';
            this.selectedCase = null;
        }
    }

    @wire(getRelatedRecords, { accountId: '$recordId' })
    wiredData(result) {
        this.wiredResult = result;
        const { data, error } = result;
        if (data) {
            // Transform orders to add badge classes
            this.orders = (data.orders || []).map(order => ({
                ...order,
                badgeClass: this.getOrderBadgeClass(order.Status),
                deliveryBadgeClass: this.getDeliveryBadgeClass(order.Delivery_Staus__c)
            }));
            
            // Transform cases to add computed fields and badge class
            this.cases = (data.cases || []).map(c => ({
                ...c,
                ProductName: c.Related_Product__r ? c.Related_Product__r.Name : '-',
                HasAttachment: c.ContentDocumentLinks && c.ContentDocumentLinks.totalSize > 0 ? '있음' : '-',
                OwnerName: c.Owner ? c.Owner.Name : '-',
                badgeClass: this.getCaseBadgeClass(c.Status)
            }));
            
            // Transform contracts to add badge class
            this.contracts = (data.contracts || []).map(contract => ({
                ...contract,
                badgeClass: this.getContractBadgeClass(contract.Status)
            }));

            this.setPaginationData('orderState', this.orders);
            this.setPaginationData('caseState', this.cases);
            this.setPaginationData('contractState', this.contracts);
            this.isLoading = false;
        } else if (error) {
            console.error('Error fetching dashboard data', error);
            this.isLoading = false;
            this.showToast('Error', 'Error loading dashboard data', 'error');
        }
    }

    handleRowAction(event) {
        const actionName = event.detail.action.name;
        const row = event.detail.row;
        
        if (actionName === 'view_case') {
            this.viewMode = 'case_detail';
            this.selectedCase = {
                Id: row.Id,
                CaseNumber: row.CaseNumber,
                Subject: row.Subject,
                Status: row.Status,
                Priority: row.Priority,
                CreatedDate: row.CreatedDate,
                Description: row.Description,
                Issue_Date__c: row.Issue_Date__c,
                ProductName: row.ProductName,
                OwnerName: row.Owner ? row.Owner.Name : ''
            };
        }
    }

    handleCaseClick(event) {
        const caseId = event.currentTarget.dataset.id;
        const selectedCase = [...this.cases, ...this.caseState.data].find(c => c.Id === caseId);
        
        if (selectedCase) {
            this.viewMode = 'case_detail';
            this.selectedCase = {
                Id: selectedCase.Id,
                CaseNumber: selectedCase.CaseNumber,
                Subject: selectedCase.Subject,
                Status: selectedCase.Status,
                Priority: selectedCase.Priority,
                CreatedDate: selectedCase.CreatedDate,
                Description: selectedCase.Description,
                Issue_Date__c: selectedCase.Issue_Date__c,
                ProductName: selectedCase.ProductName,
                OwnerName: selectedCase.Owner ? selectedCase.Owner.Name : ''
            };
        }
    }

    handleBackToDashboard() {
        this.viewMode = 'dashboard';
        this.selectedCase = null;
    }

    // Helper to initialize pagination state object
    initPaginationState() {
        return {
            data: [],
            currentPage: 1,
            totalPages: 1,
            visibleData: [],
            disablePrev: true,
            disableNext: true
        };
    }

    // Helper to set data and calculate initial page
    setPaginationData(stateName, allData) {
        const totalPages = Math.ceil(allData.length / this.pageSize) || 1;
        this[stateName] = {
            data: allData,
            currentPage: 1,
            totalPages: totalPages,
            visibleData: allData.slice(0, this.pageSize),
            disablePrev: true,
            disableNext: totalPages <= 1
        };
    }

    handleCreateCase() {
        this.showCaseModal = true;
    }

    handleCaseSuccess() {
        this.showCaseModal = false;
        return refreshApex(this.wiredResult);
    }

    handleCloseCaseModal() {
        this.showCaseModal = false;
    }

    // Handle Pagination Button Clicks
    handlePrev(event) {
        const type = event.target.dataset.type; // 'order', 'case', 'contract'
        const stateName = type + 'State';
        const state = this[stateName];

        if (state.currentPage > 1) {
            state.currentPage--;
            this.updateVisibleData(stateName);
        }
    }

    handleNext(event) {
        const type = event.target.dataset.type;
        const stateName = type + 'State';
        const state = this[stateName];

        if (state.currentPage < state.totalPages) {
            state.currentPage++;
            this.updateVisibleData(stateName);
        }
    }

    updateVisibleData(stateName) {
        const state = this[stateName];
        const start = (state.currentPage - 1) * this.pageSize;
        const end = start + this.pageSize;
        
        state.visibleData = state.data.slice(start, end);
        state.disablePrev = state.currentPage <= 1;
        state.disableNext = state.currentPage >= state.totalPages;
        
        // Force reactivity for nested objects track issue
        this[stateName] = { ...state };
    }

    handleTabActive(event) {
        this.activeTab = event.target.value;
    }

    handleOpenModal() {
        this.showModal = true;
    }

    handleCloseModal() {
        this.showModal = false;
    }

    handleOrderSuccess() {
        this.showModal = false;
        this.showToast('성공', '주문이 정상적으로 접수되었습니다.', 'success');
        return refreshApex(this.wiredResult);
    }

    // --- Case Modal Methods ---
    handleCreateCase() {
        this.showCaseModal = true;
    }

    handleCloseCaseModal() {
        this.showCaseModal = false;
    }

    handleCaseSuccess(event) {
        this.handleCloseCaseModal();
        // Toast is shown by the form component
        // Refresh the data
        return refreshApex(this.wiredResult);
    }

    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });
        this.dispatchEvent(event);
    }
}
