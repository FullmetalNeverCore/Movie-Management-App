public class TriggerControl {
    public static Boolean getMovieSettings()
    {
    	DisableUpdateTrigger__c movieSetting  = DisableUpdateTrigger__c.getOrgDefaults();
        return movieSetting.UpdateTrigger__c;
    }
}