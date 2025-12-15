@IsTest
public class GGT_TripStatusUpdateBatchTest {

    @IsTest
    static void testTripStatusUpdateBatch() {

        // GIVEN
        Account acc = GGT_TestDataFactory.createAccount();
        Opportunity opp = GGT_TestDataFactory.createOpportunity(acc);

        Date today = Date.today();

        // Trip futur : doit devenir "A venir"
        Trip__c futureTrip = new Trip__c(
            Account__c = acc.Id,
            Opportunity__c = opp.Id,
            Start_Date__c = today.addDays(10),
            End_Date__c = today.addDays(15),
            Number_of_Participants__c = 20,
            Status__c = 'En cours'
        );

        // Trip en cours : doit devenir "En cours"
        Trip__c ongoingTrip = new Trip__c(
            Account__c = acc.Id,
            Opportunity__c = opp.Id,
            Start_Date__c = today.addDays(-2),
            End_Date__c = today.addDays(3),
            Number_of_Participants__c = 20,
            Status__c = 'A venir'
        );

        // Trip passé : doit devenir "Terminé"
        Trip__c pastTrip = new Trip__c(
            Account__c = acc.Id,
            Opportunity__c = opp.Id,
            Start_Date__c = today.addDays(-10),
            End_Date__c = today.addDays(-5),
            Number_of_Participants__c = 20,
            Status__c = 'En cours'
        );

        // Trip annulé : NE DOIT PAS ÊTRE MODIFIÉ
        Trip__c cancelledTrip = new Trip__c(
            Account__c = acc.Id,
            Opportunity__c = opp.Id,
            Start_Date__c = today.addDays(-1),
            End_Date__c = today.addDays(1),
            Number_of_Participants__c = 5,
            Status__c = 'Annulé'
        );

        insert new List<Trip__c>{
            futureTrip,
            ongoingTrip,
            pastTrip,
            cancelledTrip
        };

        // WHEN
        Test.startTest();
        Database.executeBatch(new GGT_TripStatusUpdateBatch(), 200);
        Test.stopTest();

        // THEN
        Map<Id, Trip__c> tripsById = new Map<Id, Trip__c>([
            SELECT Id, Status__c
            FROM Trip__c
            WHERE Id IN :new List<Id>{
                futureTrip.Id,
                ongoingTrip.Id,
                pastTrip.Id,
                cancelledTrip.Id
            }
        ]);

        System.assertEquals(
            'A venir',
            tripsById.get(futureTrip.Id).Status__c,
            'Future trip should be A venir'
        );

        System.assertEquals(
            'En cours',
            tripsById.get(ongoingTrip.Id).Status__c,
            'Ongoing trip should be En cours'
        );

        System.assertEquals(
            'Terminé',
            tripsById.get(pastTrip.Id).Status__c,
            'Past trip should be Terminé'
        );

        System.assertEquals(
            'Annulé',
            tripsById.get(cancelledTrip.Id).Status__c,
            'Cancelled trip status must remain Annulé'
        );
    }
}