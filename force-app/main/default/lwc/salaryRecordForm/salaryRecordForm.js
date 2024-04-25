import { LightningElement, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';
import insertSalary from '@salesforce/apex/SalaryController.insertSalary';
export default class SalaryRecordForm extends NavigationMixin(LightningElement) {
    fields = ['ContactId__c', 'Month__c', 'Salary__c', 'Fiscal_year__c'];
    errorMessages = [];
    IndexOfRow = 1;
    @track rows = [
        {
            id: 1
        }
    ];
    removeform(event) {
        if (this.rows.length > 1) {
            let row_to_delete = event.target.dataset.row;
            this.rows = this.rows.filter((item) => item.id !== parseInt(row_to_delete, 10));
            this.IndexOfRow = this.IndexOfRow - 1;
            this.rows.forEach((item) => {     
                if(item.id > row_to_delete) {
                    item.id = item.id - 1;
                }
            });
   
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
            // this[NavigationMixin.Navigate]({
            //     type: 'standard__objectPage',
            //     attributes: {
            //         objectApiName: 'Salary__c',
            //         actionName: 'home'
            //     }
            // });
            this[NavigationMixin.Navigate]({
                type: 'standard__webPage',
                attributes: {
                    url: '/lightning/n/Datatable_component'
                }
            });
        }).catch((err) => {
            this.errorMessages.push(err.body.message);
            if (this.errorMessages.length > 0) { 
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error',
                        message: 'Errors in Record no. :  ' + this.errorMessages.join(', '),
                        variant: 'error'
                    })
                );
            }
            this.errorMessages.length = 0;
        });
    }
}