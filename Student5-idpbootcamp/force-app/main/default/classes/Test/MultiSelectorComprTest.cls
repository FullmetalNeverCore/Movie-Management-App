@isTest
public class MultiSelectorComprTest {

    @isTest
    static void testComparePicklists()
    {
        MultiSelectorCompr.Request req1 = new MultiSelectorCompr.Request();
        req1.picklist1 = 'Value1;Value2;Value3';
        req1.picklist2 = 'Value2;Value4;Value5';

        MultiSelectorCompr.Request req2 = new MultiSelectorCompr.Request();
        req2.picklist1 = 'Value1;Value3';
        req2.picklist2 = 'Value4;Value5';

        MultiSelectorCompr.Request req3 = new MultiSelectorCompr.Request();
        req3.picklist1 = 'Value1;Value2';
        req3.picklist2 = null;

        List<MultiSelectorCompr.Request> requests = new List<MultiSelectorCompr.Request>{req1, req2, req3};
        List<Boolean> results = MultiSelectorCompr.comparePicklists(requests);

        System.assertEquals(3, results.size(), 'There should be 3 results');
        System.assertEquals(true, results[0], 'Test case 1: Common entries should return true');
        System.assertEquals(false, results[1], 'Test case 2: No common entries should return false');
        System.assertEquals(false, results[2], 'Test case 3: Null picklist2 should return false');
    }

    @isTest
    static void testNullOrEmptyRequests() 
    {
        List<Boolean> results = MultiSelectorCompr.comparePicklists(null);
        System.assertEquals(1, results.size(), 'Null request list should return a single result');
        System.assertEquals(false, results[0], 'Null request list should return false');

        results = MultiSelectorCompr.comparePicklists(new List<MultiSelectorCompr.Request>());
        System.assertEquals(1, results.size(), 'Empty request list should return a single result');
        System.assertEquals(false, results[0], 'Empty request list should return false');
    }
    
    
}