public class JSONBatchInsert implements Queueable, Database.AllowsCallouts {
    private List<Movie__c> records;
    private Integer batchSize;
    private Integer startIndex;

    public JSONBatchInsert(List<Movie__c> records, Integer batchSize, Integer startIndex) {
        this.records = records;
        this.batchSize = batchSize;
        this.startIndex = startIndex;
    }

    public void execute(QueueableContext context) {
        Integer endIndex = Math.min(startIndex + batchSize, records.size());
        List<Movie__c> currentBatch = new List<Movie__c>();

        for (Integer i = startIndex; i < endIndex; i++) {
            currentBatch.add(records[i]);
        }

        try {
            insert currentBatch;
        } catch (DmlException dmlEx) {
            System.debug('Error inserting batch from index ' + startIndex + ' to ' + (endIndex - 1) + ': ' + dmlEx.getMessage());
        }

        if (endIndex < records.size()) {
            System.enqueueJob(new JSONBatchInsert(records, batchSize, endIndex));
        }
    }

    public static void insertInBatches(List<Movie__c> records, Integer batchSize) {
        if (records.isEmpty()) {
            return;
        }
        System.enqueueJob(new JSONBatchInsert(records, batchSize, 0));
    }
}