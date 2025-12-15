global class GGT_TripStatusUpdateScheduler implements Schedulable {
    global void execute(SchedulableContext sc) {
        Database.executeBatch(new GGT_TripStatusUpdateBatch(), 200);
    }
}