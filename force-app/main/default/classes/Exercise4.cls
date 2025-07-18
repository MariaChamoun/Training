public with sharing class Exercise4 {
    public static void createOffer(List<Offer__c> newList , Map<Id,Offer__c> oldMap) {
        Map<Id,List<Offer__c>> oppIdToOfferMap = new Map<Id,List<Offer__c>>();
        
        for(Offer__c off : newList){
            if(oldMap == Null || oldMap.get(off.Id).Opportunity__c != off.Opportunity__c ){
                if(oppIdToOfferMap.ContainsKey(off.Opportunity__c)){
                    oppIdToOfferMap.get(off.Opportunity__c).add(off);
                }else{
                    oppIdToOfferMap.put(off.Opportunity__c, new List<Offer__c> {off});
                }
            }
        }
        if(!oppIdToOfferMap.isEmpty()){
            for(Opportunity opp :[SELECT Identifier__c , TECH_OfferCount__c FROM Opportunity WHERE Id IN:oppIdToOfferMap.keySet()] ){
                Integer num = (Integer)opp.TECH_OfferCount__c;
                for( Offer__c off : oppIdToOfferMap.get(opp.Id)){
                    String countString = String.valueOf(++num);
                    countString = countString.length() == 1 ? '00' + countString :countString.length() == 2? '0' +countString : countString;
                    
                    off.Identifier__c = opp.Identifier__c + '-' + countString;
                }
            }
        }
    }
}