public class ScriptManager 
{
    private List<Script__c> scriptContainer = new List<Script__c>();
    private Set<String> scriptLegacyIds = new Set<String>();
    private Map<String, Script__c> scriptMap = new Map<String, Script__c>();

    public void processScripts(List<JsonMovieData.Movie> movieData) {
        extractScriptIds(movieData);
        loadExistingScripts();
        createMissingScripts(movieData);
        insertScripts();
    }
    private void extractScriptIds(List<JsonMovieData.Movie> movieData) {
        for(JsonMovieData.Movie jsmovie : movieData) {
            scriptLegacyIds.add(jsmovie.script.id);
        }
    }

    private void loadExistingScripts() {
        for (Script__c script : [SELECT Id, LegacyId__c FROM Script__c WHERE LegacyId__c IN :scriptLegacyIds]) {
            scriptMap.put(script.LegacyId__c, script);
        }
    }

    private void createMissingScripts(List<JsonMovieData.Movie> movieData) {
        for(JsonMovieData.Movie jsmovie : movieData) {
            if (!scriptMap.containsKey(jsmovie.script.id)) {
                Script__c scrpt = new Script__c();
                scrpt.LegacyId__c = jsmovie.script.id;
                scrpt.Title__c = jsmovie.script.name;
                scrpt.Number_of_Actors__c = 150;
                scrpt.Description__c = jsmovie.script.description;
                scriptContainer.add(scrpt);
            }
        }
    }

    private void insertScripts() {
        if (!scriptContainer.isEmpty()) {
            insert scriptContainer;
            loadExistingScripts(); 
        }
    }

    public Script__c getScriptByLegacyId(String legacyId) {
        return scriptMap.get(legacyId);
    }
}