import { LightningElement , api , track , wire} from 'lwc';
import getOpportunitiesByAccount from '@salesforce/apex/opportunitiesToAccount.getOpportunitiesByAccount';
const columns = [
    { label: 'Opportunity Name', fieldName: 'Name', type: 'text' },
    { label: 'Amount', fieldName: 'Amount', type: 'currency', cellAttributes: { alignment: 'left' } },
    {Label: 'Stage',fieldName: 'StageName',type: 'text',cellAttributes: {class: { fieldName: 'stageClass' }}
},
{ label: 'Close Date', fieldName: 'CloseDate', type: 'date' }
]
export default class OpportunitiesToAccount extends LightningElement {
    @api recordId;
    @track opportunities = [];
    @track error;
    columns=columns;
    @wire(getOpportunitiesByAccount, { accountId: '$recordId' })
    wiredOpps({ error, data }) {
        if (data) {
            this.opportunities = data.map(opp => {
                return {
                    ...opp,
                    stageClass: opp.StageName === 'Closed Lost' ? 'closed-lost-cell' : ''
                };
            });
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.opportunities = [];
        }
    }
}
