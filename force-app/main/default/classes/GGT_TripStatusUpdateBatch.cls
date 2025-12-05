public class GGT_TripStatusUpdateBatch implements Database.Batchable<SObject> {

    public Database.QueryLocator start(Database.BatchableContext bc) {
        System.debug(LoggingLevel.INFO,
            'GGT_TripStatusUpdateBatch.start - Selecting trips for status update');

        // On exclut les trips annulés, et on ne traite que ceux qui ont des dates renseignées
        return Database.getQueryLocator([
            SELECT Id, Status__c, Start_Date__c, End_Date__c
            FROM Trip__c
            WHERE Status__c != 'Annulé'
            AND Start_Date__c != null
            AND End_Date__c != null
        ]);
    }

    public void execute(Database.BatchableContext bc, List<Trip__c> trips) {
        System.debug(LoggingLevel.INFO,
            'GGT_TripStatusUpdateBatch.execute - Processing ' + trips.size() + ' trip(s)');

        Date today = Date.today();

        for (Trip__c t : trips) {
            // On ignore par sécurité les trips sans dates, même si le SOQL les filtre déjà
            if (t.Start_Date__c == null || t.End_Date__c == null) {
                continue;
            }

            if (today < t.Start_Date__c) {
                t.Status__c = 'A venir';
            } else if (today > t.End_Date__c) {
                t.Status__c = 'Terminé';
            } else {
                // today entre start et end (inclus)
                t.Status__c = 'En cours';
            }
        }

        update trips;
    }

    public void finish(Database.BatchableContext bc) {
        System.debug(LoggingLevel.INFO,
            'GGT_TripStatusUpdateBatch.finish - Trip status update batch completed');
    }
}