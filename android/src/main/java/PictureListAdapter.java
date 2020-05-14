package malaksadek.swifty;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import java.util.ArrayList;

public class PictureListAdapter extends ArrayAdapter<picturelistItem> {

    public PictureListAdapter(Context context, ArrayList<picturelistItem> c) {
        super(context, 0, c);

    }

    ImageView img;
    picturelistItem p;

    void Setup(View convertView) {
        img = convertView.findViewById(R.id.picture);
    }

    void fillItem(int position) {
        p = getItem(position);
        if(p.source == 0) {
            if (position == 0) {
                img.setImageDrawable(getContext().getDrawable(R.drawable.comicbackground));
            } else if (position == 1) {
                img.setImageDrawable(getContext().getDrawable(R.drawable.scifibackground));
            } else if (position == 2) {
                img.setImageDrawable(getContext().getDrawable(R.drawable.comingsoonimage));
            } else if (position == 3) {
                img.setImageDrawable(getContext().getDrawable(R.drawable.comingsoonimage));
            } else {
                img.setImageDrawable(getContext().getDrawable(R.drawable.comingsoonimage));
            }
        }
        else {
            if(p.topic == 0) {
                if (position == 0) {
                    img.setImageDrawable(getContext().getDrawable(R.drawable.avengersbackground));
                } else if (position == 1) {
                    img.setImageDrawable(getContext().getDrawable(R.drawable.xmenbackground));
                }
            } else {
                if (position == 0) {
                    img.setImageDrawable(getContext().getDrawable(R.drawable.startrekbackground));
                } else if (position == 1) {
                    img.setImageDrawable(getContext().getDrawable(R.drawable.meninblackbackground));
                } else if (position == 2) {
                    img.setImageDrawable(getContext().getDrawable(R.drawable.starwarsbackground));
                } else {
                    img.setImageDrawable(getContext().getDrawable(R.drawable.comingsoonimage));
                }
            }
        }
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {

        if (convertView == null) {
            convertView = LayoutInflater.from(getContext()).inflate(R.layout.picturelistitem, parent, false);
        }

        Setup(convertView);
        fillItem(position);
        return convertView;
    }
}