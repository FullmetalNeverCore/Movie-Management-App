@isTest
public class StringParserTest {
    
	@isTest
    public static void stringDividerTest()
    {
        StringParser.InputWrapper getWrapper = new StringParser.InputWrapper();
        getWrapper.text = 'Test;String';
        
        List<StringParser.InputWrapper> input = new List<StringParser.InputWrapper>{getWrapper};
        List<StringParser.OutputWrapper> results = StringParser.splitTextBySemicolon(input);
        
        
        StringParser.OutputWrapper firstElem = results.get(0);
        //System.debug(firstElem.textCollection);
        System.assertEquals(2,firstElem.textCollection.size(),'List size supposed to be equals 2');
        System.assertEquals('Test',firstElem.textCollection.get(0),'0th element supposed to be - Test');
        System.assertEquals('String',firstElem.textCollection.get(1),'1th element supposed to be - String');
    }
    
    @isTest
    public static void nullStringTest()
    {
        StringParser.InputWrapper getWrapper = new StringParser.InputWrapper();
        getWrapper.text = null;
        
        List<StringParser.InputWrapper> input = new List<StringParser.InputWrapper>{getWrapper};
        List<StringParser.OutputWrapper> results = StringParser.splitTextBySemicolon(input);
        
        StringParser.OutputWrapper firstElem = results.get(0);
        System.debug(firstElem.textCollection);
        
        System.assertEquals(0,firstElem.textCollection.size(),'List size supposed to be equals 0');
    }
}