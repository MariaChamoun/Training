public with sharing class Exercise2 {
    public static void updateField (List<Contact> newcontacts , Map<Id,Contact> oldMap){
        Set<Id> accountIdSet = new Set<Id>();
        for(Contact cts : newcontacts ){
            if(oldMap == Null || oldMap.get(cts.id).FirstName != cts.FirstName || 
            oldMap.get(cts.id).LastName != cts.LastName){
                accountIdSet.add(cts.accountId);
            }
        }
        List<Account> accountsToUpdate = new List<Account>();
        for(Account acc : [SELECT Id, (SELECT Id , FirstName , LastName FROM Contacts 
        WHERE FirstName = '' OR LastName = 'Smith'  ) FROM Account WHERE Id IN :accountIdSet] ){
            acc.Number_of_Contacts__c = acc.Contacts.size();
            accountsToUpdate.add(acc);
        } 
        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
        }
    }
}