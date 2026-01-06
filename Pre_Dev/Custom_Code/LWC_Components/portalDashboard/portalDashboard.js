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
        label: 'Case Number', 
        type: 'button', 
        typeAttributes: { 
            label: { fieldName: 'CaseNumber' }, 
            variant: 'base',
            name: 'view_case'
        } 
    },
    { label: 'Subject', fieldName: 'Subject', type: 'text' },
    { label: 'Status', fieldName: 'Status', type: 'text' },
    { label: 'Priority', fieldName: 'Priority', type: 'text' }
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
        return this.orders ? this.orders.slice(0, 5) : [];
    }

    get visibleCasesSummary() {
        return this.cases ? this.cases.slice(0, 5) : [];
    }

    get visibleContractsSummary() {
        return this.contracts ? this.contracts.slice(0, 5) : [];
    }

    orderColumns = ORDER_COLUMNS;
    caseColumns = CASE_COLUMNS;
    contractColumns = CONTRACT_COLUMNS;

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
            this.orders = data.orders || [];
            this.cases = data.cases || [];
            this.contracts = data.contracts || [];

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
            this.selectedCase = row;
            this.viewMode = 'case_detail';
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

    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });
        this.dispatchEvent(event);
    }
}
