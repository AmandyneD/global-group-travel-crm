@IsTest
public class GGT_TestDataFactory {

    public static Account createAccount() {
        Account acc = new Account(
            Name = 'Test Account ' + Datetime.now().getTime()
        );
        insert acc;
        return acc;
    }

    public static Opportunity createOpportunity(Account acc) {
        Opportunity opp = new Opportunity(
            Name = 'Test Opportunity ' + Datetime.now().getTime(),
            StageName = 'Prospecting',
            CloseDate = Date.today().addDays(30),
            Amount = 10000,
            AccountId = acc.Id,
            Number_of_Participants__c = 20,
            Destination__c = 'Barcelone',
            Start_Date__c = Date.today().addDays(60),
            End_Date__c = Date.today().addDays(65)
        );
        insert opp;
        return opp;
    }

    public static Contract createContract(Account acc) {
        Contract c = new Contract(
            AccountId = acc.Id,
            Status = 'Draft',
            StartDate = Date.today(),
            EndDate = Date.today().addMonths(12)
        );
        insert c;
        return c;
    }

    public static Trip__c createTrip(Account acc, Opportunity opp) {
        Trip__c trip = new Trip__c(
            Status__c = 'A venir',
            Destination__c = 'Barcelone',
            Start_Date__c = Date.today().addDays(60),
            End_Date__c = Date.today().addDays(65),
            Number_of_Participants__c = 20,
            Total_Cost__c = 10000,
            Account__c = acc.Id,
            Opportunity__c = opp.Id
        );
        insert trip;
        return trip;
    }
}