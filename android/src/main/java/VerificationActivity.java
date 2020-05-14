package malaksadek.swifty;

import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.pm.PackageManager;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.os.Build;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.v7.app.AppCompatActivity;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.ProgressBar;
import android.widget.Toast;

import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.OnFailureListener;
import com.google.android.gms.tasks.OnSuccessListener;
import com.google.android.gms.tasks.Task;
import com.google.firebase.auth.AuthResult;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseUser;
import com.google.firebase.firestore.DocumentReference;
import com.google.firebase.firestore.FirebaseFirestore;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

public class VerificationActivity extends AppCompatActivity {

    Button verify;
    ProgressBar prgrs;
    ImageView tick;
    String name, email, password;
    FirebaseAuth mAuth;
    boolean connected;

    void checkInternet() {
        ConnectivityManager connectivityManager = (ConnectivityManager)getSystemService(Context.CONNECTIVITY_SERVICE);
        if(connectivityManager.getNetworkInfo(ConnectivityManager.TYPE_MOBILE).getState() == NetworkInfo.State.CONNECTED ||
                connectivityManager.getNetworkInfo(ConnectivityManager.TYPE_WIFI).getState() == NetworkInfo.State.CONNECTED)
            connected = true;
        else
            connected = false;
    }


    void Setup() {
        SharedPreferences user = getSharedPreferences("SwiftyPrefs", 0);
        email = user.getString("Email", "");
        password = user.getString("Password", "");
        name = user.getString("Username", "");

        tick = findViewById(R.id.tick);
        prgrs = findViewById(R.id.progressBar2);
        verify = findViewById(R.id.verify);
        tick.setVisibility(View.INVISIBLE);
    }

    void verifyOnClickListener() {
        if(connected) {
            //we are connected to a network
            mAuth = FirebaseAuth.getInstance();
            mAuth.signInWithEmailAndPassword(email, password)
                    .addOnCompleteListener(new OnCompleteListener<AuthResult>() {
                        @Override
                        public void onComplete(@NonNull Task<AuthResult> task) {
                            Log.d("TAG", "signInWithEmail:onComplete:" + task.isSuccessful());
                            if (!task.isSuccessful()) {
                                Toast.makeText(getApplicationContext(), "Unable to sign in, please try again!", Toast.LENGTH_LONG).show();

                            } else {
                                checkIfEmailVerified();
                            }
                            // ...
                        }
                    });
        }
        else {
            Toast.makeText(getApplicationContext(), "You must be connected to the internet.", Toast.LENGTH_LONG).show();
        }
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_verification);
        getSupportActionBar().setTitle("Verify Account");

        checkInternet();
        Setup();

        verify.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                verifyOnClickListener();
            }
        });
    }


    private void checkIfEmailVerified()
    {
        FirebaseUser user = FirebaseAuth.getInstance().getCurrentUser();

        if (user.isEmailVerified()) {
            Toast.makeText(getApplicationContext(), "Verified!", Toast.LENGTH_SHORT).show();
            prgrs.setVisibility(View.INVISIBLE);
            tick.setVisibility(View.VISIBLE);
            uploadData();
        }
        else
        {
            Toast.makeText(getApplicationContext(), "Please verify your email to continue!", Toast.LENGTH_LONG).show();
            FirebaseAuth.getInstance().signOut();

        }
    }

    void uploadData() {


        Map<String, Object> data = new HashMap<>();
        DateFormat dateFormat = new SimpleDateFormat("dd.MM.yyyy");
        Date date = new Date();
        data.put("Username", name);
        data.put("Email", email);
        data.put("Score", "0");
        data.put("Joined", dateFormat.format(date));

        FirebaseFirestore db = FirebaseFirestore.getInstance();
        db.collection("Users")
                .add(data)
                .addOnSuccessListener(new OnSuccessListener<DocumentReference>() {
                    @Override
                    public void onSuccess(DocumentReference documentReference) {
                        startActivity(new Intent(getApplicationContext(), MenuActivity.class));
                    }
                })
                .addOnFailureListener(new OnFailureListener() {
                    @Override
                    public void onFailure(@NonNull Exception e) {
                        Log.w("", "Error adding document", e);
                    }
                });
    }
}