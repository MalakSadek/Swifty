package malaksadek.swifty;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.util.Base64;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.util.ArrayList;

public class LeaderboardAdapter extends ArrayAdapter<LeaderboardItem> {

    public LeaderboardAdapter(Context context, ArrayList<LeaderboardItem> c) {
        super(context, 0, c);

    }

    TextView U, Ra, L, S, D;
    LeaderboardItem c;


    void Setup(View convertView){
        U = convertView.findViewById(R.id.name);
        Ra = convertView.findViewById(R.id.rank);
        L = convertView.findViewById(R.id.level);
        S = convertView.findViewById(R.id.score);
        D = convertView.findViewById(R.id.date);
    }

    void fillItem (int position) {
        c = getItem(position);

        U.setText(c.username);
        Ra.setText(String.valueOf(position+1));
        L.setText(c.level);
        S.setText(c.score);
        D.setText(c.date);
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {

        if (convertView == null) {
            convertView = LayoutInflater.from(getContext()).inflate(R.layout.leaderboarditem, parent, false);
        }

        Setup(convertView);
        fillItem(position);
        return convertView;
    }
}
