public without sharing class CertificationAttemptTriggerHandler {
    
    public static void createCertificationHeld(List<Certification_Attempt__c> certAttempts, Map<Id, Certification_Attempt__c> oldMap) {
        
        /**
        * If a Contact successfully passes a Certification Attempt, then the code
        * will gather the data necessary to perform a query for related Certification
        * Attempt records.
        */
        
        System.Debug('Calling the createCertificationHeld method');
        
        // The set of candidates and certifications. Used to filter SOQL 
        // query when looking at existing cert attempt records
        Set<Id> candidates = new Set<Id>();
        Set<Id> certifications = new Set<Id>();
        List<Certification_Attempt__c> certAttemptsPass = new List<Certification_Attempt__c>();
        Map<String, Integer> passCounts = new Map<String, Integer>();
        Map<String , Certification_Held__c> certsHeldToAdd = new Map<String , Certification_Held__c>();
        
        // Extract candidates and certifications from incoming records that have the status 'Complete/Pass'
        for (Certification_Attempt__c attempt : certAttempts) {
            if (attempt.Status__c== 'Complete/Pass' && (oldMap==null || oldMap.get(attempt.Id).Status__c!='Complete/Pass')) {
                candidates.add(attempt.Certification_Candidate__c);
                certifications.add(attempt.Certification_Id__c);
                certAttemptsPass.add(attempt);
                
                
            }
        }
        
        for (List<Certification_Attempt__c> cAs : [SELECT Id, Certification_Id__c, Certification_Candidate__c, Number_of_Elements_for_Cert__c
        FROM Certification_Attempt__c
        WHERE Certification_Candidate__c IN :candidates
        AND Status__c = 'Complete/Pass' AND Certification_element__r.Certification__c IN :certifications]) {
            for (Certification_Attempt__c cA : cAs) {
                System.debug('Retrieved certAttempt id' + cA.id + ' candidate id'
                + cA.Certification_Id__c + ' certification id' + cA.Certification_Candidate__c
                + ' number of elements for cert ' + cA.Number_of_Elements_for_Cert__c);
                String curKey = cA.Certification_Candidate__c + cA.Certification_Id__c;
                if (passCounts.containsKey(curKey)) {
                    passCounts.put(curKey, (passCounts.get(curKey) + 1));
                } else {
                    passCounts.put(curKey, 1);
                }
            }
        }
        
        System.debug('Size of passCounts = ' + passCounts.size());
        for(Certification_Attempt__c certAttempt : certAttemptsPass ){
            String currKey = certAttempt.Certification_Candidate__c + certAttempt.Certification_Id__c;
            if(passCounts.get(currKey) == certAttempt.Number_Of_Elements_For_Cert__c){
                Certification_Held__c certheld = new Certification_Held__c();
                certheld.Date_Achieved__c = certAttempt.Attempt_Date__c;
                certheld.Certification__c = certAttempt.Certification_Id__c;
                certheld.Certified_Professional__c = certAttempt.Certification_Candidate__c;
                certsHeldToAdd.put(currKey,certheld);
            }
        }
        try{
            if(certsHeldToAdd.size() > 0 ){
                insert certsHeldToAdd.values();
                System.debug(certsHeldToAdd.size());
            }
        }
        catch(System.DmlException ex){
            Error_Log__c err = new Error_Log__c();
            err.Source__c = 'createCertificationHeld';
            err.message__c = ex.getMessage();
            insert err;
            
            
        }
    }


public static void grantInstructorSharingAccess(List<Certification_Attempt__c> triggerNew, Map<Id, Certification_Attempt__c> oldMap, Boolean isInsert, Boolean isUpdate) {
    
    /**
    *  When a new certification attempt object is assigned an
    *  instructor, or if an instructor changes on an existing
    *  object, give the new instructor access to the record by
    *  creating a share object, and remove access for the
    *  previous instructor (if it is an update of that field)
    */
    
    System.debug('Starting the Grant Instructor Sharing Access logic');
    
    // List of share records to insert in bulk
    List<Certification_Attempt__Share> sharesToCreate = new List<Certification_Attempt__Share>();
    
    // List of share records to delete in bulk
    List<Certification_Attempt__Share> sharesToDelete = new List<Certification_Attempt__Share>();
    
    // Map of the CertAttemptID to the Instructor User ID
    Map<Id, Id>certAttemptToInstructorMap = new Map<Id, Id>();
    
    // Loop through all the records in the trigger
    for (Certification_Attempt__c certAttempt : triggerNew) {
        
        // Check to see if this is an insert or the Instructor has changed
        if (isInsert || certAttempt.Certifying_Instructor__c != oldMap.get(certAttempt.Id).Certifying_Instructor__c) {
            // Create new Share record for the Instructor and add to list
            if (certAttempt.Certifying_Instructor__c != null) {
                Certification_Attempt__Share certAttemptShare = new Certification_Attempt__Share(
                parentId = certAttempt.Id,
                userOrGroupId = certAttempt.Certifying_Instructor__c,
                rowCause = Schema.Certification_Attempt__Share.RowCause.Certifying_Instructor__c,
                accessLevel = 'Edit'
                );
                sharesToCreate.add(certAttemptShare);
            }
        }
        
        if (isUpdate) {
            // See the Instructor has changed
            if ( certAttempt.Certifying_Instructor__c != oldMap.get(certAttempt.Id).Certifying_Instructor__c ) {
                // Add to map of Instructor changes
                System.debug('certAttempt.Certifying_Instructor__c is: ' + certAttempt.Certifying_Instructor__c);
                certAttemptToInstructorMap.put(certAttempt.Id, certAttempt.Certifying_Instructor__c);
            }
        }
    }
    
    if ( certAttemptToInstructorMap.size() > 0 ) {
        
        System.debug('certAttemptToInstructorMap is: ' + certAttemptToInstructorMap);
        
        for (Certification_Attempt__Share certAttemptShare :
        [SELECT UserOrGroupId, RowCause, ParentId, Id, AccessLevel
        FROM Certification_Attempt__Share
        WHERE ParentId IN :certAttemptToInstructorMap.keySet()
        AND RowCause = 'Certifying_Instructor__c']) {
            if (certAttemptToInstructorMap.get(certAttemptShare.ParentId) != certAttemptShare.UserOrGroupId) {
                sharesToDelete.add(certAttemptShare);
            }
        }
    }
    
    try {
        if ( sharesToCreate.size() > 0 ) {
            insert sharesToCreate;
        }
        if ( sharesToDelete.size() > 0) {
            delete sharesToDelete;
        }
    } catch (System.DmlException ex) {
        Error_Log__c err = new Error_Log__c();
        err.Source__c = 'grantInstructorSharingAccess';
        err.message__c = ex.getMessage();
        insert err;
    }
}

public static void validateCertificationAttempt(List<Certification_Attempt__c> triggerNew) {
    
    /**
    *  If a Contact is trying to create a Certification Attempt
    *  for an element that was already marked as "Complete/Pass"
    *  or "In Progress", then do not allow the attempt to be
    *  created and pass back an error
    */
    
    System.debug('Starting the Validate Certification Attempt logic');
    
    // All Certification_Attempt__c records which are 'In Progress' OR 'Complete/Pass' will be stored here for comparison purposes
    Set<String> concatStudentElement = new Set<String>();
    Set<ID> candidateIDs = new Set<ID>();
    for (Certification_Attempt__c dbca : triggerNew) {
        candidateIDs.add(dbca.Certification_Candidate__c);
    }
    for (Certification_Attempt__c dbca : [SELECT Certification_Candidate__c, Certification_Element__c, Status__c
    FROM Certification_Attempt__c
    WHERE Status__c IN ('In Progress', 'Complete/Pass')
    AND Certification_Candidate__c IN :candidateIDs]) {
        // We need to know 1. Which student 2. Which element they have attempted (lab or multiple choice) 3. The status
        concatStudentElement.add((String)dbca.Certification_Candidate__c + (String)dbca.Certification_Element__c + (String)dbca.Status__c);
    }
    
    for (Certification_Attempt__c ca : triggerNew) {
        // If any element is In Progress or Complete/Pass, new attempts should not be allowed for those elements
        if (concatStudentElement.contains((String)ca.Certification_Candidate__c + (String)ca.Certification_Element__c + 'In Progress') ||
        concatStudentElement.contains((String)ca.Certification_Candidate__c + (String)ca.Certification_Element__c + 'Complete/Pass')) {
            ca.addError('Cannot attempt cert for element already in progress or completed');
        }
    }
}
}