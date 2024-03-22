public  class BatchAddSalaries implements Database.Batchable<sObject>{
    public Database.QueryLocator start(Database.BatchableContext context) {
        String query = 'SELECT Id FROM Contact;SELECT Id FROM Account';
        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext context, List<Contact> listofcontacts){
        List<Salary__c> tobeaddedsalaries = new List<Salary__c>();
        String currentmonth = DateTime.now().format('MMMM');

        List<Tiers__mdt> tiers = [Select FlatTaxAmount__c, MaximumSalary__c, TaxPercent__c from Tiers__mdt ORDER BY FlatTaxAmount__c ASC ];
            Map<String, Integer> monthmap = new Map<String, Integer>{
    'January' => 6, 'February' => 5, 'March' => 4,
    'April' => 3, 'May' => 2, 'June' => 1,
    'July' => 12, 'August' => 11, 'September' => 10,
    'October' => 9, 'November' => 8, 'December' => 7
};
    Decimal taxablesalary, yearlytax=0.00, monthlytax ,SalarytobePaid, yearlysalary , totalprevioussalary = 0.00, totalprevioustax = 0.00;
    Integer RemainingMonthsUntilJuly ;
    String newcombination, existingcombination;
    List<Decimal> previousvalues = new List<Decimal>();
    List<Decimal> previoussalaryandtax = new List<Decimal>();



     Set<Id> contactIds = new Set<Id>();
        for (Contact eachcontact : listofcontacts) {
          contactIds.add(eachcontact.Id);
}

      Map<String, List<Decimal> > sumByCombination = new Map<String, List<Decimal> >();

     for (AggregateResult result : [
        SELECT ContactId__c, Fiscal_Year__c, SUM(Salary__c) salarypaidtilldate, SUM(Tax__C) taxpaidtilldate
        FROM Salary__c
        WHERE ContactId__c IN :contactIds AND Fiscal_Year__c = '2024- 2025'
        GROUP BY ContactId__c, Fiscal_Year__c
    ]) {
        if(result!= null){
        existingcombination = (Id)result.get('ContactId__c') + '-' + (String)result.get('Fiscal_Year__c');
        previousvalues.add((Decimal)result.get('salarypaidtilldate'));
        previousvalues.add((Decimal)result.get('taxpaidtilldate'));
        sumByCombination.put(existingcombination, previousvalues);
        }
    }

    for (Contact everycontact : listofcontacts) {
                Salary__c newsalary = new Salary__c(
            Salary__c = 50000,
            Month__c = currentmonth,
            Fiscal_year__c = '2024- 2025',
            ContactId__c = everycontact.Id
        );

                newcombination = everycontact.Id + '-' + '2024- 2025';
        if (sumByCombination!= null){
        if(sumByCombination.containsKey(newcombination))  {
            previoussalaryandtax = sumByCombination.get(newcombination);
            if(!previoussalaryandtax.isEmpty()){
                totalprevioussalary= previoussalaryandtax[0];
                totalprevioustax = previoussalaryandtax[1];
            }
        }
    }

     RemainingMonthsUntilJuly = monthmap.get(currentmonth);
    yearlysalary = (RemainingMonthsUntilJuly * 50000) + totalprevioussalary ;


        if(yearlysalary <= tiers[0].MaximumSalary__c){
            newsalary.Tax__c = 0.00;
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
    if(yearlytax >0){
        monthlytax = (yearlytax  - totalprevioustax) / RemainingMonthsUntilJuly; 
        newsalary.Tax__c = monthlytax;
    }
        tobeaddedsalaries.add(newsalary)  ;  
        }

        insert tobeaddedsalaries;


    }

    public void finish (Database.BatchableContext context){
        System.debug('Done');
    }
}