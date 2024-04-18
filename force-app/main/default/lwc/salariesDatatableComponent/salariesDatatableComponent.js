import { LightningElement, track } from 'lwc';

export default class MyComponent extends LightningElement {
    @track contacts = [
        { Id: '001', Name: 'John Doe' },
        { Id: '002', Name: 'Jane Smith' },
        { Id: '003', Name: 'Alice Johnson' }
    ];
    salaries = new Map();

    handleChange(event) {
        const contactId = event.target.dataset.id;
        const propertyName = event.target.name;
        const propertyValue = event.target.value;

        let salary = this.salaries.get(contactId);
        if (!salary) {
            salary = { amount: '', month: '', year: '' };
        }

        salary[propertyName] = propertyValue;
        this.salaries.set(contactId, salary);

        console.log('Salaries Map:', this.salaries);
    }
}
