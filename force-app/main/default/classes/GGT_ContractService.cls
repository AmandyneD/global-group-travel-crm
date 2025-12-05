@IsTest
public class GGT_ContractServiceTest {

    @IsTest
    static void testCreateContracts() {
        // GIVEN
        Account acc = GGT_TestDataFactory.createAccount();

        List<Contract> contracts = new List<Contract>{
            new Contract(
                AccountId = acc.Id,
                Status = 'Draft',
                StartDate = Date.today(),
                EndDate = Date.today().addMonths(6)
            )
        };

        // WHEN
        List<Contract> inserted = GGT_ContractService.createContracts(contracts);

        // THEN
        System.assertEquals(1, inserted.size(), 'One contract should have been inserted');

        Contract result = [
            SELECT Id, AccountId FROM Contract WHERE Id = :inserted[0].Id
        ];
        System.assertEquals(acc.Id, result.AccountId);
    }

    @IsTest
    static void testGetActiveContractsByAccount() {
        // GIVEN
        Account acc = GGT_TestDataFactory.createAccount();
        
        Contract activeContract = new Contract(
            AccountId = acc.Id,
            Status = 'Activated',
            StartDate = Date.today(),
            EndDate = Date.today().addMonths(12)
        );
        insert activeContract;

        // WHEN
        List<Contract> results = GGT_ContractService.getActiveContractsByAccount(acc.Id);

        // THEN
        System.assert(results.size() > 0, 'Should return at least one active contract');
    }

    @IsTest
    static void testUpdateContracts() {
        // GIVEN
        Account acc = GGT_TestDataFactory.createAccount();
        Contract c = GGT_TestDataFactory.createContract(acc);

        c.Status = 'Activated';

        // WHEN
        List<Contract> updated = GGT_ContractService.updateContracts(new List<Contract>{ c });

        // THEN
        System.assertEquals('Activated', updated[0].Status);
    }

    @IsTest
    static void testDeleteContracts() {
        // GIVEN
        Account acc = GGT_TestDataFactory.createAccount();
        Contract c = GGT_TestDataFactory.createContract(acc);

        // WHEN
        GGT_ContractService.deleteContracts(new List<Id>{ c.Id });

        // THEN
        System.assertEquals(
            0,
            [SELECT Id FROM Contract WHERE Id = :c.Id].size(),
            'Contract should have been deleted'
        );
    }

    @IsTest
    static void testContractValidation_missingAccount() {
        // GIVEN
        Contract c = new Contract(
            Status = 'Draft',
            StartDate = Date.today(),
            EndDate = Date.today().addMonths(1)
        ); // PAS d'AccountId

        // WHEN / THEN
        try {
            GGT_ContractService.createContracts(new List<Contract>{ c });
            System.assert(false, 'Expected exception for missing AccountId');
        } catch (GGT_ServiceException e) {
            System.assert(e.getMessage().contains('Account'), 'Error message should mention Account');
        }
    }

    @IsTest
    static void testContractValidation_badDates() {
        // GIVEN
        Account acc = GGT_TestDataFactory.createAccount();

        Contract c = new Contract(
            AccountId = acc.Id,
            Status = 'Draft',
            StartDate = Date.today().addMonths(2),
            EndDate = Date.today().addMonths(1) // fin avant début -> invalide
        );

        // WHEN / THEN
        try {
            GGT_ContractService.createContracts(new List<Contract>{ c });
            System.assert(false, 'Expected exception for invalid date range');
        } catch (GGT_ServiceException e) {
            System.assert(e.getMessage().contains('StartDate'), 'Invalid dates should trigger validation');
        }
    }
}