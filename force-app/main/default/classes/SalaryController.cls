public with sharing class SalaryController {
@AuraEnabled
    public static void insertSalary(List<Salary__c> newSalaries){
        try{
            if(newSalaries.size() > 0){
            insert newSalaries;
            }
        }
        catch(Exception ex) {
            throw new AuraHandledException('All Required fields must be inserted');
        }
    }
}