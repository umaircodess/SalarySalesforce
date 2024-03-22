import { LightningElement,wire } from 'lwc';
import { subscribe, MessageContext } from 'lightning/messageService';
import stringg from '@salesforce/messageChannel/message__c';
export default class SubComponent extends LightningElement {
    @wire(MessageContext) messageContext;
    String = 'null';

    connectedCallback() {
       subscribe(this.messageContext, stringg, (messagePayload) => this.fn(messagePayload));
    }
    fn(msg) { 
        console.log(msg);
        this.String = msg.incomingString;
    }
}