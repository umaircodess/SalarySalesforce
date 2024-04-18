public with sharing class ContactController {
    @AuraEnabled(cacheable=true)
    public static List<Contact> getContacts() {
        return [SELECT Id, Name FROM Contact];
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
