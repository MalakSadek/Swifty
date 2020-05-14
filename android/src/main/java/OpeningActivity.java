package malaksadek.swifty;

import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.support.annotation.NonNull;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.ProgressBar;
import android.widget.TextView;
import android.widget.Toast;

import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.Task;
import com.google.firebase.auth.AuthResult;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseUser;
import com.google.firebase.firestore.DocumentSnapshot;
import com.google.firebase.firestore.FirebaseFirestore;
import com.google.firebase.firestore.QuerySnapshot;

import java.util.Objects;

public class OpeningActivity extends AppCompatActivity {

    SharedPreferences firsttime;
    Button signin, signup;
    ProgressBar progress;
    TextView text;
    FirebaseAuth mAuth;

    boolean connected;

    boolean checkFirst() {
        final boolean[] first = new boolean[1];
        FirebaseUser user = FirebaseAuth.getInstance().getCurrentUser();
        firsttime = getSharedPreferences("SwiftyPrefs", 0);
        String username = firsttime.getString("Username", "");
        String email = firsttime.getString("Email", "");
        String password = firsttime.getString("Password", "");

        if (user != null) {
            if ((user.isEmailVerified()) && (!username.equals("")) && (!email.equals("")) && (!password.equals(""))) {

                mAuth = FirebaseAuth.getInstance();
                mAuth.signInWithEmailAndPassword(email, password)
                        .addOnCompleteListener(new OnCompleteListener<AuthResult>() {
                            @Override
                            public void onComplete(@NonNull Task<AuthResult> task) {
                                Log.d("TAG", "signInWithEmail:onComplete:" + task.isSuccessful());
                                if (!task.isSuccessful()) {
                                    Toast.makeText(getApplicationContext(), "Unable to sign in, please try again!", Toast.LENGTH_LONG).show();
                                    first[0] = true;
                                    final SharedPreferences.Editor editor = firsttime.edit();
                                    editor.putString("Email", "");
                                    editor.putString("Username", "");
                                    editor.putString("Password", "");
                                    editor.commit();
                                    FirebaseAuth.getInstance().signOut();

                                } else {
                                    first[0] = false;
                                }
                                // ...
                            }
                        });
            }
            else {

                first[0] = true;
            }
        } else {
            first[0] = true;
        }

        return first[0];
    }

    void Setup() {
        signin = findViewById(R.id.signinbutton);
        signup = findViewById(R.id.signupbutton);
        progress = findViewById(R.id.progressBar);
        text = findViewById(R.id.textView3);
    }

    void checkInternet() {
        ConnectivityManager connectivityManager = (ConnectivityManager)getSystemService(Context.CONNECTIVITY_SERVICE);
        if(connectivityManager.getNetworkInfo(ConnectivityManager.TYPE_MOBILE).getState() == NetworkInfo.State.CONNECTED ||
                connectivityManager.getNetworkInfo(ConnectivityManager.TYPE_WIFI).getState() == NetworkInfo.State.CONNECTED)
            connected = true;
        else
            connected = false;
    }


    void signupOnClickListener() {
        if (connected) {
            //we are connected to a network
            startActivity(new Intent(getApplicationContext(), SignUpActivity.class));
        }
        else {
            Toast.makeText(getApplicationContext(), "You must be connected to the internet.", Toast.LENGTH_LONG).show();
        }
    }

    void signinOnClickListener() {
        if(connected) {
            //we are connected to a network
            startActivity(new Intent(getApplicationContext(), SignInActivity.class));
        }
        else {
            Toast.makeText(getApplicationContext(), "You must be connected to the internet.", Toast.LENGTH_LONG).show();
        }
    }

    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_opening);
        getSupportActionBar().setTitle("Swifty");
        Setup();
        checkInternet();
        progress.setVisibility(View.VISIBLE);
        signin.setVisibility(View.INVISIBLE);
        signup.setVisibility(View.INVISIBLE);
        text.setVisibility(View.INVISIBLE);

        if (checkFirst()) {

            progress.setVisibility(View.INVISIBLE);
            signin.setVisibility(View.VISIBLE);
            signup.setVisibility(View.VISIBLE);
            text.setVisibility(View.VISIBLE);

                signup.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View view) {
                        signupOnClickListener();
                    }
                });

                signin.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View view) {
                        signinOnClickListener();
                    }
                });
            }
        else
        {
            startActivity(new Intent(getApplicationContext(), MenuActivity.class));
        }

    }
}
