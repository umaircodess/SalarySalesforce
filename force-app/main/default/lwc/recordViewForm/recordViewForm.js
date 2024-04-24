import { LightningElement,api } from 'lwc';
export default class RecordViewForm extends LightningElement {
    @api recordId;
    @api showmodal;   
    handleOkay() {
        const event = new CustomEvent('okay', {
            detail: false
        })

        this.dispatchEvent(event);
    }
}