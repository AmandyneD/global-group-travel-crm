@IsTest
public class GGT_OpportunityServiceTest {

    @IsTest
    static void testCreateAndGetOpportunities() {
        Account acc = GGT_TestDataFactory.createAccount();

        List<Opportunity> opps = new List<Opportunity>{
            new Opportunity(
                Name = 'Test Opp',
                StageName = 'Prospecting',
                CloseDate = Date.today().addDays(30),
                Amount = 5000,
                AccountId = acc.Id
            )
        };

        // CREATE
        List<Opportunity> inserted = GGT_OpportunityService.createOpportunities(opps);
        System.assertEquals(1, inserted.size());

        // READ
        List<Opportunity> retrieved = GGT_OpportunityService.getOpportunitiesByStage('Prospecting');
        System.assert(retrieved.size() > 0);
    }

    @IsTest
    static void testValidation_negativeAmount() {
        Account acc = GGT_TestDataFactory.createAccount();

        Opportunity opp = new Opportunity(
            Name = 'Bad Opp',
            StageName = 'Prospecting',
            CloseDate = Date.today().addDays(30),
            Amount = -100,
            AccountId = acc.Id
        );

        try {
            GGT_OpportunityService.createOpportunities(new List<Opportunity>{ opp });
            System.assert(false, 'Exception should have been thrown for negative amount');
        } catch (GGT_ServiceException e) {
            System.assert(e.getMessage().contains('cannot be negative'));
        }
    }
}