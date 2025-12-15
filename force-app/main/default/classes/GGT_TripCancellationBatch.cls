public class GGT_TripCancellationBatch implements Database.Batchable<SObject> {

    // 1. START : sélecte tous les Trip avec < 10 participants et pas déjà annulés
    public Database.QueryLocator start(Database.BatchableContext bc) {
        System.debug(LoggingLevel.INFO,
            'GGT_TripCancellationBatch.start - Selecting trips with less than 10 participants');

        return Database.getQueryLocator([
            SELECT Id, Number_of_Participants__c, Status__c
            FROM Trip__c
            WHERE Number_of_Participants__c < 10
            AND Status__c != 'Annulé'
        ]);
    }

    // 2. EXECUTE : traitement bulk
    public void execute(Database.BatchableContext bc, List<Trip__c> trips) {
        System.debug(LoggingLevel.INFO,
            'GGT_TripCancellationBatch.execute - Processing ' + trips.size() + ' trip(s)');

        for (Trip__c t : trips) {
            t.Status__c = 'Annulé';
        }
        update trips;
    }

    // 3. FINISH : logs de confirmation
    public void finish(Database.BatchableContext bc) {
        System.debug(LoggingLevel.INFO,
            'GGT_TripCancellationBatch.finish - Trip cancellation batch completed');
    }
}

