public with sharing class ContactController {
    @AuraEnabled(cacheable=true)
    public static List<Contact> getContacts() {
        return [SELECT Id, Name FROM Contact LIMIT 10]; // Example query to fetch contacts
    }

    @AuraEnabled
    public static void processSalaries(String salaryData) {
    List<Salary__c> salariesToBeAdded = new List<Salary__c>();
    String currentmonth = DateTime.now().format('MMMM');
    Map<String, Integer> resultMap = new Map<String, Integer>();
    
    List<Object> jsonList = (List<Object>) JSON.deserializeUntyped(salaryData);
    for (Object obj : jsonList) {
        List<Object> keyValue = (List<Object>) obj;
        String key = (String) keyValue[0];
        Integer value = (Integer) keyValue[1];
        resultMap.put(key, value);
    }
    for(String key: resultMap.keySet()){
        Salary__c newsalary = new Salary__c(
            Salary__c = resultMap.get(key),
            Month__c = currentmonth,
            Fiscal_year__c = '2024- 2025',
            ContactId__c = key
        );
        salariesToBeAdded.add(newsalary);
    }
    insert salariesToBeAdded;
}
}
