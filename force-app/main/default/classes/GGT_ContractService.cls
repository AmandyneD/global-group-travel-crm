public with sharing class GGT_ContractService {

    // CREATE
    public static List<Contract> createContracts(List<Contract> contracts) {
        if (contracts == null || contracts.isEmpty()) {
            return new List<Contract>();
        }
        validateContracts(contracts);
        System.debug(LoggingLevel.INFO,
            'GGT_ContractService.createContracts - Inserting ' + contracts.size() + ' contract(s)');
        insert contracts;
        return contracts;
    }

    // READ - Active contracts for a given account
    public static List<Contract> getActiveContractsByAccount(Id accountId) {
        if (accountId == null) {
            throw new GGT_ServiceException('Account Id is required.');
        }

        System.debug(LoggingLevel.DEBUG,
            'GGT_ContractService.getActiveContractsByAccount - AccountId = ' + accountId);

        return [
            SELECT Id, ContractNumber, Status, StartDate, EndDate, AccountId
            FROM Contract
            WHERE AccountId = :accountId
              AND Status = 'Activated'
            LIMIT 50
        ];
    }

    // UPDATE
    public static List<Contract> updateContracts(List<Contract> contracts) {
        if (contracts == null || contracts.isEmpty()) {
            return new List<Contract>();
        }
        validateContracts(contracts);
        System.debug(LoggingLevel.INFO,
            'GGT_ContractService.updateContracts - Updating ' + contracts.size() + ' contract(s)');
        update contracts;
        return contracts;
    }

    // DELETE
    public static void deleteContracts(List<Id> contractIds) {
        if (contractIds == null || contractIds.isEmpty()) {
            return;
        }
        System.debug(LoggingLevel.INFO,
            'GGT_ContractService.deleteContracts - Deleting ' + contractIds.size() + ' contract(s)');
        delete [SELECT Id FROM Contract WHERE Id IN :contractIds];
    }

    // VALIDATION
    private static void validateContracts(List<Contract> contracts) {
        for (Contract c : contracts) {
            if (c.AccountId == null) {
                throw new GGT_ServiceException('Contract must be related to an Account.');
            }
            // Ici, on lit seulement EndDate, on ne l’écrit jamais
            if (c.StartDate != null && c.EndDate != null && c.StartDate > c.EndDate) {
                throw new GGT_ServiceException('Contract StartDate cannot be after EndDate.');
            }
        }
    }
}