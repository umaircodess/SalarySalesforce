public with sharing class returnSalaries {
@AuraEnabled(cacheable=true)
    public static List<Salary__c> getSalaries(){
        return [SELECT Id, ContactId__c, Name, Salary_to_be_Paid__c, Month__c, Fiscal_year__c from Salary__c] ;

    }
}