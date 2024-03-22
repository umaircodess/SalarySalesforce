trigger SalaryTrigger on Salary__c (before insert, before update) {


    if (trigger.isInsert){
        DuplicateSalaryCheck.DuplicateFinder(Trigger.new);
        SalaryTaxCalculator.CalculatePayableSalary(Trigger.new);
    }

    
    if (trigger.isUpdate){
        SalaryTaxCalculator.CalculatePayableSalary(Trigger.new);
    }  
}