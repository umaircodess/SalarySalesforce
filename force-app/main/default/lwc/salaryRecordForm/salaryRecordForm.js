import { LightningElement, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';
import insertSalary from '@salesforce/apex/SalaryController.insertSalary';
export default class SalaryRecordForm extends NavigationMixin(LightningElement) {
    fields = ['ContactId__c', 'Month__c', 'Salary__c', 'Fiscal_year__c'];
    IndexOfRow = 0;
    @track rows = [
        {
            id: 0
        }
    ];
    removeform(event) {
        if (this.rows.length > 1) {
            let indexOfRow = event.target.dataset.index;
            this.rows = this.rows.filter((item) => item.id !== parseInt(indexOfRow));
        }
    }
    addform() {
        ++this.IndexOfRow;
        let newrow = { id: this.IndexOfRow };
        this.rows.push(newrow);
    }

    savesalaries() {

        let newSalaries = [];
        this.template.querySelectorAll('lightning-record-edit-form').forEach(element => {
            let newSalary = {};
            element.querySelectorAll('lightning-input-field').forEach(field => {
                newSalary[field.fieldName] = field.value;
            });
            newSalaries.push(newSalary);
        });
        insertSalary({ newSalaries: newSalaries }).then(() => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Salary added successfully',
                    variant: 'success'
                })
            );
            this[NavigationMixin.Navigate]({
                type: 'standard__objectPage',
                attributes: {
                    objectApiName: 'Salary__c',
                    actionName: 'list'
                }
            });
        }).catch((error) => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: 'Error in adding salary: ' + JSON.stringify(error),
                    variant: 'error'
                })
            );
        });
    }
}