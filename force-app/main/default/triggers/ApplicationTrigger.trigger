trigger ApplicationTrigger 
on Application__c
(
    before insert,
    after update
)
{


    if(Trigger.isBefore &&
       Trigger.isInsert)
    {


        TriggerHandler.beforeInsert(
            Trigger.new
        );


    }



    if(Trigger.isAfter &&
       Trigger.isUpdate)
    {


        TriggerHandler.afterUpdate(
            Trigger.new,
            Trigger.oldMap
        );


    }


}