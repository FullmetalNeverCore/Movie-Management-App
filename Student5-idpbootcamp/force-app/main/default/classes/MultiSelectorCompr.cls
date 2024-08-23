public with sharing class MultiSelectorCompr {
    
    @InvocableMethod(label='Compare Multi-Select Picklists' description='Compares two multi-select picklists and returns true if they have any common entries.')
    public static List<Boolean> comparePicklists(List<Request> requests) {
        List<Boolean> results = new List<Boolean>();

        if(requests == null || requests.isEmpty()) {
            results.add(false);
            return results;
        }

        for(Request req : requests) {
            if(req.picklist1 == null || req.picklist2 == null) {
                results.add(false);
                return results;
            } else {
                Set<String> set1 = new Set<String>(req.picklist1.split(';'));
                Set<String> set2 = new Set<String>(req.picklist2.split(';'));

                set1.retainAll(set2);
                results.add(!set1.isEmpty());
            }
        }
        return results;
    }

    public class Request {
        @InvocableVariable(required=false)
        public String picklist1;

        @InvocableVariable(required=false)
        public String picklist2;
    }

}