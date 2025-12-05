@IsTest
public class GGT_TripServiceTest {

    @IsTest
    static void testCreateAndGetTrips() {
        Account acc = GGT_TestDataFactory.createAccount();
        Opportunity opp = GGT_TestDataFactory.createOpportunity(acc);

        List<Trip__c> trips = new List<Trip__c>{
            new Trip__c(
                Status__c = 'A venir',
                Destination__c = 'Rome',
                Start_Date__c = Date.today().addDays(10),
                End_Date__c = Date.today().addDays(15),
                Number_of_Participants__c = 15,
                Total_Cost__c = 5000,
                Account__c = acc.Id,
                Opportunity__c = opp.Id
            )
        };

        // CREATE
        List<Trip__c> insertedTrips = GGT_TripService.createTrips(trips);
        System.assertEquals(1, insertedTrips.size(), 'One trip should be created');

        // READ
        List<Trip__c> retrieved = GGT_TripService.getTripsByStatus('A venir');
        System.assert(retrieved.size() > 0, 'There should be at least one trip with status A venir');
    }

    @IsTest
    static void testUpdateTrips() {
        Account acc = GGT_TestDataFactory.createAccount();
        Opportunity opp = GGT_TestDataFactory.createOpportunity(acc);
        Trip__c trip = GGT_TestDataFactory.createTrip(acc, opp);

        trip.Status__c = 'En cours';
        List<Trip__c> updated = GGT_TripService.updateTrips(new List<Trip__c>{ trip });
        System.assertEquals('En cours', updated[0].Status__c);
    }

    @IsTest
    static void testDeleteTrips() {
        Account acc = GGT_TestDataFactory.createAccount();
        Opportunity opp = GGT_TestDataFactory.createOpportunity(acc);
        Trip__c trip = GGT_TestDataFactory.createTrip(acc, opp);

        GGT_TripService.deleteTrips(new List<Id>{ trip.Id });

        List<Trip__c> remaining = [
            SELECT Id FROM Trip__c WHERE Id = :trip.Id
        ];
        System.assertEquals(0, remaining.size(), 'Trip should be deleted');
    }

    @IsTest
    static void testTripValidation_negativeCost() {
        Account acc = GGT_TestDataFactory.createAccount();
        Opportunity opp = GGT_TestDataFactory.createOpportunity(acc);

        Trip__c trip = new Trip__c(
            Status__c = 'A venir',
            Destination__c = 'Paris',
            Start_Date__c = Date.today(),
            End_Date__c = Date.today().addDays(3),
            Number_of_Participants__c = 10,
            Total_Cost__c = -100,
            Account__c = acc.Id,
            Opportunity__c = opp.Id
        );

        try {
            GGT_TripService.createTrips(new List<Trip__c>{ trip });
            System.assert(false, 'Exception should have been thrown for negative cost');
        } catch (GGT_ServiceException e) {
            System.assert(e.getMessage().contains('total cost cannot be negative'));
        }
    }
}