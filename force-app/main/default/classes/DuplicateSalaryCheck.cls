public with sharing class DuplicateSalaryCheck {
    public static void DuplicateFinder(List<Salary__c> salary) {
        Set<Id> contactIds = new Set<Id>();
        Set<String> fiscalYears = new Set<String>();
            for (Salary__c eachsalary : salary) {
                if(eachsalary.Salary__c!= null){
                    contactIds.add(eachsalary.ContactId__c);
                    fiscalYears.add(eachsalary.Fiscal_year__c);
                }
            }
        if(contactIds.size() > 0) {
            List<Salary__c> salaries = 
            [
                SELECT ContactId__c, Fiscal_year__c, Month__c 
                FROM Salary__c 
                WHERE ContactId__c 
                IN :contactIds 
                AND Fiscal_Year__c
                IN :fiscalYears
            ];
        
            if (!salaries.isEmpty()) {
                Map<String,List<Salary__c>> salariesMap = new Map<String,List<Salary__c>>();
                for(Salary__c existingSalary :salaries){
                    if(salariesMap.containsKey(existingSalary.ContactId__c)){
                        salariesMap.get(existingSalary.ContactId__c).add(existingSalary);
                    }
                    else{
                        salariesMap.put(existingSalary.ContactId__c ,new List<Salary__c> {existingSalary});
                    }
                }
                if(salariesMap!=null || !salariesMap.isEmpty()){
                    for(Salary__c everysalary : salary){
                        if(!salariesMap.get(everysalary.ContactId__c).isEmpty()){
                            List<Salary__c> existingSalaries = salariesMap.get(everysalary.ContactId__c);
                                for (Salary__c existingSalary : existingSalaries) {
                                    if (everysalary.Month__c == existingSalary.Month__c && everysalary.Fiscal_Year__c == existingSalary.Fiscal_Year__c) {
                                    everysalary.AddError('Salary for this contact for this month already exists');
                                    break;    
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}