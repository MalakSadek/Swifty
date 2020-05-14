package malaksadek.swifty;

import android.app.Dialog;
import android.app.DialogFragment;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.support.v7.app.AlertDialog;

import com.google.firebase.auth.FirebaseAuth;

public class DialogPopup extends DialogFragment {

    int source;
    Context mContext;

    public DialogPopup() {
        mContext = getActivity();
        source = 1;
    }

    public DialogPopup(int s) {
        mContext = getActivity();
        source = s;
    }

    void updateSharedPreferences() {
        SharedPreferences sp = getContext().getSharedPreferences("SwiftyPrefs", 0);
        final SharedPreferences.Editor editor = sp.edit();
        editor.putString("Email", "");
        editor.putString("Username", "");
        editor.putString("Password", "");
        editor.commit();
    }

    void Logout() {
        updateSharedPreferences();
        Intent i = new Intent(getContext(), OpeningActivity.class);
        FirebaseAuth.getInstance().signOut();
        startActivity(i);
    }

    @Override
    public Dialog onCreateDialog(Bundle savedInstanceState) {
        AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(getContext());

        if (source == 0) {
            alertDialogBuilder.setTitle("Gone so soon?");
            alertDialogBuilder.setMessage("Are you sure you want to log out?");
            //null should be your on click listener
            alertDialogBuilder.setPositiveButton("Yes, I'm Sure", new DialogInterface.OnClickListener() {
                @Override
                public void onClick(DialogInterface dialog, int which) {
                    Logout();
                }
            });

            alertDialogBuilder.setNegativeButton("No, Cancel", new DialogInterface.OnClickListener() {

                @Override
                public void onClick(DialogInterface dialog, int which) {
                    dialog.dismiss();
                }
            });
        } else if (source == 1) {
            alertDialogBuilder.setTitle(getContext().getSharedPreferences("SwiftyPrefs", 0).getString("Topic", ""));
            alertDialogBuilder.setMessage("Are you sure you want to start this quiz?");
            //null should be your on click listener
            alertDialogBuilder.setPositiveButton("Let's Do It!", new DialogInterface.OnClickListener() {
                @Override
                public void onClick(DialogInterface dialog, int which) {
                    startActivity(new Intent(getContext(), QuizActivity.class));
                }
            });

            alertDialogBuilder.setNegativeButton("I changed my mind.", new DialogInterface.OnClickListener() {

                @Override
                public void onClick(DialogInterface dialog, int which) {
                    dialog.dismiss();
                }
            });
        } else if (source == 2) {
            alertDialogBuilder.setTitle("Warning!");
            alertDialogBuilder.setMessage("Are you sure you want to go back? Your score will be lost!");
            //null should be your on click listener
            alertDialogBuilder.setPositiveButton("I'm Sure", new DialogInterface.OnClickListener() {
                @Override
                public void onClick(DialogInterface dialog, int which) {
                    startActivity(new Intent(getContext(), MenuActivity.class));
                }
            });

            alertDialogBuilder.setNegativeButton("Nevermind.", new DialogInterface.OnClickListener() {

                @Override
                public void onClick(DialogInterface dialog, int which) {
                    dialog.dismiss();
                }
            });
        }
        return alertDialogBuilder.create();
    }
}

