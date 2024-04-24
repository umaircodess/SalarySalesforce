// Trigger to delegate the trigger handling logic to AccountTriggerHandler class
trigger AccountTrigger on Account (before insert, after insert, before update, after update, before delete, after delete) {
    // Before trigger logic
    if(Trigger.isBefore) {
        // Before insert logic
        if(Trigger.isInsert) {
            AccountTriggerHandler.beforeInsert(Trigger.new);
            // The beforeInsert method in AccountTriggerHandler will set a default description for new accounts.
        }
        // Before update logic
        else if(Trigger.isUpdate) {
            AccountTriggerHandler.beforeUpdate(Trigger.new, Trigger.oldMap);
            // The beforeUpdate method in AccountTriggerHandler will update the account description if the phone number is modified.
        }
        // Before delete logic
        else if(Trigger.isDelete) {
            AccountTriggerHandler.beforeDelete(Trigger.old);
            // The beforeDelete method in AccountTriggerHandler will prevent the deletion of accounts with related opportunities.
        }
    } 
    // After trigger logic
    else if(Trigger.isAfter) {
        // After insert logic
        if(Trigger.isInsert) {
            AccountTriggerHandler.afterInsert(Trigger.new);
            // The afterInsert method in AccountTriggerHandler will create related opportunities after account insertion.
        }
        // After update logic
        else if(Trigger.isUpdate) {
            AccountTriggerHandler.afterUpdate(Trigger.new, Trigger.oldMap);
            // The afterUpdate method in AccountTriggerHandler will update related opportunities if the account phone number is modified.
        }
        // After delete logic
        else if(Trigger.isDelete) {
            AccountTriggerHandler.afterDelete(Trigger.old);
            // The afterDelete method in AccountTriggerHandler will delete related opportunities when an account is deleted.
        }
    }
}