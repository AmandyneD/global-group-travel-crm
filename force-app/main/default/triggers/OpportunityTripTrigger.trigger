trigger OpportunityTripTrigger on Opportunity (after update) {
    GGT_OpportunityTripHandler.handleAfterUpdate(Trigger.new, Trigger.oldMap);
}