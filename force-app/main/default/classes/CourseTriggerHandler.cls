public with sharing class CourseTriggerHandler {
    
    static final String RETIRED = 'Retired';
    static final String ENROLLED = 'Enrolled';
    static final String SCHEDULED = 'Scheduled';
    static final String CANCELLED = 'Cancelled';
    static final String COURSE_ERROR_MESSAGE = 'Course has enrolled students'; // Optionally replace text with a custom label
    static final String DELIVERY_ERROR_MESSAGE = 'Unable to update scheduled delivery status'; // Optionally replace text with a custom label
    
    
    public static void checkStatus(List<Course__c> triggerNew, Map<Id, Course__c> oldMap, Map<Id, Course__c> newMap)  {
        
        /**
        *  If a Course Status is changed to retired, then we need to check to see if there are any Course Delivery records marked
        *  as Scheduled. If there is at least one attendee marked as Enrolled, then the change to retired should not happen
        *  and an error message passed back
        */
        
        // Initialize a Set of Id's named courseIds
        Set<Id> courseIds = new Set<Id>();
        
        // Loop through all Course Delivery records to look for attendees
        for (Course__c course : triggerNew) {
            if (oldMap.get(course.Id).Status__c != RETIRED && course.Status__c == RETIRED) {
                
                // Add the course Id to the set named courseIds
                courseIds.add(course.Id);
            }
        }
        // Check to see that we have records to process
        if (courseIds.size() > 0) {
            for (List<Course_Delivery__c> cds : [SELECT Id, Course__c, Status__c, (SELECT Status__c FROM Course_Attendees__r WHERE Status__c = :ENROLLED)
            FROM Course_Delivery__c
            WHERE Course__c IN :courseIds AND Status__c = :SCHEDULED]) {
                
                List<Course_Delivery__c> courseDeliveriesToUpdate = new List<Course_Delivery__c>();
                for(Course_Delivery__c cd : cds){
                    if (cd.Course_Attendees__r != null && cd.Course_Attendees__r.size() > 0) {
                        newMap.get(cd.Course__c).addError(COURSE_ERROR_MESSAGE);
                    } else {
                        // Change the status of the Course Delivery record to 'Cancelled'
                        cd.Status__c = CANCELLED;
                        courseDeliveriesToUpdate.add(cd);
                    }
                }
                if(courseDeliveriesToUpdate.size() > 0){
                    List<Database.SaveResult> lsr = Database.update(courseDeliveriesToUpdate,false);
                    for(Integer i =0; i<courseDeliveriesToUpdate.size() ; i++){
                        if (lsr[i].isSuccess() == false) {
                            newMap.get(courseDeliveriesToUpdate[i].Course__c).addError(DELIVERY_ERROR_MESSAGE);
                        } 
                    }
                    
                }
                
            }
        }        
    }
}