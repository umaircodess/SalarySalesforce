public class BatchPostalCodetoAddress implements Database.Batchable<sObject>,  Database.AllowsCallouts {

    public Database.QueryLocator start(Database.BatchableContext context) { 
        String query = 'Select Id, MailingPostalCode, MailingCity, MailingCountry, MailingLatitude, MailingLongitude, MailingState from Contact';
        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext context, List<Contact> listofcontacts){
        List<String> postalcodes = new List<String>();
        String endpoint = 'https://www.zipcodeapi.com/rest/War34GhxBC8tbA2VV69hfb6vdWMq3FCnhvZWHl8PXF5h2reFqpAB3MrWnxoTd7BY/multi-info.json/';
        for (Contact eachcontact : listofcontacts){
            if(eachcontact.MailingPostalCode!=null){
                postalcodes.add(eachcontact.MailingPostalCode);
            }
        }

    String postalcodelist = (String.join(postalcodes, ','));
            endpoint = endpoint+ postalcodelist +'/degrees';

           HttpRequest apirequest = new HttpRequest();
           apirequest.setMethod('GET');
           apirequest.setEndpoint(endpoint);

           HttpResponse apiresponse = new Http().send(apirequest);

           Map<String, ZipCodeLocation> responsemap = ZipCodeLocation.parseMultiple(apiresponse.getBody());

           for (Contact eachcontact : listofcontacts){
            if(eachcontact.MailingPostalCode!=null && responsemap.get(eachcontact.MailingPostalCode)!=null){
                eachcontact.MailingCity= responsemap.get(eachcontact.MailingPostalCode).city;
                eachcontact.MailingState= responsemap.get(eachcontact.MailingPostalCode).state;
                eachcontact.MailingLatitude= responsemap.get(eachcontact.MailingPostalCode).lat;
                eachcontact.MailingLongitude= responsemap.get(eachcontact.MailingPostalCode).lng;
            }
            

           }

           update listofcontacts;

        }

        public void finish (Database.BatchableContext context){
        
        System.debug('Done');
        
    }
}