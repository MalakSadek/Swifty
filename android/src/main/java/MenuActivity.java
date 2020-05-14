package malaksadek.swifty;

import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.ListView;

import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.Task;
import com.google.firebase.firestore.DocumentSnapshot;
import com.google.firebase.firestore.FirebaseFirestore;
import com.google.firebase.firestore.QuerySnapshot;

import java.util.ArrayList;
import java.util.Objects;

public class MenuActivity extends AppCompatActivity {

    Button profile, leaderboard;
    ListView listview;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        getSupportActionBar().setTitle("Main Menu");
        setContentView(R.layout.activity_menu);
        Setup();

        profile.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                profileOnClickListener();
            }
        });

        leaderboard.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                leaderboardOnClickListener();
            }
        });

        ArrayList<picturelistItem> picturelist;
        picturelist = new ArrayList<>(4);
        picturelist.add(new picturelistItem(0, 0));
        picturelist.add(new picturelistItem(0, 0));
        picturelist.add(new picturelistItem(0, 0));
        picturelist.add(new picturelistItem(0, 0));
        PictureListAdapter PA = new PictureListAdapter(getApplicationContext(), picturelist);
        listview.setAdapter(PA);

        listview.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                SharedPreferences sp = getSharedPreferences("SwiftyPrefs", 0);
                final SharedPreferences.Editor editor = sp.edit();
                if (position == 0) {
                    editor.putString("Category", "Comics");
                    editor.commit();
                    startActivity(new Intent(getApplicationContext(), TopicsActivity.class));
                } else if (position == 1) {
                    editor.putString("Category", "SciFi");
                    editor.commit();
                    startActivity(new Intent(getApplicationContext(), TopicsActivity.class));
                }
            }
        });
    }


    void profileOnClickListener() {
        startActivity(new Intent(getApplicationContext(), ProfileActivity.class));
    }

    void leaderboardOnClickListener() {
        startActivity(new Intent(getApplicationContext(), LeaderboardActivity.class));
    }

    void Setup() {
        SharedPreferences sp = getSharedPreferences("SwiftyPrefs", 0);
        final SharedPreferences.Editor editor = sp.edit();
        editor.putString("Category", "");
        editor.commit();
        profile = findViewById(R.id.profile);
        leaderboard = findViewById(R.id.leaderboard);
        listview = findViewById(R.id.listview);
    }
}
