trigger SalaryTrigger on Salary__c (before insert, before update) {
        for(Salary__c salaryrecord : Trigger.new){
            if(salaryrecord.Salary__c == null || salaryrecord.Month__c == null || salaryrecord.Fiscal_year__c == null || salaryrecord.ContactId__c == null){
                salaryrecord.addError('Please enter all the required fields');
            }
        }

        if (trigger.isInsert){
            DuplicateSalaryCheck.DuplicateFinder(Trigger.new);
            SalaryTaxCalculator.CalculatePayableSalary(Trigger.new);
        }

        if (trigger.isUpdate){
            SalaryTaxCalculator.CalculatePayableSalary(Trigger.new);
        }  
}