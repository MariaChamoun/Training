public with sharing class opportunitiesToAccount {
    @AuraEnabled(cacheable=true)
    public static List<Opportunity> getOpportunitiesByAccount(Id accountId){
        return [SELECT Id, Name , Amount , StageName , CloseDate
        FROM Opportunity WHERE AccountId=:accountId ORDER BY Amount DESC];
    }
}