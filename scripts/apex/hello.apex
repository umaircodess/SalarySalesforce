// List<Salary__c> sal1 = [Select Id from Salary__c];

 //delete [Select Id from Salary__c];


// //Salary__c sal1 = new Salary__c ();

// List<Salary__c> s = new List<Salary__c> ();
// s.add(sal1);

// SalaryTaxCalculator.CalculatePayableSalary(s);
// Integer currentMonthName = System.today().month();

//  System.debug(currentMonthName);
// String dt = DateTime.now().format('MMMM');
// System.debug(dt);

String singlejson ='{ "10009": {"zip_code": "10008","lat": 40.710028,"lng": -73.990053,"city": "New York","state": "NY","timezone": {"timezone_identifier": "America/New_York","timezone_abbr": "EST","utc_offset_sec": -18000,"is_dst": "F"},"acceptable_city_names": [{"city": "Manhattan","state": "NY"},{"city": "Nyc","state": "NY"}],"area_codes": [212,646,917]}}' ;
    System.debug(ZipCodeLocation.parse(singlejson).city);
String jsonString = '{ "10008": { "zip_code": "10008", "lat": 40.710028, "lng": -73.990053, "city": "New York", "state": "NY", "timezone": { "timezone_identifier": "America/New_York", "timezone_abbr": "EST", "utc_offset_sec": -18000, "is_dst": "F" }, "acceptable_city_names": [ { "city": "Manhattan", "state": "NY" }, { "city": "Nyc", "state": "NY" } ], "area_codes": [ 212, 646, 917 ] }, "07001": { "zip_code": "07001", "lat": 40.582313, "lng": -74.271375, "city": "Avenel", "state": "NJ", "timezone": { "timezone_identifier": "America/New_York", "timezone_abbr": "EST", "utc_offset_sec": -18000, "is_dst": "F" }, "acceptable_city_names": [], "area_codes": [ 732, 848 ] } }';
    System.debug(ZipCodeLocation.parseMultiple(jsonString).get('10008'));
    
    // Map<String, Object> resultMap = (Map<String, Object>) JSON.deserializeUntyped(jsonString);
    //     System.debug(resultMap);
List<String> postalcodes = new List<String>{'10008','07001'};
String a= 'a'+ postalcodes[0] + 'a';
System.debug(a);


List<Contact> con = [Select Id, MailingPostalCode, MailingCity, MailingCountry, MailingLatitude, MailingLongitude, MailingState from Contact];

        List<String> postalcodes = new List<String>();
        String endpoint = 'https://www.zipcodeapi.com/rest/War34GhxBC8tbA2VV69hfb6vdWMq3FCnhvZWHl8PXF5h2reFqpAB3MrWnxoTd7BY/multi-info.json/';
        Boolean isFirst = true;
        for (Contact eachcontact : con){
            if(eachcontact.MailingPostalCode!=null){
                postalcodes.add(eachcontact.MailingPostalCode);
            }
        }
           
    for(String eachpostalcode : postalcodes) {
        if(isFirst) {
            endpoint += eachpostalcode;
            isFirst = false;
        } else {
            endpoint += ',' + eachpostalcode;
            }
        
    }
            endpoint += '00001/degrees';

           HttpRequest apirequest = new HttpRequest();
           apirequest.setMethod('GET');
           apirequest.setEndpoint(endpoint);

           HttpResponse apiresponse = new Http().send(apirequest);

           Map<String, ZipCodeLocation> responsemap = ZipCodeLocation.parseMultiple(apiresponse.getBody());
           System.debug(responsemap);
           for (Contact eachcontact : con){
            if(eachcontact.MailingPostalCode!=null && responsemap.get(eachcontact.MailingPostalCode)!=null){
                
                eachcontact.MailingCity= responsemap.get(eachcontact.MailingPostalCode).city;
                System.debug(eachcontact);
            }
            

           }

Map<String, String> objectAPINameToLabelMap = new Map<String, String>();

// Getting all objects metadata
Map<String, Schema.SObjectType> globalDescribeMap = Schema.getGlobalDescribe();

// Processing each object one by one
for (String globalDescribeKey : globalDescribeMap.keySet()) {

    // Getting the current sObject type
    Schema.SObjectType currentSObjectType = globalDescribeMap.get(globalDescribeKey);

    // Getting the current sObject description result from sObjectType
    Schema.DescribeSObjectResult currentSObjectResult = currentSObjectType.getDescribe();
System.debug(currentSObjectResult);  
    // Getting the API name and value of current sObject and adding it to the map
    objectAPINameToLabelMap.put(currentSObjectResult.getName(), currentSObjectResult.getLabel());
}

// Returning the map



  