package malaksadek.swifty;

import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.ListView;
import android.widget.TextView;

import java.util.ArrayList;

public class TopicsActivity extends AppCompatActivity {

    ListView listview;
    TextView categoryText;
    String category;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        getSupportActionBar().setTitle("Topics");
        setContentView(R.layout.activity_topics);
        Setup();

        ArrayList<picturelistItem> picturelist;

        if (category.equals("Comics")) {
            picturelist = new ArrayList<>(3);
            picturelist.add(new picturelistItem(1, 0));
            picturelist.add(new picturelistItem(1, 0));
            picturelist.add(new picturelistItem(1, 0));
        } else {
            picturelist = new ArrayList<>(4);
            picturelist.add(new picturelistItem(1, 1));
            picturelist.add(new picturelistItem(1, 1));
            picturelist.add(new picturelistItem(1, 1));
            picturelist.add(new picturelistItem(1, 1));
        }


        PictureListAdapter PA = new PictureListAdapter(getApplicationContext(), picturelist);
        listview.setAdapter(PA);

        listview.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                SharedPreferences sp = getSharedPreferences("SwiftyPrefs", 0);
                final SharedPreferences.Editor editor = sp.edit();

                if (category.equals("Comics")) {
                    if (position == 0) {
                        editor.putString("Topic", "Avengers");
                    } else if (position == 1) {
                        editor.putString("Topic", "X-Men");
                    }
                } else {
                    if (position == 0) {
                        editor.putString("Topic", "Star Trek");
                    } else if (position == 1) {
                        editor.putString("Topic", "Men In Black");
                    } else if (position == 2) {
                        editor.putString("Topic", "Star Wars");
                    }
                }

                editor.commit();
                DialogPopup d = new DialogPopup(1);
                d.show(getFragmentManager(), "My Dialog");
            }
        });
    }

    void Setup() {
        SharedPreferences sp = getSharedPreferences("SwiftyPrefs", 0);
        final SharedPreferences.Editor editor = sp.edit();
        editor.putString("Topic", "");
        editor.commit();
        category = getSharedPreferences("SwiftyPrefs", 0).getString("Category", "Error");
        categoryText = findViewById(R.id.categorytext);
        listview = findViewById(R.id.topicslist);
        categoryText.setText(category);
    }
}
