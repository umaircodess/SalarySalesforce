public with sharing class SalaryTaxCalculator {
    
    public static void CalculatePayableSalary(List<Salary__c> salary) {
        
        Decimal taxablesalary, yearlytax, monthlytax ,SalarytobePaid, yearlysalary , totalprevioussalary = 0.00, totalprevioustax = 0.00;
        
        Integer RemainingMonthsUntilJuly ;
        
        String newcombination, existingcombination;
        
        List<Decimal> previousvalues = new List<Decimal>();
        
        List<Decimal> previoussalaryandtax = new List<Decimal>();
        
        List<Tiers__mdt> tiers = [Select FlatTaxAmount__c, MaximumSalary__c, TaxPercent__c from Tiers__mdt ORDER BY FlatTaxAmount__c ASC ];
        
        Set<String> fiscalYears = new Set<String>();
        
        Set<Id> contactIds = new Set<Id>();
        
        Map<String, List<Decimal> > sumByCombination = new Map<String, List<Decimal> >();
        
        Map<String, Integer> monthmap = new Map<String, Integer>{
        'January' => 6, 'February' => 5, 'March' => 4,
        'April' => 3, 'May' => 2, 'June' => 1,
        'July' => 12, 'August' => 11, 'September' => 10,
        'October' => 9, 'November' => 8, 'December' => 7
        };


            for (Salary__c eachsalary : salary) {
                if(eachsalary.Salary__c!= null){
                    contactIds.add(eachsalary.ContactId__c);
                    fiscalYears.add(eachsalary.Fiscal_year__c);
                }
            }

        if(contactIds.size() > 0) {
            for (AggregateResult result : [
                SELECT ContactId__c, Fiscal_Year__c, SUM(Salary__c) salarypaidtilldate, SUM(Tax__C) taxpaidtilldate
                FROM Salary__c
                WHERE ContactId__c IN :contactIds AND Fiscal_Year__c IN :fiscalYears
                GROUP BY ContactId__c, Fiscal_Year__c
            ]) {
                existingcombination = (Id)result.get('ContactId__c') + '-' + (String)result.get('Fiscal_Year__c');
                previousvalues.add((Decimal)result.get('salarypaidtilldate'));
                previousvalues.add((Decimal)result.get('taxpaidtilldate'));
                sumByCombination.put(existingcombination, previousvalues);
            }
        }



        for(Salary__c eachsalary : salary) {
            if(eachsalary.Salary__c!= null){
            newcombination = eachsalary.ContactId__c + '-' + eachsalary.Fiscal_Year__c;
            if (sumByCombination.containsKey(newcombination)) {
                previoussalaryandtax = sumByCombination.get(newcombination);
                if(!previoussalaryandtax.isEmpty()){
                    totalprevioussalary= previoussalaryandtax[0];
                    totalprevioustax = previoussalaryandtax[1];
                }       
            }

        RemainingMonthsUntilJuly = monthmap.get(eachsalary.Month__c);
        yearlysalary = (RemainingMonthsUntilJuly * eachsalary.Salary__c) + totalprevioussalary ;

            if(yearlysalary <= tiers[0].MaximumSalary__c){
                eachsalary.Tax__c = 0.00;
                break ;
            }

            for(integer i =1; i<=4; i++){

                if(yearlysalary > tiers[i-1].MaximumSalary__c && yearlysalary <= tiers[i].MaximumSalary__c){
                    taxablesalary = yearlysalary - tiers[i-1].MaximumSalary__c;   
                    yearlytax = tiers[i].FlatTaxAmount__c + ((tiers[i].TaxPercent__c * taxablesalary ) /100);
                }
            }


            if(yearlysalary > tiers[4].MaximumSalary__c){
                taxablesalary = yearlysalary - tiers[4].MaximumSalary__c; 
                yearlytax = tiers[5].FlatTaxAmount__c + ((tiers[5].TaxPercent__c * taxablesalary ) /100);
            
            }

                monthlytax = (yearlytax  - totalprevioustax) / RemainingMonthsUntilJuly; 
                eachsalary.Tax__c = monthlytax;
        }
    }
  }
}