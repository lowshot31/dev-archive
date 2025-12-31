import { LightningElement, track, api, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { getRecord } from 'lightning/uiRecordApi';
import USER_ID from '@salesforce/user/Id';
import NAME_FIELD from '@salesforce/schema/User.Name';

export default class PortalHeader extends NavigationMixin(LightningElement) {
    @api logoUrl;
    @track isScrolled = false;
    @track isMobileMenuOpen = false;
    @track userName;

    @wire(getRecord, { recordId: USER_ID, fields: [NAME_FIELD] })
    wiredUser({ error, data }) {
        if (data) {
            this.userName = data.fields.Name.value;
        } else if (error) {
            console.error('Error fetching user record', error);
        }
    }

    connectedCallback() {
        window.addEventListener('scroll', this.handleScroll);
    }

    disconnectedCallback() {
        window.removeEventListener('scroll', this.handleScroll);
    }

    handleScroll = () => {
        this.isScrolled = window.scrollY > 50;
    };

    toggleMenu() {
        this.isMobileMenuOpen = !this.isMobileMenuOpen;
    }

    navigateToHome(event) {
        event.preventDefault();
        event.stopPropagation();
        this[NavigationMixin.Navigate]({
            type: 'comm__namedPage',
            attributes: {
                name: 'Home'
            },
            state: {
                tab: 'overview',
                t: Date.now() // Timestamp to force Wire service to see a change
            }
        });
        this.isMobileMenuOpen = false;
    }

    navigateToOrder(event) {
        event.preventDefault();
        event.stopPropagation();
        this[NavigationMixin.Navigate]({
            type: 'comm__namedPage',
            attributes: {
                name: 'Home'
            },
            state: {
                tab: 'orders',
                t: Date.now()
            }
        });
        this.isMobileMenuOpen = false;
    }

    navigateToSupport(event) {
        event.preventDefault();
        event.stopPropagation();
         this[NavigationMixin.Navigate]({
            type: 'comm__namedPage',
            attributes: {
                name: 'Home'
            },
            state: {
                tab: 'cases',
                t: Date.now()
            }
        });
        this.isMobileMenuOpen = false;
    }

    handleLogout() {
        const sitePrefix = window.location.pathname.substring(0, window.location.pathname.indexOf('/s/'));
        window.location.href = sitePrefix + '/secur/logout.jsp';
    }

    get headerClass() {
        return `header ${this.isScrolled ? 'scrolled' : ''}`;
    }

    get navClass() {
        return `nav ${this.isMobileMenuOpen ? 'active' : ''}`;
    }

    get menuToggleClass() {
        return `menu-toggle ${this.isMobileMenuOpen ? 'active' : ''}`;
    }
}
