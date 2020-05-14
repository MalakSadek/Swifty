package malaksadek.swifty;

import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.v7.app.AppCompatActivity;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;
import android.widget.Toast;

import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.OnFailureListener;
import com.google.android.gms.tasks.OnSuccessListener;
import com.google.android.gms.tasks.Task;
import com.google.firebase.firestore.DocumentReference;
import com.google.firebase.firestore.DocumentSnapshot;
import com.google.firebase.firestore.FirebaseFirestore;
import com.google.firebase.firestore.QuerySnapshot;

import java.util.Objects;

public class ScoreActivity extends AppCompatActivity {

    Button mainmenu, leaderboard;
    TextView score, message;
    int oldscore, newscore, currentscore;
    String id;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        getSupportActionBar().setTitle("Score");
        setContentView(R.layout.activity_score);
        Setup();

        UpdateScore();
    }

    void Setup() {
        mainmenu = findViewById(R.id.menubutton);
        leaderboard = findViewById(R.id.leaderboardbutton);
        message = findViewById(R.id.message);
        score = findViewById(R.id.score);
        score.setText(getSharedPreferences("SwiftyPrefs", 0).getString("Score", "0"));
        mainmenu.setVisibility(View.INVISIBLE);
        leaderboard.setVisibility(View.INVISIBLE);
        if (Integer.valueOf(score.getText().toString()) > 0) {
            message.setText("Great job! Your score is:");
        } else {
            message.setText("Better luck next time! Your score is:");
        }

        mainmenu.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                SharedPreferences sp = getSharedPreferences("SwiftyPrefs", 0);
                final SharedPreferences.Editor editor = sp.edit();
                editor.putString("Score", "");
                editor.commit();
                startActivity(new Intent(getApplicationContext(), MenuActivity.class));
            }
        });

        leaderboard.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                SharedPreferences sp = getSharedPreferences("SwiftyPrefs", 0);
                final SharedPreferences.Editor editor = sp.edit();
                editor.putString("Score", "");
                editor.commit();
                startActivity(new Intent(getApplicationContext(), LeaderboardActivity.class));
            }
        });
    }

    void UpdateScore() {

        currentscore = Integer.valueOf(getSharedPreferences("SwiftyPrefs", 0).getString("Score", "0"));
        final FirebaseFirestore db = FirebaseFirestore.getInstance();
        db.collection("Users")
                .get()
                .addOnCompleteListener(new OnCompleteListener<QuerySnapshot>() {
                    @Override
                    public void onComplete(@NonNull Task<QuerySnapshot> task) {
                        if (task.isSuccessful()) {
                            for (DocumentSnapshot document : task.getResult()) {
                                for (int i = 0; i < task.getResult().size(); i++) {
                                    if(Objects.equals(document.get("Email").toString(), getSharedPreferences("SwiftyPrefs", 0).getString("Email", ""))){
                                        oldscore = Integer.valueOf(document.get("Score").toString());
                                        id = document.getId();
                                    }
                                }
                            }

                            newscore = currentscore + oldscore;
                            handleLevels();
                            DocumentReference ref = db.collection("Users").document(id);

                            ref
                                    .update("Score", newscore)
                                    .addOnSuccessListener(new OnSuccessListener<Void>() {
                                        @Override
                                        public void onSuccess(Void aVoid) {
                                            Log.d("", "DocumentSnapshot successfully updated!");
                                            mainmenu.setVisibility(View.VISIBLE);
                                            leaderboard.setVisibility(View.VISIBLE);
                                        }
                                    })
                                    .addOnFailureListener(new OnFailureListener() {
                                        @Override
                                        public void onFailure(@NonNull Exception e) {
                                            Log.w("", "Error updating document", e);
                                        }
                                    });

                        } else {
                            Log.d("", "Error getting documents: ", task.getException());
                        }
                    }
                });
    }

    void handleLevels() {
        
        if(oldscore < 0) {
            if ((newscore > 50) && (newscore < 101)) {
                Toast.makeText(getApplicationContext(), "Congratulations, You've been promoted from Underdog to Rookie.", Toast.LENGTH_LONG).show();
            } else if ((newscore > 100) && (newscore < 201)) {
                Toast.makeText(getApplicationContext(), "Congratulations, You've been promoted from Underdog to Expert.", Toast.LENGTH_LONG).show();
            } else if ((newscore > 0) && (newscore < 51)) {
                Toast.makeText(getApplicationContext(), "Congratulations, You've been promoted from Underdog to Novice.", Toast.LENGTH_LONG).show();
            } else if (newscore > 200) {
                Toast.makeText(getApplicationContext(), "Congratulations, You've been promoted from Underdog to Genius.", Toast.LENGTH_LONG).show();
            }

        } else if ((oldscore > 0) && (oldscore < 51)) {

            if ((newscore > 50) && (newscore < 101)) {
                Toast.makeText(getApplicationContext(), "Congratulations, You've been promoted from Novice to Rookie.", Toast.LENGTH_LONG).show();
            } else if ((newscore > 100) && (newscore < 201)) {
                Toast.makeText(getApplicationContext(), "Congratulations, You've been promoted from Novice to Expert.", Toast.LENGTH_LONG).show();
            } else if (newscore > 200) {
                Toast.makeText(getApplicationContext(), "Congratulations, You've been promoted from Novice to Genius.", Toast.LENGTH_LONG).show();
            } else if (newscore < 0) {
                Toast.makeText(getApplicationContext(), "Too bad! You've been demoted from Novice to Underdog.", Toast.LENGTH_LONG).show();
            }

        } else if ((oldscore > 50) && (oldscore < 101)){

            if ((newscore > 0) && (newscore < 51)) {
                Toast.makeText(getApplicationContext(), "Too bad! You've been demoted from Rookie to Novice.", Toast.LENGTH_LONG).show();
            } else if ((newscore > 100) && (newscore < 201)) {
                Toast.makeText(getApplicationContext(), "Congratulations, You've been promoted from Rookie to Expert\".", Toast.LENGTH_LONG).show();
            } else if (newscore > 200) {
                Toast.makeText(getApplicationContext(), "Congratulations, You've been promoted from Rookie to Genius.", Toast.LENGTH_LONG).show();
            } else if (newscore < 0) {
                Toast.makeText(getApplicationContext(), "Too bad! You've been demoted from Rookie to Underdog.", Toast.LENGTH_LONG).show();
            }

        } else if ((oldscore > 100) && (oldscore < 201)){

            if ((newscore > 0) && (newscore < 51)) {
                Toast.makeText(getApplicationContext(), "Too bad! You've been demoted from Expert to Novice.", Toast.LENGTH_LONG).show();
            } else if ((newscore > 50) && (newscore < 101)) {
                Toast.makeText(getApplicationContext(), "Too bad! You've been demoted from Expert to Rookie.", Toast.LENGTH_LONG).show();
            } else if (newscore > 200) {
                Toast.makeText(getApplicationContext(), "Congratulations, You've been promoted from Expert to Genius.", Toast.LENGTH_LONG).show();
            } else if (newscore < 0) {
                Toast.makeText(getApplicationContext(), "Too bad! You've been demoted from Expert to Underdog.", Toast.LENGTH_LONG).show();
            }

        } else if (oldscore > 200) {

            if ((newscore > 50) && (newscore < 101)) {
                Toast.makeText(getApplicationContext(), "Too bad! You've been demoted from Genius to Rookie.", Toast.LENGTH_LONG).show();
            } else if ((newscore > 100) && (newscore < 201)) {
                Toast.makeText(getApplicationContext(), "Too bad! You've been demoted from Genius to Expert.", Toast.LENGTH_LONG).show();
            } else if ((newscore > 0) && (newscore < 51)) {
                Toast.makeText(getApplicationContext(), "Too bad! You've been demoted from Genius to Novice.", Toast.LENGTH_LONG).show();
            } else if (newscore < 0) {
                Toast.makeText(getApplicationContext(), "Too bad! You've been demoted from Genius to Underdog.", Toast.LENGTH_LONG).show();
            }

        }
    }
}