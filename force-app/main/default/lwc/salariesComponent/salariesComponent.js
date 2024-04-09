import { LightningElement, track, wire } from 'lwc';
import getContacts from '@salesforce/apex/ContactController.getContacts';
import processSalaries from '@salesforce/apex/ContactController.processSalaries';

export default class SalariesComponent extends LightningElement {
    @track contacts;
    @track salariesMap = new Map();

    @wire(getContacts)
    wiredContacts({ error, data }) {
        if (data) {
            this.contacts = data;
        } else if (error) {
            console.error('Error fetching contacts: ', error);
        }
    }

    handleChange(event) {
        this.salariesMap.set(event.target.dataset.id, parseFloat(event.target.value) );
    }

saveSalaries() {
    // let salariesToProcess = [];
    // for (let contactId in this.salaries) {
    //     if (this.salaries[contactId] !== null) {
    //         salariesToProcess.push({ contactId: contactId, salary: this.salaries[contactId] });
    //     }
    // }
    if (this.salariesMap.size !== 0) {
        let outgoingsalary = JSON.stringify(Array.from(this.salariesMap.entries()));
        console.log('Processing salaries: ', outgoingsalary);
        processSalaries({ salaryData:outgoingsalary })
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

