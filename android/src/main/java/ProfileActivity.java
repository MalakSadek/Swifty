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
import com.google.android.gms.tasks.Task;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.firestore.DocumentSnapshot;
import com.google.firebase.firestore.FirebaseFirestore;
import com.google.firebase.firestore.QuerySnapshot;

import java.util.Objects;

public class ProfileActivity extends AppCompatActivity {

    Button changepassword, logout;
    TextView name, email, joined, score, level;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        getSupportActionBar().setTitle("Profile");
        setContentView(R.layout.activity_profile);
        Setup();

        changepassword.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                changepasswordOnClickListener();
            }
        });

        logout.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                logoutOnClickListener();
            }
        });

        getInformation();
    }

    void changepasswordOnClickListener() {

        FirebaseAuth auth = FirebaseAuth.getInstance();
        auth.sendPasswordResetEmail(getSharedPreferences("SwiftyPrefs", 0).getString("Email", ""))
                .addOnCompleteListener(new OnCompleteListener<Void>() {
                    @Override
                    public void onComplete(@NonNull Task<Void> task) {
                        if (task.isSuccessful()) {
                            Toast.makeText(getApplicationContext(), "Password reset email has been sent.", Toast.LENGTH_LONG).show();
                        }
                    }
                });
    }

    void logoutOnClickListener() {
        DialogPopup d = new DialogPopup(0);
        d.show(getFragmentManager(), "My Dialog");
    }

    void getInformation() {

        FirebaseFirestore db = FirebaseFirestore.getInstance();
        db.collection("Users")
                .get()
                .addOnCompleteListener(new OnCompleteListener<QuerySnapshot>() {
                    @Override
                    public void onComplete(@NonNull Task<QuerySnapshot> task) {
                        if (task.isSuccessful()) {
                            for (DocumentSnapshot document : task.getResult()) {
                                for (int i = 0; i < task.getResult().size(); i++) {
                                    if(Objects.equals(document.get("Email").toString(), getSharedPreferences("SwiftyPrefs", 0).getString("Email", ""))){
                                        name.setText(document.get("Username").toString());
                                        email.setText(document.get("Email").toString());
                                        joined.setText(document.get("Joined").toString());
                                        score.setText(document.get("Score").toString());
                                    }
                                }

                                int tempscore = Integer.valueOf(score.getText().toString());
                                Log.i("tempscccore", String.valueOf(tempscore));
                                if (tempscore < 0) {
                                    level.setText("Underdog");
                                } else if (tempscore <= 50) {
                                    level.setText("Novice");
                                } else if (tempscore <= 100) {
                                    level.setText("Rookie");
                                } else if (tempscore <= 200) {
                                    level.setText("Expert");
                                } else if (tempscore > 200) {
                                    level.setText("Genius");
                                } else {
                                    level.setText("Unavailable right now");
                                }
                            }
                        } else {
                            Log.d("", "Error getting documents: ", task.getException());
                        }
                    }
                });

    }

    void Setup() {
        changepassword = findViewById(R.id.changepasswordbutton);
        logout = findViewById(R.id.logoutbutton);
        name = findViewById(R.id.name);
        email = findViewById(R.id.email);
        joined = findViewById(R.id.date);
        score = findViewById(R.id.score);
        level = findViewById(R.id.level);
    }
}