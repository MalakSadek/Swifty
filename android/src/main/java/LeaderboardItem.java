package malaksadek.swifty;

public class LeaderboardItem {
    public String username, score, date, level;

    public int getScore() {
        return Integer.valueOf(score);
    }
}
