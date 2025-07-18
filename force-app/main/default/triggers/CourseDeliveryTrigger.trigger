trigger CourseDeliveryTrigger on Course_Delivery__c (before insert, before update,before delete) {

    // Retrieve the Custom Metadata Type record for this trigger
    Trigger_Switch__mdt tsw = Trigger_Switch__mdt.getInstance('Course_Delivery_Trigger');

    // If no Custom Metadata Type record found or if the active flag is set to true then execute the trigger logic
    if (tsw == null || tsw.Active_Flag__c == true) {
        if(!Trigger.isDelete){
            CourseDeliveryTriggerHandler.preventInvalidCourseDeliveries(Trigger.new, Trigger.oldMap);
           }

}
}