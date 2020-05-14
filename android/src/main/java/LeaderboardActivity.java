package malaksadek.swifty;

import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.v7.app.AppCompatActivity;
import android.util.Log;
import android.widget.ListView;
import android.widget.Toast;

import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.Task;
import com.google.firebase.firestore.DocumentSnapshot;
import com.google.firebase.firestore.FirebaseFirestore;
import com.google.firebase.firestore.QuerySnapshot;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.Objects;

public class LeaderboardActivity extends AppCompatActivity {

    ArrayList<LeaderboardItem> leaderboard;
    LeaderboardItem temp;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        getSupportActionBar().setTitle("Leaderboard");
        setContentView(R.layout.activity_leaderboard);

        getLeaderboard();
    }

    void getLeaderboard() {

        FirebaseFirestore db = FirebaseFirestore.getInstance();
        leaderboard = new ArrayList<>(5);
        db.collection("Users")
                .get()
                .addOnCompleteListener(new OnCompleteListener<QuerySnapshot>() {
                    @Override
                    public void onComplete(@NonNull Task<QuerySnapshot> task) {
                        if (task.isSuccessful()) {
                            int i = 0;
                            for (DocumentSnapshot document : task.getResult()) {
                                if (i < 5) {
                                    temp = new LeaderboardItem();
                                    temp.username = document.get("Username").toString();
                                    temp.score = document.get("Score").toString();
                                    temp.date = document.get("Joined").toString();
                                    i++;

                                    int tempscore = Integer.valueOf(temp.score);
                                    if (tempscore < 0) {
                                        temp.level = "Underdog";
                                    } else if (tempscore <= 50) {
                                        temp.level = "Novice";
                                    } else if (tempscore <= 100) {
                                        temp.level = "Rookie";
                                    } else if (tempscore <= 200) {
                                        temp.level = "Expert";
                                    } else {
                                        temp.level = "Genius";
                                    }
                                }
                                leaderboard.add(temp);
                            }

                            Collections.sort(leaderboard, new Comparator<LeaderboardItem>() {
                                public int compare(LeaderboardItem v1, LeaderboardItem v2) {
                                    return v2.getScore() - v1.getScore();
                                }
                            });

                            LeaderboardAdapter LA = new LeaderboardAdapter(getApplicationContext(), leaderboard);
                            ListView list = findViewById(R.id.leaderboardlist);

                            list.setAdapter(LA);

                        } else {
                            Log.d("", "Error getting documents: ", task.getException());
                        }
                    }
                });
    }

}