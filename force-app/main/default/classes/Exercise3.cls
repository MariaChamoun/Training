public with sharing class Exercise3 {
    public static void checkCompetitor(List<Competitor__c> newCompetitors , Map<Id,Competitor__c> oldCompetitors ){
        Set<Id> accOppIdSet = new Set<Id>();
        Set<Id> accQuoteIdSet = new Set<Id>();
        for(Competitor__c compt : newCompetitors){
            if(oldCompetitors == Null || oldCompetitors.get(compt.id).Account__c != compt.Account__c){
                if( compt.Opportunity__c != Null ){
                    accOppIdSet.add(compt.Account__c);
                }
                if (compt.Quote__c != Null){
                    accQuoteIdSet.add(compt.Account__c);
                }
            }
        }
        List<Competitor__c> comptToCheck1 = [SELECT Id FROM Competitor__c WHERE Account__c IN :accOppIdSet AND Opportunity__c !=Null];
        List<Competitor__c> comptToCheck2 = [SELECT Id FROM Competitor__c WHERE Account__c IN :accQuoteIdSet AND Quote__c !=Null];
        
        for(Competitor__c exisitingComp : comptToCheck1){
            for(Competitor__c newComp: newCompetitors){
                if(exisitingComp.Account__c == newComp.Account__c){
                    newComp.addError('ERROR');
                }
            }
        }
        for(Competitor__c exisitingComp : comptToCheck2){
            for(Competitor__c newComp: newCompetitors){
                if(exisitingComp.Account__c == newComp.Account__c){
                    newComp.addError('ERROR');
                }
            }
        }
        
    }


    // balshiii asra3 
    public static void addCompetitor (List<Competitor__c> newCompetitors , Map<Id,Competitor__c> oldCompetitors  ){
        Map<Id,Id> quoteIdToAccountIdMap = new Map<Id,Id>();
        for(Competitor__c comp : newCompetitors){
            quoteIdToAccountIdMap.add(comp.Quote__c,comp.Account__c);
        }
        for(Quote__c quote : [SELECT Opportunity__c FROM Quote__c WHERE Id IN :quoteIdToAccountIdMap.keySet()]){
            Competitor__c newCompetitor = new Competitor__c();
            newCompetitor.Opportunity__c = quote.Opportunity__c;
            newCompetitor.Account__c = quoteIdToAccountIdMap.get(quote.Id);
        }
        List<Competitor__c> newCompetitorsList = new List<Competitor__c>();
        




    }
}
