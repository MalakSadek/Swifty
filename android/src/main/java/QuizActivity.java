package malaksadek.swifty;

import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.os.CountDownTimer;
import android.os.Handler;
import android.support.annotation.NonNull;
import android.support.v7.app.AppCompatActivity;
import android.util.Log;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.ListView;
import android.widget.TextView;

import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.Task;
import com.google.firebase.firestore.DocumentSnapshot;
import com.google.firebase.firestore.FirebaseFirestore;
import com.google.firebase.firestore.QuerySnapshot;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.Objects;

public class QuizActivity extends AppCompatActivity {

    TextView TimeLeft, QuizScore, QuestionTitle, Question, CorrectAnswer;
    Button AnswerButton;
    ListView Answers;
    int QuestionIndex, Score;
    String correctanswer, selectedanswer;
    ArrayList<String> answers;
    JSONObject questions;

    CountDownTimer mCountDownTimer = new CountDownTimer(10000, 1000) {

        @Override
        public void onTick(long millisUntilFinished) {
            TimeLeft.setText(String.valueOf(millisUntilFinished/1000));
        }

        @Override
        public void onFinish() {
            isCounterRunning = false;
            if (QuestionIndex < 10) {
                Score = Score - 10;
                QuizScore.setText(String.valueOf(Score));
                answers.clear();
                QuestionTitle.setText("Question " + String.valueOf(QuestionIndex + 1));
                try {
                    Question.setText(questions.names().getString(QuestionIndex));
                } catch (JSONException e) {
                    e.printStackTrace();
                }

                for (int j = 0; j < 4; j++) {
                    try {
                        if (j == 0) {
                            correctanswer = questions.getJSONArray(questions.names().getString(QuestionIndex)).getString(j);
                        }
                        answers.add(questions.getJSONArray(questions.names().getString(QuestionIndex)).getString(j));
                    } catch (JSONException e) {
                        e.printStackTrace();
                    }
                }

                Collections.shuffle(answers);
                ArrayAdapter<String> adapter = new ArrayAdapter<String>(getApplicationContext(),
                        R.layout.answerstext, answers);
                Answers.setAdapter(adapter);
                QuestionIndex++;
                resetTimer();
            } else {
                Score = Score - 10;
                QuizScore.setText(String.valueOf(Score));
                SharedPreferences sp = getSharedPreferences("SwiftyPrefs", 0);
                final SharedPreferences.Editor editor = sp.edit();
                editor.putString("Score", String.valueOf(Score));
                editor.commit();
                startActivity(new Intent(getApplicationContext(), ScoreActivity.class));
                finish();
            }
        }
    };



    boolean isCounterRunning  = false;

    private void resetTimer() {
        if( !isCounterRunning ){
            isCounterRunning = true;
            mCountDownTimer.start();
        }
        else{
            mCountDownTimer.cancel(); // cancel
            mCountDownTimer.start();  // then restart
        }

    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        getSupportActionBar().setTitle("Quiz");
        setContentView(R.layout.activity_quiz);
        Setup();
        resetTimer();

        try {
            JSONObject obj = new JSONObject(loadJSONFromAsset(getApplicationContext()));
            String category = getSharedPreferences("SwiftyPrefs", 0).getString("Category", "");
            String topic = getSharedPreferences("SwiftyPrefs", 0).getString("Topic", "");
            questions = obj.getJSONObject("Categories").getJSONObject(category).getJSONObject("Topics").getJSONObject(topic).getJSONObject("Questions");
            //Question
            Log.i("json test", questions.names().getString(0));
            //Answer
            Log.i("json test", questions.getJSONArray(questions.names().getString(0)).getString(0));


            answers.clear();
            QuestionTitle.setText("Question "+String.valueOf(QuestionIndex+1));
            Question.setText(questions.names().getString(QuestionIndex));

            for (int j = 0; j < 4; j++) {
                if (j == 0) {
                    correctanswer = questions.getJSONArray(questions.names().getString(QuestionIndex)).getString(j);
                }
                answers.add(questions.getJSONArray(questions.names().getString(QuestionIndex)).getString(j));
            }

            Collections.shuffle(answers);
            ArrayAdapter<String> adapter = new ArrayAdapter<String>(this,
                        R.layout.answerstext, answers);
            Answers.setAdapter(adapter);
            QuestionIndex++;


        } catch (JSONException e) {
            e.printStackTrace();
        }
    }

    void Setup() {
        TimeLeft = findViewById(R.id.timeleft);
        QuizScore = findViewById(R.id.quizscore);
        QuestionTitle = findViewById(R.id.questiontitle);
        Question = findViewById(R.id.question);
        CorrectAnswer = findViewById(R.id.correctanswer);
        AnswerButton = findViewById(R.id.answerbutton);
        Answers = findViewById(R.id.answers);
        QuestionIndex = 0;
        answers = new ArrayList<>(4);
        QuizScore.setText("0");
        Score = 0;
        CorrectAnswer.setVisibility(View.INVISIBLE);
        AnswerButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                answerButtonOnClickListener();
            }
        });
        Answers.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                answersOnItemClickListener(position);
            }
        });
    }

    void answersOnItemClickListener(int position) {
        selectedanswer = answers.get(position);
    }

    void answerButtonOnClickListener() {

        CorrectAnswer.setVisibility(View.VISIBLE);

        if (selectedanswer.equals(correctanswer)) {
            Score = Score + 10;
            CorrectAnswer.setText("Correct answer!");
            AnswerButton.setBackgroundColor(getResources().getColor(R.color.green));
            QuizScore.setText(String.valueOf(Score));
        } else {
            Score = Score - 10;
            CorrectAnswer.setText("Correct answer is: "+correctanswer);
            AnswerButton.setBackgroundColor(getResources().getColor(R.color.red));
            QuizScore.setText(String.valueOf(Score));
        }

        if (QuestionIndex < 10) {
            pause();
        } else {
            SharedPreferences sp = getSharedPreferences("SwiftyPrefs", 0);
            final SharedPreferences.Editor editor = sp.edit();
            editor.putString("Score", String.valueOf(Score));
            editor.commit();
            startActivity(new Intent(getApplicationContext(), ScoreActivity.class));
            finish();
        }
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        mCountDownTimer.cancel();
    }

    //    @Override
//    public void onBackPressed() {
//        super.onBackPressed();
//        DialogPopup d = new DialogPopup(2);
//        d.show(getFragmentManager(), "My Dialog");
//    }

    void pause() {

        CountDownTimer mCountDownTimer2 = new CountDownTimer(2000, 1000) {

            @Override
            public void onTick(long millisUntilFinished) {

            }

            @Override
            public void onFinish() {
                Log.i("i am here", "pls");
                AnswerButton.setBackgroundColor(getResources().getColor(R.color.colorAccent));
                CorrectAnswer.setVisibility(View.INVISIBLE);
                answers.clear();
                QuestionTitle.setText("Question " + String.valueOf(QuestionIndex + 1));
                try {
                    Question.setText(questions.names().getString(QuestionIndex));
                } catch (JSONException e) {
                    e.printStackTrace();
                }

                for (int j = 0; j < 4; j++) {
                    try {
                        if (j == 0) {
                            correctanswer = questions.getJSONArray(questions.names().getString(QuestionIndex)).getString(j);
                        }
                        answers.add(questions.getJSONArray(questions.names().getString(QuestionIndex)).getString(j));
                    } catch (JSONException e) {
                        e.printStackTrace();
                    }
                }

                Collections.shuffle(answers);
                ArrayAdapter<String> adapter = new ArrayAdapter<String>(getApplicationContext(),
                        R.layout.answerstext, answers);
                Answers.setAdapter(adapter);
                QuestionIndex++;
                resetTimer();
            }
        };

        mCountDownTimer2.start();

    }

    public String loadJSONFromAsset(Context context) {
        String json = null;
        try {
            InputStream is = context.getAssets().open("questions.JSON");
            int size = is.available();
            byte[] buffer = new byte[size];
            is.read(buffer);
            is.close();
            json = new String(buffer, "UTF-8");

        } catch (IOException ex) {
            ex.printStackTrace();
            return null;
        }
        return json;


    }
}