public with sharing class SalaryController {
@AuraEnabled
    public static List<Integer> insertSalary(List<Salary__c> newSalaries){
        List<Integer> result = new List<Integer>();
        try{
            if(newSalaries.size() > 0){
            insert newSalaries;
            }
            result.add(0);
        }
        catch(DmlException e) {
            for (Integer i = 0; i < e.getNumDml(); i++) {
                result.add(e.getDmlIndex(i) + 1); // Add the index of the record to the result
            }
            throw new DmlException(String.join(result, ','));
        }
        return result;
    }

@AuraEnabled(cacheable=true)
    public static List<Salary__c> getSalaries(){
        return [SELECT Id, ContactId__c, Name, Salary_to_be_Paid__c, Month__c, Fiscal_year__c from Salary__c] ;

    }

    
@AuraEnabled
    public static void processSalaries(String salaryData) {
        List<Salary__c> salariesToBeAdded = new List<Salary__c>();
        List<SalaryJSON> incomingsalaries = SalaryJSON.parse(salaryData);
        for (SalaryJSON salary : incomingsalaries) {
            Salary__c newsalary = new Salary__c(
                Salary__c = salary.amount,
                Month__c = salary.month,
                Fiscal_year__c = salary.fiscalyear,
                ContactId__c = salary.contactId
            );
            salariesToBeAdded.add(newsalary);
        }
        insert salariesToBeAdded;

    }
}