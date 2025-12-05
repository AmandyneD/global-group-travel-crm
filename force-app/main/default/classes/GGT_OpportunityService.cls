public with sharing class GGT_OpportunityService {

    // CREATE
    public static List<Opportunity> createOpportunities(List<Opportunity> opps) {
        if (opps == null || opps.isEmpty()) {
            return new List<Opportunity>();
        }
        validateOpportunities(opps);
        System.debug(LoggingLevel.INFO, 'GGT_OpportunityService.createOpportunities - Inserting ' + opps.size() + ' opportunities');
        insert opps;
        return opps;
    }

    // READ - par statut
    public static List<Opportunity> getOpportunitiesByStage(String stageName) {
        if (String.isBlank(stageName)) {
            throw new GGT_ServiceException('StageName is required.');
        }

        System.debug(LoggingLevel.DEBUG, 'GGT_OpportunityService.getOpportunitiesByStage - Stage = ' + stageName);

        return [
            SELECT Id, Name, StageName, Amount, CloseDate,
                   Number_of_Participants__c, Destination__c, Start_Date__c, End_Date__c,
                   AccountId
            FROM Opportunity
            WHERE StageName = :stageName
            LIMIT 100
        ];
    }

    // UPDATE
    public static List<Opportunity> updateOpportunities(List<Opportunity> opps) {
        if (opps == null || opps.isEmpty()) {
            return new List<Opportunity>();
        }
        validateOpportunities(opps);
        System.debug(LoggingLevel.INFO, 'GGT_OpportunityService.updateOpportunities - Updating ' + opps.size() + ' opportunities');
        update opps;
        return opps;
    }

    // DELETE
    public static void deleteOpportunities(List<Id> opportunityIds) {
        if (opportunityIds == null || opportunityIds.isEmpty()) {
            return;
        }
        System.debug(LoggingLevel.INFO, 'GGT_OpportunityService.deleteOpportunities - Deleting ' + opportunityIds.size() + ' opportunities');
        delete [SELECT Id FROM Opportunity WHERE Id IN :opportunityIds];
    }

    // VALIDATION
    private static void validateOpportunities(List<Opportunity> opps) {
        for (Opportunity opp : opps) {
            if (opp.Amount < 0) {
                throw new GGT_ServiceException('Opportunity Amount cannot be negative. Opportunity: ' + opp.Name);
            }
            if (opp.CloseDate == null) {
                throw new GGT_ServiceException('Opportunity CloseDate is required. Opportunity: ' + opp.Name);
            }
            // Dates custom de voyage si présentes
            if (opp.Start_Date__c != null && opp.End_Date__c != null && opp.Start_Date__c > opp.End_Date__c) {
                throw new GGT_ServiceException('Opportunity Start Date cannot be after End Date. Opportunity: ' + opp.Name);
            }
        }
    }
}