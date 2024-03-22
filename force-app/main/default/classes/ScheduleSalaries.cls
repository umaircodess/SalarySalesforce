public with sharing class ScheduleSalaries implements Schedulable {
    public void execute(SchedulableContext context) {
        Database.executeBatch(new BatchAddSalaries());

    }
}