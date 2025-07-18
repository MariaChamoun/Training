@isTest
public with sharing class Exercise4_Test {
    @isTest
    static void insertOppTest(){
        Account acc = new Account(Name = 'Test Account');
        insert acc;
        Opportunity opp = new Opportunity(Name = 'Test Opportunity 1' , AccountId = acc.Id, Identifier__c ='EIT' ,CloseDate = Date.today(),StageName = 'Prospecting' );
        insert opp;
        Opportunity opp2 = new Opportunity(Name = 'Test Opportunity 2' , AccountId = acc.Id, Identifier__c ='FWZ' ,CloseDate = Date.today(),StageName = 'Prospecting');
        insert opp2;

        Opportunity opps = [SELECT Identifier__c , TECH_OfferCount__c FROM Opportunity];
        
        Offer__c off1 = new Offer__c(Name = 'Test Offer 1' ,  Opportunity__c = opp.Id);
        Offer__c off2 = new Offer__c(Name = 'Test Offer 2' ,  Opportunity__c = opp.Id);

        insert off1;
        off1 = [SELECT  Identifier__c FROM Offer__c WHERE ID=:off1.id];
        System.assertEquals(off1.Identifier__c, 'EIT-001' );

        insert off2;

        off2 = [SELECT  Identifier__c FROM Offer__c WHERE ID=:off2.id];
        System.assertEquals(off2.Identifier__c, 'EIT-001' );

    }
    
    
    
    
    
    
    
    
}