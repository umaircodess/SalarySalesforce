import { LightningElement, track } from 'lwc';
import getContacts from '@salesforce/apex/ContactController.getContacts';
import processSalaries from '@salesforce/apex/SalaryController.processSalaries';

export default class SalariesComponent extends LightningElement {
    @track contacts;
    @track salariesArray = [];
    selectedMonth = '';
    selectedFiscalYear = '';
    
    monthOptions = [
        { label: 'January', value: 'January' },
        { label: 'February', value: 'February' },
        { label: 'March', value: 'March' },
        { label: 'April', value: 'April' },
        { label: 'May', value: 'May' },
        { label: 'June', value: 'June' },
        { label: 'July', value: 'July' },
        { label: 'August', value: 'August' },
        { label: 'September', value: 'September' },
        { label: 'October', value: 'October' },
        { label: 'November', value: 'November' },
        { label: 'December', value: 'December' },
    ];

    fiscalYearOptions = [
        { label: '2024-2025', value: '2024-2025' },
        { label: '2023-2024', value: '2023-2024' },
        { label: '2025-2026', value: '2025-2026' },
    ];

    connectedCallback() {
        getContacts()
            .then((result) => {
                this.contacts = result;
            })
            .catch((error) => {
                console.error("Error loading contacts: ", error);
            });
    }

    handleChange(event) {
        const contactId = event.target.dataset.id;
        const propertyName = event.target.name;
        const propertyValue = event.target.value;

        let salaryIndex = this.salariesArray.findIndex((salary) => salary.contactId === contactId);
        if (salaryIndex === -1) {
            this.salariesArray.push({ contactId, [propertyName]: propertyValue });
        } else {
            this.salariesArray[salaryIndex] = { ...this.salariesArray[salaryIndex], [propertyName]: propertyValue };
        }
    }

    saveSalaries() {
        if (this.salariesArray.length !== 0) {
            console.log('Processing salaries: ', this.salariesArray);
            processSalaries({ salaryData: JSON.stringify(this.salariesArray) })
                .then(result => {
                    // Handle success
                    console.log('Salaries processed successfully:', result);
                })
                .catch(error => {
                    // Handle error1
                    console.error('Error processing salaries:', error);
                });
        }
    }
}