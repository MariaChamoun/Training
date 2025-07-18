public with sharing class Exercise1 {
    public static Map<String,Integer> occurrenceCount (List<String> nameList){
        Map<String,Integer> nameoccurenceMap = new Map<String,Integer>();
        
        for(String name : nameList){
            if(nameoccurenceMap.containsKey(name)){
                
                nameoccurenceMap.put(name,nameoccurenceMap.get(name)+ 1);
            }
            else {
                nameoccurenceMap.put(name,1);
            }
        }
        return nameoccurenceMap;
    }
}