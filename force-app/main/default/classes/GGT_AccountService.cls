public with sharing class GGT_AccountService {

    // CREATE
    public static List<Account> createAccounts(List<Account> accounts) {
        if (accounts == null || accounts.isEmpty()) {
            return new List<Account>();
        }
        validateAccounts(accounts);
        System.debug(LoggingLevel.INFO, 'GGT_AccountService.createAccounts - Inserting ' + accounts.size() + ' accounts');
        insert accounts;
        return accounts;
    }

    // READ
    public static List<Account> getAccountsByName(String nameFragment) {
        String filter = String.isBlank(nameFragment) ? '%' : '%' + nameFragment + '%';
        System.debug(LoggingLevel.DEBUG, 'GGT_AccountService.getAccountsByName - filter = ' + filter);

        return [
            SELECT Id, Name, Industry, Phone, BillingCity
            FROM Account
            WHERE Name LIKE :filter
            LIMIT 50
        ];
    }

    // UPDATE
    public static List<Account> updateAccounts(List<Account> accounts) {
        if (accounts == null || accounts.isEmpty()) {
            return new List<Account>();
        }
        validateAccounts(accounts);
        System.debug(LoggingLevel.INFO, 'GGT_AccountService.updateAccounts - Updating ' + accounts.size() + ' accounts');
        update accounts;
        return accounts;
    }

    // DELETE
    public static void deleteAccounts(List<Id> accountIds) {
        if (accountIds == null || accountIds.isEmpty()) {
            return;
        }
        System.debug(LoggingLevel.INFO, 'GGT_AccountService.deleteAccounts - Deleting ' + accountIds.size() + ' accounts');
        delete [SELECT Id FROM Account WHERE Id IN :accountIds];
    }

    // VALIDATION
    private static void validateAccounts(List<Account> accounts) {
        for (Account acc : accounts) {
            if (String.isBlank(acc.Name)) {
                throw new GGT_ServiceException('Account Name is required.');
            }
        }
    }
}