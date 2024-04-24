import { LightningElement, api } from "lwc";
export default class ModalRecordForm extends LightningElement {
    @api recordId;
    @api showmodal;
    objApiName = 'Account';
    handleOkay() {
        const event = new CustomEvent("okay", {
            detail: false
        });

        this.dispatchEvent(event);
    }
    // changesite(event) {
    //   event.preventDefault();
    //   const fields = event.detail.fields;
    //   fields.Site = "Task Done";
    //   fields.Website = "Task Done";
    //   fields.Description = "Task Done";
    //   this.template.querySelector("lightning-record-form").submit(fields);
    // }
}