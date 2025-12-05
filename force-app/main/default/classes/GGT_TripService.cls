public with sharing class GGT_TripService {

    // CREATE
    public static List<Trip__c> createTrips(List<Trip__c> trips) {
        if (trips == null || trips.isEmpty()) {
            return new List<Trip__c>();
        }
        validateTrips(trips);
        System.debug(LoggingLevel.INFO, 'GGT_TripService.createTrips - Inserting ' + trips.size() + ' trips');
        insert trips;
        return trips;
    }

    // READ - Trips par statut
    public static List<Trip__c> getTripsByStatus(String status) {
        if (String.isBlank(status)) {
            throw new GGT_ServiceException('Status is required.');
        }

        System.debug(LoggingLevel.DEBUG, 'GGT_TripService.getTripsByStatus - Status = ' + status);

        return [
            SELECT Id, Name, Status__c, Destination__c,
                   Start_Date__c, End_Date__c,
                   Number_of_Participants__c, Total_Cost__c,
                   Account__c, Opportunity__c
            FROM Trip__c
            WHERE Status__c = :status
            LIMIT 100
        ];
    }

    // UPDATE
    public static List<Trip__c> updateTrips(List<Trip__c> trips) {
        if (trips == null || trips.isEmpty()) {
            return new List<Trip__c>();
        }
        validateTrips(trips);
        System.debug(LoggingLevel.INFO, 'GGT_TripService.updateTrips - Updating ' + trips.size() + ' trips');
        update trips;
        return trips;
    }

    // DELETE
    public static void deleteTrips(List<Id> tripIds) {
        if (tripIds == null || tripIds.isEmpty()) {
            return;
        }
        System.debug(LoggingLevel.INFO, 'GGT_TripService.deleteTrips - Deleting ' + tripIds.size() + ' trips');
        delete [SELECT Id FROM Trip__c WHERE Id IN :tripIds];
    }

    // VALIDATION
    private static void validateTrips(List<Trip__c> trips) {
        for (Trip__c t : trips) {
            if (t.Number_of_Participants__c != null && t.Number_of_Participants__c < 0) {
                throw new GGT_ServiceException('Trip participants cannot be negative. Trip Id: ' + t.Id);
            }
            if (t.Total_Cost__c != null && t.Total_Cost__c < 0) {
                throw new GGT_ServiceException('Trip total cost cannot be negative. Trip Id: ' + t.Id);
            }
            if (t.Start_Date__c != null && t.End_Date__c != null && t.Start_Date__c > t.End_Date__c) {
                throw new GGT_ServiceException('Trip Start Date cannot be after End Date. Trip Id: ' + t.Id);
            }
        }
    }
}