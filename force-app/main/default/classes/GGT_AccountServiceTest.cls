@IsTest
public class GGT_AccountServiceTest {

    @IsTest
    static void testCreateAccounts() {
        // GIVEN
        List<Account> accounts = new List<Account>{
            new Account(Name = 'Test Account A'),
            new Account(Name = 'Test Account B')
        };

        // WHEN
        List<Account> insertedAccounts = GGT_AccountService.createAccounts(accounts);

        // THEN
        System.assertEquals(2, insertedAccounts.size(), 'Two accounts should have been created');

        List<Account> fetched = [
            SELECT Id, Name FROM Account WHERE Id IN :insertedAccounts
        ];
        System.assertEquals(2, fetched.size(), 'Accounts should exist in the database');
    }

    @IsTest
    static void testReadAccountsByName() {
        // GIVEN
        Account acc = GGT_TestDataFactory.createAccount();

        // WHEN
        List<Account> results = GGT_AccountService.getAccountsByName('Test Account');

        // THEN
        System.assert(results.size() > 0, 'At least one account should be returned');
    }

    @IsTest
    static void testUpdateAccounts() {
        // GIVEN
        Account acc = GGT_TestDataFactory.createAccount();
        acc.Name = 'Updated Name';

        // WHEN
        List<Account> updated = GGT_AccountService.updateAccounts(new List<Account>{ acc });

        // THEN
        System.assertEquals('Updated Name', updated[0].Name);
    }

    @IsTest
    static void testDeleteAccounts() {
        // GIVEN
        Account acc = GGT_TestDataFactory.createAccount();

        // WHEN
        GGT_AccountService.deleteAccounts(new List<Id>{ acc.Id });

        // THEN
        List<Account> res = [
            SELECT Id FROM Account WHERE Id = :acc.Id
        ];
        System.assertEquals(0, res.size(), 'Account should have been deleted');
    }

    @IsTest
    static void testAccountValidation_missingName() {
        // GIVEN
        Account acc = new Account(); // pas de name -> invalide

        // WHEN / THEN
        try {
            GGT_AccountService.createAccounts(new List<Account>{ acc });
            System.assert(false, 'Expected exception for missing account name');
        } catch (GGT_ServiceException e) {
            System.assert(e.getMessage().contains('Name'), 'Error message should mention missing name');
        }
    }
}