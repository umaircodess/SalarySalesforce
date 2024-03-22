import { LightningElement, track } from 'lwc';
import getSalaries from '@salesforce/apex/returnSalaries.getSalaries';
export default class SalariesComboBox extends LightningElement {
    columns = [
        { label: 'Salary Id', fieldName: 'Id' },
        { label: 'Contact Id', fieldName: 'ContactId__c' },
        { label: 'Name', fieldName: 'Name' },
        { label: 'Salary', fieldName: 'Salary_to_be_Paid__c' },
        { label: 'Month', fieldName: 'Month__c' },
        { label: 'Fiscal Year', fieldName: 'Fiscal_year__c' },
        {
            label: 'Salary', type: 'combobox',
            options: [
            { label: 'Salary 1', value: 10 },
            { label: 'Salary 2', value: 20 },
            { label: 'Salary 3', value: 30 },
            ]
        },
        {
            label: "Action",
            type: "button",
            typeAttributes: {
                label: "Inner Label",
            }
        },
        // ,{
        //     label: "abc",
        //     type: "action",
        //     typeAttributes: {
        //         rowActions:[
        //             { label: "Another Label", name: "rowaction" },
        //             { label: " Label 2", name: "else" },
        //         ]
                
        //     }
        // }
    ];
    rowaction(event) {
    console.log('row action'+ event.detail);
    }
    cellaction(event) {
            console.log('cell action' + event.detail);
    }

    @track options = [];
    @track data = [];
    completedata = [];
    objectApiName = 'Salary__c';
    connectedCallback() {
        getSalaries().then(result => {
            this.completedata = result;
            let arr = [];
            result.forEach(item => { arr.push({ 'label': item.Name, 'value': item.ContactId__c }) });
            this.options = arr;
        }).catch((error) => {
            console.log(error);
        });
    }
    handleChange(event) {
        const selected = event.detail.value;
        let arr = [];
        // console.log(selected);
        // console.log(this.completedata);
        this.completedata.forEach(item => {
            if (item.ContactId__c === selected) {
                arr.push(item);
            }
        });
        this.data = arr;
    }

}
