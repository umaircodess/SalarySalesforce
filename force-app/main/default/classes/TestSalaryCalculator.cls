@isTest
public with sharing class TestSalaryCalculator {
    // @isTest
    // public static void TestSalaryCalculator() {

    //     Salary__c salary = new Salary__c(
    //         Salary__c = 40000,
    //         Month__c = 'June',
    //         ContactId__c = '003GA000043LG28YAG'
    //     );

    //     Salary__c secondsalary = new Salary__c(
    //         Salary__c = 60000,
    //         Month__c = 'July',
    //         ContactId__c = '003GA000043LG28YAG'
    //     );
    //     Salary__c thirdsalary = new Salary__c(
    //         Salary__c = 500000,
    //         Month__c = 'July',
    //         ContactId__c = '003GA000043LG28YAG'
    //     );
    //     Salary__c fourthsalary = new Salary__c(
    //         Salary__c = 600000,
    //         Month__c = 'July',
    //         ContactId__c = '003GA000043LG28YAG'
    //     );
    //     List<Tiers__mdt> tiers = [Select FlatTaxAmount__c, MaximumSalary__c, TaxPercent__c from Tiers__mdt ORDER BY FlatTaxAmount__c ASC ];

    //     Test.startTest();
    //     Decimal Payablesalary = SalaryTaxCalculator.CalculatePayableSalary(salary, tiers);
    //     Decimal Payablesecondsalary = SalaryTaxCalculator.CalculatePayableSalary(secondsalary, tiers);
    //     Decimal Payablethirdsalary = SalaryTaxCalculator.CalculatePayableSalary(thirdsalary, tiers);
    //     Decimal Payablefourthsalary = SalaryTaxCalculator.CalculatePayableSalary(fourthsalary, tiers);
    //     Test.stopTest();

    //     System.assertEquals(40000, Payablesalary);
    //     System.assertEquals(59750, Payablesecondsalary);
    //     System.assertEquals(408750, Payablethirdsalary);
    //     System.assertEquals(473750, Payablefourthsalary);



    // }
}