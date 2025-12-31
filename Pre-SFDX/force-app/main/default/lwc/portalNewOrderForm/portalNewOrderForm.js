import { LightningElement, api, track, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getActiveContracts from '@salesforce/apex/PortalDashboardController.getActiveContracts';
import getPricebookProducts from '@salesforce/apex/PortalDashboardController.getPricebookProducts';
import createOrder from '@salesforce/apex/PortalDashboardController.createOrder';

export default class PortalNewOrderForm extends LightningElement {
    @api accountId;
    @track selectedContractId = '';
    @track selectedPricebook2Id = '';
    @track effectiveDate = this.getTodayDate();
    @track description = '';
    @track isLoading = false;
    @track contractOptions = [];
    @track products = [];
    @track contractsData = [];

    // Wire to fetch active contracts
    @wire(getActiveContracts, { accountId: '$accountId' })
    wiredContracts({ error, data }) {
        if (data) {
            this.contractsData = data;
            this.contractOptions = data.map(contract => ({
                label: `${contract.ContractNumber} (${contract.Status})`,
                value: contract.Id,
                pricebook2Id: contract.Pricebook2Id
            }));
        } else if (error) {
            console.error('Error fetching contracts:', error);
            this.showToast('오류', '계약서 목록을 불러올 수 없습니다.', 'error');
        }
    }

    // Wire to fetch products from Pricebook based on Contract
    @wire(getPricebookProducts, { pricebook2Id: '$selectedPricebook2Id', contractId: '$selectedContractId' })
    wiredProducts({ error, data }) {
        if (data) {
            this.products = data.map(entry => ({
                id: entry.Id,
                pricebookEntryId: entry.Id,
                product2Id: entry.Product2Id,
                name: entry.Product2.Name,
                unitPrice: entry.UnitPrice,
                quantity: 1,
                selected: false
            }));
        } else if (error) {
            console.error('Error fetching products:', error);
            this.showToast('오류', '상품 목록을 불러올 수 없습니다.', 'error');
        }
    }

    getTodayDate() {
        const today = new Date();
        const year = today.getFullYear();
        const month = String(today.getMonth() + 1).padStart(2, '0');
        const day = String(today.getDate()).padStart(2, '0');
        return `${year}-${month}-${day}`;
    }

    handleContractChange(event) {
        this.selectedContractId = event.detail.value;
        
        // Get selected contract's Pricebook2Id
        const selectedContract = this.contractOptions.find(c => c.value === this.selectedContractId);
        this.selectedPricebook2Id = selectedContract ? selectedContract.pricebook2Id : '';
    }

    handleDateChange(event) {
        this.effectiveDate = event.detail.value;
    }

    handleDescriptionChange(event) {
        this.description = event.detail.value;
    }

    handleProductSelect(event) {
        const productId = event.target.dataset.id;
        this.products = this.products.map(p => {
            if (p.id === productId) {
                return { ...p, selected: event.target.checked };
            }
            return p;
        });
    }

    handleQuantityChange(event) {
        const productId = event.target.dataset.id;
        const quantity = parseInt(event.target.value, 10);
        this.products = this.products.map(p => {
            if (p.id === productId) {
                return { ...p, quantity: quantity };
            }
            return p;
        });
    }

    async handleSubmit() {
        // Validation
        if (!this.effectiveDate) {
            this.showToast('알림', '주문 일자를 입력해주세요.', 'warning');
            return;
        }

        // Get selected products
        const selectedProducts = this.products.filter(p => p.selected).map(p => ({
            pricebookEntryId: p.pricebookEntryId,
            quantity: p.quantity,
            unitPrice: p.unitPrice
        }));

        if (selectedProducts.length === 0) {
            this.showToast('알림', '최소 1개 이상의 상품을 선택해주세요.', 'warning');
            return;
        }

        this.isLoading = true;
        try {
            const newOrder = await createOrder({
                accountId: this.accountId,
                contractId: this.selectedContractId || null,
                effectiveDate: this.effectiveDate,
                description: this.description,
                products: selectedProducts
            });

            this.showToast('성공', '주문이 정상적으로 접수되었습니다.', 'success');
            this.dispatchEvent(new CustomEvent('success', {
                detail: { id: newOrder.Id }
            }));
        } catch (error) {
            console.error('Order Creation Error:', error);
            const errorMsg = error.body ? error.body.message : error.message;
            this.showToast('주문 접수 실패', '주문 접수 중 오류가 발생했습니다: ' + errorMsg, 'error');
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
