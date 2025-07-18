
@isTest
public class Exercise2_Test {
    
    @isTest
    static void insertcontactsTest() {
        // TO DO: implement unit test
        Account testaccount = new Account(Name='Test Account');
        insert testaccount;
        Contact testcontact1 = new Contact(FirstName='Maria' , LastName = 'Smith' , accountId = testaccount.Id);
        Contact testcontact2 = new Contact(FirstName='Rayan' , LastName = 'Ballout' , accountId = testaccount.Id);
        

        insert new List<Contact>{testcontact1 ,testcontact2} ;
        
        Account acc=[SELECT Number_of_Contacts__c FROM testaccount WHERE Id = :testaccount.Id] ;
        System.assertEquals(1, acc.Number_of_Contacts__c);
        testcontact1.FirstName ='';
        testcontact2.LastName='Smith';
        update new List<Contact> {testcontact1 ,testcontact2};
        Account acc=[SELECT Number_of_Contacts__c FROM testaccount WHERE Id = :testaccount.Id] ;
        System.assertEquals(2, acc.Number_of_Contacts__c);
        
    }
}