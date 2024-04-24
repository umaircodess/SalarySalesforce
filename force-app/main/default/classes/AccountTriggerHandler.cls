public class AccountTriggerHandler {
    // Trigger handler method to set a default description for new accounts
    public static void beforeInsert(List<Account> newAccounts) {
        for(Account newAccount : newAccounts) {
            newAccount.Description = 'Triggers at work';
        }
    }

    // Trigger handler method to create related opportunities after account insertion
    public static void afterInsert(List<Account> newAccounts) {
        List<Opportunity> opportunitiesToInsert = new List<Opportunity>();
        for(Account parentAccount : newAccounts) {
            Opportunity relatedOpportunity = new Opportunity();
            relatedOpportunity.Name = parentAccount.Name;
            relatedOpportunity.AccountId = parentAccount.Id;
            relatedOpportunity.CloseDate = System.Today();
            relatedOpportunity.StageName = 'Prospecting';
            opportunitiesToInsert.add(relatedOpportunity);
        }
        insert opportunitiesToInsert;
    }

    // Trigger handler method to update account description if phone number is modified
    public static void beforeUpdate(List<Account> updatedAccounts, Map<Id, Account> oldAccountsMap) {
        for(Account updatedAccount : updatedAccounts) {
            if(updatedAccount.Phone != oldAccountsMap.get(updatedAccount.Id).Phone) {
                updatedAccount.Description = 'Phone number modified';
            }
        }
    }

    // Trigger handler method to update related opportunities if account phone number is modified
    public static void afterUpdate(List<Account> updatedAccounts, Map<Id, Account> oldAccountsMap) {
        // Set<Id> accountIdsToUpdate = new Set<Id>();
        // for(Account updatedAccount : updatedAccounts) {
        //     if(updatedAccount.Phone != oldAccountsMap.get(updatedAccount.Id).Phone) {
        //         accountIdsToUpdate.add(updatedAccount.Id);
        //     }
        // }

        // List<Opportunity> opportunitiesToUpdate = new List<Opportunity>();
        // List<Account> accountsWithOpportunities = [SELECT Id, Phone, (SELECT Id, Phone__c FROM Opportunities) FROM Account WHERE Id IN :accountIdsToUpdate];

        // for(Account accountWithOpportunity : accountsWithOpportunities) {
        //     List<Opportunity> relatedOpportunities = accountWithOpportunity.Opportunities;
        //     for(Opportunity relatedOpportunity : relatedOpportunities) {
        //         relatedOpportunity.Phone__c = accountWithOpportunity.Phone;
        //         opportunitiesToUpdate.add(relatedOpportunity);
        //     }
        // }

        // update opportunitiesToUpdate;
    }

    // Trigger handler method to prevent deletion of accounts with related opportunities
    public static void beforeDelete(List<Account> accountsToDelete) {
        for(Account accountToDelete : accountsToDelete) {
            List<Opportunity> relatedOpportunities = [SELECT Id FROM Opportunity WHERE AccountId = :accountToDelete.Id];
            if(!relatedOpportunities.isEmpty()) {
                accountToDelete.addError('Account has related opportunities and therefore cannot be deleted');
            }
        }
    }

    // Trigger handler method to delete related opportunities when an account is deleted
    public static void afterDelete(List<Account> deletedAccounts) {
        for(Account deletedAccount : deletedAccounts) {
            List<Opportunity> relatedOpportunities = [SELECT Id FROM Opportunity WHERE AccountId = :deletedAccount.Id];
            delete relatedOpportunities;
        }
    }
}