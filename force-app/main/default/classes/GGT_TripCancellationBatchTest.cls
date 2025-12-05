@IsTest
public class GGT_TripCancellationBatchTest {

    @IsTest
    static void testTripCancellationBatch() {
        // GIVEN : Création de données
        Account acc = GGT_TestDataFactory.createAccount();
        Opportunity opp = GGT_TestDataFactory.createOpportunity(acc);

        Trip__c trip1 = new Trip__c(
            Account__c = acc.Id,
            Opportunity__c = opp.Id,
            Number_of_Participants__c = 5,
            Status__c = 'A venir'
        );
        Trip__c trip2 = new Trip__c(
            Account__c = acc.Id,
            Opportunity__c = opp.Id,
            Number_of_Participants__c = 25,
            Status__c = 'A venir'
        );
        insert new List<Trip__c>{ trip1, trip2 };

        // WHEN : exécuter le batch
        Test.startTest();
        Database.executeBatch(new GGT_TripCancellationBatch(), 200);
        Test.stopTest();

        // THEN : validation
        Trip__c t1 = [SELECT Status__c FROM Trip__c WHERE Id = :trip1.Id];
        Trip__c t2 = [SELECT Status__c FROM Trip__c WHERE Id = :trip2.Id];

        System.assertEquals('Annulé', t1.Status__c,
            'Trip with <10 participants should be cancelled');
        System.assertEquals('A venir', t2.Status__c,
            'Trip with >=10 participants should NOT be cancelled');
    }
}