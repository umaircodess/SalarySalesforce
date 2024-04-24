public class SalaryJSON {
    public String contactId;
    public Integer amount;
    public String month;
    public String fiscalyear;

    public static List<SalaryJSON> parse(String json) {
        return (List<SalaryJSON>) System.JSON.deserialize(json, List<SalaryJSON>.class);
    }
}