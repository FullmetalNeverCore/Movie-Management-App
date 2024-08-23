public class MovieUpdateSchedule implements Schedulable
{
    public void execute(SchedulableContext SC) {
        Database.executeBatch(new MovieTMDBSyncBatch(), 100);
    }
}