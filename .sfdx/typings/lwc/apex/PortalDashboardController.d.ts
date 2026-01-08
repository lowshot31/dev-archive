declare module "@salesforce/apex/PortalDashboardController.getCaseFeed" {
  export default function getCaseFeed(param: {caseId: any}): Promise<any>;
}
declare module "@salesforce/apex/PortalDashboardController.addFeedPost" {
  export default function addFeedPost(param: {caseId: any, body: any}): Promise<any>;
}
declare module "@salesforce/apex/PortalDashboardController.getRelatedRecords" {
  export default function getRelatedRecords(param: {accountId: any}): Promise<any>;
}
declare module "@salesforce/apex/PortalDashboardController.getActiveContracts" {
  export default function getActiveContracts(param: {accountId: any}): Promise<any>;
}
declare module "@salesforce/apex/PortalDashboardController.getPricebookProducts" {
  export default function getPricebookProducts(param: {pricebook2Id: any, contractId: any}): Promise<any>;
}
declare module "@salesforce/apex/PortalDashboardController.createOrder" {
  export default function createOrder(param: {accountId: any, contractId: any, effectiveDate: any, description: any, products: any}): Promise<any>;
}
declare module "@salesforce/apex/PortalDashboardController.uploadFiles" {
  export default function uploadFiles(param: {recordId: any, files: any}): Promise<any>;
}
