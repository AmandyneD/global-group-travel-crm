global class GGT_TripStatusUpdateBatch implements Database.Batchable<Trip__c> {

    global Iterable<Trip__c> start(Database.BatchableContext bc) {
        return [
            SELECT Id, Start_Date__c, End_Date__c, Status__c
            FROM Trip__c
            WHERE Start_Date__c != null
              AND End_Date__c != null
              AND Status__c != 'Annulé'
        ];
    }

    global void execute(Database.BatchableContext bc, List<Trip__c> scope) {
        Date today = Date.today();
        List<Trip__c> toUpdate = new List<Trip__c>();

        for (Trip__c trip : scope) {

            // Sécurité : même si un record "Annulé" passe (changement entre start & execute), on ne le modifie jamais
            if (trip.Status__c == 'Annulé') {
                continue;
            }

            // Ignore records invalides (Start > End) pour éviter la validation rule
            if (trip.Start_Date__c > trip.End_Date__c) {
                System.debug(LoggingLevel.WARN,
                    'Skipping invalid Trip (Start > End). Id=' + trip.Id +
                    ' start=' + trip.Start_Date__c + ' end=' + trip.End_Date__c
                );
                continue;
            }

            String newStatus;
            if (today < trip.Start_Date__c) newStatus = 'A venir';
            else if (today > trip.End_Date__c) newStatus = 'Terminé';
            else newStatus = 'En cours';

            if (trip.Status__c != newStatus) {
                trip.Status__c = newStatus;
                toUpdate.add(trip);
            }
        }

        if (!toUpdate.isEmpty()) {
            Database.update(toUpdate, false);
        }
    }

    global void finish(Database.BatchableContext bc) {
        System.debug('GGT_TripStatusUpdateBatch.finish - Trip status update batch completed');
    }
}