public with sharing class GGT_OpportunityTripHandler {

    public static void handleAfterUpdate(List<Opportunity> newList, Map<Id, Opportunity> oldMap) {
        List<Trip__c> tripsToInsert = new List<Trip__c>();
        Set<Id> oppIdsToCheck = new Set<Id>();

        // 1. Identifier uniquement les Opp "Closed Won" nouvellement gagnées
        for (Opportunity opp : newList) {
            Opportunity oldOpp = oldMap.get(opp.Id);

            if (opp.StageName == 'Closed Won' && oldOpp.StageName != 'Closed Won') {
                oppIdsToCheck.add(opp.Id);
            }
        }

        if (oppIdsToCheck.isEmpty()) {
            return; // Rien à faire
        }

        // 2. Vérifier si ces Opp ont déjà un Trip__c associé
        Map<Id, Trip__c> existingTrips = new Map<Id, Trip__c>(
            [SELECT Id, Opportunity__c FROM Trip__c WHERE Opportunity__c IN :oppIdsToCheck]
        );

        // 3. Créer les Trips manquants
        for (Opportunity opp : newList) {
            if (!oppIdsToCheck.contains(opp.Id)) {
                continue;
            }

            // Éviter de recréer un Trip déjà existant
            if (existingTrips.containsKey(opp.Id)) {
                continue;
            }

            Trip__c t = new Trip__c(
                Opportunity__c = opp.Id,
                Account__c = opp.AccountId,
                Destination__c = opp.Destination__c,
                Number_of_Participants__c = opp.Number_of_Participants__c,
                Start_Date__c = opp.Start_Date__c,
                End_Date__c = opp.End_Date__c,
                Total_Cost__c = opp.Amount,
                Status__c = 'A venir'
            );

            tripsToInsert.add(t);
        }

        if (!tripsToInsert.isEmpty()) {
            insert tripsToInsert;
        }
    }
}