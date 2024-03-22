public with sharing class DuplicateSalaryCheck {
    public static void DuplicateFinder(List<Salary__c> salary) {
    Set<Id> contactIds = new Set<Id>();
    Set<String> fiscalYears = new Set<String>();
    for (Salary__c eachsalary : salary) {
        contactIds.add(eachsalary.ContactId__c);
        fiscalYears.add(eachsalary.Fiscal_year__c);
}

     List<Salary__c> salaries = [SELECT ContactId__c, Fiscal_year__c, Month__c 
     FROM Salary__c 
     WHERE ContactId__c IN :contactIds AND Fiscal_Year__c IN :fiscalYears];
     if(!salaries.isEmpty()){
        for(Salary__c everysalary : salary){
        for (Salary__c existingSalary : salaries) {
            if (existingSalary.Month__c == everysalary.Month__c &&
                existingSalary.Fiscal_year__c == everysalary.Fiscal_year__c &&
                existingSalary.ContactId__c == everysalary.ContactId__c) {
                everysalary.AddError('Salary for this contact for this month already exists');
                break;


                }
    }

       
}
}
    }
}