public class GetGovernorLimits {
    public class LimitsResult {
        @InvocableVariable(label='Limit Usage') public Integer limitUsage;
        @InvocableVariable(label='Limit Value') public Integer limitValue;
    }
    @InvocableMethod(label='Get Governor Limit Usage')
    public static List<LimitsResult> getLimit(List<String> limitNames) {
        
        List<LimitsResult> results = new List<LimitsResult>();
        
        for (String limitName : limitNames) {
            
            LimitsResult result = new LimitsResult();
            
            switch on limitName.toUpperCase() {
                when 'QUERYROWS' {
                    result.limitUsage = Limits.getQueryRows();
                    result.limitValue = Limits.getLimitQueryRows();
                }
                when 'QUERIES' {
                    result.limitUsage = Limits.getQueries();
                    result.limitValue = Limits.getLimitQueries();
                }
                when 'DMLROWS' {
                    result.limitUsage = Limits.getDmlRows();
                    result.limitValue = Limits.getLimitDmlRows();
                }
                when 'DMLSTATEMENTS' {
                    result.limitUsage = Limits.getDmlStatements();
                    result.limitValue = Limits.getLimitDmlStatements();
                }
                when else {
                    result.limitUsage = -1;
                    result.limitValue = -1;
                }
            }
            results.add(result);
        }
        
        return results;
    }
}