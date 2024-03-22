import { LightningElement,wire } from 'lwc';
import { MessageContext, publish } from 'lightning/messageService'; 
import stringg from '@salesforce/messageChannel/message__c'; 
export default class PubComponent extends LightningElement {
    @wire(MessageContext) messageContext;
    message;
    messagePayload;
    sendmessage(event) {
        this.message = event.target.value;
    }


    handleClick() {
        this.messagePayload = {
    incomingString : this.message
};
        publish(this.messageContext, stringg, this.messagePayload);
    }
}