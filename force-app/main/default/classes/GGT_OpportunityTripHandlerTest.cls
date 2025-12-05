@IsTest
public class GGT_OpportunityTripHandlerTest {

    @IsTest
    static void testTripCreationOnClosedWon() {
        // GIVEN
        Account acc = GGT_TestDataFactory.createAccount();

        Opportunity opp = new Opportunity(
            Name = 'Opp Test',
            StageName = 'Prospecting',
            CloseDate = Date.today().addDays(10),
            Amount = 8000,
            AccountId = acc.Id,
            Destination__c = 'Lisbonne',
            Number_of_Participants__c = 25,
            Start_Date__c = Date.today().addDays(30),
            End_Date__c = Date.today().addDays(35)
        );
        insert opp;

        // WHEN : opportunité devient gagnée
        opp.StageName = 'Closed Won';
        update opp;

        // THEN : un Trip doit avoir été créé
        Trip__c trip = [
            SELECT Id, Opportunity__c, Account__c, Destination__c,
                   Number_of_Participants__c, Start_Date__c, End_Date__c,
                   Total_Cost__c, Status__c
            FROM Trip__c
            WHERE Opportunity__c = :opp.Id
            LIMIT 1
        ];

        System.assertEquals(acc.Id, trip.Account__c);
        System.assertEquals('Lisbonne', trip.Destination__c);
        System.assertEquals(25, trip.Number_of_Participants__c);
        System.assertEquals(opp.Start_Date__c, trip.Start_Date__c);
        System.assertEquals(opp.End_Date__c, trip.End_Date__c);
        System.assertEquals(8000, trip.Total_Cost__c);
        System.assertEquals('A venir', trip.Status__c);
    }

    @IsTest
    static void testNoDuplicateTripCreation() {
        // GIVEN
        Account acc = GGT_TestDataFactory.createAccount();

        Opportunity opp = GGT_TestDataFactory.createOpportunity(acc);
        opp.StageName = 'Closed Won';
        update opp; // 1er Trip créé

        // WHEN : on met à jour autre champ mais pas le stage
        opp.Amount = 9999;
        update opp;

        // THEN : toujours un seul Trip
        Integer tripCount = [
            SELECT COUNT() FROM Trip__c WHERE Opportunity__c = :opp.Id
        ];
        System.assertEquals(1, tripCount, 'No duplicate trips should be created');
    }

    @IsTest
    static void testBulkTripCreation() {
        // GIVEN
        Account acc = GGT_TestDataFactory.createAccount();

        List<Opportunity> opps = new List<Opportunity>();

        for (Integer i = 0; i < 10; i++) {
            opps.add(new Opportunity(
                Name = 'Bulk Opp ' + i,
                StageName = 'Prospecting',
                CloseDate = Date.today().addDays(10),
                Amount = 5000,
                AccountId = acc.Id
            ));
        }
        insert opps;

        // WHEN - toutes deviennent Closed Won en bulk
        for (Opportunity o : opps) {
            o.StageName = 'Closed Won';
        }
        update opps;

        // THEN
        Integer trips = [
            SELECT COUNT() FROM Trip__c WHERE Opportunity__c IN :opps
        ];
        System.assertEquals(10, trips, '10 trips should have been created in bulk');
    }
}